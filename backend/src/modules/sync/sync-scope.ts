import { Types } from 'mongoose';
import { hasRole, type AuthUser } from '../../common/types/auth-user.js';

/** Collections a client may pull, mapped to their Mongoose model names. */
export const SYNC_COLLECTIONS = {
  products: 'Product',
  vendors: 'Vendor',
  categories: 'Category',
  orders: 'Order',
  subOrders: 'SubOrder',
  deliveries: 'Delivery',
  carts: 'Cart',
  addresses: 'Address',
  notifications: 'Notification',
  riderProfiles: 'RiderProfile',
  inventoryMovements: 'InventoryMovement',
  vendorLedger: 'VendorLedgerEntry',
  payouts: 'Payout',
  users: 'User',
} as const;
export type SyncCollection = keyof typeof SYNC_COLLECTIONS;

export function isSyncCollection(value: string): value is SyncCollection {
  return Object.hasOwn(SYNC_COLLECTIONS, value);
}

export interface SyncDoc {
  _id: Types.ObjectId;
  updatedAt: Date;
  deletedAt: Date | null;
  [key: string]: unknown;
}

export interface ScopeContext {
  user: AuthUser;
  riderProfileId: Types.ObjectId | null;
}

export interface Scope {
  /** Mongo filter restricting what the caller may see. `null` = collection not visible. */
  filter: Record<string, unknown> | null;
  /** Docs matching the filter but that the client must treat as deleted. */
  isTombstone?: (doc: SyncDoc) => boolean;
}

/**
 * Role-based scoping for `GET /sync/pull` (§7): every collection is filtered to
 * what the caller may see; docs they may no longer see arrive as tombstones.
 */
export function scopeFor(collection: SyncCollection, ctx: ScopeContext): Scope {
  const { user } = ctx;
  const me = new Types.ObjectId(user.userId);
  const isAdmin = hasRole(user, 'admin');
  const vendorId =
    user.vendorId && hasRole(user, 'vendor_owner', 'vendor_staff')
      ? new Types.ObjectId(user.vendorId)
      : null;
  const riderId = hasRole(user, 'rider') ? ctx.riderProfileId : null;

  switch (collection) {
    case 'categories':
      return { filter: {} };
    case 'products':
      // Vendor product management must only ever receive its own catalogue.
      // Returning all active products here made another vendor's product look
      // editable in the vendor app; image uploads then correctly failed the
      // server-side ownership check with PRODUCT_NOT_FOUND.
      if (isAdmin) return { filter: {} };
      if (vendorId) return { filter: { vendorId } };
      return {
        filter: {},
        isTombstone: (d) => d['status'] !== 'active',
      };
    case 'vendors':
      return {
        filter: {},
        isTombstone: (d) =>
          d['status'] !== 'active' &&
          !(vendorId && String(d._id) === String(vendorId)) &&
          !isAdmin,
      };
    case 'orders':
      if (isAdmin) return { filter: {} };
      if (hasRole(user, 'customer')) return { filter: { customerId: me } };
      return { filter: null };
    case 'subOrders':
      if (isAdmin) return { filter: {} };
      if (vendorId) {
        return {
          filter: hasRole(user, 'customer')
            ? { $or: [{ vendorId }, { customerId: me }] }
            : { vendorId },
          isTombstone: (d) =>
            d['status'] === 'awaiting_payment' &&
            String(d['customerId']) !== String(me),
        };
      }
      if (hasRole(user, 'customer')) return { filter: { customerId: me } };
      return { filter: null };
    case 'deliveries':
      if (isAdmin) return { filter: {} };
      if (vendorId) return { filter: { vendorId } };
      if (riderId) {
        return {
          filter: { $or: [{ riderId }, { 'offeredTo.riderId': riderId }] },
          isTombstone: (d) => String(d['riderId']) !== String(riderId),
        };
      }
      if (hasRole(user, 'customer')) return { filter: { customerId: me } };
      return { filter: null };
    case 'carts':
    case 'addresses':
    case 'notifications':
      return { filter: { userId: me } };
    case 'riderProfiles':
      if (isAdmin) return { filter: {} };
      if (vendorId) return { filter: { vendorId } };
      if (hasRole(user, 'rider')) return { filter: { userId: me } };
      return { filter: null };
    case 'inventoryMovements':
    case 'vendorLedger':
      if (vendorId) return { filter: { vendorId } };
      return { filter: isAdmin ? {} : null };
    case 'payouts':
      if (isAdmin) return { filter: {} };
      if (vendorId) return { filter: { vendorId } };
      return { filter: null };
    case 'users':
      return { filter: { _id: me } };
  }
}
