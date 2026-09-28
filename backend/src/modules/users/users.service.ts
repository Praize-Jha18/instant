import { Injectable } from '@nestjs/common';
import { InjectModel } from '@nestjs/mongoose';
import { Model, QueryFilter, Types } from 'mongoose';
import { AppError } from '../../common/errors/app-error.js';
import { clampLimit, idCursorFilter, idPage, type Page } from '../../common/pagination/cursor.js';
import { notDeleted } from '../../common/schemas/base.js';
import type { Role } from '../../common/types/auth-user.js';
import { oid } from '../../common/utils/ids.js';
import { User, type UserDocument, type UserStatus } from './schemas/user.schema.js';

export interface CreateUserInput {
  email: string;
  passwordHash: string;
  fullName: string;
  phone?: string;
  roles: Role[];
  vendorId?: Types.ObjectId;
}

export interface ListUsersQuery {
  q?: string;
  role?: Role;
  status?: UserStatus;
  cursor?: string;
  limit?: number;
}

@Injectable()
export class UsersService {
  constructor(@InjectModel(User.name) private readonly users: Model<User>) {}

  normalizeEmail(email: string): string {
    return email.trim().toLowerCase();
  }

  async create(input: CreateUserInput): Promise<UserDocument> {
    const email = this.normalizeEmail(input.email);
    const existing = await this.users.exists({ email });
    if (existing) throw AppError.conflict('EMAIL_TAKEN', 'Email already registered');
    const doc = await this.users.create({ ...input, email });
    doc.set('passwordHash', undefined);
    return doc;
  }

  /** Includes `passwordHash` for credential verification. */
  findByEmailWithSecret(email: string): Promise<UserDocument | null> {
    return this.users
      .findOne({ email: this.normalizeEmail(email), ...notDeleted })
      .select('+passwordHash')
      .exec();
  }

  findById(id: string | Types.ObjectId): Promise<UserDocument | null> {
    return this.users.findOne({ _id: id, ...notDeleted }).exec();
  }

  async getById(id: string | Types.ObjectId): Promise<UserDocument> {
    const user = await this.findById(id);
    if (!user) throw AppError.notFound('USER_NOT_FOUND', 'User not found');
    return user;
  }

  findByIds(ids: Array<string | Types.ObjectId>): Promise<UserDocument[]> {
    return this.users.find({ _id: { $in: ids }, ...notDeleted }).exec();
  }

  async attachVendor(userId: Types.ObjectId, vendorId: Types.ObjectId): Promise<void> {
    await this.users.updateOne({ _id: userId }, { $set: { vendorId } }).exec();
  }

  /** Vendor owner + staff user ids, for notifications. */
  async findVendorMembers(vendorId: string | Types.ObjectId): Promise<UserDocument[]> {
    return this.users
      .find({ vendorId, roles: { $in: ['vendor_owner', 'vendor_staff'] }, ...notDeleted })
      .exec();
  }

  async setStatus(id: string, status: UserStatus): Promise<UserDocument> {
    const user = await this.users
      .findOneAndUpdate({ _id: oid(id, 'userId'), ...notDeleted }, { $set: { status } }, { new: true })
      .exec();
    if (!user) throw AppError.notFound('USER_NOT_FOUND', 'User not found');
    return user;
  }

  async list(query: ListUsersQuery): Promise<Page<UserDocument>> {
    const limit = clampLimit(query.limit);
    const filter: QueryFilter<User> = { ...notDeleted, ...idCursorFilter(query.cursor) };
    if (query.role) filter.roles = query.role;
    if (query.status) filter.status = query.status;
    if (query.q) {
      const rx = new RegExp(escapeRegex(query.q), 'i');
      filter.$or = [{ email: rx }, { fullName: rx }, { phone: rx }];
    }
    const docs = await this.users.find(filter).sort({ _id: -1 }).limit(limit + 1).exec();
    return idPage(docs, limit);
  }

  async count(filter: QueryFilter<User> = {}): Promise<number> {
    return this.users.countDocuments({ ...notDeleted, ...filter }).exec();
  }
}

export function escapeRegex(input: string): string {
  return input.replace(/[.*+?^${}()|[\]\\]/g, '\\$&');
}
