import { Types } from 'mongoose';
import { AppError } from '../errors/app-error.js';

export function isObjectId(value: unknown): value is string {
  return typeof value === 'string' && Types.ObjectId.isValid(value) && /^[a-f\d]{24}$/i.test(value);
}

export function oid(value: string, what = 'id'): Types.ObjectId {
  if (!isObjectId(value)) {
    throw AppError.badRequest('INVALID_ID', `Invalid ${what}: ${String(value)}`);
  }
  return new Types.ObjectId(value);
}

export function sameId(a: Types.ObjectId | string | null | undefined, b: Types.ObjectId | string | null | undefined): boolean {
  if (!a || !b) return false;
  return String(a) === String(b);
}
