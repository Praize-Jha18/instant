import { Injectable } from '@nestjs/common';
import { Types } from 'mongoose';
import { AppError } from '../../common/errors/app-error.js';
import type { Page } from '../../common/pagination/cursor.js';
import { oid } from '../../common/utils/ids.js';
import { DeliveriesService } from '../deliveries/deliveries.service.js';
import { NotificationsService } from '../notifications/notifications.service.js';
import { PaymentIntentsService } from '../payments/payment-intents.service.js';
import { StockService } from '../products/stock.service.js';
import { RealtimeService } from '../realtime/realtime.service.js';
import { VendorsService } from '../vendors/vendors.service.js';
import type { UpdateSubOrderStatusDto, VendorOrdersQueryDto } from './dto/order.dto.js';
import { holdsStock, vendorCanTransition, vendorNextStatuses } from './order-state-machine.js';
import { OrdersService, stockLinesOf } from './orders.service.js';
import type { SubOrderDocument } from './schemas/sub-order.schema.js';
import { SubOrdersService } from './sub-orders.service.js';

const CUSTOMER_MESSAGES: Record<string, { title: string; body: (n: string) => string }> = {
  accepted: { title: 'Order accepted', body: (n) => `The store has accepted order ${n}.` },
  preparing: { title: 'Order being prepared', body: (n) => `Order ${n} is being prepared.` },
  cancelled: { title: 'Order cancelled', body: (n) => `The store cancelled part of order ${n}. Any payment will be refunded.` },
};

/**
 * Vendor-side sub-order transitions (§6). `ready` creates the delivery;
 * `cancelled` releases stock and refunds the paid amount for that sub-order.
 */
@Injectable()
export class VendorOrdersService {
  constructor(
    private readonly subOrders: SubOrdersService,
    private readonly orders: OrdersService,
    private readonly vendors: VendorsService,
    private readonly stock: StockService,
    private readonly deliveries: DeliveriesService,
    private readonly paymentIntents: PaymentIntentsService,
    private readonly notifications: NotificationsService,
    private readonly realtime: RealtimeService,
  ) {}

  list(vendorId: string, query: VendorOrdersQueryDto): Promise<Page<SubOrderDocument>> {
    return this.subOrders.listForVendor(vendorId, query);
  }

  get(vendorId: string, subOrderId: string): Promise<SubOrderDocument> {
    return this.subOrders.getForVendor(vendorId, subOrderId);
  }

  async setStatus(vendorId: string, subOrderId: string, byUserId: string, dto: UpdateSubOrderStatusDto): Promise<SubOrderDocument> {
    const subOrder = await this.subOrders.getForVendor(vendorId, subOrderId);
    const from = subOrder.status;
    if (!vendorCanTransition(from, dto.status)) {
      throw AppError.conflict('INVALID_TRANSITION', `Cannot move sub-order from ${from} to ${dto.status}`, {
        from,
        to: dto.status,
        allowed: vendorNextStatuses(from),
      });
    }
    const actor = { userId: oid(byUserId, 'userId'), note: dto.note ?? null };
    const order = await this.orders.getById(subOrder.orderId);

    if (dto.status === 'ready') {
      const vendor = await this.vendors.getById(subOrder.vendorId);
      const { lat, lng } = vendor.address;
      if (lat === null || lng === null) {
        throw AppError.conflict('VENDOR_ADDRESS_MISSING', 'Set your store location before marking orders ready');
      }
      await this.subOrders.transition(subOrder, 'ready', actor);
      await this.deliveries.createForSubOrder({ subOrder, order, pickup: { lat, lng } });
      return subOrder;
    }

    await this.subOrders.transition(subOrder, dto.status, actor);

    if (dto.status === 'cancelled') {
      if (holdsStock(from)) {
        await this.stock.release(stockLinesOf([subOrder]), { orderId: order._id, byUserId: actor.userId, note: dto.note ?? 'Vendor cancelled' }, 'cancel');
      }
      if (order.paymentStatus === 'paid' || order.paymentStatus === 'partially_refunded') {
        const amount = subOrder.subtotalKobo + subOrder.deliveryFeeKobo - subOrder.refundedKobo;
        const payment = await this.paymentIntents.findByOrder(order._id);
        if (payment && amount > 0 && (await this.paymentIntents.refund(payment, amount, 'vendor cancel'))) {
          await this.subOrders.addRefund(subOrder, amount);
        }
        const siblings = await this.subOrders.findByOrder(order._id);
        order.paymentStatus = siblings.every((s) => s.status === 'cancelled') ? 'refunded' : 'partially_refunded';
        await order.save();
        this.realtime.emitChanged('orders', order);
      }
    }

    const message = CUSTOMER_MESSAGES[dto.status];
    if (message) {
      await this.notifications.notify(subOrder.customerId, {
        type: `order.${dto.status}`,
        title: message.title,
        body: message.body(order.orderNumber),
        data: { orderId: String(order._id), subOrderId: String(subOrder._id), status: dto.status },
      });
    }
    return subOrder;
  }

  static asObjectId(id: string): Types.ObjectId {
    return oid(id);
  }
}
