import { model, Schema, Types } from 'mongoose';
import { bumpDocumentVersion, timestampsVersionPlugin, withVersionBump } from './timestamps-version.plugin.js';

describe('timestampsVersionPlugin', () => {
  const schema = new Schema({ name: String });
  schema.plugin(timestampsVersionPlugin);
  schema.plugin(timestampsVersionPlugin); // idempotent: hooks/index registered once
  const Thing = model('PluginThing', schema);

  it('adds version/deletedAt defaults, timestamps, updatedAt index and no __v', () => {
    const doc = new Thing({ name: 'x' });
    expect(doc.get('version')).toBe(1);
    expect(doc.get('deletedAt')).toBeNull();
    expect(schema.get('timestamps')).toBe(true);
    expect(schema.get('versionKey')).toBe(false);
    expect(schema.indexes().filter(([f]) => (f as Record<string, unknown>)['updatedAt'] === 1)).toHaveLength(1);
  });

  it('maps _id to id in JSON and flattens ObjectIds', () => {
    const ref = new Types.ObjectId();
    const withRef = new Schema({ owner: Schema.Types.ObjectId });
    withRef.plugin(timestampsVersionPlugin);
    const Ref = model('PluginRef', withRef);
    const json = new Ref({ owner: ref }).toJSON() as Record<string, unknown>;
    expect(typeof json['id']).toBe('string');
    expect(json).not.toHaveProperty('_id');
    expect(json).not.toHaveProperty('__v');
    expect(json['owner']).toBe(String(ref));
  });

  it('bumps version on save of an existing document but not on insert', () => {
    const existing = { isNew: false, version: 3 };
    bumpDocumentVersion(existing);
    expect(existing.version).toBe(4);
    const fresh: { isNew: boolean; version?: number } = { isNew: true };
    bumpDocumentVersion(fresh);
    expect(fresh.version).toBe(1);
  });

  it('adds $inc version to update queries without clobbering other $inc keys', () => {
    const update = withVersionBump({ $inc: { stock: -2 }, $set: { name: 'z' } });
    expect(update?.$inc).toEqual({ stock: -2, version: 1 });
    expect(update?.$set).toMatchObject({ name: 'z' });
  });

  it('leaves an explicit version alone and ignores pipeline updates', () => {
    expect(withVersionBump({ $set: { version: 9 } })).toBeNull();
    expect(withVersionBump({ $inc: { version: 2 } })).toBeNull();
    expect(withVersionBump([{ $set: { a: 1 } }])).toBeNull();
  });

  it('drops version from $setOnInsert so upserts do not conflict with $inc', () => {
    const update = withVersionBump({ $setOnInsert: { version: 1, name: 'n' } });
    expect(update?.$setOnInsert).toEqual({ name: 'n' });
    expect(update?.$inc).toEqual({ version: 1 });
  });
});
