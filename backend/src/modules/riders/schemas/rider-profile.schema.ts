import { Prop, Schema, SchemaFactory } from '@nestjs/mongoose';
import { HydratedDocument, SchemaTypes, Types } from 'mongoose';
import { BaseDocument, buildSchema } from '../../../common/schemas/base.js';

export type RiderStatus = 'pending' | 'active' | 'suspended';
export const RIDER_STATUSES: readonly RiderStatus[] = ['pending', 'active', 'suspended'];

@Schema({ _id: false })
export class RiderDocumentRef {
  @Prop({ required: true }) type: string;
  @Prop({ type: SchemaTypes.ObjectId, ref: 'Image', required: true }) imageId: Types.ObjectId;
}
export const RiderDocumentRefSchema = SchemaFactory.createForClass(RiderDocumentRef);

@Schema({ collection: 'riderProfiles' })
export class RiderProfile extends BaseDocument {
  @Prop({ type: SchemaTypes.ObjectId, ref: 'User', required: true, unique: true })
  userId: Types.ObjectId;

  @Prop({ type: SchemaTypes.ObjectId, ref: 'Vendor', required: true, index: true })
  vendorId: Types.ObjectId;

  @Prop({ type: String, enum: [...RIDER_STATUSES], default: 'pending', index: true })
  status: RiderStatus;

  @Prop({ default: 'bike' })
  vehicleType: string;

  @Prop({ default: '' })
  plateNumber: string;

  @Prop({ type: [RiderDocumentRefSchema], default: [] })
  documents: RiderDocumentRef[];

  @Prop({ default: false, index: true })
  isOnline: boolean;

  @Prop({ type: Date, default: null })
  lastSeenAt: Date | null;

  @Prop({ type: SchemaTypes.ObjectId, ref: 'Delivery', default: null })
  currentDeliveryId: Types.ObjectId | null;
}

export type RiderProfileDocument = HydratedDocument<RiderProfile>;
export const RiderProfileSchema = buildSchema(RiderProfile);
RiderProfileSchema.index({ vendorId: 1, status: 1, isOnline: 1 });
