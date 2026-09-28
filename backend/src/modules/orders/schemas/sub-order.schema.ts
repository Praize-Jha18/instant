import { Prop, Schema, SchemaFactory } from '@nestjs/mongoose';
import { HydratedDocument, SchemaTypes, Types } from 'mongoose';
import { BaseDocument, buildSchema } from '../../../common/schemas/base.js';
import { LineItem, LineItemSchema } from '../../cart/schemas/cart.schema.js';
import { SUB_ORDER_STATUSES, type SubOrderStatus } from '../order-state-machine.js';

@Schema({ _id: false })
export class TimelineEntry {
  @Prop({ required: true }) status: string;
  @Prop({ required: true }) at: Date;
  @Prop({ type: SchemaTypes.ObjectId, default: null }) byUserId: Types.ObjectId | null;
  @Prop({ type: String, default: null }) note: string | null;
}
export const TimelineEntrySchema = SchemaFactory.createForClass(TimelineEntry);

@Schema({ collection: 'subOrders' })
export class SubOrder extends BaseDocument {
  @Prop({ type: SchemaTypes.ObjectId, ref: 'Order', required: true, index: true })
  orderId: Types.ObjectId;

  @Prop({ type: SchemaTypes.ObjectId, ref: 'Vendor', required: true })
  vendorId: Types.ObjectId;

  @Prop({ type: SchemaTypes.ObjectId, ref: 'User', required: true, index: true })
  customerId: Types.ObjectId;

  @Prop({ required: true })
  orderNumber: string;

  @Prop({ default: '' })
  vendorNameSnapshot: string;

  @Prop({ type: [LineItemSchema], required: true })
  items: LineItem[];

  @Prop({ required: true }) subtotalKobo: number;
  @Prop({ required: true }) deliveryFeeKobo: number;
  @Prop({ required: true }) commissionKobo: number;
  @Prop({ required: true }) vendorNetKobo: number;

  @Prop({ type: String, enum: [...SUB_ORDER_STATUSES], default: 'awaiting_payment' })
  status: SubOrderStatus;

  @Prop({ type: SchemaTypes.ObjectId, ref: 'Delivery', default: null })
  deliveryId: Types.ObjectId | null;

  /** Plaintext OTP the customer gives the rider; the delivery doc holds only the hash. */
  @Prop({ type: String, default: null })
  deliveryOtp: string | null;

  @Prop({ type: [TimelineEntrySchema], default: [] })
  timeline: TimelineEntry[];

  @Prop({ default: 0 })
  refundedKobo: number;
}

export type SubOrderDocument = HydratedDocument<SubOrder>;
export const SubOrderSchema = buildSchema(SubOrder);
SubOrderSchema.index({ vendorId: 1, status: 1, _id: -1 });
SubOrderSchema.index({ customerId: 1, _id: -1 });
export { LineItem };
