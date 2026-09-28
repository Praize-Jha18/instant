import { Prop, Schema } from '@nestjs/mongoose';
import { HydratedDocument, SchemaTypes, Types } from 'mongoose';
import { BaseDocument, buildSchema } from '../../../common/schemas/base.js';

@Schema({ collection: 'addresses' })
export class Address extends BaseDocument {
  @Prop({ type: SchemaTypes.ObjectId, ref: 'User', required: true, index: true })
  userId: Types.ObjectId;

  @Prop({ default: 'Home' }) label: string;
  @Prop({ required: true }) line1: string;
  @Prop({ default: '' }) line2: string;
  @Prop({ required: true }) city: string;
  @Prop({ required: true }) state: string;
  @Prop({ required: true }) lat: number;
  @Prop({ required: true }) lng: number;
  @Prop({ default: '' }) phone: string;
  @Prop({ default: false }) isDefault: boolean;

  /** Client write time for last-write-wins via sync push. */
  @Prop({ type: Date, default: null })
  clientUpdatedAt: Date | null;
}

export type AddressDocument = HydratedDocument<Address>;
export const AddressSchema = buildSchema(Address);
