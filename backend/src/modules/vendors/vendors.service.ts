import { Injectable } from '@nestjs/common';
import { InjectModel } from '@nestjs/mongoose';
import { Model, QueryFilter, Types } from 'mongoose';
import { normaliseOpeningHours } from './dto/vendor.dto.js';
import { AppError } from '../../common/errors/app-error.js';
import { clampLimit, idCursorFilter, idPage, type Page } from '../../common/pagination/cursor.js';
import { notDeleted } from '../../common/schemas/base.js';
import { haversineKm, parseLatLng } from '../../common/utils/geo.js';
import { oid } from '../../common/utils/ids.js';
import { slugify, uniqueSlug } from '../../common/utils/slug.js';
import { ImagesService } from '../images/images.service.js';
import { NotificationsService } from '../notifications/notifications.service.js';
import { RealtimeService } from '../realtime/realtime.service.js';
import { escapeRegex } from '../users/users.service.js';
import type { AdminUpdateVendorDto, AdminVendorsQueryDto, PublicVendorsQueryDto, UpdateVendorDto } from './dto/vendor.dto.js';
import { Vendor, type VendorDocument, type VendorStatus } from './schemas/vendor.schema.js';

/** Applies defined keys of `patch` onto `doc.<path>` without replacing the subdocument. */
function mergeSubdocument(doc: VendorDocument, path: string, patch: object): void {
  for (const [key, value] of Object.entries(patch)) {
    if (value !== undefined) doc.set(`${path}.${key}`, value);
  }
}

export type PublicVendor = ReturnType<VendorDocument['toJSON']> & { distanceKm?: number };

@Injectable()
export class VendorsService {
  constructor(
    @InjectModel(Vendor.name) private readonly vendors: Model<Vendor>,
    private readonly notifications: NotificationsService,
    private readonly realtime: RealtimeService,
    private readonly images: ImagesService,
  ) {}

  /** Uploads and attaches the vendor logo or cover image, soft-deleting the previous one. */
  async setImage(vendorId: string, kind: 'logo' | 'cover', file: { buffer: Buffer; mimetype: string }, uploadedBy: string): Promise<VendorDocument> {
    const doc = await this.getById(oid(vendorId, 'vendorId'));
    const image = await this.images.store({
      buffer: file.buffer,
      mimetype: file.mimetype,
      ownerType: 'vendor',
      ownerId: doc._id,
      uploadedBy: oid(uploadedBy, 'userId'),
    });
    const field = kind === 'logo' ? 'logoImageId' : 'coverImageId';
    const previous = doc[field];
    doc[field] = image._id;
    await doc.save();
    if (previous) await this.images.softDelete(previous);
    this.realtime.emitChanged('vendors', doc);
    return doc;
  }

  async createPending(input: { name: string; ownerUserId: Types.ObjectId }): Promise<VendorDocument> {
    const base = slugify(input.name);
    const taken = await this.vendors.exists({ slug: base });
    const doc = await this.vendors.create({
      name: input.name,
      slug: taken ? uniqueSlug(input.name) : base,
      ownerUserId: input.ownerUserId,
      status: 'pending',
    });
    this.realtime.emitChanged('vendors', doc);
    return doc;
  }

  findById(id: string | Types.ObjectId): Promise<VendorDocument | null> {
    return this.vendors.findOne({ _id: id, ...notDeleted }).exec();
  }

  async getById(id: string | Types.ObjectId): Promise<VendorDocument> {
    const doc = await this.findById(id);
    if (!doc) throw AppError.notFound('VENDOR_NOT_FOUND', 'Vendor not found');
    return doc;
  }

  async getActive(id: string | Types.ObjectId): Promise<VendorDocument> {
    const doc = await this.getById(id);
    if (doc.status !== 'active') throw AppError.conflict('VENDOR_NOT_ACTIVE', `Vendor ${doc.name} is not active`);
    return doc;
  }

  findByIds(ids: Array<string | Types.ObjectId>): Promise<VendorDocument[]> {
    return this.vendors.find({ _id: { $in: ids }, ...notDeleted }).exec();
  }

  /** Public vendor detail by slug, or by id when the param is a valid ObjectId. */
  async getPublicBySlug(slugOrId: string): Promise<VendorDocument> {
    const key = slugOrId.toLowerCase();
    const or: QueryFilter<Vendor>[] = [{ slug: key }];
    if (Types.ObjectId.isValid(slugOrId) && String(new Types.ObjectId(slugOrId)) === slugOrId) {
      or.push({ _id: new Types.ObjectId(slugOrId) });
    }
    const doc = await this.vendors.findOne({ $or: or, status: 'active', ...notDeleted }).exec();
    if (!doc) throw AppError.notFound('VENDOR_NOT_FOUND', 'Vendor not found');
    return doc;
  }

  /** Active vendors, optionally filtered by name and sorted by distance from `near`. */
  async listPublic(query: PublicVendorsQueryDto): Promise<Page<PublicVendor>> {
    const limit = clampLimit(query.limit, 50);
    const filter: QueryFilter<Vendor> = { status: 'active', ...notDeleted };
    if (query.q) filter.name = new RegExp(escapeRegex(query.q), 'i');
    const near = parseLatLng(query.near);

    if (!near) {
      Object.assign(filter, idCursorFilter(query.cursor));
      const docs = await this.vendors.find(filter).sort({ _id: -1 }).limit(limit + 1).exec();
      const page = idPage(docs, limit);
      return { items: page.items.map((d) => d.toJSON() as PublicVendor), nextCursor: page.nextCursor };
    }

    // Distance sort: evaluated in-process (vendor counts are small); no cursor paging.
    const docs = await this.vendors.find(filter).limit(500).exec();
    const items = docs
      .map((d) => {
        const { lat, lng } = d.address;
        const distanceKm = lat !== null && lng !== null ? haversineKm(near, { lat, lng }) : Number.POSITIVE_INFINITY;
        return { doc: d, distanceKm };
      })
      .filter((x) => x.distanceKm <= x.doc.deliveryRadiusKm || !Number.isFinite(x.distanceKm))
      .sort((a, b) => a.distanceKm - b.distanceKm)
      .slice(0, limit)
      .map((x) => ({
        ...(x.doc.toJSON() as PublicVendor),
        distanceKm: Number.isFinite(x.distanceKm) ? Math.round(x.distanceKm * 10) / 10 : undefined,
      }));
    return { items, nextCursor: null };
  }

  async updateOwn(vendorId: string, dto: UpdateVendorDto): Promise<VendorDocument> {
    return this.applyUpdate(vendorId, dto);
  }

  async adminUpdate(vendorId: string, dto: AdminUpdateVendorDto): Promise<VendorDocument> {
    return this.applyUpdate(vendorId, dto);
  }

  private async applyUpdate(vendorId: string, dto: AdminUpdateVendorDto): Promise<VendorDocument> {
    const doc = await this.getById(oid(vendorId, 'vendorId'));
    if (dto.name !== undefined) doc.name = dto.name;
    if (dto.description !== undefined) doc.description = dto.description;
    if (dto.address) mergeSubdocument(doc, 'address', dto.address);
    if (dto.deliveryFee) mergeSubdocument(doc, 'deliveryFee', dto.deliveryFee);
    if (dto.deliveryRadiusKm !== undefined) doc.deliveryRadiusKm = dto.deliveryRadiusKm;
    if (dto.openingHours) doc.set('openingHours', normaliseOpeningHours(dto.openingHours));
    if (dto.payout) mergeSubdocument(doc, 'payout', dto.payout);
    if (dto.commissionBps !== undefined) doc.commissionBps = dto.commissionBps;
    if (dto.status !== undefined) doc.status = dto.status;
    await doc.save();
    this.realtime.emitChanged('vendors', doc);
    return doc;
  }

  async listAdmin(query: AdminVendorsQueryDto): Promise<Page<VendorDocument>> {
    const limit = clampLimit(query.limit);
    const filter: QueryFilter<Vendor> = { ...notDeleted, ...idCursorFilter(query.cursor) };
    if (query.status) filter.status = query.status;
    if (query.q) filter.name = new RegExp(escapeRegex(query.q), 'i');
    const docs = await this.vendors.find(filter).sort({ _id: -1 }).limit(limit + 1).exec();
    return idPage(docs, limit);
  }

  async setStatus(vendorId: string, status: VendorStatus): Promise<VendorDocument> {
    const doc = await this.getById(oid(vendorId, 'vendorId'));
    if (doc.status === status) return doc;
    doc.status = status;
    await doc.save();
    this.realtime.emitChanged('vendors', doc);
    await this.notifications.notify(doc.ownerUserId, {
      type: status === 'active' ? 'vendor.approved' : 'vendor.suspended',
      title: status === 'active' ? 'Your store is live' : 'Your store was suspended',
      body: status === 'active' ? `${doc.name} has been approved.` : `${doc.name} has been suspended by the platform.`,
      data: { vendorId: String(doc._id), status },
    });
    return doc;
  }

  countByStatus(): Promise<Array<{ _id: VendorStatus; count: number }>> {
    return this.vendors
      .aggregate<{ _id: VendorStatus; count: number }>([
        { $match: notDeleted },
        { $group: { _id: '$status', count: { $sum: 1 } } },
      ])
      .exec();
  }
}
