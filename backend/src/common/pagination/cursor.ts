import { Types } from 'mongoose';
import { AppError } from '../errors/app-error.js';

export interface Page<T> {
  items: T[];
  nextCursor: string | null;
}

export const DEFAULT_PAGE_SIZE = 20;
export const MAX_PAGE_SIZE = 100;

export function clampLimit(limit: number | undefined, max = MAX_PAGE_SIZE): number {
  if (!limit || Number.isNaN(limit)) return DEFAULT_PAGE_SIZE;
  return Math.min(Math.max(1, Math.floor(limit)), max);
}

export function encodeCursor(value: unknown): string {
  return Buffer.from(JSON.stringify(value), 'utf8').toString('base64url');
}

export function decodeCursor<T>(cursor: string | undefined | null): T | null {
  if (!cursor) return null;
  try {
    return JSON.parse(Buffer.from(cursor, 'base64url').toString('utf8')) as T;
  } catch {
    throw AppError.badRequest('INVALID_CURSOR', 'Malformed pagination cursor');
  }
}

/** Cursor for lists sorted by `_id` descending (newest first). */
export interface IdCursor {
  id: string;
}

export function idCursorFilter(cursor: string | undefined): Record<string, unknown> {
  const parsed = decodeCursor<IdCursor>(cursor);
  if (!parsed || !Types.ObjectId.isValid(parsed.id)) return {};
  return { _id: { $lt: new Types.ObjectId(parsed.id) } };
}

/**
 * Given `limit + 1` fetched items, returns the page and next cursor.
 */
export function toPage<T>(
  fetched: T[],
  limit: number,
  cursorOf: (last: T) => unknown,
): Page<T> {
  const hasMore = fetched.length > limit;
  const items = hasMore ? fetched.slice(0, limit) : fetched;
  const last = items[items.length - 1];
  return {
    items,
    nextCursor: hasMore && last !== undefined ? encodeCursor(cursorOf(last)) : null,
  };
}

export function idPage<T extends { _id: Types.ObjectId }>(fetched: T[], limit: number): Page<T> {
  return toPage(fetched, limit, (last) => ({ id: String(last._id) }) satisfies IdCursor);
}
