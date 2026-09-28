import type { Schema, UpdateQuery } from 'mongoose';

const APPLIED = Symbol.for('instant.timestampsVersionPlugin');

type Marked = { [APPLIED]?: boolean };
type AnyUpdate = UpdateQuery<Record<string, unknown>>;

function isPlainUpdate(update: unknown): update is AnyUpdate {
  return typeof update === 'object' && update !== null && !Array.isArray(update);
}

/**
 * Adds `$inc: { version: 1 }` to an update unless the caller sets `version`
 * explicitly. Returns the (mutated) update, or null when nothing was changed.
 */
export function withVersionBump(update: unknown): AnyUpdate | null {
  if (!isPlainUpdate(update)) return null;
  const set = (update.$set ?? {}) as Record<string, unknown>;
  if (set['version'] !== undefined || update['version'] !== undefined) return null;
  const inc = (update.$inc ?? {}) as Record<string, number>;
  if (inc['version'] !== undefined) return null;
  update.$inc = { ...inc, version: 1 };
  const setOnInsert = update.$setOnInsert as Record<string, unknown> | undefined;
  if (setOnInsert && setOnInsert['version'] !== undefined) delete setOnInsert['version'];
  return update;
}

/** Version starts at 1 on insert and increments on every subsequent save. */
export function bumpDocumentVersion(doc: { isNew: boolean; version?: number }): void {
  if (doc.isNew) {
    if (typeof doc.version !== 'number') doc.version = 1;
  } else {
    doc.version = (doc.version ?? 0) + 1;
  }
}

/** `toJSON` transform: `_id` → `id`, drop `__v`. */
export function toJsonTransform(_doc: unknown, ret: Record<string, unknown>): Record<string, unknown> {
  const rawId = ret['_id'];
  if (rawId !== undefined && rawId !== null) {
    ret['id'] = typeof rawId === 'string' ? rawId : (rawId as { toString(): string }).toString();
    delete ret['_id'];
  }
  delete ret['__v'];
  return ret;
}

/**
 * Applied to every schema (ARCHITECTURE §4):
 *  - `createdAt` / `updatedAt` maintained on every write (Mongoose timestamps)
 *  - `version` starts at 1 and is bumped on every write
 *  - `deletedAt: Date | null` for soft deletes / tombstones
 *  - `updatedAt` indexed for sync pulls
 *  - `toJSON` maps `_id` → `id` and drops `__v`
 */
export function timestampsVersionPlugin(schema: Schema): void {
  const marked = schema as unknown as Marked;
  if (marked[APPLIED]) return;
  marked[APPLIED] = true;

  schema.add({
    deletedAt: { type: Date, default: null },
    version: { type: Number, default: 1 },
  });
  if (!schema.get('timestamps')) schema.set('timestamps', true);
  schema.set('versionKey', false);
  schema.index({ updatedAt: 1 });

  schema.set('toJSON', {
    virtuals: false,
    versionKey: false,
    flattenObjectIds: true,
    transform: toJsonTransform,
  });

  schema.pre('save', function (this: { isNew: boolean; version?: number }) {
    bumpDocumentVersion(this);
  });

  schema.pre(['updateOne', 'updateMany', 'findOneAndUpdate', 'replaceOne'], function (this: {
    getUpdate(): unknown;
    setUpdate(u: AnyUpdate): void;
  }) {
    const bumped = withVersionBump(this.getUpdate());
    if (bumped) this.setUpdate(bumped);
  });
}
