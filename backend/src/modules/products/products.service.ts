import { Injectable } from '@nestjs/common';
import { InjectModel } from '@nestjs/mongoose';
import { Model, PipelineStage, QueryFilter, Types } from 'mongoose';
import { AppError } from '../../common/errors/app-error.js';
import { clampLimit, decodeCursor, encodeCursor, idCursorFilter, idPage, type Page } from '../../common/pagination/cursor.js';
import { notDeleted } from '../../common/schemas/base.js';
import { oid } from '../../common/utils/ids.js';
import { uniqueSlug } from '../../common/utils/slug.js';
import { AppConfig } from '../../config/app-config.service.js';
import { CategoriesService } from '../categories/categories.service.js';
import { ImagesService } from '../images/images.service.js';
import { RealtimeService } from '../realtime/realtime.service.js';
import { escapeRegex } from '../users/users.service.js';
import { Vendor } from '../vendors/schemas/vendor.schema.js';
import type {
  CreateProductDto,
  ProductTextPatchDto,
  ProductVariantDto,
  PublicProductsQueryDto,
  UpdateProductDto,
  VendorProductsQueryDto,
} from './dto/product.dto.js';
import { Product, type ProductDocument, type ProductVariant } from './schemas/product.schema.js';

interface OffsetCursor {
  skip: number;
}

export function buildSearchText(p: Pick<Product, 'name' | 'description' | 'tags'> & { variants?: Array<Pick<ProductVariant, 'name'>> }): string {
  return [p.name, p.description, ...(p.tags ?? []), ...(p.variants ?? []).map((v) => v.name)]
    .filter((s) => typeof s === 'string' && s.trim().length > 0)
    .join(' ')
    .toLowerCase();
}

@Injectable()
export class ProductsService {
  private activeVendorCache: { at: number; ids: Types.ObjectId[] } | null = null;

  constructor(
    @InjectModel(Product.name) private readonly products: Model<Product>,
    @InjectModel(Vendor.name) private readonly vendors: Model<Vendor>,
    private readonly images: ImagesService,
    private readonly categories: CategoriesService,
    private readonly realtime: RealtimeService,
    private readonly config: AppConfig,
  ) {}

  // ───────────────────────────── public catalogue ─────────────────────────────

  async listPublic(query: PublicProductsQueryDto): Promise<Page<ProductDocument>> {
    const limit = clampLimit(query.limit);
    const filter: QueryFilter<Product> = { status: 'active', ...notDeleted };

    if (query.vendorId) {
      const vendor = await this.vendors.findOne({ _id: oid(query.vendorId, 'vendorId'), status: 'active', ...notDeleted }).select('_id').exec();
      if (!vendor) throw AppError.notFound('VENDOR_NOT_FOUND', 'Vendor not found');
      filter.vendorId = vendor._id;
    } else {
      filter.vendorId = { $in: await this.activeVendorIds() };
    }
    if (query.categoryId) filter.categoryIds = oid(query.categoryId, 'categoryId');

    const q = query.q?.trim();
    if (q && this.config.atlasSearchIndex) {
      return this.atlasSearch(q, filter, limit, query.cursor);
    }
    if (q) {
      // Regex fallback when Atlas Search is not configured.
      filter.searchText = { $regex: escapeRegex(q.toLowerCase()) };
    }
    Object.assign(filter, idCursorFilter(query.cursor));
    const docs = await this.products.find(filter).sort({ _id: -1 }).limit(limit + 1).exec();
    return idPage(docs, limit);
  }

  private async atlasSearch(q: string, filter: QueryFilter<Product>, limit: number, cursor?: string): Promise<Page<ProductDocument>> {
    const skip = decodeCursor<OffsetCursor>(cursor)?.skip ?? 0;
    const pipeline: PipelineStage[] = [
      {
        $search: {
          index: this.config.atlasSearchIndex,
          text: { query: q, path: ['name', 'description', 'tags', 'searchText'], fuzzy: { maxEdits: 1 } },
        },
      },
      { $match: filter },
      { $skip: skip },
      { $limit: limit + 1 },
    ];
    const raw = await this.products.aggregate<Record<string, unknown>>(pipeline).exec();
    const docs = raw.map((r) => this.products.hydrate(r));
    const hasMore = docs.length > limit;
    return {
      items: hasMore ? docs.slice(0, limit) : docs,
      nextCursor: hasMore ? encodeCursor({ skip: skip + limit } satisfies OffsetCursor) : null,
    };
  }

  private async activeVendorIds(): Promise<Types.ObjectId[]> {
    const now = Date.now();
    if (this.activeVendorCache && now - this.activeVendorCache.at < 30_000) return this.activeVendorCache.ids;
    const rows = await this.vendors.find({ status: 'active', ...notDeleted }).select('_id').lean().exec();
    const ids = rows.map((r) => r._id);
    this.activeVendorCache = { at: now, ids };
    return ids;
  }

  async getPublic(id: string): Promise<ProductDocument> {
    const doc = await this.products.findOne({ _id: oid(id, 'productId'), status: 'active', ...notDeleted }).exec();
    if (!doc) throw AppError.notFound('PRODUCT_NOT_FOUND', 'Product not found');
    return doc;
  }

  /** Active, non-deleted products by id (checkout snapshotting). */
  findActiveByIds(ids: Types.ObjectId[]): Promise<ProductDocument[]> {
    return this.products.find({ _id: { $in: ids }, status: 'active', ...notDeleted }).exec();
  }

  // ───────────────────────────── vendor CRUD ─────────────────────────────

  async listForVendor(vendorId: string, query: VendorProductsQueryDto): Promise<Page<ProductDocument>> {
    const limit = clampLimit(query.limit);
    const filter: QueryFilter<Product> = { vendorId: oid(vendorId, 'vendorId'), ...notDeleted, ...idCursorFilter(query.cursor) };
    if (query.status) filter.status = query.status;
    if (query.q) filter.searchText = { $regex: escapeRegex(query.q.toLowerCase()) };
    const docs = await this.products.find(filter).sort({ _id: -1 }).limit(limit + 1).exec();
    return idPage(docs, limit);
  }

  async getForVendor(vendorId: string | Types.ObjectId, id: string | Types.ObjectId): Promise<ProductDocument> {
    const doc = await this.products
      .findOne({ _id: typeof id === 'string' ? oid(id, 'productId') : id, vendorId: typeof vendorId === 'string' ? oid(vendorId, 'vendorId') : vendorId, ...notDeleted })
      .exec();
    if (!doc) throw AppError.notFound('PRODUCT_NOT_FOUND', 'Product not found');
    return doc;
  }

  async create(vendorId: string, dto: CreateProductDto): Promise<ProductDocument> {
    await this.assertCategories(dto.categoryIds);
    const variants = (dto.variants ?? []).map((v) => this.toVariant(v));
    const hasVariants = variants.length > 0;
    const doc = await this.products.create({
      vendorId: oid(vendorId, 'vendorId'),
      name: dto.name,
      slug: uniqueSlug(dto.name),
      description: dto.description ?? '',
      categoryIds: (dto.categoryIds ?? []).map((c) => new Types.ObjectId(c)),
      basePriceKobo: dto.basePriceKobo,
      variants,
      hasVariants,
      stock: hasVariants ? 0 : (dto.stock ?? 0),
      status: dto.status ?? 'draft',
      tags: dto.tags ?? [],
      searchText: buildSearchText({ name: dto.name, description: dto.description ?? '', tags: dto.tags ?? [], variants }),
    });
    this.realtime.emitChanged('products', doc);
    return doc;
  }

  async update(vendorId: string, id: string, dto: UpdateProductDto): Promise<ProductDocument> {
    const doc = await this.getForVendor(vendorId, id);
    await this.assertCategories(dto.categoryIds);
    if (dto.name !== undefined) doc.name = dto.name;
    if (dto.description !== undefined) doc.description = dto.description;
    if (dto.categoryIds !== undefined) doc.categoryIds = dto.categoryIds.map((c) => new Types.ObjectId(c));
    if (dto.basePriceKobo !== undefined) doc.basePriceKobo = dto.basePriceKobo;
    if (dto.status !== undefined) doc.status = dto.status;
    if (dto.tags !== undefined) doc.tags = dto.tags;
    if (dto.images !== undefined) {
      const current = new Set(doc.images.map((i) => String(i.imageId)));
      const incoming = new Set(dto.images.map((i) => i.imageId));
      if (current.size !== incoming.size || [...current].some((id) => !incoming.has(id))) {
        throw AppError.badRequest('IMAGE_SET_MISMATCH', 'images must list exactly the images attached to this product');
      }
      const order = new Map(dto.images.map((i) => [i.imageId, i.sortOrder]));
      doc.images = doc.images
        .map((i) => ({ imageId: i.imageId, sortOrder: order.get(String(i.imageId)) ?? i.sortOrder }))
        .sort((a, b) => a.sortOrder - b.sortOrder);
    }
    if (dto.variants !== undefined) {
      // Existing variants keep their server-side stock; new ones may set an initial stock.
      const existing = new Map(doc.variants.map((v) => [String(v._id), v]));
      doc.variants = dto.variants.map((v) => {
        const prev = v.id ? existing.get(v.id) : undefined;
        const next = this.toVariant(v, prev);
        return next;
      });
      doc.hasVariants = doc.variants.length > 0;
      if (doc.hasVariants) doc.stock = 0;
    }
    doc.searchText = buildSearchText(doc);
    doc.clientUpdatedAt = new Date();
    await doc.save();
    this.realtime.emitChanged('products', doc);
    return doc;
  }

  /**
   * Sync push: text fields only, last-write-wins by `clientAt`.
   * Returns null when the incoming write is older than what the server holds.
   */
  async patchText(vendorId: Types.ObjectId, id: Types.ObjectId, patch: ProductTextPatchDto, clientAt: Date): Promise<ProductDocument | null> {
    const doc = await this.getForVendor(vendorId, id);
    if (doc.clientUpdatedAt && doc.clientUpdatedAt.getTime() > clientAt.getTime()) return null;
    if (patch.name !== undefined) doc.name = patch.name;
    if (patch.description !== undefined) doc.description = patch.description;
    if (patch.tags !== undefined) doc.tags = patch.tags;
    doc.searchText = buildSearchText(doc);
    doc.clientUpdatedAt = clientAt;
    await doc.save();
    this.realtime.emitChanged('products', doc);
    return doc;
  }

  async remove(vendorId: string, id: string): Promise<ProductDocument> {
    const doc = await this.getForVendor(vendorId, id);
    doc.deletedAt = new Date();
    doc.status = 'archived';
    await doc.save();
    this.realtime.emitRemoved('products', doc);
    return doc;
  }

  async addImage(vendorId: string, id: string, file: { buffer: Buffer; mimetype: string }, uploadedBy: string): Promise<ProductDocument> {
    const doc = await this.getForVendor(vendorId, id);
    if (doc.images.length >= 10) throw AppError.conflict('TOO_MANY_IMAGES', 'A product may have at most 10 images');
    const image = await this.images.store({
      buffer: file.buffer,
      mimetype: file.mimetype,
      ownerType: 'product',
      ownerId: doc._id,
      uploadedBy: oid(uploadedBy, 'userId'),
    });
    const sortOrder = doc.images.reduce((m, i) => Math.max(m, i.sortOrder), -1) + 1;
    doc.images.push({ imageId: image._id, sortOrder });
    await doc.save();
    this.realtime.emitChanged('products', doc);
    return doc;
  }

  async removeImage(vendorId: string, id: string, imageId: string): Promise<ProductDocument> {
    const doc = await this.getForVendor(vendorId, id);
    const target = oid(imageId, 'imageId');
    const before = doc.images.length;
    doc.images = doc.images.filter((i) => !i.imageId.equals(target));
    if (doc.images.length === before) throw AppError.notFound('IMAGE_NOT_FOUND', 'Image not attached to this product');
    await doc.save();
    await this.images.softDelete(target);
    this.realtime.emitChanged('products', doc);
    return doc;
  }

  async count(filter: QueryFilter<Product> = {}): Promise<number> {
    return this.products.countDocuments({ ...notDeleted, ...filter }).exec();
  }

  private async assertCategories(ids: string[] | undefined): Promise<void> {
    if (!ids || ids.length === 0) return;
    if (!(await this.categories.existsAll(ids))) {
      throw AppError.badRequest('CATEGORY_NOT_FOUND', 'One or more categories do not exist');
    }
  }

  private toVariant(dto: ProductVariantDto, prev?: ProductVariant): ProductVariant {
    return {
      _id: prev?._id ?? (dto.id ? new Types.ObjectId(dto.id) : new Types.ObjectId()),
      name: dto.name,
      sku: dto.sku ?? prev?.sku ?? '',
      priceKobo: dto.priceKobo,
      stock: prev ? prev.stock : (dto.stock ?? 0),
      attributes: dto.attributes ?? prev?.attributes ?? {},
    };
  }
}
