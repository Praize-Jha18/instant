import { Prop, Schema, SchemaFactory } from '@nestjs/mongoose';
import { HydratedDocument, SchemaTypes, Types } from 'mongoose';
import { BaseDocument, buildSchema } from '../../../common/schemas/base.js';

export type PaymentRecordStatus = 'pending' | 'succeeded' | 'failed' | 'canceled' | 'refunded' | 'partially_refunded';

@Schema({ _id: false })
export class PaymentRawEvent {
  @Prop({ required: true }) id: string;
  @Prop({ required: true }) type: string;
  @Prop({ required: true }) at: Date;
}
export const PaymentRawEventSchema = SchemaFactory.createForClass(PaymentRawEvent);

@Schema({ collection: 'payments' })
export class Payment extends BaseDocument {
  @Prop({ type: SchemaTypes.ObjectId, ref: 'Order', required: true, index: true })
  orderId: Types.ObjectId;

  @Prop({ type: String, required: true })
  provider: 'stripe' | 'mock';

  /** PaymentIntent id (or provider equivalent). */
  @Prop({ required: true, unique: true })
  providerRef: string;

  @Prop({ required: true })
  amountKobo: number;

  @Prop({ default: 'NGN' })
  currency: string;

  @Prop({ type: String, default: 'pending', index: true })
  status: PaymentRecordStatus;

  /** Last 20 provider events; used for webhook idempotency. */
  @Prop({ type: [PaymentRawEventSchema], default: [] })
  rawEvents: PaymentRawEvent[];

  @Prop({ required: true })
  idempotencyKey: string;

  @Prop({ type: String, default: null, select: false })
  clientSecret: string | null;

  @Prop({ default: 0 })
  refundedKobo: number;
}

export type PaymentDocument = HydratedDocument<Payment>;
export const PaymentSchema = buildSchema(Payment);
