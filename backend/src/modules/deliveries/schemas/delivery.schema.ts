import { Prop, Schema, SchemaFactory } from '@nestjs/mongoose';
import { HydratedDocument, SchemaTypes, Types } from 'mongoose';
import { BaseDocument, buildSchema } from '../../../common/schemas/base.js';
import { DELIVERY_STATUSES, type DeliveryStatus } from '../../orders/order-state-machine.js';
import { AddressSnapshot, AddressSnapshotSchema } from '../../orders/schemas/order.schema.js';
import { TimelineEntry, TimelineEntrySchema } from '../../orders/schemas/sub-order.schema.js';

export type OfferResponse = 'pending' | 'accepted' | 'declined';

@Schema({ _id: false })
export class GeoPoint {
  @Prop({ required: true }) lat: number;
  @Prop({ required: true }) lng: number;
}
export const GeoPointSchema = SchemaFactory.createForClass(GeoPoint);

@Schema({ _id: false })
export class Dropoff {
  @Prop({ required: true }) lat: number;
  @Prop({ required: true }) lng: number;
  @Prop({ type: AddressSnapshotSchema, required: true }) addressSnapshot: AddressSnapshot;
}
export const DropoffSchema = SchemaFactory.createForClass(Dropoff);

@Schema({ _id: false })
export class Offer {
  @Prop({ type: SchemaTypes.ObjectId, ref: 'RiderProfile', required: true }) riderId: Types.ObjectId;
  @Prop({ required: true }) at: Date;
  @Prop({ type: String, default: 'pending' }) response: OfferResponse;
  @Prop({ type: Date, default: null }) respondedAt: Date | null;
}
export const OfferSchema = SchemaFactory.createForClass(Offer);

@Schema({ _id: false })
export class DeliveryProof {
  @Prop({ type: SchemaTypes.ObjectId, ref: 'Image', default: null }) photoImageId: Types.ObjectId | null;
  /** HMAC-SHA256 of the OTP (never the plaintext). */
  @Prop({ required: true }) otp: string;
  @Prop({ type: Date, default: null }) otpVerifiedAt: Date | null;
}
export const DeliveryProofSchema = SchemaFactory.createForClass(DeliveryProof);

@Schema({ collection: 'deliveries' })
export class Delivery extends BaseDocument {
  @Prop({ type: SchemaTypes.ObjectId, ref: 'SubOrder', required: true, index: true })
  subOrderId: Types.ObjectId;

  @Prop({ type: SchemaTypes.ObjectId, ref: 'Order', required: true, index: true })
  orderId: Types.ObjectId;

  @Prop({ type: SchemaTypes.ObjectId, ref: 'Vendor', required: true })
  vendorId: Types.ObjectId;

  @Prop({ type: SchemaTypes.ObjectId, ref: 'User', required: true })
  customerId: Types.ObjectId;

  @Prop({ required: true })
  orderNumber: string;

  @Prop({ type: SchemaTypes.ObjectId, ref: 'RiderProfile', default: null })
  riderId: Types.ObjectId | null;

  /** Denormalised for room fan-out to the rider's `user:{id}` room. */
  @Prop({ type: SchemaTypes.ObjectId, ref: 'User', default: null })
  riderUserId: Types.ObjectId | null;

  @Prop({ type: String, enum: [...DELIVERY_STATUSES], default: 'unassigned' })
  status: DeliveryStatus;

  @Prop({ type: GeoPointSchema, required: true })
  pickup: GeoPoint;

  @Prop({ type: DropoffSchema, required: true })
  dropoff: Dropoff;

  @Prop({ type: [OfferSchema], default: [] })
  offeredTo: Offer[];

  @Prop({ type: DeliveryProofSchema, required: true })
  proof: DeliveryProof;

  @Prop({ type: [TimelineEntrySchema], default: [] })
  timeline: TimelineEntry[];

  @Prop({ type: Date, default: null }) pickedUpAt: Date | null;
  @Prop({ type: Date, default: null }) deliveredAt: Date | null;
  @Prop({ default: '' }) failureReason: string;
}

export type DeliveryDocument = HydratedDocument<Delivery>;
export const DeliverySchema = buildSchema(Delivery);
DeliverySchema.index({ vendorId: 1, status: 1, _id: -1 });
DeliverySchema.index({ riderId: 1, status: 1, _id: -1 });
