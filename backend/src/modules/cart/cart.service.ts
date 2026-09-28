import { Injectable } from '@nestjs/common';
import { InjectModel } from '@nestjs/mongoose';
import { Model, Types } from 'mongoose';
import { oid } from '../../common/utils/ids.js';
import { RealtimeService } from '../realtime/realtime.service.js';
import type { CartItemDto } from './dto/cart.dto.js';
import { Cart, type CartDocument, type LineItem } from './schemas/cart.schema.js';

export function toLineItem(dto: CartItemDto): LineItem {
  return {
    productId: new Types.ObjectId(dto.productId),
    variantId: dto.variantId ? new Types.ObjectId(dto.variantId) : null,
    vendorId: new Types.ObjectId(dto.vendorId),
    qty: dto.qty,
    priceKoboSnapshot: dto.priceKoboSnapshot,
    nameSnapshot: dto.nameSnapshot,
    variantNameSnapshot: dto.variantNameSnapshot ?? null,
    imageId: dto.imageId ? new Types.ObjectId(dto.imageId) : null,
  };
}

@Injectable()
export class CartService {
  constructor(
    @InjectModel(Cart.name) private readonly carts: Model<Cart>,
    private readonly realtime: RealtimeService,
  ) {}

  async get(userId: string | Types.ObjectId): Promise<CartDocument> {
    const owner = typeof userId === 'string' ? oid(userId, 'userId') : userId;
    const doc = await this.carts
      .findOneAndUpdate({ userId: owner }, { $setOnInsert: { userId: owner, items: [] } }, { new: true, upsert: true })
      .exec();
    return doc as CartDocument;
  }

  /** Full replace; the client is the source of truth. */
  async replace(userId: string | Types.ObjectId, items: CartItemDto[], clientAt: Date = new Date()): Promise<CartDocument> {
    const cart = await this.get(userId);
    if (cart.clientUpdatedAt && cart.clientUpdatedAt.getTime() > clientAt.getTime()) {
      return cart; // stale write from an offline device; server copy wins (LWW)
    }
    cart.items = items.map(toLineItem);
    cart.clientUpdatedAt = clientAt;
    await cart.save();
    this.realtime.emitChanged('carts', cart);
    return cart;
  }

  async clear(userId: Types.ObjectId): Promise<void> {
    const cart = await this.get(userId);
    cart.items = [];
    cart.clientUpdatedAt = new Date();
    await cart.save();
    this.realtime.emitChanged('carts', cart);
  }
}
