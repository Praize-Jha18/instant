import { Connection, Model } from 'mongoose';
import type { AuthUser } from '../../common/types/auth-user.js';
import type { RidersService } from '../riders/riders.service.js';
import type { SyncOpDto } from './dto/sync.dto.js';
import type { SyncOp, StoredSyncResult } from './schemas/sync-op.schema.js';
import { resolveOperation, type HandlerResult, type SyncPushHandlers } from './sync-push.handlers.js';
import { SyncService } from './sync.service.js';

interface OpRow {
  opId: string;
  result: StoredSyncResult;
}

function fakeSyncOpModel(options: { raceOnCreate?: boolean } = {}) {
  const rows: OpRow[] = [];
  let raced = false;
  return {
    rows,
    findOne(filter: { opId: string }) {
      return { exec: async () => rows.find((r) => r.opId === filter.opId) ?? null };
    },
    async create(doc: OpRow) {
      if (options.raceOnCreate && !raced) {
        // Simulate a concurrent request that inserted the same opId first.
        raced = true;
        rows.push({ opId: doc.opId, result: { status: 'applied', docId: 'winner' } });
        const err = new Error('E11000 duplicate key') as Error & { code: number };
        err.code = 11000;
        throw err;
      }
      if (rows.some((r) => r.opId === doc.opId)) {
        const err = new Error('E11000 duplicate key') as Error & { code: number };
        err.code = 11000;
        throw err;
      }
      rows.push(doc);
      return doc;
    },
  };
}

function fakeHandlers(result: HandlerResult | (() => HandlerResult)) {
  const calls: SyncOpDto[] = [];
  return {
    calls,
    async apply(_user: AuthUser, op: SyncOpDto): Promise<HandlerResult> {
      calls.push(op);
      return typeof result === 'function' ? result() : result;
    },
  };
}

const user: AuthUser = { userId: '65f000000000000000000001', email: 'c@x.io', roles: ['customer'] };
const cartOp = {
  opId: '0f3d2a2e-6d7c-4a4e-9c1b-2f0a1f9d8e77',
  entity: 'cart',
  action: 'upsert',
  payload: { items: [] },
  clientAt: '2026-01-01T00:00:00.000Z',
} satisfies SyncOpDto;

describe('SyncService.push idempotency (§7)', () => {
  function setup(handlers: ReturnType<typeof fakeHandlers>, model = fakeSyncOpModel()) {
    const service = new SyncService(
      model as unknown as Model<SyncOp>,
      {} as Connection,
      {} as RidersService,
      handlers as unknown as SyncPushHandlers,
    );
    return { service, model };
  }

  it('applies an op once and reports later replays as duplicate without re-running the handler', async () => {
    const handlers = fakeHandlers({ status: 'applied', doc: { id: 'cart1' }, docId: 'cart1' });
    const { service, model } = setup(handlers);

    const first = await service.push(user, [cartOp]);
    expect(first.results).toEqual([{ opId: cartOp.opId, status: 'applied', doc: { id: 'cart1' } }]);

    const second = await service.push(user, [cartOp]);
    expect(second.results).toEqual([{ opId: cartOp.opId, status: 'duplicate' }]);
    expect(handlers.calls).toHaveLength(1);
    expect(model.rows).toHaveLength(1);
  });

  it('deduplicates within a single batch and preserves order', async () => {
    const handlers = fakeHandlers({ status: 'applied' });
    const { service } = setup(handlers);
    const other: SyncOpDto = { ...cartOp, opId: '2c1e2b6a-9d51-4f0e-8a58-4c8d8c3f1e10' };
    const { results } = await service.push(user, [cartOp, other, cartOp]);
    expect(results.map((r) => [r.opId, r.status])).toEqual([
      [cartOp.opId, 'applied'],
      [other.opId, 'applied'],
      [cartOp.opId, 'duplicate'],
    ]);
    expect(handlers.calls).toHaveLength(2);
  });

  it('records rejections so a replayed bad op is reported as duplicate with its code', async () => {
    const handlers = fakeHandlers({ status: 'rejected', code: 'VALIDATION_ERROR', message: 'bad payload' });
    const { service } = setup(handlers);
    const first = await service.push(user, [cartOp]);
    expect(first.results[0]).toMatchObject({ status: 'rejected', code: 'VALIDATION_ERROR', message: 'bad payload' });
    const second = await service.push(user, [cartOp]);
    expect(second.results[0]).toMatchObject({ status: 'duplicate', code: 'VALIDATION_ERROR' });
    expect(handlers.calls).toHaveLength(1);
  });

  it('treats a lost insert race on opId as a duplicate', async () => {
    const handlers = fakeHandlers({ status: 'applied' });
    const { service } = setup(handlers, fakeSyncOpModel({ raceOnCreate: true }));
    const { results } = await service.push(user, [cartOp]);
    expect(results[0]).toEqual({ opId: cartOp.opId, status: 'duplicate' });
  });

  it('converts handler crashes into rejected results instead of failing the batch', async () => {
    const handlers = fakeHandlers(() => {
      throw new Error('boom');
    });
    const { service } = setup(handlers);
    const { results } = await service.push(user, [cartOp]);
    expect(results[0]).toMatchObject({ status: 'rejected', code: 'INTERNAL_ERROR' });
  });
});

describe('resolveOperation', () => {
  it('normalises entity aliases and custom names', () => {
    expect(resolveOperation({ ...cartOp, entity: 'carts' })).toBe('carts.upsert');
    expect(resolveOperation({ ...cartOp, entity: 'address', action: 'delete' })).toBe('addresses.delete');
    expect(resolveOperation({ ...cartOp, entity: 'stock', action: 'custom', payload: { name: 'stock.adjust' } })).toBe('stock.adjust');
    expect(resolveOperation({ ...cartOp, entity: 'inventory', action: 'custom', payload: { type: 'adjust' } })).toBe('stock.adjust');
    expect(resolveOperation({ ...cartOp, entity: 'products', action: 'custom', customAction: 'stock.adjust', payload: {} })).toBe('stock.adjust');
    expect(resolveOperation({ ...cartOp, entity: 'riderLocation', action: 'upsert' })).toBe('riderLocations.upsert');
  });
});
