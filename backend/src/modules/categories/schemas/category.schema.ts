import { Prop, Schema } from '@nestjs/mongoose';
import { HydratedDocument, SchemaTypes, Types } from 'mongoose';
import { BaseDocument, buildSchema } from '../../../common/schemas/base.js';

@Schema({ collection: 'categories' })
export class Category extends BaseDocument {
  @Prop({ required: true, trim: true })
  name: string;

  @Prop({ required: true, unique: true, lowercase: true, trim: true })
  slug: string;

  @Prop({ type: SchemaTypes.ObjectId, ref: 'Category', default: null, index: true })
  parentId: Types.ObjectId | null;

  @Prop({ default: 0 })
  sortOrder: number;

  @Prop({ type: SchemaTypes.ObjectId, ref: 'Image', default: null })
  imageId: Types.ObjectId | null;
}

export type CategoryDocument = HydratedDocument<Category>;
export const CategorySchema = buildSchema(Category);
CategorySchema.index({ sortOrder: 1, name: 1 });
