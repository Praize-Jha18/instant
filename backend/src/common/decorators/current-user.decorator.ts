import { createParamDecorator, ExecutionContext } from '@nestjs/common';
import { AppError } from '../errors/app-error.js';
import type { AuthUser, RequestWithUser } from '../types/auth-user.js';

/**
 * `@CurrentUser()` → AuthUser, `@CurrentUser('userId')` → string.
 */
export const CurrentUser = createParamDecorator(
  (field: keyof AuthUser | undefined, ctx: ExecutionContext) => {
    const req = ctx.switchToHttp().getRequest<RequestWithUser>();
    const user = req.user;
    if (!user) {
      throw AppError.unauthorized('UNAUTHENTICATED', 'Authentication required');
    }
    return field ? user[field] : user;
  },
);

/** The caller's vendorId; throws if the caller is not vendor-scoped. */
export const VendorId = createParamDecorator(
  (_: unknown, ctx: ExecutionContext): string => {
    const req = ctx.switchToHttp().getRequest<RequestWithUser>();
    const vendorId = req.user?.vendorId;
    if (!vendorId) {
      throw AppError.forbidden('VENDOR_SCOPE_REQUIRED', 'Caller is not attached to a vendor');
    }
    return vendorId;
  },
);
