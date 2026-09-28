import { randomBytes } from 'node:crypto';

export function slugify(input: string): string {
  return input
    .normalize('NFKD')
    .replace(/[̀-ͯ]/g, '')
    .toLowerCase()
    .replace(/[^a-z0-9]+/g, '-')
    .replace(/^-+|-+$/g, '')
    .slice(0, 60) || 'item';
}

export function shortId(bytes = 3): string {
  return randomBytes(bytes).toString('hex');
}

export function uniqueSlug(input: string): string {
  return `${slugify(input)}-${shortId()}`;
}
