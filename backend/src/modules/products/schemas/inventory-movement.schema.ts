import { Prop, Schema } from '@nestjs/mongoose';
import { HydratedDocument, SchemaTypes, Types } from 'mongoose';
import { BaseDocument, buildSchema } from '../../../common/schemas/base.js';

export type InventoryReason = 'sale' | 'restock' | 'adjustment' | 'return' | 'cancel';
export const INVENTORY_REASONS: readonly InventoryReason[] = ['sale', 'restock', 'adjustment', 'return', 'cancel'];

@Schema({ collection: 'inventoryMovements' })
export class InventoryMovement extends BaseDocument {
  @Prop({ type: SchemaTypes.ObjectId, ref: 'Vendor', required: true, index: true })
  vendorId: Types.ObjectId;

  @Prop({ type: SchemaTypes.ObjectId, ref: 'Product', required: true, index: true })
  productId: Types.ObjectId;

  @Prop({ type: SchemaTypes.ObjectId, default: null })
  variantId: Types.ObjectId | null;

  @Prop({ required: true })
  delta: number;

  @Prop({ type: String, enum: [...INVENTORY_REASONS], required: true })
  reason: InventoryReason;

  @Prop({ type: SchemaTypes.ObjectId, ref: 'Order', default: null })
  orderId: Types.ObjectId | null;

  @Prop({ type: SchemaTypes.ObjectId, ref: 'User', default: null })
  byUserId: Types.ObjectId | null;

  @Prop({ default: '' })
  note: string;
}

export type InventoryMovementDocument = HydratedDocument<InventoryMovement>;
export const InventoryMovementSchema = buildSchema(InventoryMovement);
InventoryMovementSchema.index({ vendorId: 1, _id: -1 });
