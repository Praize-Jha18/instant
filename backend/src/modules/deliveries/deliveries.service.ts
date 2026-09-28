import { Injectable } from '@nestjs/common';
import { InjectModel } from '@nestjs/mongoose';
import { Model, QueryFilter, Types } from 'mongoose';
import { createHmac, timingSafeEqual } from 'node:crypto';
import { AppError } from '../../common/errors/app-error.js';
import { clampLimit, idCursorFilter, idPage, type Page } from '../../common/pagination/cursor.js';
import { notDeleted } from '../../common/schemas/base.js';
import { haversineKm } from '../../common/utils/geo.js';
import { oid } from '../../common/utils/ids.js';
import { generateOtp } from '../../common/utils/otp.js';
import { AppConfig } from '../../config/app-config.service.js';
import { ImagesService } from '../images/images.service.js';
import { LedgerService } from '../ledger/ledger.service.js';
import { NotificationsService } from '../notifications/notifications.service.js';
import { canTransitionDelivery, type DeliveryStatus } from '../orders/order-state-machine.js';
import type { OrderDocument } from '../orders/schemas/order.schema.js';
import type { SubOrderDocument } from '../orders/schemas/sub-order.schema.js';
import { SubOrdersService } from '../orders/sub-orders.service.js';
import { RealtimeService } from '../realtime/realtime.service.js';
import type { RiderProfileDocument } from '../riders/schemas/rider-profile.schema.js';
import { RidersService } from '../riders/riders.service.js';
import { UsersService } from '../users/users.service.js';
import type { DeliveriesQueryDto } from './dto/delivery.dto.js';
import { Delivery, type DeliveryDocument } from './schemas/delivery.schema.js';

export interface CreateDeliveryInput {
  subOrder: SubOrderDocument;
  order: OrderDocument;
  pickup: { lat: number; lng: number };
}

@Injectable()
export class DeliveriesService {
  constructor(
    @InjectModel(Delivery.name) private readonly deliveries: Model<Delivery>,
    private readonly subOrders: SubOrdersService,
    private readonly riders: RidersService,
    private readonly ledger: LedgerService,
    private readonly notifications: NotificationsService,
    private readonly images: ImagesService,
    private readonly users: UsersService,
    private readonly realtime: RealtimeService,
    private readonly config: AppConfig,
  ) {}

  private hashOtp(otp: string): string {
    return createHmac('sha256', this.config.jwtSecret).update(otp).digest('hex');
  }

  // ───────────────────────────── creation ─────────────────────────────

  /** Called when a sub-order reaches `ready` (§6). Idempotent per sub-order. */
  async createForSubOrder(input: CreateDeliveryInput): Promise<DeliveryDocument> {
    const existing = await this.deliveries.findOne({ subOrderId: input.subOrder._id, ...notDeleted }).exec();
    if (existing) return existing;

    const otp = generateOtp(4);
    const snapshot = input.order.addressSnapshot;
    const delivery = await this.deliveries.create({
      subOrderId: input.subOrder._id,
      orderId: input.order._id,
      vendorId: input.subOrder.vendorId,
      customerId: input.order.customerId,
      orderNumber: input.order.orderNumber,
      status: 'unassigned',
      pickup: input.pickup,
      dropoff: { lat: snapshot.lat, lng: snapshot.lng, addressSnapshot: snapshot },
      offeredTo: [],
      proof: { photoImageId: null, otp: this.hashOtp(otp), otpVerifiedAt: null },
      timeline: [{ status: 'unassigned', at: new Date(), byUserId: null, note: 'Sub-order ready' }],
    });
    await this.subOrders.setDelivery(input.subOrder, delivery._id, otp);
    this.realtime.emitChanged('deliveries', delivery);
    await this.notifications.notify(input.order.customerId, {
      type: 'order.ready',
      title: 'Your order is ready',
      body: `Order ${input.order.orderNumber} is being prepared for delivery. Your pickup code is ${otp}.`,
      data: { orderId: String(input.order._id), subOrderId: String(input.subOrder._id), deliveryId: String(delivery._id), otp },
    });
    return delivery;
  }

  // ───────────────────────────── queries ─────────────────────────────

  async findBySubOrderIds(ids: Types.ObjectId[]): Promise<DeliveryDocument[]> {
    if (ids.length === 0) return [];
    return this.deliveries.find({ subOrderId: { $in: ids }, ...notDeleted }).exec();
  }

  async getForVendor(vendorId: string, id: string): Promise<DeliveryDocument> {
    const doc = await this.deliveries.findOne({ _id: oid(id, 'deliveryId'), vendorId: oid(vendorId, 'vendorId'), ...notDeleted }).exec();
    if (!doc) throw AppError.notFound('DELIVERY_NOT_FOUND', 'Delivery not found');
    return doc;
  }

  async listForVendor(vendorId: string, query: DeliveriesQueryDto): Promise<Page<DeliveryDocument>> {
    const limit = clampLimit(query.limit);
    const filter: QueryFilter<Delivery> = { vendorId: oid(vendorId, 'vendorId'), ...notDeleted, ...idCursorFilter(query.cursor) };
    if (query.status) filter.status = query.status;
    const docs = await this.deliveries.find(filter).sort({ _id: -1 }).limit(limit + 1).exec();
    return idPage(docs, limit);
  }

  async listForRider(userId: string, query: DeliveriesQueryDto): Promise<Page<DeliveryDocument>> {
    const profile = await this.riders.requireByUserId(userId);
    const limit = clampLimit(query.limit);
    const filter: QueryFilter<Delivery> = { riderId: profile._id, ...notDeleted, ...idCursorFilter(query.cursor) };
    if (query.status) filter.status = query.status;
    const docs = await this.deliveries.find(filter).sort({ _id: -1 }).limit(limit + 1).exec();
    return idPage(docs, limit);
  }

  async getForRider(userId: string, id: string): Promise<{ delivery: DeliveryDocument; profile: RiderProfileDocument }> {
    const profile = await this.riders.requireByUserId(userId);
    const delivery = await this.deliveries.findOne({ _id: oid(id, 'deliveryId'), riderId: profile._id, ...notDeleted }).exec();
    if (!delivery) throw AppError.notFound('DELIVERY_NOT_FOUND', 'Delivery not found');
    return { delivery, profile };
  }

  // ───────────────────────────── vendor actions ─────────────────────────────

  async assign(vendorId: string, deliveryId: string, riderId: string, byUserId: string): Promise<DeliveryDocument> {
    const delivery = await this.getForVendor(vendorId, deliveryId);
    const rider = await this.riders.getForVendor(vendorId, riderId);
    if (rider.status !== 'active') throw AppError.conflict('RIDER_NOT_ACTIVE', 'Rider is not approved');
    return this.offerTo(delivery, rider, oid(byUserId, 'userId'));
  }

  /** Nearest online, idle rider of this vendor by their last known location. */
  async autoAssign(vendorId: string, deliveryId: string, byUserId: string): Promise<DeliveryDocument> {
    const delivery = await this.getForVendor(vendorId, deliveryId);
    const declined = new Set(delivery.offeredTo.filter((o) => o.response === 'declined').map((o) => String(o.riderId)));
    const candidates = (await this.riders.findAvailable(delivery.vendorId)).filter((r) => !declined.has(String(r._id)));
    if (candidates.length === 0) throw AppError.conflict('NO_RIDER_AVAILABLE', 'No online rider is available');

    const locations = await this.riders.lastLocations(candidates.map((c) => c._id));
    const ranked = candidates
      .map((rider) => {
        const loc = locations.get(String(rider._id));
        const distanceKm = loc ? haversineKm(delivery.pickup, loc) : Number.POSITIVE_INFINITY;
        return { rider, distanceKm };
      })
      .sort((a, b) => a.distanceKm - b.distanceKm);
    const best = ranked[0];
    if (!best) throw AppError.conflict('NO_RIDER_AVAILABLE', 'No online rider is available');
    return this.offerTo(delivery, best.rider, oid(byUserId, 'userId'));
  }

  private async offerTo(delivery: DeliveryDocument, rider: RiderProfileDocument, byUserId: Types.ObjectId): Promise<DeliveryDocument> {
    this.assertDeliveryTransition(delivery, 'offered');
    delivery.status = 'offered';
    delivery.riderId = rider._id;
    delivery.riderUserId = rider.userId;
    delivery.offeredTo.push({ riderId: rider._id, at: new Date(), response: 'pending', respondedAt: null });
    delivery.timeline.push({ status: 'offered', at: new Date(), byUserId, note: `Offered to rider ${String(rider._id)}` });
    await delivery.save();
    this.realtime.emitChanged('deliveries', delivery);
    await this.notifications.notify(rider.userId, {
      type: 'delivery.offered',
      title: 'New delivery',
      body: `Order ${delivery.orderNumber} is ready for pickup.`,
      data: { deliveryId: String(delivery._id) },
    });
    return delivery;
  }

  // ───────────────────────────── rider actions ─────────────────────────────

  async respond(userId: string, deliveryId: string, accept: boolean): Promise<DeliveryDocument> {
    const { delivery, profile } = await this.getForRider(userId, deliveryId);
    if (delivery.status !== 'offered') {
      throw AppError.conflict('INVALID_TRANSITION', `Delivery is ${delivery.status}, not offered`);
    }
    const offer = [...delivery.offeredTo].reverse().find((o) => o.riderId.equals(profile._id) && o.response === 'pending');
    const now = new Date();
    if (offer) {
      offer.response = accept ? 'accepted' : 'declined';
      offer.respondedAt = now;
    }
    if (accept) {
      if (profile.currentDeliveryId && !profile.currentDeliveryId.equals(delivery._id)) {
        throw AppError.conflict('RIDER_BUSY', 'Finish your current delivery first');
      }
      delivery.status = 'accepted';
      delivery.timeline.push({ status: 'accepted', at: now, byUserId: profile.userId, note: null });
      await delivery.save();
      await this.riders.setCurrentDelivery(profile._id, delivery._id);
      await this.notifications.notify(delivery.customerId, {
        type: 'delivery.accepted',
        title: 'A rider is on the way to the store',
        body: `Order ${delivery.orderNumber} has been assigned to a rider.`,
        data: { deliveryId: String(delivery._id), orderId: String(delivery.orderId) },
      });
    } else {
      delivery.status = 'unassigned';
      delivery.riderId = null;
      delivery.riderUserId = null;
      delivery.timeline.push({ status: 'unassigned', at: now, byUserId: profile.userId, note: 'Rider declined' });
      await delivery.save();
      const members = await this.users.findVendorMembers(delivery.vendorId);
      await this.notifications.notifyMany(
        members.map((m) => m._id),
        { type: 'delivery.declined', title: 'Rider declined a delivery', body: `Order ${delivery.orderNumber} needs a rider.`, data: { deliveryId: String(delivery._id) } },
      );
    }
    this.realtime.emitChanged('deliveries', delivery);
    return delivery;
  }

  async pickup(userId: string, deliveryId: string): Promise<DeliveryDocument> {
    const { delivery, profile } = await this.getForRider(userId, deliveryId);
    this.assertDeliveryTransition(delivery, 'picked_up');
    const subOrder = await this.subOrders.getById(delivery.subOrderId);
    await this.subOrders.transition(subOrder, 'out_for_delivery', { userId: profile.userId });
    delivery.status = 'picked_up';
    delivery.pickedUpAt = new Date();
    delivery.timeline.push({ status: 'picked_up', at: delivery.pickedUpAt, byUserId: profile.userId, note: null });
    await delivery.save();
    this.realtime.emitChanged('deliveries', delivery);
    await this.notifications.notify(delivery.customerId, {
      type: 'delivery.picked_up',
      title: 'Your order is on its way',
      body: `Order ${delivery.orderNumber} has left the store.`,
      data: { deliveryId: String(delivery._id), orderId: String(delivery.orderId) },
    });
    return delivery;
  }

  async deliver(
    userId: string,
    deliveryId: string,
    proof: { otp?: string; photo?: { buffer: Buffer; mimetype: string } },
  ): Promise<DeliveryDocument> {
    const { delivery, profile } = await this.getForRider(userId, deliveryId);
    this.assertDeliveryTransition(delivery, 'delivered');
    if (!proof.otp && !proof.photo) {
      throw AppError.badRequest('PROOF_REQUIRED', 'Provide the customer OTP or a proof photo');
    }
    const now = new Date();
    if (proof.otp) {
      const expected = Buffer.from(delivery.proof.otp, 'hex');
      const given = Buffer.from(this.hashOtp(proof.otp.trim()), 'hex');
      if (expected.length !== given.length || !timingSafeEqual(expected, given)) {
        throw AppError.forbidden('INVALID_OTP', 'The OTP does not match');
      }
      delivery.proof.otpVerifiedAt = now;
    }
    if (proof.photo) {
      const image = await this.images.store({
        buffer: proof.photo.buffer,
        mimetype: proof.photo.mimetype,
        ownerType: 'delivery_proof',
        ownerId: delivery._id,
        uploadedBy: profile.userId,
      });
      delivery.proof.photoImageId = image._id;
    }

    const subOrder = await this.subOrders.getById(delivery.subOrderId);
    await this.subOrders.transition(subOrder, 'delivered', { userId: profile.userId });
    delivery.status = 'delivered';
    delivery.deliveredAt = now;
    delivery.timeline.push({ status: 'delivered', at: now, byUserId: profile.userId, note: proof.otp ? 'OTP verified' : 'Photo proof' });
    await delivery.save();
    this.realtime.emitChanged('deliveries', delivery);

    await this.ledger.recordSale({
      vendorId: subOrder.vendorId,
      subOrderId: subOrder._id,
      subtotalKobo: subOrder.subtotalKobo,
      deliveryFeeKobo: subOrder.deliveryFeeKobo,
      commissionKobo: subOrder.commissionKobo,
    });
    await this.riders.setCurrentDelivery(profile._id, null);
    await this.notifications.notify(delivery.customerId, {
      type: 'delivery.delivered',
      title: 'Delivered',
      body: `Order ${delivery.orderNumber} was delivered. Enjoy!`,
      data: { deliveryId: String(delivery._id), orderId: String(delivery.orderId) },
    });
    return delivery;
  }

  private assertDeliveryTransition(delivery: DeliveryDocument, to: DeliveryStatus): void {
    if (!canTransitionDelivery(delivery.status, to)) {
      throw AppError.conflict('INVALID_TRANSITION', `Cannot move delivery from ${delivery.status} to ${to}`, { from: delivery.status, to });
    }
  }
}
