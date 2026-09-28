import { Prop, Schema } from '@nestjs/mongoose';
import { HydratedDocument, SchemaTypes, Types } from 'mongoose';
import { BaseDocument, buildSchema } from '../../../common/schemas/base.js';

@Schema({ collection: 'refreshTokens' })
export class RefreshToken extends BaseDocument {
  @Prop({ type: SchemaTypes.ObjectId, ref: 'User', required: true, index: true })
  userId: Types.ObjectId;

  /** SHA-256 hex of the opaque token. */
  @Prop({ required: true, unique: true })
  tokenHash: string;

  /** All tokens descending from one login share a family. */
  @Prop({ required: true, index: true })
  familyId: string;

  @Prop({ default: 'unknown' })
  deviceId: string;

  @Prop({ required: true, index: true })
  expiresAt: Date;

  @Prop({ type: Date, default: null })
  revokedAt: Date | null;

  /** Hash of the token that replaced this one (rotation audit trail). */
  @Prop({ type: String, default: null })
  replacedByHash: string | null;
}

export type RefreshTokenDocument = HydratedDocument<RefreshToken>;
export const RefreshTokenSchema = buildSchema(RefreshToken);
