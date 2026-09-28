import { Injectable } from '@nestjs/common';
import { InjectModel } from '@nestjs/mongoose';
import { Model, QueryFilter, Types } from 'mongoose';
import { AppError } from '../../common/errors/app-error.js';
import { clampLimit, idCursorFilter, toPage, type Page } from '../../common/pagination/cursor.js';
import { notDeleted } from '../../common/schemas/base.js';
import { oid } from '../../common/utils/ids.js';
import { NotificationsService } from '../notifications/notifications.service.js';
import { RealtimeService } from '../realtime/realtime.service.js';
import { UsersService } from '../users/users.service.js';
import type { RiderLocationDto, UpdateRiderProfileDto, VendorRidersQueryDto } from './dto/rider.dto.js';
import { RiderLocation } from './schemas/rider-location.schema.js';
import { RiderProfile, type RiderProfileDocument, type RiderStatus } from './schemas/rider-profile.schema.js';

export interface LastLocation {
  lat: number;
  lng: number;
  heading: number | null;
  speed: number | null;
  at: Date;
}

export interface RiderSummary {
  profile: RiderProfileDocument;
  user: { id: string; fullName: string; phone?: string; email: string } | null;
  lastLocation: LastLocation | null;
}

/** Minimum interval between persisted location points per rider. */
export const LOCATION_WRITE_INTERVAL_MS = 3000;

@Injectable()
export class RidersService {
  private readonly lastWriteAt = new Map<string, number>();

  constructor(
    @InjectModel(RiderProfile.name) private readonly profiles: Model<RiderProfile>,
    @InjectModel(RiderLocation.name) private readonly locations: Model<RiderLocation>,
    private readonly users: UsersService,
    private readonly notifications: NotificationsService,
    private readonly realtime: RealtimeService,
  ) {}

  async createPendingProfile(userId: Types.ObjectId, vendorId: Types.ObjectId): Promise<RiderProfileDocument> {
    const doc = await this.profiles.create({ userId, vendorId, status: 'pending', isOnline: false });
    this.realtime.emitChanged('riderProfiles', doc);
    return doc;
  }

  findByUserId(userId: string | Types.ObjectId): Promise<RiderProfileDocument | null> {
    return this.profiles.findOne({ userId, ...notDeleted }).exec();
  }

  async requireByUserId(userId: string | Types.ObjectId): Promise<RiderProfileDocument> {
    const doc = await this.findByUserId(userId);
    if (!doc) throw AppError.notFound('RIDER_PROFILE_NOT_FOUND', 'No rider profile for this user');
    return doc;
  }

  findById(id: string | Types.ObjectId): Promise<RiderProfileDocument | null> {
    return this.profiles.findOne({ _id: id, ...notDeleted }).exec();
  }

  async getForVendor(vendorId: string, riderId: string): Promise<RiderProfileDocument> {
    const doc = await this.profiles
      .findOne({ _id: oid(riderId, 'riderId'), vendorId: oid(vendorId, 'vendorId'), ...notDeleted })
      .exec();
    if (!doc) throw AppError.notFound('RIDER_NOT_FOUND', 'Rider not found for this vendor');
    return doc;
  }

  async updateOwn(userId: string, dto: UpdateRiderProfileDto): Promise<RiderProfileDocument> {
    const profile = await this.requireByUserId(userId);
    if (dto.isOnline !== undefined) {
      if (dto.isOnline && profile.status !== 'active') {
        throw AppError.conflict('RIDER_NOT_ACTIVE', 'Rider must be approved before going online');
      }
      profile.isOnline = dto.isOnline;
      profile.lastSeenAt = new Date();
    }
    if (dto.vehicleType !== undefined) profile.vehicleType = dto.vehicleType;
    if (dto.plateNumber !== undefined) profile.plateNumber = dto.plateNumber;
    await profile.save();
    this.realtime.emitChanged('riderProfiles', profile);
    return profile;
  }

  /** Used by sync push: only `isOnline` may be set offline-first. */
  async setOnline(userId: string, isOnline: boolean): Promise<RiderProfileDocument> {
    return this.updateOwn(userId, { isOnline });
  }

  /**
   * Persists a location point (throttled to one write per 3s per rider) and
   * rebroadcasts to the active delivery room and the vendor room.
   */
  async ingestLocation(
    profile: RiderProfileDocument,
    point: RiderLocationDto,
    options: { force?: boolean; persist?: boolean } = {},
  ): Promise<{ stored: boolean }> {
    const key = String(profile._id);
    const now = Date.now();
    const last = this.lastWriteAt.get(key) ?? 0;
    const at = new Date(point.at);
    if (Number.isNaN(at.getTime())) throw AppError.badRequest('INVALID_TIMESTAMP', 'at must be an ISO date');

    let stored = false;
    const persist = options.persist ?? true;
    if (persist && (options.force || now - last >= LOCATION_WRITE_INTERVAL_MS)) {
      this.lastWriteAt.set(key, now);
      await this.locations.create({
        riderId: profile._id,
        vendorId: profile.vendorId,
        lat: point.lat,
        lng: point.lng,
        heading: point.heading ?? null,
        speed: point.speed ?? null,
        at,
      });
      await this.profiles.updateOne({ _id: profile._id }, { $set: { lastSeenAt: new Date() } }).exec();
      stored = true;
    }

    const deliveryId = profile.currentDeliveryId ? String(profile.currentDeliveryId) : null;
    const rooms = [`vendor:${String(profile.vendorId)}`];
    if (deliveryId) rooms.push(`delivery:${deliveryId}`);
    this.realtime.emitRiderLocation(rooms, {
      deliveryId,
      riderId: key,
      lat: point.lat,
      lng: point.lng,
      heading: point.heading ?? null,
      at: at.toISOString(),
    });
    return { stored };
  }

  /** Offline backlog from the outbox: every point is stored, no throttle. */
  async ingestBatch(profile: RiderProfileDocument, points: RiderLocationDto[]): Promise<{ stored: number }> {
    if (points.length === 0) return { stored: 0 };
    const docs = points
      .map((p) => ({
        riderId: profile._id,
        vendorId: profile.vendorId,
        lat: p.lat,
        lng: p.lng,
        heading: p.heading ?? null,
        speed: p.speed ?? null,
        at: new Date(p.at),
      }))
      .filter((p) => !Number.isNaN(p.at.getTime()));
    await this.locations.insertMany(docs);
    await this.profiles.updateOne({ _id: profile._id }, { $set: { lastSeenAt: new Date() } }).exec();
    this.lastWriteAt.set(String(profile._id), Date.now());
    const latest = points[points.length - 1];
    if (latest) await this.ingestLocation(profile, latest, { persist: false }); // rebroadcast only
    return { stored: docs.length };
  }

  async lastLocation(riderId: Types.ObjectId | string): Promise<LastLocation | null> {
    const map = await this.lastLocations([riderId]);
    return map.get(String(riderId)) ?? null;
  }

  async lastLocations(riderIds: Array<Types.ObjectId | string>): Promise<Map<string, LastLocation>> {
    const result = new Map<string, LastLocation>();
    if (riderIds.length === 0) return result;
    const rows = await this.locations
      .aggregate<{ _id: Types.ObjectId; lat: number; lng: number; heading: number | null; speed: number | null; at: Date }>([
        { $match: { riderId: { $in: riderIds.map((id) => new Types.ObjectId(String(id))) } } },
        { $sort: { riderId: 1, at: -1 } },
        {
          $group: {
            _id: '$riderId',
            lat: { $first: '$lat' },
            lng: { $first: '$lng' },
            heading: { $first: '$heading' },
            speed: { $first: '$speed' },
            at: { $first: '$at' },
          },
        },
      ])
      .exec();
    for (const r of rows) {
      result.set(String(r._id), { lat: r.lat, lng: r.lng, heading: r.heading, speed: r.speed, at: r.at });
    }
    return result;
  }

  async findAvailable(vendorId: Types.ObjectId | string): Promise<RiderProfileDocument[]> {
    return this.profiles
      .find({ vendorId, status: 'active', isOnline: true, currentDeliveryId: null, ...notDeleted })
      .exec();
  }

  async setCurrentDelivery(riderId: Types.ObjectId, deliveryId: Types.ObjectId | null): Promise<void> {
    const doc = await this.profiles
      .findOneAndUpdate({ _id: riderId }, { $set: { currentDeliveryId: deliveryId } }, { new: true })
      .exec();
    if (doc) this.realtime.emitChanged('riderProfiles', doc);
  }

  async listForVendor(vendorId: string, query: VendorRidersQueryDto): Promise<Page<RiderSummary>> {
    const limit = clampLimit(query.limit);
    const filter: QueryFilter<RiderProfile> = {
      vendorId: oid(vendorId, 'vendorId'),
      ...notDeleted,
      ...idCursorFilter(query.cursor),
    };
    if (query.status) filter.status = query.status;
    const docs = await this.profiles.find(filter).sort({ _id: -1 }).limit(limit + 1).exec();
    const page = toPage(docs, limit, (last) => ({ id: String(last._id) }));
    const items = await this.summarise(page.items);
    return { items, nextCursor: page.nextCursor };
  }

  async summarise(profiles: RiderProfileDocument[]): Promise<RiderSummary[]> {
    const [users, locations] = await Promise.all([
      this.users.findByIds(profiles.map((p) => p.userId)),
      this.lastLocations(profiles.map((p) => p._id)),
    ]);
    const byId = new Map(users.map((u) => [String(u._id), u]));
    return profiles.map((profile) => {
      const u = byId.get(String(profile.userId));
      return {
        profile,
        user: u ? { id: String(u._id), fullName: u.fullName, phone: u.phone, email: u.email } : null,
        lastLocation: locations.get(String(profile._id)) ?? null,
      };
    });
  }

  async setStatusByVendor(vendorId: string, riderId: string, status: RiderStatus): Promise<RiderProfileDocument> {
    const profile = await this.getForVendor(vendorId, riderId);
    profile.status = status;
    if (status !== 'active') profile.isOnline = false;
    await profile.save();
    this.realtime.emitChanged('riderProfiles', profile);
    await this.notifications.notify(profile.userId, {
      type: status === 'active' ? 'rider.approved' : 'rider.suspended',
      title: status === 'active' ? 'You are approved to ride' : 'Your rider account was suspended',
      data: { riderId: String(profile._id), status },
    });
    return profile;
  }
}
