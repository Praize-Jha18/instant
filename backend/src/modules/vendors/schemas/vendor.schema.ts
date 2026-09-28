import { Prop, Schema, SchemaFactory } from '@nestjs/mongoose';
import { HydratedDocument, SchemaTypes, Types } from 'mongoose';
import { BaseDocument, buildSchema } from '../../../common/schemas/base.js';

export type VendorStatus = 'pending' | 'active' | 'suspended';
export const VENDOR_STATUSES: readonly VendorStatus[] = ['pending', 'active', 'suspended'];

@Schema({ _id: false })
export class VendorAddress {
  @Prop({ default: '' }) line1: string;
  @Prop({ default: '' }) city: string;
  @Prop({ default: '' }) state: string;
  @Prop({ default: 'NG' }) country: string;
  @Prop({ type: Number, default: null }) lat: number | null;
  @Prop({ type: Number, default: null }) lng: number | null;
}
export const VendorAddressSchema = SchemaFactory.createForClass(VendorAddress);

@Schema({ _id: false })
export class VendorDeliveryFee {
  @Prop({ default: 50_000 }) baseKobo: number;
  @Prop({ default: 10_000 }) perKmKobo: number;
  @Prop({ type: Number, default: null }) freeAboveKobo: number | null;
}
export const VendorDeliveryFeeSchema = SchemaFactory.createForClass(VendorDeliveryFee);

@Schema({ _id: false })
export class OpeningHours {
  /** 0 = Sunday … 6 = Saturday */
  @Prop({ required: true, min: 0, max: 6 }) day: number;
  @Prop({ required: true }) open: string;
  @Prop({ required: true }) close: string;
  /** Closed all day; open/close are ignored. */
  @Prop({ default: false }) closed: boolean;
}
export const OpeningHoursSchema = SchemaFactory.createForClass(OpeningHours);

@Schema({ _id: false })
export class VendorPayoutDetails {
  @Prop({ default: '' }) bankName: string;
  @Prop({ default: '' }) accountNumber: string;
  @Prop({ default: '' }) accountName: string;
}
export const VendorPayoutDetailsSchema = SchemaFactory.createForClass(VendorPayoutDetails);

@Schema({ collection: 'vendors' })
export class Vendor extends BaseDocument {
  @Prop({ required: true, trim: true })
  name: string;

  @Prop({ required: true, unique: true, lowercase: true, trim: true })
  slug: string;

  @Prop({ default: '' })
  description: string;

  @Prop({ type: SchemaTypes.ObjectId, ref: 'Image', default: null })
  logoImageId: Types.ObjectId | null;

  @Prop({ type: SchemaTypes.ObjectId, ref: 'Image', default: null })
  coverImageId: Types.ObjectId | null;

  @Prop({ type: SchemaTypes.ObjectId, ref: 'User', required: true, index: true })
  ownerUserId: Types.ObjectId;

  @Prop({ type: String, enum: [...VENDOR_STATUSES], default: 'pending', index: true })
  status: VendorStatus;

  @Prop({ type: VendorAddressSchema, default: () => ({}) })
  address: VendorAddress;

  @Prop({ type: VendorDeliveryFeeSchema, default: () => ({}) })
  deliveryFee: VendorDeliveryFee;

  @Prop({ default: 10 })
  deliveryRadiusKm: number;

  @Prop({ type: [OpeningHoursSchema], default: [] })
  openingHours: OpeningHours[];

  /** Platform take in basis points; 1000 = 10%. */
  @Prop({ default: 1000, min: 0, max: 10_000 })
  commissionBps: number;

  @Prop({ type: VendorPayoutDetailsSchema, default: () => ({}) })
  payout: VendorPayoutDetails;
}

export type VendorDocument = HydratedDocument<Vendor>;
export const VendorSchema = buildSchema(Vendor);
VendorSchema.index({ name: 'text', description: 'text' });
