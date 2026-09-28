import { Injectable } from '@nestjs/common';
import { InjectModel } from '@nestjs/mongoose';
import { Model, QueryFilter, Types } from 'mongoose';
import { AppError } from '../../common/errors/app-error.js';
import { clampLimit, idCursorFilter, idPage, type Page } from '../../common/pagination/cursor.js';
import { notDeleted } from '../../common/schemas/base.js';
import { oid } from '../../common/utils/ids.js';
import { NotificationsService } from '../notifications/notifications.service.js';
import { RealtimeService } from '../realtime/realtime.service.js';
import type { PaginationQueryDto } from '../../common/dto/pagination-query.dto.js';
import type { PayoutsQueryDto } from './dto/ledger.dto.js';
import { Payout, type PayoutDocument } from './schemas/payout.schema.js';
import { VendorLedgerEntry, type LedgerEntryType, type VendorLedgerEntryDocument } from './schemas/vendor-ledger.schema.js';

export interface SaleInput {
  vendorId: Types.ObjectId;
  subOrderId: Types.ObjectId;
  subtotalKobo: number;
  deliveryFeeKobo: number;
  commissionKobo: number;
}

export interface VendorBalance {
  balanceKobo: number;
  pendingPayoutKobo: number;
  availableKobo: number;
}

/**
 * Earnings accrue here; payouts are manual bank transfers marked paid by admin (§8).
 */
@Injectable()
export class LedgerService {
  constructor(
    @InjectModel(VendorLedgerEntry.name) private readonly ledger: Model<VendorLedgerEntry>,
    @InjectModel(Payout.name) private readonly payouts: Model<Payout>,
    private readonly notifications: NotificationsService,
    private readonly realtime: RealtimeService,
  ) {}

  async append(
    vendorId: Types.ObjectId,
    entry: { type: LedgerEntryType; amountKobo: number; subOrderId?: Types.ObjectId | null; payoutId?: Types.ObjectId | null; note?: string },
  ): Promise<VendorLedgerEntryDocument> {
    const last = await this.ledger.findOne({ vendorId }).sort({ _id: -1 }).select('balanceAfterKobo').exec();
    const balanceAfterKobo = (last?.balanceAfterKobo ?? 0) + entry.amountKobo;
    const doc = await this.ledger.create({
      vendorId,
      subOrderId: entry.subOrderId ?? null,
      payoutId: entry.payoutId ?? null,
      type: entry.type,
      amountKobo: entry.amountKobo,
      balanceAfterKobo,
      note: entry.note ?? '',
    });
    this.realtime.emitChanged('vendorLedger', doc);
    return doc;
  }

  /** Idempotent: a subOrder's sale is recorded once. */
  async recordSale(input: SaleInput): Promise<void> {
    const exists = await this.ledger.exists({ subOrderId: input.subOrderId, type: 'sale' });
    if (exists) return;
    await this.append(input.vendorId, {
      type: 'sale',
      amountKobo: input.subtotalKobo + input.deliveryFeeKobo,
      subOrderId: input.subOrderId,
      note: 'Order delivered',
    });
    if (input.commissionKobo > 0) {
      await this.append(input.vendorId, {
        type: 'commission',
        amountKobo: -input.commissionKobo,
        subOrderId: input.subOrderId,
        note: 'Platform commission',
      });
    }
  }

  async balance(vendorId: Types.ObjectId): Promise<VendorBalance> {
    const [last, pending] = await Promise.all([
      this.ledger.findOne({ vendorId }).sort({ _id: -1 }).select('balanceAfterKobo').exec(),
      this.payouts
        .aggregate<{ total: number }>([
          { $match: { vendorId, status: 'requested', ...notDeleted } },
          { $group: { _id: null, total: { $sum: '$amountKobo' } } },
        ])
        .exec(),
    ]);
    const balanceKobo = last?.balanceAfterKobo ?? 0;
    const pendingPayoutKobo = pending[0]?.total ?? 0;
    return { balanceKobo, pendingPayoutKobo, availableKobo: Math.max(0, balanceKobo - pendingPayoutKobo) };
  }

  async listLedger(vendorId: string, query: PaginationQueryDto): Promise<Page<VendorLedgerEntryDocument> & { balance: VendorBalance }> {
    const owner = oid(vendorId, 'vendorId');
    const limit = clampLimit(query.limit);
    const docs = await this.ledger
      .find({ vendorId: owner, ...notDeleted, ...idCursorFilter(query.cursor) })
      .sort({ _id: -1 })
      .limit(limit + 1)
      .exec();
    return { ...idPage(docs, limit), balance: await this.balance(owner) };
  }

  async requestPayout(vendorId: string, requestedBy: string, amountKobo?: number): Promise<PayoutDocument> {
    const owner = oid(vendorId, 'vendorId');
    const balance = await this.balance(owner);
    const amount = amountKobo ?? balance.availableKobo;
    if (amount <= 0) throw AppError.conflict('NOTHING_TO_PAY_OUT', 'No available balance');
    if (amount > balance.availableKobo) {
      throw AppError.conflict('INSUFFICIENT_BALANCE', 'Requested amount exceeds available balance', balance);
    }
    const doc = await this.payouts.create({ vendorId: owner, amountKobo: amount, status: 'requested', method: 'manual', requestedBy: oid(requestedBy, 'userId') });
    this.realtime.emitChanged('payouts', doc);
    return doc;
  }

  async listPayouts(query: PayoutsQueryDto): Promise<Page<PayoutDocument>> {
    const limit = clampLimit(query.limit);
    const filter: QueryFilter<Payout> = { ...notDeleted, ...idCursorFilter(query.cursor) };
    if (query.vendorId) filter.vendorId = oid(query.vendorId, 'vendorId');
    if (query.status) filter.status = query.status;
    const docs = await this.payouts.find(filter).sort({ _id: -1 }).limit(limit + 1).exec();
    return idPage(docs, limit);
  }

  async markPaid(payoutId: string, adminUserId: string, reference?: string): Promise<PayoutDocument> {
    const doc = await this.payouts
      .findOneAndUpdate(
        { _id: oid(payoutId, 'payoutId'), status: 'requested', ...notDeleted },
        { $set: { status: 'paid', paidAt: new Date(), reference: reference ?? '', processedBy: oid(adminUserId, 'userId') } },
        { new: true },
      )
      .exec();
    if (!doc) throw AppError.conflict('PAYOUT_NOT_PENDING', 'Payout not found or already processed');
    await this.append(doc.vendorId, { type: 'payout', amountKobo: -doc.amountKobo, payoutId: doc._id, note: reference ?? 'Manual bank transfer' });
    this.realtime.emitChanged('payouts', doc);
    await this.notifications.notify(doc.requestedBy, {
      type: 'payout.paid',
      title: 'Payout sent',
      body: `₦${(doc.amountKobo / 100).toLocaleString('en-NG')} has been transferred.`,
      data: { payoutId: String(doc._id) },
    });
    return doc;
  }

  async markFailed(payoutId: string, adminUserId: string, reason?: string): Promise<PayoutDocument> {
    const doc = await this.payouts
      .findOneAndUpdate(
        { _id: oid(payoutId, 'payoutId'), status: 'requested', ...notDeleted },
        { $set: { status: 'failed', failureReason: reason ?? '', processedBy: oid(adminUserId, 'userId') } },
        { new: true },
      )
      .exec();
    if (!doc) throw AppError.conflict('PAYOUT_NOT_PENDING', 'Payout not found or already processed');
    this.realtime.emitChanged('payouts', doc);
    return doc;
  }
}
