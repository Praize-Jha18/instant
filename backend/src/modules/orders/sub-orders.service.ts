import { Injectable } from '@nestjs/common';
import { InjectModel } from '@nestjs/mongoose';
import { Model, QueryFilter, Types } from 'mongoose';
import { AppError } from '../../common/errors/app-error.js';
import { clampLimit, idCursorFilter, idPage, type Page } from '../../common/pagination/cursor.js';
import { notDeleted } from '../../common/schemas/base.js';
import { oid } from '../../common/utils/ids.js';
import { RealtimeService } from '../realtime/realtime.service.js';
import { canTransition, type SubOrderStatus } from './order-state-machine.js';
import { SubOrder, type SubOrderDocument } from './schemas/sub-order.schema.js';

export interface TransitionActor {
  userId?: Types.ObjectId | string | null;
  note?: string | null;
}

export interface VendorSubOrdersQuery {
  status?: SubOrderStatus;
  cursor?: string;
  limit?: number;
}

/**
 * Low-level SubOrder persistence + state machine enforcement. Side effects
 * (deliveries, ledger, stock) live in the callers so this module has no
 * dependency on them.
 */
@Injectable()
export class SubOrdersService {
  constructor(
    @InjectModel(SubOrder.name) private readonly subOrders: Model<SubOrder>,
    private readonly realtime: RealtimeService,
  ) {}

  get model(): Model<SubOrder> {
    return this.subOrders;
  }

  async findByOrder(orderId: Types.ObjectId): Promise<SubOrderDocument[]> {
    return this.subOrders.find({ orderId, ...notDeleted }).sort({ _id: 1 }).exec();
  }

  async findByOrders(orderIds: Types.ObjectId[]): Promise<SubOrderDocument[]> {
    if (orderIds.length === 0) return [];
    return this.subOrders.find({ orderId: { $in: orderIds }, ...notDeleted }).sort({ _id: 1 }).exec();
  }

  async getById(id: Types.ObjectId | string): Promise<SubOrderDocument> {
    const doc = await this.subOrders.findOne({ _id: typeof id === 'string' ? oid(id, 'subOrderId') : id, ...notDeleted }).exec();
    if (!doc) throw AppError.notFound('SUB_ORDER_NOT_FOUND', 'Sub-order not found');
    return doc;
  }

  /** Vendor view: never exposes awaiting_payment (§6 payment gate). */
  async getForVendor(vendorId: string, id: string): Promise<SubOrderDocument> {
    const doc = await this.subOrders
      .findOne({ _id: oid(id, 'subOrderId'), vendorId: oid(vendorId, 'vendorId'), status: { $ne: 'awaiting_payment' }, ...notDeleted })
      .exec();
    if (!doc) throw AppError.notFound('SUB_ORDER_NOT_FOUND', 'Sub-order not found');
    return doc;
  }

  async listForVendor(vendorId: string, query: VendorSubOrdersQuery): Promise<Page<SubOrderDocument>> {
    const limit = clampLimit(query.limit);
    const filter: QueryFilter<SubOrder> = {
      vendorId: oid(vendorId, 'vendorId'),
      ...notDeleted,
      ...idCursorFilter(query.cursor),
    };
    filter.status = query.status && query.status !== 'awaiting_payment' ? query.status : { $ne: 'awaiting_payment' };
    const docs = await this.subOrders.find(filter).sort({ _id: -1 }).limit(limit + 1).exec();
    return idPage(docs, limit);
  }

  async listAdmin(query: { status?: SubOrderStatus; vendorId?: string; cursor?: string; limit?: number }): Promise<Page<SubOrderDocument>> {
    const limit = clampLimit(query.limit);
    const filter: QueryFilter<SubOrder> = { ...notDeleted, ...idCursorFilter(query.cursor) };
    if (query.status) filter.status = query.status;
    if (query.vendorId) filter.vendorId = oid(query.vendorId, 'vendorId');
    const docs = await this.subOrders.find(filter).sort({ _id: -1 }).limit(limit + 1).exec();
    return idPage(docs, limit);
  }

  /**
   * Applies a state-machine transition, appends a timeline entry, persists and
   * emits realtime. Throws 409 INVALID_TRANSITION when not allowed.
   */
  async transition(subOrder: SubOrderDocument, to: SubOrderStatus, actor: TransitionActor = {}): Promise<SubOrderDocument> {
    if (!canTransition(subOrder.status, to)) {
      throw AppError.conflict('INVALID_TRANSITION', `Cannot move sub-order from ${subOrder.status} to ${to}`, {
        from: subOrder.status,
        to,
      });
    }
    return this.forceStatus(subOrder, to, actor);
  }

  /** Bypasses the state machine. Only for documented special cases (payment retry reopen). */
  async forceStatus(subOrder: SubOrderDocument, to: SubOrderStatus, actor: TransitionActor = {}): Promise<SubOrderDocument> {
    subOrder.status = to;
    subOrder.timeline.push({
      status: to,
      at: new Date(),
      byUserId: actor.userId ? new Types.ObjectId(String(actor.userId)) : null,
      note: actor.note ?? null,
    });
    await subOrder.save();
    this.realtime.emitChanged('subOrders', subOrder);
    return subOrder;
  }

  async setDelivery(subOrder: SubOrderDocument, deliveryId: Types.ObjectId, otp: string): Promise<void> {
    subOrder.deliveryId = deliveryId;
    subOrder.deliveryOtp = otp;
    await subOrder.save();
    this.realtime.emitChanged('subOrders', subOrder);
  }

  async addRefund(subOrder: SubOrderDocument, amountKobo: number): Promise<void> {
    subOrder.refundedKobo += amountKobo;
    await subOrder.save();
  }
}
