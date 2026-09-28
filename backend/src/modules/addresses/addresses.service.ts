import { Injectable } from '@nestjs/common';
import { InjectModel } from '@nestjs/mongoose';
import { Model, Types } from 'mongoose';
import { AppError } from '../../common/errors/app-error.js';
import type { Page } from '../../common/pagination/cursor.js';
import { notDeleted } from '../../common/schemas/base.js';
import { oid } from '../../common/utils/ids.js';
import { RealtimeService } from '../realtime/realtime.service.js';
import type { CreateAddressDto, UpdateAddressDto } from './dto/address.dto.js';
import { Address, type AddressDocument } from './schemas/address.schema.js';

const ADDRESS_FIELDS = ['label', 'line1', 'line2', 'city', 'state', 'lat', 'lng', 'phone', 'isDefault'] as const;

function applyAddressPatch(doc: AddressDocument, dto: UpdateAddressDto): void {
  for (const key of ADDRESS_FIELDS) {
    const value = dto[key];
    if (value !== undefined) doc.set(key, value);
  }
}

@Injectable()
export class AddressesService {
  constructor(
    @InjectModel(Address.name) private readonly addresses: Model<Address>,
    private readonly realtime: RealtimeService,
  ) {}

  async list(userId: string): Promise<Page<AddressDocument>> {
    const items = await this.addresses
      .find({ userId: oid(userId, 'userId'), ...notDeleted })
      .sort({ isDefault: -1, _id: -1 })
      .limit(100)
      .exec();
    return { items, nextCursor: null };
  }

  async get(userId: string | Types.ObjectId, id: string | Types.ObjectId): Promise<AddressDocument> {
    const doc = await this.addresses
      .findOne({ _id: typeof id === 'string' ? oid(id, 'addressId') : id, userId: typeof userId === 'string' ? oid(userId, 'userId') : userId, ...notDeleted })
      .exec();
    if (!doc) throw AppError.notFound('ADDRESS_NOT_FOUND', 'Address not found');
    return doc;
  }

  async create(userId: string, dto: CreateAddressDto, clientAt: Date = new Date()): Promise<AddressDocument> {
    const owner = oid(userId, 'userId');
    const count = await this.addresses.countDocuments({ userId: owner, ...notDeleted }).exec();
    const isDefault = dto.isDefault ?? count === 0;
    if (isDefault) await this.clearDefault(owner);
    const doc = await this.addresses.create({
      _id: dto.id ? new Types.ObjectId(dto.id) : new Types.ObjectId(),
      userId: owner,
      label: dto.label ?? 'Home',
      line1: dto.line1,
      line2: dto.line2 ?? '',
      city: dto.city,
      state: dto.state,
      lat: dto.lat,
      lng: dto.lng,
      phone: dto.phone ?? '',
      isDefault,
      clientUpdatedAt: clientAt,
    });
    this.realtime.emitChanged('addresses', doc);
    return doc;
  }

  async update(userId: string, id: string, dto: UpdateAddressDto, clientAt: Date = new Date()): Promise<AddressDocument> {
    const doc = await this.get(userId, id);
    if (dto.isDefault) await this.clearDefault(doc.userId);
    applyAddressPatch(doc, dto);
    doc.clientUpdatedAt = clientAt;
    await doc.save();
    this.realtime.emitChanged('addresses', doc);
    return doc;
  }

  /**
   * Sync push upsert: last-write-wins by `clientAt`. Returns `null` when the
   * server copy is newer (op is still reported as applied, doc is the server copy).
   */
  async upsertFromSync(userId: string, dto: CreateAddressDto, clientAt: Date): Promise<AddressDocument> {
    if (!dto.id) return this.create(userId, dto, clientAt);
    const existing = await this.addresses.findOne({ _id: new Types.ObjectId(dto.id), userId: oid(userId, 'userId') }).exec();
    if (!existing) return this.create(userId, dto, clientAt);
    if (existing.clientUpdatedAt && existing.clientUpdatedAt.getTime() > clientAt.getTime()) return existing;
    if (dto.isDefault) await this.clearDefault(existing.userId);
    applyAddressPatch(existing, dto);
    existing.deletedAt = null;
    existing.clientUpdatedAt = clientAt;
    await existing.save();
    this.realtime.emitChanged('addresses', existing);
    return existing;
  }

  async remove(userId: string, id: string): Promise<AddressDocument> {
    const doc = await this.get(userId, id);
    doc.deletedAt = new Date();
    doc.isDefault = false;
    await doc.save();
    this.realtime.emitRemoved('addresses', doc);
    return doc;
  }

  private async clearDefault(userId: Types.ObjectId): Promise<void> {
    await this.addresses.updateMany({ userId, isDefault: true, ...notDeleted }, { $set: { isDefault: false } }).exec();
  }
}
