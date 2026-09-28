import { Injectable, Logger } from '@nestjs/common';
import { InjectConnection, InjectModel } from '@nestjs/mongoose';
import { Model, Types, type Connection } from 'mongoose';
import { AppError } from '../../common/errors/app-error.js';
import { decodeCursor, encodeCursor } from '../../common/pagination/cursor.js';
import { hasRole, type AuthUser } from '../../common/types/auth-user.js';
import { RidersService } from '../riders/riders.service.js';
import type { SyncOpDto, SyncOpResult, SyncPullQueryDto, SyncPullResponse, SyncPushResponse } from './dto/sync.dto.js';
import { SyncOp, type StoredSyncResult } from './schemas/sync-op.schema.js';
import { isSyncCollection, scopeFor, SYNC_COLLECTIONS, type SyncCollection, type SyncDoc } from './sync-scope.js';
import { SyncPushHandlers } from './sync-push.handlers.js';

/** Overlap subtracted from `since` to absorb clock skew (§7). */
export const PULL_OVERLAP_MS = 2000;
const DEFAULT_PULL_LIMIT = 200;

interface CollectionCursor {
  updatedAt: string;
  id: string;
}
type PullCursor = Partial<Record<SyncCollection, CollectionCursor>>;

function isDuplicateKeyError(err: unknown): boolean {
  return typeof err === 'object' && err !== null && (err as { code?: unknown }).code === 11000;
}

@Injectable()
export class SyncService {
  private readonly logger = new Logger(SyncService.name);

  constructor(
    @InjectModel(SyncOp.name) private readonly syncOps: Model<SyncOp>,
    @InjectConnection() private readonly connection: Connection,
    private readonly riders: RidersService,
    private readonly handlers: SyncPushHandlers,
  ) {}

  // ───────────────────────────── pull ─────────────────────────────

  async pull(user: AuthUser, query: SyncPullQueryDto): Promise<SyncPullResponse> {
    const serverTime = new Date();
    const sinceRaw = query.since ? new Date(query.since) : new Date(0);
    if (Number.isNaN(sinceRaw.getTime())) throw AppError.badRequest('INVALID_SINCE', 'since must be an ISO date');
    const since = new Date(Math.max(0, sinceRaw.getTime() - PULL_OVERLAP_MS));
    const limit = Math.min(Math.max(1, query.limit ?? DEFAULT_PULL_LIMIT), 500);

    const requested = [...new Set(query.collections.split(',').map((c) => c.trim()).filter(Boolean))];
    const unknown = requested.filter((c) => !isSyncCollection(c));
    if (unknown.length > 0) throw AppError.badRequest('UNKNOWN_COLLECTION', `Unknown collections: ${unknown.join(', ')}`);
    const collections = requested.filter(isSyncCollection);
    const cursor = decodeCursor<PullCursor>(query.cursor) ?? {};

    const riderProfileId = hasRole(user, 'rider') ? ((await this.riders.findByUserId(user.userId))?._id ?? null) : null;
    const ctx = { user, riderProfileId };

    const changes: Record<string, unknown[]> = {};
    const tombstones: Record<string, string[]> = {};
    const nextCursor: PullCursor = {};
    let hasMore = false;

    for (const collection of collections) {
      const scope = scopeFor(collection, ctx);
      changes[collection] = [];
      tombstones[collection] = [];
      if (scope.filter === null) continue;

      const position = cursor[collection];
      const filter: Record<string, unknown> = { ...scope.filter };
      if (position) {
        const at = new Date(position.updatedAt);
        filter.$and = [
          ...((scope.filter.$and as unknown[] | undefined) ?? []),
          { $or: [{ updatedAt: { $gt: at } }, { updatedAt: at, _id: { $gt: new Types.ObjectId(position.id) } }] },
        ];
      } else {
        filter.updatedAt = { $gt: since };
      }

      const model = this.connection.model<SyncDoc>(SYNC_COLLECTIONS[collection]);
      const rows = await model.find(filter).sort({ updatedAt: 1, _id: 1 }).limit(limit + 1).exec();
      const page = rows.length > limit ? rows.slice(0, limit) : rows;
      if (rows.length > limit) {
        hasMore = true;
        const last = page[page.length - 1];
        if (last) nextCursor[collection] = { updatedAt: last.updatedAt.toISOString(), id: String(last._id) };
      }
      for (const doc of page) {
        if (doc.deletedAt || scope.isTombstone?.(doc.toObject() as SyncDoc)) tombstones[collection].push(String(doc._id));
        else changes[collection].push(doc.toJSON());
      }
    }

    const response: SyncPullResponse = { changes, tombstones, serverTime: serverTime.toISOString() };
    if (hasMore) {
      // Collections that finished keep their place so a follow-up call does not repeat them.
      for (const collection of collections) {
        if (!nextCursor[collection]) nextCursor[collection] = { updatedAt: serverTime.toISOString(), id: 'ffffffffffffffffffffffff' };
      }
      response.nextCursor = encodeCursor(nextCursor);
    }
    return response;
  }

  // ───────────────────────────── push ─────────────────────────────

  /** Processes ops in order; each `opId` is applied at most once (`syncOps`). */
  async push(user: AuthUser, ops: SyncOpDto[]): Promise<SyncPushResponse> {
    const results: SyncOpResult[] = [];
    const userId = new Types.ObjectId(user.userId);
    for (const op of ops) {
      results.push(await this.pushOne(user, userId, op));
    }
    return { results, serverTime: new Date().toISOString() };
  }

  private async pushOne(user: AuthUser, userId: Types.ObjectId, op: SyncOpDto): Promise<SyncOpResult> {
    const existing = await this.syncOps.findOne({ opId: op.opId }).exec();
    if (existing) return this.asDuplicate(op.opId, existing.result);

    let outcome: StoredSyncResult;
    let doc: unknown;
    try {
      const applied = await this.handlers.apply(user, op);
      if (applied.status === 'applied') {
        doc = applied.doc;
        outcome = { status: 'applied', docId: applied.docId, code: applied.code };
      } else {
        outcome = { status: 'rejected', code: applied.code, message: applied.message };
      }
    } catch (err) {
      this.logger.error(`Sync op ${op.opId} (${op.entity}.${op.action}) failed: ${err instanceof Error ? err.message : String(err)}`);
      outcome = { status: 'rejected', code: 'INTERNAL_ERROR', message: 'Could not apply operation' };
    }

    try {
      await this.syncOps.create({ opId: op.opId, userId, entity: op.entity, action: op.action, result: outcome, processedAt: new Date() });
    } catch (err) {
      if (isDuplicateKeyError(err)) {
        const winner = await this.syncOps.findOne({ opId: op.opId }).exec();
        return this.asDuplicate(op.opId, winner?.result ?? outcome);
      }
      throw err;
    }

    const result: SyncOpResult = { opId: op.opId, status: outcome.status };
    if (outcome.code) result.code = outcome.code;
    if (outcome.message) result.message = outcome.message;
    if (doc !== undefined) result.doc = doc;
    return result;
  }

  private asDuplicate(opId: string, stored: StoredSyncResult): SyncOpResult {
    const result: SyncOpResult = { opId, status: 'duplicate' };
    if (stored.code) result.code = stored.code;
    if (stored.status === 'rejected' && stored.message) result.message = stored.message;
    return result;
  }
}
