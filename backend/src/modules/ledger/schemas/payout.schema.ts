import { Prop, Schema } from '@nestjs/mongoose';
import { HydratedDocument, SchemaTypes, Types } from 'mongoose';
import { BaseDocument, buildSchema } from '../../../common/schemas/base.js';

export type PayoutStatus = 'requested' | 'paid' | 'failed';
export const PAYOUT_STATUSES: readonly PayoutStatus[] = ['requested', 'paid', 'failed'];

@Schema({ collection: 'payouts' })
export class Payout extends BaseDocument {
  @Prop({ type: SchemaTypes.ObjectId, ref: 'Vendor', required: true, index: true })
  vendorId: Types.ObjectId;

  @Prop({ required: true, min: 1 })
  amountKobo: number;

  @Prop({ type: String, enum: [...PAYOUT_STATUSES], default: 'requested', index: true })
  status: PayoutStatus;

  @Prop({ type: String, default: 'manual' })
  method: 'manual';

  @Prop({ default: '' })
  reference: string;

  @Prop({ type: Date, default: null })
  paidAt: Date | null;

  @Prop({ type: SchemaTypes.ObjectId, ref: 'User', required: true })
  requestedBy: Types.ObjectId;

  @Prop({ type: SchemaTypes.ObjectId, ref: 'User', default: null })
  processedBy: Types.ObjectId | null;

  @Prop({ default: '' })
  failureReason: string;
}

export type PayoutDocument = HydratedDocument<Payout>;
export const PayoutSchema = buildSchema(Payout);
