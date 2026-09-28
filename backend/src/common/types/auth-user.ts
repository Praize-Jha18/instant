import type { Request } from 'express';

export const ROLES = [
  'customer',
  'rider',
  'vendor_owner',
  'vendor_staff',
  'admin',
] as const;
export type Role = (typeof ROLES)[number];

export const VENDOR_ROLES: readonly Role[] = ['vendor_owner', 'vendor_staff'];

/** Shape attached to `req.user` by the JWT strategy. */
export interface AuthUser {
  userId: string;
  email: string;
  roles: Role[];
  vendorId?: string;
}

export interface JwtPayload {
  sub: string;
  roles: Role[];
  vendorId?: string;
  iat?: number;
  exp?: number;
}

export type RequestWithUser = Request & { user?: AuthUser };

export function hasRole(user: AuthUser | undefined, ...roles: Role[]): boolean {
  if (!user) return false;
  return roles.some((r) => user.roles.includes(r));
}

export function isVendorUser(user: AuthUser | undefined): boolean {
  return hasRole(user, 'vendor_owner', 'vendor_staff') && !!user?.vendorId;
}
