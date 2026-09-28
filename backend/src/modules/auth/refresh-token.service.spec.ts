import { Model, Types } from 'mongoose';
import type { AppConfig } from '../../config/app-config.service.js';
import { hashToken, RefreshTokenService } from './refresh-token.service.js';
import type { RefreshToken } from './schemas/refresh-token.schema.js';

interface Row {
  _id: Types.ObjectId;
  userId: Types.ObjectId;
  tokenHash: string;
  familyId: string;
  deviceId: string;
  expiresAt: Date;
  revokedAt: Date | null;
  replacedByHash: string | null;
}

type Filter = Partial<Pick<Row, 'tokenHash' | 'familyId' | 'userId' | '_id'>> & { revokedAt?: null };

function matches(row: Row, filter: Filter): boolean {
  if (filter.tokenHash !== undefined && row.tokenHash !== filter.tokenHash) return false;
  if (filter.familyId !== undefined && row.familyId !== filter.familyId) return false;
  if (filter._id !== undefined && !row._id.equals(filter._id)) return false;
  if (filter.userId !== undefined && !row.userId.equals(filter.userId)) return false;
  if ('revokedAt' in filter && row.revokedAt !== null) return false;
  return true;
}

/** Minimal in-memory model implementing the calls RefreshTokenService makes. */
function fakeModel() {
  const rows: Row[] = [];
  return {
    rows,
    async create(doc: Omit<Row, '_id'>) {
      const row = { ...doc, _id: new Types.ObjectId() };
      rows.push(row);
      return row;
    },
    findOne(filter: Filter) {
      return { exec: async () => rows.find((r) => matches(r, filter)) ?? null };
    },
    findOneAndUpdate(filter: Filter, update: { $set: Partial<Row> }) {
      return {
        exec: async () => {
          const row = rows.find((r) => matches(r, filter));
          if (!row) return null;
          Object.assign(row, update.$set);
          return row;
        },
      };
    },
    updateMany(filter: Filter, update: { $set: Partial<Row> }) {
      return {
        exec: async () => {
          let n = 0;
          for (const r of rows) {
            if (matches(r, filter)) {
              Object.assign(r, update.$set);
              n += 1;
            }
          }
          return { modifiedCount: n };
        },
      };
    },
  };
}

describe('RefreshTokenService rotation (§3)', () => {
  const config = { refreshTtlDays: 30 } as AppConfig;
  const userId = new Types.ObjectId();

  function setup() {
    const model = fakeModel();
    const service = new RefreshTokenService(model as unknown as Model<RefreshToken>, config);
    return { model, service };
  }

  it('stores only a SHA-256 hash of the issued token', async () => {
    const { model, service } = setup();
    const issued = await service.issue(userId, 'phone-1');
    expect(model.rows).toHaveLength(1);
    expect(model.rows[0]?.tokenHash).toBe(hashToken(issued.token));
    expect(model.rows[0]?.tokenHash).not.toContain(issued.token);
    expect(issued.expiresAt.getTime() - Date.now()).toBeGreaterThan(29 * 24 * 60 * 60 * 1000);
  });

  it('rotates: returns a new token in the same family and revokes the old one', async () => {
    const { model, service } = setup();
    const first = await service.issue(userId, 'phone-1');
    const second = await service.rotate(first.token);

    expect(second.token).not.toBe(first.token);
    expect(second.familyId).toBe(first.familyId);
    expect(second.userId.equals(userId)).toBe(true);
    expect(second.deviceId).toBe('phone-1');

    const old = model.rows.find((r) => r.tokenHash === hashToken(first.token));
    expect(old?.revokedAt).toBeInstanceOf(Date);
    expect(old?.replacedByHash).toBe(hashToken(second.token));
    expect(model.rows.filter((r) => r.familyId === first.familyId)).toHaveLength(2);
  });

  it('revokes the whole family when a rotated token is presented again', async () => {
    const { model, service } = setup();
    const first = await service.issue(userId, 'phone-1');
    const second = await service.rotate(first.token);
    const third = await service.rotate(second.token);

    // Attacker replays the already-rotated first token.
    await expect(service.rotate(first.token)).rejects.toMatchObject({ code: 'REFRESH_TOKEN_REUSED' });

    // Every token in the family is now revoked, including the legitimate latest one.
    expect(model.rows.filter((r) => r.familyId === first.familyId).every((r) => r.revokedAt !== null)).toBe(true);
    await expect(service.rotate(third.token)).rejects.toMatchObject({ code: 'REFRESH_TOKEN_REUSED' });
  });

  it('rejects unknown and expired tokens without touching other families', async () => {
    const { model, service } = setup();
    const a = await service.issue(userId, 'phone-a');
    const b = await service.issue(userId, 'phone-b');
    await expect(service.rotate('not-a-real-token')).rejects.toMatchObject({ code: 'INVALID_REFRESH_TOKEN' });

    const rowA = model.rows.find((r) => r.tokenHash === hashToken(a.token));
    if (rowA) rowA.expiresAt = new Date(Date.now() - 1000);
    await expect(service.rotate(a.token)).rejects.toMatchObject({ code: 'REFRESH_TOKEN_EXPIRED' });

    const rotatedB = await service.rotate(b.token);
    expect(rotatedB.familyId).toBe(b.familyId);
  });

  it('logout revokes the presented token family', async () => {
    const { model, service } = setup();
    const issued = await service.issue(userId, 'phone-1');
    expect(await service.revokeByRaw(issued.token)).toBe(true);
    expect(model.rows[0]?.revokedAt).toBeInstanceOf(Date);
    expect(await service.revokeByRaw('unknown')).toBe(false);
  });
});
