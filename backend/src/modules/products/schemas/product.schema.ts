import { Prop, Schema, SchemaFactory } from '@nestjs/mongoose';
import { HydratedDocument, Schema as MongooseSchema, SchemaTypes, Types } from 'mongoose';
import { BaseDocument, buildSchema } from '../../../common/schemas/base.js';

export type ProductStatus = 'draft' | 'active' | 'archived';
export const PRODUCT_STATUSES: readonly ProductStatus[] = ['draft', 'active', 'archived'];

@Schema({ _id: false })
export class ProductImageRef {
  @Prop({ type: SchemaTypes.ObjectId, ref: 'Image', required: true }) imageId: Types.ObjectId;
  @Prop({ default: 0 }) sortOrder: number;
}
export const ProductImageRefSchema = SchemaFactory.createForClass(ProductImageRef);

@Schema({ _id: true })
export class ProductVariant {
  _id: Types.ObjectId;
  @Prop({ required: true }) name: string;
  @Prop({ default: '' }) sku: string;
  @Prop({ required: true, min: 0 }) priceKobo: number;
  @Prop({ default: 0 }) stock: number;
  @Prop({ type: MongooseSchema.Types.Mixed, default: {} }) attributes: Record<string, string>;
}
export const ProductVariantSchema = SchemaFactory.createForClass(ProductVariant);

@Schema({ _id: false })
export class ProductRating {
  @Prop({ default: 0 }) avg: number;
  @Prop({ default: 0 }) count: number;
}
export const ProductRatingSchema = SchemaFactory.createForClass(ProductRating);

@Schema({ collection: 'products' })
export class Product extends BaseDocument {
  @Prop({ type: SchemaTypes.ObjectId, ref: 'Vendor', required: true, index: true })
  vendorId: Types.ObjectId;

  @Prop({ required: true, trim: true })
  name: string;

  @Prop({ required: true, lowercase: true, trim: true })
  slug: string;

  @Prop({ default: '' })
  description: string;

  @Prop({ type: [SchemaTypes.ObjectId], ref: 'Category', default: [], index: true })
  categoryIds: Types.ObjectId[];

  @Prop({ type: [ProductImageRefSchema], default: [] })
  images: ProductImageRef[];

  @Prop({ required: true, min: 0 })
  basePriceKobo: number;

  @Prop({ type: [ProductVariantSchema], default: [] })
  variants: ProductVariant[];

  @Prop({ default: false })
  hasVariants: boolean;

  /** Used when `hasVariants` is false. */
  @Prop({ default: 0 })
  stock: number;

  @Prop({ type: String, enum: [...PRODUCT_STATUSES], default: 'draft', index: true })
  status: ProductStatus;

  @Prop({ type: [String], default: [] })
  tags: string[];

  @Prop({ type: ProductRatingSchema, default: () => ({}) })
  rating: ProductRating;

  /** Denormalised name + description + tags + variant names for search. */
  @Prop({ default: '' })
  searchText: string;

  /** Last client write timestamp, for last-write-wins on text fields via sync push. */
  @Prop({ type: Date, default: null })
  clientUpdatedAt: Date | null;
}

export type ProductDocument = HydratedDocument<Product>;
export const ProductSchema = buildSchema(Product);
ProductSchema.index({ vendorId: 1, status: 1, _id: -1 });
ProductSchema.index({ vendorId: 1, slug: 1 });
ProductSchema.index({ status: 1, categoryIds: 1, _id: -1 });
ProductSchema.index({ searchText: 'text' }, { name: 'products_search_text', weights: { searchText: 1 } });
