import { Prop, Schema } from '@nestjs/mongoose';
import { HydratedDocument, SchemaTypes, Types } from 'mongoose';
import { BaseDocument, buildSchema } from '../../../common/schemas/base.js';

export type LedgerEntryType = 'sale' | 'commission' | 'refund' | 'payout';
export const LEDGER_TYPES: readonly LedgerEntryType[] = ['sale', 'commission', 'refund', 'payout'];

@Schema({ collection: 'vendorLedger' })
export class VendorLedgerEntry extends BaseDocument {
  @Prop({ type: SchemaTypes.ObjectId, ref: 'Vendor', required: true, index: true })
  vendorId: Types.ObjectId;

  @Prop({ type: SchemaTypes.ObjectId, ref: 'SubOrder', default: null })
  subOrderId: Types.ObjectId | null;

  @Prop({ type: SchemaTypes.ObjectId, ref: 'Payout', default: null })
  payoutId: Types.ObjectId | null;

  @Prop({ type: String, enum: [...LEDGER_TYPES], required: true })
  type: LedgerEntryType;

  /** Signed kobo: sale positive, commission/payout negative. */
  @Prop({ required: true })
  amountKobo: number;

  @Prop({ required: true })
  balanceAfterKobo: number;

  @Prop({ default: '' })
  note: string;
}

export type VendorLedgerEntryDocument = HydratedDocument<VendorLedgerEntry>;
export const VendorLedgerEntrySchema = buildSchema(VendorLedgerEntry);
VendorLedgerEntrySchema.index({ vendorId: 1, _id: -1 });
VendorLedgerEntrySchema.index({ subOrderId: 1, type: 1 });
