import { Prop, Schema } from '@nestjs/mongoose';
import { HydratedDocument, SchemaTypes, Types } from 'mongoose';
import { BaseDocument, buildSchema } from '../../../common/schemas/base.js';

@Schema({ collection: 'riderLocations' })
export class RiderLocation extends BaseDocument {
  @Prop({ type: SchemaTypes.ObjectId, ref: 'RiderProfile', required: true })
  riderId: Types.ObjectId;

  @Prop({ type: SchemaTypes.ObjectId, ref: 'Vendor', required: true })
  vendorId: Types.ObjectId;

  @Prop({ required: true }) lat: number;
  @Prop({ required: true }) lng: number;
  @Prop({ type: Number, default: null }) heading: number | null;
  @Prop({ type: Number, default: null }) speed: number | null;

  @Prop({ required: true })
  at: Date;
}

export type RiderLocationDocument = HydratedDocument<RiderLocation>;
export const RiderLocationSchema = buildSchema(RiderLocation);
RiderLocationSchema.index({ riderId: 1, at: -1 });
RiderLocationSchema.index({ vendorId: 1, at: -1 });
/** Time-series-like: rows expire after 24h (§4). */
RiderLocationSchema.index({ at: 1 }, { expireAfterSeconds: 24 * 60 * 60 });
