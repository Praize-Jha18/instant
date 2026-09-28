import { Prop, Schema } from '@nestjs/mongoose';
import { HydratedDocument, Schema as MongooseSchema, SchemaTypes, Types } from 'mongoose';
import { BaseDocument, buildSchema } from '../../../common/schemas/base.js';

export type SyncResultStatus = 'applied' | 'duplicate' | 'rejected';

export interface StoredSyncResult {
  status: Exclude<SyncResultStatus, 'duplicate'>;
  code?: string;
  message?: string;
  docId?: string;
}

/** Idempotency log for `POST /sync/push` (§7). TTL 30 days. */
@Schema({ collection: 'syncOps' })
export class SyncOp extends BaseDocument {
  @Prop({ required: true, unique: true })
  opId: string;

  @Prop({ type: SchemaTypes.ObjectId, ref: 'User', required: true, index: true })
  userId: Types.ObjectId;

  @Prop({ required: true }) entity: string;
  @Prop({ required: true }) action: string;

  @Prop({ type: MongooseSchema.Types.Mixed, required: true })
  result: StoredSyncResult;

  @Prop({ required: true })
  processedAt: Date;
}

export type SyncOpDocument = HydratedDocument<SyncOp>;
export const SyncOpSchema = buildSchema(SyncOp);
SyncOpSchema.index({ processedAt: 1 }, { expireAfterSeconds: 30 * 24 * 60 * 60 });
