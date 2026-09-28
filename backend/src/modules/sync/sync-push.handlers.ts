import { Injectable } from '@nestjs/common';
import { plainToInstance } from 'class-transformer';
import { validateSync, type ValidationError } from 'class-validator';
import { Types } from 'mongoose';
import { AppError } from '../../common/errors/app-error.js';
import { hasRole, type AuthUser } from '../../common/types/auth-user.js';
import { isObjectId } from '../../common/utils/ids.js';
import { AddressesService } from '../addresses/addresses.service.js';
import { CreateAddressDto } from '../addresses/dto/address.dto.js';
import { CartService } from '../cart/cart.service.js';
import { ReplaceCartDto } from '../cart/dto/cart.dto.js';
import { ProductTextPatchDto, StockAdjustDto } from '../products/dto/product.dto.js';
import { ProductsService } from '../products/products.service.js';
import { StockService } from '../products/stock.service.js';
import { RiderLocationBatchDto, RiderLocationDto } from '../riders/dto/rider.dto.js';
import { RidersService } from '../riders/riders.service.js';
import type { SyncOpDto } from './dto/sync.dto.js';

export type HandlerResult =
  | { status: 'applied'; doc?: unknown; docId?: string; code?: string }
  | { status: 'rejected'; code: string; message: string };

type Ctor<T> = new () => T;

function flatten(errors: ValidationError[], prefix = ''): string[] {
  return errors.flatMap((e) => {
    const own = Object.values(e.constraints ?? {}).map((m) => `${prefix}${m}`);
    const nested = e.children?.length ? flatten(e.children, `${prefix}${e.property}.`) : [];
    return [...own, ...nested];
  });
}

function validated<T extends object>(cls: Ctor<T>, payload: unknown): T {
  const instance = plainToInstance(cls, payload ?? {});
  const errors = validateSync(instance, { whitelist: true, forbidUnknownValues: false });
  if (errors.length > 0) {
    throw AppError.badRequest('VALIDATION_ERROR', 'Invalid payload', flatten(errors));
  }
  return instance;
}

function str(value: unknown): string | undefined {
  return typeof value === 'string' ? value : undefined;
}

/** Canonical entity names accepted from clients (singular or plural). */
const ENTITY_ALIASES: Record<string, string> = {
  cart: 'carts',
  carts: 'carts',
  address: 'addresses',
  addresses: 'addresses',
  riderprofile: 'riderProfiles',
  riderprofiles: 'riderProfiles',
  riderlocation: 'riderLocations',
  riderlocations: 'riderLocations',
  product: 'products',
  products: 'products',
  stock: 'stock',
  inventory: 'stock',
};

export function resolveOperation(op: SyncOpDto): string {
  const entity = ENTITY_ALIASES[op.entity.toLowerCase()] ?? op.entity;
  if (op.action === 'custom') {
    const name =
      str(op.customAction) ?? str(op.payload?.["name"]) ?? str(op.payload?.["type"]) ?? str(op.payload?.["op"]);
    if (!name) return `${entity}.custom`;
    return name.includes('.') ? name : `${entity}.${name}`;
  }
  return `${entity}.${op.action}`;
}

/**
 * Applies one pushed op. Each handler is a delta or an LWW upsert so replays are safe (§7).
 */
@Injectable()
export class SyncPushHandlers {
  constructor(
    private readonly cart: CartService,
    private readonly addresses: AddressesService,
    private readonly riders: RidersService,
    private readonly products: ProductsService,
    private readonly stock: StockService,
  ) {}

  async apply(user: AuthUser, op: SyncOpDto): Promise<HandlerResult> {
    const clientAt = new Date(op.clientAt);
    const operation = resolveOperation(op);
    const payload = op.payload ?? {};
    try {
      switch (operation) {
        case 'carts.upsert': {
          const dto = validated(ReplaceCartDto, payload);
          const cart = await this.cart.replace(user.userId, dto.items, clientAt);
          return { status: 'applied', doc: cart.toJSON(), docId: String(cart._id) };
        }
        case 'addresses.upsert': {
          const dto = validated(CreateAddressDto, payload);
          const doc = await this.addresses.upsertFromSync(user.userId, dto, clientAt);
          return { status: 'applied', doc: doc.toJSON(), docId: String(doc._id) };
        }
        case 'addresses.delete': {
          const id = str(payload['id']) ?? str(payload['_id']);
          if (!id || !isObjectId(id)) return { status: 'rejected', code: 'INVALID_ID', message: 'payload.id must be an ObjectId' };
          try {
            const doc = await this.addresses.remove(user.userId, id);
            return { status: 'applied', docId: String(doc._id) };
          } catch (err) {
            if (err instanceof AppError && err.code === 'ADDRESS_NOT_FOUND') return { status: 'applied', docId: id, code: 'ALREADY_DELETED' };
            throw err;
          }
        }
        case 'riderProfiles.upsert': {
          if (!hasRole(user, 'rider')) return { status: 'rejected', code: 'FORBIDDEN_ROLE', message: 'Only riders may update a rider profile' };
          const isOnline = payload['isOnline'];
          if (typeof isOnline !== 'boolean') return { status: 'rejected', code: 'VALIDATION_ERROR', message: 'Only { isOnline: boolean } may be synced' };
          const profile = await this.riders.setOnline(user.userId, isOnline);
          return { status: 'applied', doc: profile.toJSON(), docId: String(profile._id) };
        }
        case 'riderLocations.upsert': {
          if (!hasRole(user, 'rider')) return { status: 'rejected', code: 'FORBIDDEN_ROLE', message: 'Only riders may push locations' };
          const profile = await this.riders.requireByUserId(user.userId);
          const points = Array.isArray(payload['points'])
            ? validated(RiderLocationBatchDto, payload).points
            : [validated(RiderLocationDto, payload)];
          const result = await this.riders.ingestBatch(profile, points);
          return { status: 'applied', doc: result };
        }
        case 'products.upsert': {
          if (!user.vendorId || !hasRole(user, 'vendor_owner', 'vendor_staff')) {
            return { status: 'rejected', code: 'VENDOR_SCOPE_REQUIRED', message: 'Only vendor users may edit products' };
          }
          const id = str(payload['id']) ?? str(payload['_id']);
          if (!id || !isObjectId(id)) return { status: 'rejected', code: 'INVALID_ID', message: 'payload.id must be an existing product id' };
          const patch = validated(ProductTextPatchDto, payload);
          const doc = await this.products.patchText(new Types.ObjectId(user.vendorId), new Types.ObjectId(id), patch, clientAt);
          if (!doc) {
            const current = await this.products.getForVendor(user.vendorId, id);
            return { status: 'applied', doc: current.toJSON(), docId: id, code: 'SERVER_NEWER' };
          }
          return { status: 'applied', doc: doc.toJSON(), docId: String(doc._id) };
        }
        case 'stock.adjust': {
          if (!user.vendorId || !hasRole(user, 'vendor_owner', 'vendor_staff')) {
            return { status: 'rejected', code: 'VENDOR_SCOPE_REQUIRED', message: 'Only vendor users may adjust stock' };
          }
          const productId = str(payload['productId']);
          if (!productId || !isObjectId(productId)) return { status: 'rejected', code: 'INVALID_ID', message: 'payload.productId is required' };
          const dto = validated(StockAdjustDto, { reason: 'adjustment', ...payload });
          const product = await this.products.getForVendor(user.vendorId, productId);
          const result = await this.stock.adjust(product.vendorId, product._id, dto, new Types.ObjectId(user.userId));
          return { status: 'applied', doc: result, docId: productId };
        }
        default:
          return { status: 'rejected', code: 'UNSUPPORTED_OPERATION', message: `Unsupported sync operation: ${operation}` };
      }
    } catch (err) {
      if (err instanceof AppError) {
        return { status: 'rejected', code: err.code, message: err.message };
      }
      throw err;
    }
  }
}
