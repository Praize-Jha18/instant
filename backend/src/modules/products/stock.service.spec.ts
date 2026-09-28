import { Model, Types } from 'mongoose';
import { AppError } from '../../common/errors/app-error.js';
import type { InventoryMovement } from './schemas/inventory-movement.schema.js';
import type { Product } from './schemas/product.schema.js';
import { StockService, type StockLine } from './stock.service.js';

interface FakeVariant {
  _id: Types.ObjectId;
  stock: number;
}
interface FakeProduct {
  _id: Types.ObjectId;
  hasVariants: boolean;
  stock: number;
  variants: FakeVariant[];
}

interface Filter {
  _id: Types.ObjectId;
  hasVariants?: boolean;
  stock?: { $gte: number };
  variants?: { $elemMatch: { _id: Types.ObjectId; stock: { $gte: number } } };
  'variants._id'?: Types.ObjectId;
}
interface Update {
  $inc: Record<string, number>;
}

/**
 * In-memory stand-in for the Product model that honours the exact filter/update
 * shapes StockService relies on (guarded `$inc`, positional variant update).
 */
function fakeProductModel(products: FakeProduct[]) {
  const calls: Array<{ filter: Filter; update: Update }> = [];
  const model = {
    calls,
    updateOne(filter: Filter, update: Update) {
      calls.push({ filter, update });
      return {
        exec: async () => {
          const p = products.find((x) => x._id.equals(filter._id));
          if (!p) return { modifiedCount: 0 };
          if (filter.variants) {
            const { _id, stock } = filter.variants.$elemMatch;
            const v = p.variants.find((x) => x._id.equals(_id) && x.stock >= stock.$gte);
            if (!v) return { modifiedCount: 0 };
            v.stock += update.$inc['variants.$.stock'] ?? 0;
            return { modifiedCount: 1 };
          }
          if (filter['variants._id']) {
            const v = p.variants.find((x) => x._id.equals(filter['variants._id'] as Types.ObjectId));
            if (!v) return { modifiedCount: 0 };
            v.stock += update.$inc['variants.$.stock'] ?? 0;
            return { modifiedCount: 1 };
          }
          if (filter.hasVariants === false && p.hasVariants) return { modifiedCount: 0 };
          if (filter.stock && p.stock < filter.stock.$gte) return { modifiedCount: 0 };
          p.stock += update.$inc['stock'] ?? 0;
          return { modifiedCount: 1 };
        },
      };
    },
  };
  return model;
}

function fakeMovementModel() {
  const rows: Array<Record<string, unknown>> = [];
  return {
    rows,
    async insertMany(docs: Array<Record<string, unknown>>) {
      rows.push(...docs);
      return docs;
    },
    async create(doc: Record<string, unknown>) {
      rows.push(doc);
      return { ...doc, _id: new Types.ObjectId() };
    },
  };
}

describe('StockService.reserve (atomic all-or-nothing)', () => {
  const vendorId = new Types.ObjectId();
  const orderId = new Types.ObjectId();
  const userId = new Types.ObjectId();
  const ctx = { orderId, byUserId: userId };

  function setup() {
    const simple: FakeProduct = { _id: new Types.ObjectId(), hasVariants: false, stock: 5, variants: [] };
    const variantId = new Types.ObjectId();
    const withVariants: FakeProduct = { _id: new Types.ObjectId(), hasVariants: true, stock: 0, variants: [{ _id: variantId, stock: 2 }] };
    const products = fakeProductModel([simple, withVariants]);
    const movements = fakeMovementModel();
    const service = new StockService(products as unknown as Model<Product>, movements as unknown as Model<InventoryMovement>);
    return { simple, withVariants, variantId, products, movements, service };
  }

  it('decrements every line and writes one sale movement per line', async () => {
    const { simple, withVariants, variantId, movements, service } = setup();
    const lines: StockLine[] = [
      { productId: simple._id, variantId: null, vendorId, qty: 3 },
      { productId: withVariants._id, variantId, vendorId, qty: 2 },
    ];
    await service.reserve(lines, ctx);
    expect(simple.stock).toBe(2);
    expect(withVariants.variants[0]?.stock).toBe(0);
    expect(movements.rows).toHaveLength(2);
    expect(movements.rows.every((r) => r['reason'] === 'sale' && r['orderId'] === orderId)).toBe(true);
    expect(movements.rows.map((r) => r['delta'])).toEqual([-3, -2]);
  });

  it('rolls back already-reserved lines when a later line has insufficient stock', async () => {
    const { simple, withVariants, variantId, movements, service } = setup();
    const lines: StockLine[] = [
      { productId: simple._id, variantId: null, vendorId, qty: 4 },
      { productId: withVariants._id, variantId, vendorId, qty: 3 }, // only 2 available
    ];
    await expect(service.reserve(lines, ctx)).rejects.toMatchObject({ code: 'INSUFFICIENT_STOCK' });
    expect(simple.stock).toBe(5); // restored
    expect(withVariants.variants[0]?.stock).toBe(2); // untouched
    // Rollback is audited as a `cancel` movement; no `sale` rows were written.
    expect(movements.rows.filter((r) => r['reason'] === 'sale')).toHaveLength(0);
    expect(movements.rows.filter((r) => r['reason'] === 'cancel')).toHaveLength(1);
  });

  it('reports which line failed', async () => {
    const { withVariants, variantId, service } = setup();
    try {
      await service.reserve([{ productId: withVariants._id, variantId, vendorId, qty: 99 }], ctx);
      throw new Error('should have thrown');
    } catch (err) {
      expect(err).toBeInstanceOf(AppError);
      expect((err as AppError).details).toEqual({ productId: String(withVariants._id), variantId: String(variantId), requested: 99 });
    }
  });

  it('release puts stock back and records the reason', async () => {
    const { simple, movements, service } = setup();
    await service.release([{ productId: simple._id, variantId: null, vendorId, qty: 2 }], { ...ctx, note: 'expired' }, 'cancel');
    expect(simple.stock).toBe(7);
    expect(movements.rows[0]).toMatchObject({ delta: 2, reason: 'cancel', note: 'expired' });
  });

  it('adjust guards negative deltas so stock never goes below zero', async () => {
    const { simple, movements, service } = setup();
    await expect(service.adjust(vendorId, simple._id, { delta: -6, reason: 'adjustment' }, userId)).rejects.toMatchObject({ code: 'INSUFFICIENT_STOCK' });
    expect(simple.stock).toBe(5);
    const ok = await service.adjust(vendorId, simple._id, { delta: 10, reason: 'restock', note: 'delivery' }, userId);
    expect(simple.stock).toBe(15);
    expect(ok.delta).toBe(10);
    expect(movements.rows.at(-1)).toMatchObject({ delta: 10, reason: 'restock' });
  });
});
