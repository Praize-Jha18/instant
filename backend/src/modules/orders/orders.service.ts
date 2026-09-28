import { Injectable, Logger } from '@nestjs/common';
import { InjectModel } from '@nestjs/mongoose';
import { Model, QueryFilter, Types } from 'mongoose';
import { AppError } from '../../common/errors/app-error.js';
import { clampLimit, idCursorFilter, idPage, type Page } from '../../common/pagination/cursor.js';
import { notDeleted } from '../../common/schemas/base.js';
import type { AuthUser } from '../../common/types/auth-user.js';
import { haversineKm } from '../../common/utils/geo.js';
import { oid } from '../../common/utils/ids.js';
import { AddressesService } from '../addresses/addresses.service.js';
import { CartService } from '../cart/cart.service.js';
import type { LineItem } from '../cart/schemas/cart.schema.js';
import { DeliveriesService } from '../deliveries/deliveries.service.js';
import { NotificationsService } from '../notifications/notifications.service.js';
import { PaymentIntentsService, type CheckoutPayment } from '../payments/payment-intents.service.js';
import type { PaymentDocument } from '../payments/schemas/payment.schema.js';
import { ProductsService } from '../products/products.service.js';
import { StockService, type StockLine } from '../products/stock.service.js';
import { RealtimeService } from '../realtime/realtime.service.js';
import { RidersService, type LastLocation } from '../riders/riders.service.js';
import { UsersService } from '../users/users.service.js';
import { VendorsService } from '../vendors/vendors.service.js';
import type { AdminOrdersQueryDto, CreateOrderDto } from './dto/order.dto.js';
import { customerCanCancel, holdsStock, type DeliveryStatus, type SubOrderStatus } from './order-state-machine.js';
import { deliveryFeeKobo, generateOrderNumber, UNPAID_ORDER_TTL_MS, vendorGroupTotals } from './pricing.js';
import { Order, type OrderDocument } from './schemas/order.schema.js';
import { SubOrder, type SubOrderDocument } from './schemas/sub-order.schema.js';
import { SubOrdersService } from './sub-orders.service.js';

export interface OrderWithSubOrders {
  order: OrderDocument;
  subOrders: SubOrderDocument[];
}

export interface CheckoutPayload extends OrderWithSubOrders {
  payment: CheckoutPayment;
}

export interface SubOrderTracking {
  subOrderId: string;
  vendorId: string;
  vendorName: string;
  status: SubOrderStatus;
  delivery: {
    id: string;
    status: DeliveryStatus;
    riderId: string | null;
    pickup: { lat: number; lng: number };
    dropoff: { lat: number; lng: number };
    riderLocation: LastLocation | null;
  } | null;
}

export function stockLinesOf(subOrders: Array<Pick<SubOrder, 'items' | 'vendorId'>>): StockLine[] {
  return subOrders.flatMap((s) =>
    s.items.map((i) => ({ productId: i.productId, variantId: i.variantId, vendorId: s.vendorId, qty: i.qty })),
  );
}

function mergeCartLines(items: LineItem[]): Map<string, { productId: Types.ObjectId; variantId: Types.ObjectId | null; qty: number }> {
  const merged = new Map<string, { productId: Types.ObjectId; variantId: Types.ObjectId | null; qty: number }>();
  for (const item of items) {
    const key = `${String(item.productId)}:${item.variantId ? String(item.variantId) : ''}`;
    const prev = merged.get(key);
    if (prev) prev.qty += item.qty;
    else merged.set(key, { productId: item.productId, variantId: item.variantId, qty: item.qty });
  }
  return merged;
}

@Injectable()
export class OrdersService {
  private readonly logger = new Logger(OrdersService.name);

  constructor(
    @InjectModel(Order.name) private readonly orders: Model<Order>,
    private readonly subOrders: SubOrdersService,
    private readonly cart: CartService,
    private readonly addresses: AddressesService,
    private readonly products: ProductsService,
    private readonly stock: StockService,
    private readonly vendors: VendorsService,
    private readonly paymentIntents: PaymentIntentsService,
    private readonly deliveries: DeliveriesService,
    private readonly riders: RidersService,
    private readonly users: UsersService,
    private readonly notifications: NotificationsService,
    private readonly realtime: RealtimeService,
  ) {}

  // ───────────────────────────── checkout ─────────────────────────────

  /**
   * Cart → order + subOrders (one per vendor). Prices are snapshotted from the
   * database, stock is reserved atomically (all lines or none), then a payment
   * intent is created. Everything before payment confirmation is `awaiting_payment`.
   */
  async create(user: AuthUser, dto: CreateOrderDto): Promise<CheckoutPayload> {
    const customerId = oid(user.userId, 'userId');
    const cart = await this.cart.get(customerId);
    if (cart.items.length === 0) throw AppError.badRequest('CART_EMPTY', 'Your cart is empty');
    const address = await this.addresses.get(customerId, dto.addressId);

    const merged = mergeCartLines(cart.items);
    const productIds = [...new Set([...merged.values()].map((l) => String(l.productId)))].map((id) => new Types.ObjectId(id));
    const products = new Map((await this.products.findActiveByIds(productIds)).map((p) => [String(p._id), p]));

    // Snapshot lines from the DB, never from the client.
    const lines: LineItem[] = [];
    for (const line of merged.values()) {
      const product = products.get(String(line.productId));
      if (!product) {
        throw AppError.conflict('PRODUCT_UNAVAILABLE', 'A product in your cart is no longer available', { productId: String(line.productId) });
      }
      let priceKobo = product.basePriceKobo;
      let variantName: string | null = null;
      if (product.hasVariants) {
        const variant = line.variantId ? product.variants.find((v) => v._id.equals(line.variantId as Types.ObjectId)) : undefined;
        if (!variant) {
          throw AppError.conflict('VARIANT_REQUIRED', `Choose a variant for ${product.name}`, { productId: String(product._id) });
        }
        priceKobo = variant.priceKobo;
        variantName = variant.name;
      }
      lines.push({
        productId: product._id,
        variantId: product.hasVariants ? line.variantId : null,
        vendorId: product.vendorId,
        qty: line.qty,
        priceKoboSnapshot: priceKobo,
        nameSnapshot: product.name,
        variantNameSnapshot: variantName,
        imageId: product.images[0]?.imageId ?? null,
      });
    }

    // Group by vendor and price each group.
    const byVendor = new Map<string, LineItem[]>();
    for (const l of lines) {
      const key = String(l.vendorId);
      byVendor.set(key, [...(byVendor.get(key) ?? []), l]);
    }
    const vendors = new Map((await this.vendors.findByIds([...byVendor.keys()])).map((v) => [String(v._id), v]));

    const orderId = new Types.ObjectId();
    const now = new Date();
    const orderNumber = generateOrderNumber(now);
    const subOrderDrafts: Array<Partial<SubOrder> & { _id: Types.ObjectId }> = [];
    let subtotalKobo = 0;
    let deliveryTotalKobo = 0;

    for (const [vendorId, groupLines] of byVendor) {
      const vendor = vendors.get(vendorId);
      if (!vendor || vendor.status !== 'active') {
        throw AppError.conflict('VENDOR_NOT_ACTIVE', 'A vendor in your cart is not accepting orders', { vendorId });
      }
      const groupSubtotal = groupLines.reduce((sum, l) => sum + l.priceKoboSnapshot * l.qty, 0);
      const { lat, lng } = vendor.address;
      const distanceKm = lat !== null && lng !== null ? haversineKm({ lat, lng }, { lat: address.lat, lng: address.lng }) : 0;
      if (distanceKm > vendor.deliveryRadiusKm) {
        throw AppError.conflict('OUT_OF_DELIVERY_RANGE', `${vendor.name} does not deliver to this address`, {
          vendorId,
          distanceKm: Math.round(distanceKm * 10) / 10,
          deliveryRadiusKm: vendor.deliveryRadiusKm,
        });
      }
      const fee = deliveryFeeKobo(vendor.deliveryFee, distanceKm, groupSubtotal);
      const totals = vendorGroupTotals(groupSubtotal, fee, vendor.commissionBps);
      subtotalKobo += groupSubtotal;
      deliveryTotalKobo += fee;
      subOrderDrafts.push({
        _id: new Types.ObjectId(),
        orderId,
        vendorId: vendor._id,
        customerId,
        orderNumber,
        vendorNameSnapshot: vendor.name,
        items: groupLines,
        ...totals,
        status: 'awaiting_payment',
        deliveryId: null,
        deliveryOtp: null,
        timeline: [{ status: 'awaiting_payment', at: now, byUserId: customerId, note: null }],
        refundedKobo: 0,
      });
    }
    const totalKobo = subtotalKobo + deliveryTotalKobo;

    // Atomic stock reservation (all or nothing).
    const stockLines: StockLine[] = lines.map((l) => ({ productId: l.productId, variantId: l.variantId, vendorId: l.vendorId, qty: l.qty }));
    await this.stock.reserve(stockLines, { orderId, byUserId: customerId, note: `Order ${orderNumber}` });

    let payment: CheckoutPayment;
    let order: OrderDocument;
    let subOrders: SubOrderDocument[];
    try {
      const created = await this.paymentIntents.createForOrder({
        orderId,
        orderNumber,
        amountKobo: totalKobo,
        customerId,
        customerEmail: user.email,
      });
      payment = created.checkout;
      order = await this.orders.create({
        _id: orderId,
        customerId,
        orderNumber,
        subOrderIds: subOrderDrafts.map((s) => s._id),
        addressSnapshot: {
          addressId: address._id,
          label: address.label,
          line1: address.line1,
          line2: address.line2,
          city: address.city,
          state: address.state,
          lat: address.lat,
          lng: address.lng,
          phone: address.phone,
        },
        subtotalKobo,
        deliveryTotalKobo,
        totalKobo,
        currency: 'NGN',
        paymentStatus: 'pending',
        paymentId: created.payment._id,
        placedAt: now,
        paidAt: null,
        expiresAt: new Date(now.getTime() + UNPAID_ORDER_TTL_MS),
        note: dto.note ?? '',
      });
      subOrders = await this.subOrders.model.create(subOrderDrafts);
    } catch (err) {
      await this.stock.release(stockLines, { orderId, byUserId: customerId, note: 'checkout failed' }, 'cancel');
      throw err;
    }

    await this.cart.clear(customerId);
    this.realtime.emitChanged('orders', order);
    for (const s of subOrders) this.realtime.emitChanged('subOrders', s);
    return { order, subOrders, payment };
  }

  // ───────────────────────────── customer reads ─────────────────────────────

  async getOwned(userId: string, orderId: string): Promise<OrderDocument> {
    const order = await this.orders.findOne({ _id: oid(orderId, 'orderId'), customerId: oid(userId, 'userId'), ...notDeleted }).exec();
    if (!order) throw AppError.notFound('ORDER_NOT_FOUND', 'Order not found');
    return order;
  }

  async findById(orderId: Types.ObjectId): Promise<OrderDocument | null> {
    return this.orders.findOne({ _id: orderId, ...notDeleted }).exec();
  }

  async getById(orderId: Types.ObjectId): Promise<OrderDocument> {
    const order = await this.findById(orderId);
    if (!order) throw AppError.notFound('ORDER_NOT_FOUND', 'Order not found');
    return order;
  }

  async get(userId: string, orderId: string): Promise<OrderWithSubOrders> {
    const order = await this.getOwned(userId, orderId);
    return { order, subOrders: await this.subOrders.findByOrder(order._id) };
  }

  async list(userId: string, query: { cursor?: string; limit?: number }): Promise<Page<Record<string, unknown>>> {
    const limit = clampLimit(query.limit);
    const docs = await this.orders
      .find({ customerId: oid(userId, 'userId'), ...notDeleted, ...idCursorFilter(query.cursor) })
      .sort({ _id: -1 })
      .limit(limit + 1)
      .exec();
    const page = idPage(docs, limit);
    const subOrders = await this.subOrders.findByOrders(page.items.map((o) => o._id));
    const grouped = new Map<string, SubOrderDocument[]>();
    for (const s of subOrders) grouped.set(String(s.orderId), [...(grouped.get(String(s.orderId)) ?? []), s]);
    return {
      items: page.items.map((o) =>
        Object.assign(o.toJSON() as unknown as Record<string, unknown>, { subOrders: (grouped.get(String(o._id)) ?? []).map((s) => s.toJSON()) }),
      ),
      nextCursor: page.nextCursor,
    };
  }

  async listAdmin(query: AdminOrdersQueryDto): Promise<Page<OrderDocument>> {
    const limit = clampLimit(query.limit);
    const filter: QueryFilter<Order> = { ...notDeleted, ...idCursorFilter(query.cursor) };
    if (query.paymentStatus) filter.paymentStatus = query.paymentStatus;
    if (query.customerId) filter.customerId = oid(query.customerId, 'customerId');
    const docs = await this.orders.find(filter).sort({ _id: -1 }).limit(limit + 1).exec();
    return idPage(docs, limit);
  }

  async tracking(userId: string, orderId: string): Promise<{ orderId: string; paymentStatus: string; subOrders: SubOrderTracking[] }> {
    const order = await this.getOwned(userId, orderId);
    const subOrders = await this.subOrders.findByOrder(order._id);
    const deliveries = await this.deliveries.findBySubOrderIds(subOrders.map((s) => s._id));
    const byLine = new Map(deliveries.map((d) => [String(d.subOrderId), d]));
    const activeRiderIds = deliveries.filter((d) => d.riderId && (d.status === 'accepted' || d.status === 'picked_up')).map((d) => d.riderId as Types.ObjectId);
    const locations = await this.riders.lastLocations(activeRiderIds);
    return {
      orderId: String(order._id),
      paymentStatus: order.paymentStatus,
      subOrders: subOrders.map((s) => {
        const d = byLine.get(String(s._id));
        return {
          subOrderId: String(s._id),
          vendorId: String(s.vendorId),
          vendorName: s.vendorNameSnapshot,
          status: s.status,
          delivery: d
            ? {
                id: String(d._id),
                status: d.status,
                riderId: d.riderId ? String(d.riderId) : null,
                pickup: { lat: d.pickup.lat, lng: d.pickup.lng },
                dropoff: { lat: d.dropoff.lat, lng: d.dropoff.lng },
                riderLocation: d.riderId ? (locations.get(String(d.riderId)) ?? null) : null,
              }
            : null,
        };
      }),
    };
  }

  // ───────────────────────────── customer cancel ─────────────────────────────

  /** Only while every sub-order is still `placed` (or the order is still unpaid). */
  async cancel(userId: string, orderId: string, reason?: string): Promise<OrderWithSubOrders> {
    const order = await this.getOwned(userId, orderId);
    const subOrders = await this.subOrders.findByOrder(order._id);
    const open = subOrders.filter((s) => s.status !== 'cancelled');
    if (open.length === 0) throw AppError.conflict('ALREADY_CANCELLED', 'Order is already cancelled');
    const blocked = open.find((s) => !customerCanCancel(s.status) && s.status !== 'awaiting_payment');
    if (blocked) {
      throw AppError.conflict('CANNOT_CANCEL', `Order can no longer be cancelled (a vendor has already ${blocked.status} it)`, { subOrderId: String(blocked._id), status: blocked.status });
    }

    const customerId = oid(userId, 'userId');
    for (const s of open) {
      await this.subOrders.transition(s, 'cancelled', { userId: customerId, note: reason ?? 'Cancelled by customer' });
    }
    await this.stock.release(stockLinesOf(open), { orderId: order._id, byUserId: customerId, note: 'Customer cancelled' }, 'cancel');

    const payment = await this.paymentIntents.findByOrder(order._id);
    if (order.paymentStatus === 'paid' || order.paymentStatus === 'partially_refunded') {
      const outstanding = open.reduce((sum, s) => sum + s.subtotalKobo + s.deliveryFeeKobo - s.refundedKobo, 0);
      if (payment) await this.paymentIntents.refund(payment, outstanding, 'customer cancel');
      order.paymentStatus = 'refunded';
    } else if (order.paymentStatus === 'pending') {
      if (payment) await this.paymentIntents.cancel(payment);
      order.paymentStatus = 'failed';
    }
    await order.save();
    this.realtime.emitChanged('orders', order);

    for (const s of open.filter((x) => x.timeline.some((t) => t.status === 'placed'))) {
      const members = await this.users.findVendorMembers(s.vendorId);
      await this.notifications.notifyMany(members.map((m) => m._id), {
        type: 'order.cancelled',
        title: 'Order cancelled by customer',
        body: `Order ${order.orderNumber} was cancelled.`,
        data: { subOrderId: String(s._id), orderId: String(order._id) },
      });
    }
    return { order, subOrders: await this.subOrders.findByOrder(order._id) };
  }

  // ───────────────────────────── payment outcomes ─────────────────────────────

  /**
   * Payment confirmed by the provider: order → paid, subOrders awaiting_payment → placed,
   * vendors notified. Idempotent. A late payment on an already-expired order re-reserves
   * stock; if that fails the payment is refunded.
   */
  async confirmPayment(payment: PaymentDocument): Promise<{ status: 'paid' | 'already_paid' | 'refunded' | 'ignored' }> {
    const order = await this.findById(payment.orderId);
    if (!order) return { status: 'ignored' };
    if (order.paymentStatus === 'paid') return { status: 'already_paid' };
    const subOrders = await this.subOrders.findByOrder(order._id);

    if (order.paymentStatus !== 'pending') {
      const cancelled = subOrders.filter((s) => s.status === 'cancelled');
      try {
        await this.stock.reserve(stockLinesOf(cancelled), { orderId: order._id, byUserId: order.customerId, note: 'Late payment' });
      } catch {
        await this.paymentIntents.refund(payment, payment.amountKobo, 'late payment, stock gone');
        order.paymentStatus = 'refunded';
        await order.save();
        this.realtime.emitChanged('orders', order);
        await this.notifications.notify(order.customerId, {
          type: 'order.refunded',
          title: 'Order expired',
          body: `Order ${order.orderNumber} expired before payment arrived; you have been refunded.`,
          data: { orderId: String(order._id) },
        });
        return { status: 'refunded' };
      }
      for (const s of cancelled) await this.subOrders.forceStatus(s, 'placed', { note: 'Late payment confirmed' });
    } else {
      for (const s of subOrders.filter((x) => x.status === 'awaiting_payment')) {
        await this.subOrders.transition(s, 'placed', { note: 'Payment confirmed' });
      }
    }

    order.paymentStatus = 'paid';
    order.paidAt = new Date();
    order.paymentId = payment._id;
    await order.save();
    await this.paymentIntents.setStatus(payment._id, 'succeeded');
    this.realtime.emitChanged('orders', order);

    for (const s of subOrders) {
      const members = await this.users.findVendorMembers(s.vendorId);
      await this.notifications.notifyMany(members.map((m) => m._id), {
        type: 'order.placed',
        title: 'New order',
        body: `Order ${order.orderNumber}: ${s.items.length} item(s), ₦${(s.subtotalKobo / 100).toLocaleString('en-NG')}.`,
        data: { subOrderId: String(s._id), orderId: String(order._id) },
      });
    }
    await this.notifications.notify(order.customerId, {
      type: 'order.paid',
      title: 'Payment confirmed',
      body: `Order ${order.orderNumber} has been sent to the store(s).`,
      data: { orderId: String(order._id) },
    });
    return { status: 'paid' };
  }

  /** Payment failed or the order expired unpaid: release stock and cancel sub-orders. Idempotent. */
  async failPayment(order: OrderDocument, reason: 'payment_failed' | 'expired'): Promise<boolean> {
    if (order.paymentStatus !== 'pending') return false;
    const subOrders = await this.subOrders.findByOrder(order._id);
    const awaiting = subOrders.filter((s) => s.status === 'awaiting_payment');
    for (const s of awaiting) {
      await this.subOrders.transition(s, 'cancelled', { note: reason === 'expired' ? 'Expired unpaid' : 'Payment failed' });
    }
    await this.stock.release(stockLinesOf(awaiting), { orderId: order._id, byUserId: null, note: reason }, 'cancel');
    order.paymentStatus = 'failed';
    await order.save();
    this.realtime.emitChanged('orders', order);
    const payment = await this.paymentIntents.findByOrder(order._id);
    if (payment) {
      if (reason === 'expired') await this.paymentIntents.cancel(payment);
      else await this.paymentIntents.setStatus(payment._id, 'failed');
    }
    await this.notifications.notify(order.customerId, {
      type: reason === 'expired' ? 'order.expired' : 'order.payment_failed',
      title: reason === 'expired' ? 'Order expired' : 'Payment failed',
      body: `Order ${order.orderNumber} was not paid. You can retry from the order screen.`,
      data: { orderId: String(order._id) },
    });
    return true;
  }

  /** Scheduled: expire unpaid orders older than 30 minutes (§6). */
  async expireUnpaid(now: Date = new Date()): Promise<number> {
    const stale = await this.orders.find({ paymentStatus: 'pending', expiresAt: { $lte: now }, ...notDeleted }).limit(100).exec();
    let count = 0;
    for (const order of stale) {
      try {
        if (await this.failPayment(order, 'expired')) count += 1;
      } catch (err) {
        this.logger.error(`Failed to expire order ${order.orderNumber}: ${err instanceof Error ? err.message : String(err)}`);
      }
    }
    return count;
  }

  /**
   * New payment intent for an order. While `pending` the previous intent is cancelled.
   * A `failed` (expired) order is reopened: stock is re-reserved and sub-orders return
   * to awaiting_payment with a fresh 30-minute window.
   */
  async retryPayment(user: AuthUser, orderId: string): Promise<CheckoutPayload> {
    const order = await this.getOwned(user.userId, orderId);
    if (order.paymentStatus === 'paid') throw AppError.conflict('ALREADY_PAID', 'Order is already paid');
    if (order.paymentStatus === 'refunded' || order.paymentStatus === 'partially_refunded') {
      throw AppError.conflict('ORDER_REFUNDED', 'A refunded order cannot be paid again');
    }
    const subOrders = await this.subOrders.findByOrder(order._id);
    const customerId = order.customerId;

    if (order.paymentStatus === 'failed') {
      if (!subOrders.every((s) => s.status === 'cancelled')) {
        throw AppError.conflict('CANNOT_RETRY', 'Order is not in a retryable state');
      }
      await this.stock.reserve(stockLinesOf(subOrders), { orderId: order._id, byUserId: customerId, note: 'Payment retry' });
      for (const s of subOrders) await this.subOrders.forceStatus(s, 'awaiting_payment', { userId: customerId, note: 'Payment retry' });
      order.paymentStatus = 'pending';
      order.placedAt = new Date();
      order.expiresAt = new Date(order.placedAt.getTime() + UNPAID_ORDER_TTL_MS);
    } else {
      const previous = await this.paymentIntents.findByOrder(order._id);
      if (previous && previous.status === 'pending') await this.paymentIntents.cancel(previous);
    }

    const created = await this.paymentIntents.createForOrder({
      orderId: order._id,
      orderNumber: order.orderNumber,
      amountKobo: order.totalKobo,
      customerId,
      customerEmail: user.email,
    });
    order.paymentId = created.payment._id;
    await order.save();
    this.realtime.emitChanged('orders', order);
    return { order, subOrders: await this.subOrders.findByOrder(order._id), payment: created.checkout };
  }

  /** Existing checkout details (client lost the client secret). */
  async checkoutDetails(user: AuthUser, orderId: string): Promise<CheckoutPayload | OrderWithSubOrders> {
    const order = await this.getOwned(user.userId, orderId);
    const subOrders = await this.subOrders.findByOrder(order._id);
    const payment = await this.paymentIntents.findByOrderWithSecret(order._id);
    if (!payment || order.paymentStatus !== 'pending') return { order, subOrders };
    return { order, subOrders, payment: this.paymentIntents.toCheckout(payment, payment.clientSecret) };
  }

  // ───────────────────────────── stats ─────────────────────────────

  async revenueSince(since: Date): Promise<{ revenueKobo: number; orders: number }> {
    const rows = await this.orders
      .aggregate<{ revenueKobo: number; orders: number }>([
        { $match: { paymentStatus: { $in: ['paid', 'partially_refunded'] }, paidAt: { $gte: since }, ...notDeleted } },
        { $group: { _id: null, revenueKobo: { $sum: '$totalKobo' }, orders: { $sum: 1 } } },
      ])
      .exec();
    return rows[0] ?? { revenueKobo: 0, orders: 0 };
  }

  async count(filter: QueryFilter<Order> = {}): Promise<number> {
    return this.orders.countDocuments({ ...notDeleted, ...filter }).exec();
  }
}

export { holdsStock };
