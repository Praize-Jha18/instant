import { CanActivate, ExecutionContext, Injectable } from '@nestjs/common';
import { AppError } from '../errors/app-error.js';
import { isVendorUser, type RequestWithUser } from '../types/auth-user.js';

function pickVendorId(source: unknown): string | undefined {
  if (typeof source !== 'object' || source === null) return undefined;
  const v = (source as Record<string, unknown>)['vendorId'];
  return typeof v === 'string' ? v : undefined;
}

/**
 * Ensures vendor routes only ever touch the caller's own vendor.
 * Any `vendorId` supplied in params/query/body must equal `req.user.vendorId`.
 */
@Injectable()
export class VendorScopeGuard implements CanActivate {
  canActivate(context: ExecutionContext): boolean {
    const req = context.switchToHttp().getRequest<RequestWithUser>();
    const user = req.user;
    if (!user) {
      throw AppError.unauthorized('UNAUTHENTICATED', 'Authentication required');
    }
    if (!isVendorUser(user)) {
      throw AppError.forbidden('VENDOR_SCOPE_REQUIRED', 'Caller is not attached to a vendor');
    }
    const own = user.vendorId as string;
    for (const supplied of [
      pickVendorId(req.params),
      pickVendorId(req.query),
      pickVendorId(req.body),
    ]) {
      if (supplied !== undefined && supplied !== own) {
        throw AppError.forbidden('VENDOR_SCOPE_VIOLATION', 'Cannot access another vendor');
      }
    }
    return true;
  }
}
