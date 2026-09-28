import { Prop, Schema, SchemaFactory } from '@nestjs/mongoose';
import { HydratedDocument, SchemaTypes, Types } from 'mongoose';
import { BaseDocument, buildSchema } from '../../../common/schemas/base.js';

export type OrderPaymentStatus = 'pending' | 'paid' | 'failed' | 'refunded' | 'partially_refunded';
export const ORDER_PAYMENT_STATUSES: readonly OrderPaymentStatus[] = ['pending', 'paid', 'failed', 'refunded', 'partially_refunded'];

@Schema({ _id: false })
export class AddressSnapshot {
  @Prop({ type: SchemaTypes.ObjectId, default: null }) addressId: Types.ObjectId | null;
  @Prop({ default: '' }) label: string;
  @Prop({ required: true }) line1: string;
  @Prop({ default: '' }) line2: string;
  @Prop({ required: true }) city: string;
  @Prop({ required: true }) state: string;
  @Prop({ required: true }) lat: number;
  @Prop({ required: true }) lng: number;
  @Prop({ default: '' }) phone: string;
}
export const AddressSnapshotSchema = SchemaFactory.createForClass(AddressSnapshot);

@Schema({ collection: 'orders' })
export class Order extends BaseDocument {
  @Prop({ type: SchemaTypes.ObjectId, ref: 'User', required: true, index: true })
  customerId: Types.ObjectId;

  @Prop({ required: true, unique: true })
  orderNumber: string;

  @Prop({ type: [SchemaTypes.ObjectId], ref: 'SubOrder', default: [] })
  subOrderIds: Types.ObjectId[];

  @Prop({ type: AddressSnapshotSchema, required: true })
  addressSnapshot: AddressSnapshot;

  @Prop({ required: true }) subtotalKobo: number;
  @Prop({ required: true }) deliveryTotalKobo: number;
  @Prop({ required: true }) totalKobo: number;
  @Prop({ default: 'NGN' }) currency: string;

  @Prop({ type: String, enum: [...ORDER_PAYMENT_STATUSES], default: 'pending', index: true })
  paymentStatus: OrderPaymentStatus;

  @Prop({ type: SchemaTypes.ObjectId, ref: 'Payment', default: null })
  paymentId: Types.ObjectId | null;

  @Prop({ required: true, index: true })
  placedAt: Date;

  @Prop({ type: Date, default: null })
  paidAt: Date | null;

  /** Unpaid orders expire at this time (placedAt + 30 min). */
  @Prop({ required: true })
  expiresAt: Date;

  @Prop({ default: '' })
  note: string;
}

export type OrderDocument = HydratedDocument<Order>;
export const OrderSchema = buildSchema(Order);
OrderSchema.index({ customerId: 1, _id: -1 });
OrderSchema.index({ paymentStatus: 1, expiresAt: 1 });
