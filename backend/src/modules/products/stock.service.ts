import { Injectable } from '@nestjs/common';
import { InjectModel } from '@nestjs/mongoose';
import { Model, QueryFilter, Types, UpdateQuery } from 'mongoose';
import { AppError } from '../../common/errors/app-error.js';
import { clampLimit, idCursorFilter, idPage, type Page } from '../../common/pagination/cursor.js';
import { notDeleted } from '../../common/schemas/base.js';
import { oid } from '../../common/utils/ids.js';
import type { MovementsQueryDto, StockAdjustDto } from './dto/product.dto.js';
import { InventoryMovement, type InventoryMovementDocument, type InventoryReason } from './schemas/inventory-movement.schema.js';
import { Product } from './schemas/product.schema.js';

export interface StockLine {
  productId: Types.ObjectId;
  variantId: Types.ObjectId | null;
  vendorId: Types.ObjectId;
  qty: number;
}

export interface StockContext {
  orderId: Types.ObjectId | null;
  byUserId: Types.ObjectId | null;
  note?: string;
}

export interface FailedLine {
  productId: string;
  variantId: string | null;
  requested: number;
}

/**
 * Stock is never changed from the client. Every change is an atomic `$inc`
 * and writes an `inventoryMovements` row (§6).
 */
@Injectable()
export class StockService {
  constructor(
    @InjectModel(Product.name) private readonly products: Model<Product>,
    @InjectModel(InventoryMovement.name) private readonly movements: Model<InventoryMovement>,
  ) {}

  /**
   * Reserves every line or none: `$inc` guarded by `stock >= qty`. If any line
   * cannot be reserved, the lines already taken are rolled back and a 409 is thrown.
   */
  async reserve(lines: StockLine[], ctx: StockContext): Promise<void> {
    const taken: StockLine[] = [];
    for (const line of lines) {
      const ok = await this.decrementGuarded(line);
      if (!ok) {
        await this.incrementLines(taken, ctx, 'cancel', 'rollback: reservation failed');
        const failed: FailedLine = {
          productId: String(line.productId),
          variantId: line.variantId ? String(line.variantId) : null,
          requested: line.qty,
        };
        throw AppError.conflict('INSUFFICIENT_STOCK', 'One or more items are out of stock', failed);
      }
      taken.push(line);
    }
    if (taken.length > 0) {
      await this.movements.insertMany(
        taken.map((l) => ({
          vendorId: l.vendorId,
          productId: l.productId,
          variantId: l.variantId,
          delta: -l.qty,
          reason: 'sale' as const,
          orderId: ctx.orderId,
          byUserId: ctx.byUserId,
          note: ctx.note ?? '',
        })),
      );
    }
  }

  /** Puts reserved stock back (payment failure, expiry, cancellation). */
  async release(lines: StockLine[], ctx: StockContext, reason: Extract<InventoryReason, 'cancel' | 'return'>): Promise<void> {
    await this.incrementLines(lines, ctx, reason, ctx.note ?? '');
  }

  /** Vendor stock adjustment by delta. Negative deltas are guarded so stock never goes below zero. */
  async adjust(
    vendorId: Types.ObjectId,
    productId: Types.ObjectId,
    dto: StockAdjustDto,
    byUserId: Types.ObjectId | null,
  ): Promise<{ productId: string; variantId: string | null; delta: number; movementId: string }> {
    if (dto.delta === 0) throw AppError.badRequest('ZERO_DELTA', 'delta must be non-zero');
    const variantId = dto.variantId ? oid(dto.variantId, 'variantId') : null;
    const line: StockLine = { productId, variantId, vendorId, qty: Math.abs(dto.delta) };

    const ok =
      dto.delta < 0
        ? await this.decrementGuarded(line, vendorId)
        : await this.incrementOne(line, vendorId);
    if (!ok) {
      throw AppError.conflict('INSUFFICIENT_STOCK', 'Stock cannot go below zero', {
        productId: String(productId),
        variantId: variantId ? String(variantId) : null,
      });
    }
    const movement = await this.movements.create({
      vendorId,
      productId,
      variantId,
      delta: dto.delta,
      reason: dto.reason,
      orderId: null,
      byUserId,
      note: dto.note ?? '',
    });
    return { productId: String(productId), variantId: variantId ? String(variantId) : null, delta: dto.delta, movementId: String(movement._id) };
  }

  async listMovements(vendorId: string, query: MovementsQueryDto): Promise<Page<InventoryMovementDocument>> {
    const limit = clampLimit(query.limit);
    const filter: QueryFilter<InventoryMovement> = {
      vendorId: oid(vendorId, 'vendorId'),
      ...notDeleted,
      ...idCursorFilter(query.cursor),
    };
    if (query.productId) filter.productId = oid(query.productId, 'productId');
    const docs = await this.movements.find(filter).sort({ _id: -1 }).limit(limit + 1).exec();
    return idPage(docs, limit);
  }

  private async decrementGuarded(line: StockLine, vendorId?: Types.ObjectId): Promise<boolean> {
    const base: QueryFilter<Product> = { _id: line.productId, ...notDeleted };
    if (vendorId) base.vendorId = vendorId;
    let filter: QueryFilter<Product>;
    let update: UpdateQuery<Product>;
    if (line.variantId) {
      filter = { ...base, variants: { $elemMatch: { _id: line.variantId, stock: { $gte: line.qty } } } };
      update = { $inc: { 'variants.$.stock': -line.qty } };
    } else {
      filter = { ...base, hasVariants: false, stock: { $gte: line.qty } };
      update = { $inc: { stock: -line.qty } };
    }
    const res = await this.products.updateOne(filter, update).exec();
    return res.modifiedCount === 1;
  }

  private async incrementOne(line: StockLine, vendorId?: Types.ObjectId): Promise<boolean> {
    const base: QueryFilter<Product> = { _id: line.productId, ...notDeleted };
    if (vendorId) base.vendorId = vendorId;
    const filter: QueryFilter<Product> = line.variantId
      ? { ...base, 'variants._id': line.variantId }
      : { ...base, hasVariants: false };
    const update: UpdateQuery<Product> = line.variantId
      ? { $inc: { 'variants.$.stock': line.qty } }
      : { $inc: { stock: line.qty } };
    const res = await this.products.updateOne(filter, update).exec();
    return res.modifiedCount === 1;
  }

  private async incrementLines(lines: StockLine[], ctx: StockContext, reason: InventoryReason, note: string): Promise<void> {
    if (lines.length === 0) return;
    for (const line of lines) {
      await this.incrementOne(line);
    }
    await this.movements.insertMany(
      lines.map((l) => ({
        vendorId: l.vendorId,
        productId: l.productId,
        variantId: l.variantId,
        delta: l.qty,
        reason,
        orderId: ctx.orderId,
        byUserId: ctx.byUserId,
        note,
      })),
    );
  }
}
