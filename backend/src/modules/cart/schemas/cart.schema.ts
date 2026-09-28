import { Prop, Schema, SchemaFactory } from '@nestjs/mongoose';
import { HydratedDocument, SchemaTypes, Types } from 'mongoose';
import { BaseDocument, buildSchema } from '../../../common/schemas/base.js';

/** Same snapshot shape is reused by subOrders.items. */
@Schema({ _id: false })
export class LineItem {
  @Prop({ type: SchemaTypes.ObjectId, ref: 'Product', required: true }) productId: Types.ObjectId;
  @Prop({ type: SchemaTypes.ObjectId, default: null }) variantId: Types.ObjectId | null;
  @Prop({ type: SchemaTypes.ObjectId, ref: 'Vendor', required: true }) vendorId: Types.ObjectId;
  @Prop({ required: true, min: 1 }) qty: number;
  @Prop({ required: true, min: 0 }) priceKoboSnapshot: number;
  @Prop({ required: true }) nameSnapshot: string;
  @Prop({ type: String, default: null }) variantNameSnapshot: string | null;
  @Prop({ type: SchemaTypes.ObjectId, default: null }) imageId: Types.ObjectId | null;
}
export const LineItemSchema = SchemaFactory.createForClass(LineItem);

@Schema({ collection: 'carts' })
export class Cart extends BaseDocument {
  @Prop({ type: SchemaTypes.ObjectId, ref: 'User', required: true, unique: true })
  userId: Types.ObjectId;

  @Prop({ type: [LineItemSchema], default: [] })
  items: LineItem[];

  /** Client write time; the client is the source of truth (LWW). */
  @Prop({ type: Date, default: null })
  clientUpdatedAt: Date | null;
}

export type CartDocument = HydratedDocument<Cart>;
export const CartSchema = buildSchema(Cart);
