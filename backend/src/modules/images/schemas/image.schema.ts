import { Prop, Schema } from '@nestjs/mongoose';
import { HydratedDocument, SchemaTypes, Types } from 'mongoose';
import { BaseDocument, buildSchema } from '../../../common/schemas/base.js';

export type ImageOwnerType = 'product' | 'vendor' | 'user' | 'rider_document' | 'delivery_proof' | 'category';

@Schema({ collection: 'images' })
export class Image extends BaseDocument {
  /** Resized to max 1200px. Excluded by default; select `+data`. */
  @Prop({ type: Buffer, required: true, select: false })
  data: Buffer;

  /** 200px thumbnail. Excluded by default; select `+thumb`. */
  @Prop({ type: Buffer, required: true, select: false })
  thumb: Buffer;

  @Prop({ required: true })
  contentType: string;

  @Prop({ required: true })
  size: number;

  @Prop({ required: true })
  width: number;

  @Prop({ required: true })
  height: number;

  @Prop({ type: String, required: true, index: true })
  ownerType: ImageOwnerType;

  @Prop({ type: SchemaTypes.ObjectId, default: null, index: true })
  ownerId: Types.ObjectId | null;

  @Prop({ type: SchemaTypes.ObjectId, ref: 'User', required: true })
  uploadedBy: Types.ObjectId;
}

export type ImageDocument = HydratedDocument<Image>;
export const ImageSchema = buildSchema(Image);
