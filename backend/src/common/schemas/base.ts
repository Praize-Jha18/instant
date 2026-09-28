import type { Type } from '@nestjs/common';
import { SchemaFactory } from '@nestjs/mongoose';
import { Schema as MongooseSchema, Types } from 'mongoose';
import { timestampsVersionPlugin } from '../plugins/timestamps-version.plugin.js';

/**
 * Fields every document carries. They are added by `timestampsVersionPlugin`,
 * so subclasses do not decorate them.
 */
export class BaseDocument {
  _id: Types.ObjectId;
  createdAt: Date;
  updatedAt: Date;
  deletedAt: Date | null;
  version: number;
}



/** Builds a schema for a decorated class and applies the base plugin. */
export function buildSchema<T>(cls: Type<T>): MongooseSchema<T> {
  const schema = SchemaFactory.createForClass(cls) as unknown as MongooseSchema<T>;
  schema.plugin(timestampsVersionPlugin);
  return schema;
}

/** Filter fragment excluding soft-deleted docs. */
export const notDeleted = { deletedAt: null } as const;
