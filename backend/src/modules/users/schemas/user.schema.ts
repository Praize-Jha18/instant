import { Prop, Schema } from '@nestjs/mongoose';
import { HydratedDocument, SchemaTypes, Types } from 'mongoose';
import { BaseDocument, buildSchema } from '../../../common/schemas/base.js';
import { ROLES, type Role } from '../../../common/types/auth-user.js';

export type UserStatus = 'active' | 'suspended';
export const USER_STATUSES: readonly UserStatus[] = ['active', 'suspended'];

@Schema({ collection: 'users' })
export class User extends BaseDocument {
  @Prop({ required: true, unique: true, lowercase: true, trim: true, index: true })
  email: string;

  /** Excluded from queries by default; select with `+passwordHash`. */
  @Prop({ required: true, select: false })
  passwordHash: string;

  @Prop({ required: true, trim: true })
  fullName: string;

  @Prop({ trim: true })
  phone?: string;

  @Prop({ type: [String], enum: [...ROLES], default: ['customer'] })
  roles: Role[];

  @Prop({ type: SchemaTypes.ObjectId, ref: 'Vendor', index: true })
  vendorId?: Types.ObjectId;

  @Prop({ type: SchemaTypes.ObjectId, ref: 'Image' })
  avatarImageId?: Types.ObjectId;

  @Prop({ type: String, enum: [...USER_STATUSES], default: 'active' })
  status: UserStatus;
}

export type UserDocument = HydratedDocument<User>;
export const UserSchema = buildSchema(User);
