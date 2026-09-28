import { Schema } from 'mongoose';
import { AddressSchema } from '../../modules/addresses/schemas/address.schema.js';
import { RefreshTokenSchema } from '../../modules/auth/schemas/refresh-token.schema.js';
import { CartSchema } from '../../modules/cart/schemas/cart.schema.js';
import { CategorySchema } from '../../modules/categories/schemas/category.schema.js';
import { DeliverySchema } from '../../modules/deliveries/schemas/delivery.schema.js';
import { ImageSchema } from '../../modules/images/schemas/image.schema.js';
import { PayoutSchema } from '../../modules/ledger/schemas/payout.schema.js';
import { VendorLedgerEntrySchema } from '../../modules/ledger/schemas/vendor-ledger.schema.js';
import { NotificationSchema } from '../../modules/notifications/schemas/notification.schema.js';
import { OrderSchema } from '../../modules/orders/schemas/order.schema.js';
import { SubOrderSchema } from '../../modules/orders/schemas/sub-order.schema.js';
import { PaymentSchema } from '../../modules/payments/schemas/payment.schema.js';
import { InventoryMovementSchema } from '../../modules/products/schemas/inventory-movement.schema.js';
import { ProductSchema } from '../../modules/products/schemas/product.schema.js';
import { RiderLocationSchema } from '../../modules/riders/schemas/rider-location.schema.js';
import { RiderProfileSchema } from '../../modules/riders/schemas/rider-profile.schema.js';
import { SyncOpSchema } from '../../modules/sync/schemas/sync-op.schema.js';
import { UserSchema } from '../../modules/users/schemas/user.schema.js';
import { VendorSchema } from '../../modules/vendors/schemas/vendor.schema.js';

/** Every collection in ARCHITECTURE §4. Importing them exercises all @Prop metadata. */
const SCHEMAS: Record<string, Schema> = {
  users: UserSchema,
  refreshTokens: RefreshTokenSchema,
  vendors: VendorSchema,
  categories: CategorySchema,
  products: ProductSchema,
  inventoryMovements: InventoryMovementSchema,
  images: ImageSchema,
  addresses: AddressSchema,
  carts: CartSchema,
  orders: OrderSchema,
  subOrders: SubOrderSchema,
  payments: PaymentSchema,
  vendorLedger: VendorLedgerEntrySchema,
  payouts: PayoutSchema,
  riderProfiles: RiderProfileSchema,
  riderLocations: RiderLocationSchema,
  deliveries: DeliverySchema,
  notifications: NotificationSchema,
  syncOps: SyncOpSchema,
};

function indexes(schema: Schema): Array<Record<string, unknown>> {
  return schema.indexes().map(([fields]) => fields as Record<string, unknown>);
}

function indexOptions(schema: Schema, field: string): Record<string, unknown> | undefined {
  const found = schema.indexes().find(([fields]) => Object.keys(fields as object).join(',') === field);
  return found?.[1] as Record<string, unknown> | undefined;
}

describe('Mongoose schemas (§4)', () => {
  it.each(Object.entries(SCHEMAS))('%s builds and carries the base fields + updatedAt index', (name, schema) => {
    expect(schema.path('deletedAt')).toBeDefined();
    expect(schema.path('version')).toBeDefined();
    expect(schema.get('timestamps')).toBeTruthy();
    expect(schema.get('versionKey')).toBe(false);
    expect(indexes(schema).some((f) => Object.keys(f).length === 1 && f['updatedAt'] === 1)).toBe(true);
    expect(schema.get('collection')).toBe(name);
  });

  it.each(Object.entries(SCHEMAS))('%s: every ref path is a real ObjectId path (not Mixed)', (_name, schema) => {
    const offenders: string[] = [];
    schema.eachPath((path, type) => {
      const opts = type.options as { ref?: unknown; type?: unknown };
      const isArray = type.instance === 'Array';
      const inner = isArray ? (type as unknown as { embeddedSchemaType?: { instance?: string } }).embeddedSchemaType?.instance : type.instance;
      if (opts.ref !== undefined && inner !== 'ObjectId') offenders.push(`${path}:${String(inner)}`);
      if (type.instance === 'Mixed' && !['data', 'attributes', 'result'].includes(path.split('.').pop() ?? '')) offenders.push(`${path}:Mixed`);
    });
    expect(offenders).toEqual([]);
  });

  it('declares the contract indexes', () => {
    expect(UserSchema.path('email').options).toMatchObject({ unique: true });
    expect(VendorSchema.path('slug').options).toMatchObject({ unique: true });
    expect(RefreshTokenSchema.path('tokenHash').options).toMatchObject({ unique: true });
    expect(SyncOpSchema.path('opId').options).toMatchObject({ unique: true });
    expect(CartSchema.path('userId').options).toMatchObject({ unique: true });
    expect(indexOptions(RiderLocationSchema, 'at')).toMatchObject({ expireAfterSeconds: 24 * 60 * 60 });
    expect(indexOptions(SyncOpSchema, 'processedAt')).toMatchObject({ expireAfterSeconds: 30 * 24 * 60 * 60 });
    expect(indexes(ProductSchema).some((f) => f['searchText'] === 'text')).toBe(true);
  });

  it('hides secrets and binary blobs by default', () => {
    expect(UserSchema.path('passwordHash').options).toMatchObject({ select: false });
    expect(ImageSchema.path('data').options).toMatchObject({ select: false });
    expect(ImageSchema.path('thumb').options).toMatchObject({ select: false });
    expect(PaymentSchema.path('clientSecret').options).toMatchObject({ select: false });
  });
});
