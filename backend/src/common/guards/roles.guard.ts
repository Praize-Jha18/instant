import { CanActivate, ExecutionContext, Injectable } from '@nestjs/common';
import { Reflector } from '@nestjs/core';
import { ROLES_KEY } from '../decorators/roles.decorator.js';
import { AppError } from '../errors/app-error.js';
import type { RequestWithUser, Role } from '../types/auth-user.js';

@Injectable()
export class RolesGuard implements CanActivate {
  constructor(private readonly reflector: Reflector) {}

  canActivate(context: ExecutionContext): boolean {
    const required = this.reflector.getAllAndOverride<Role[] | undefined>(ROLES_KEY, [
      context.getHandler(),
      context.getClass(),
    ]);
    if (!required || required.length === 0) return true;
    const req = context.switchToHttp().getRequest<RequestWithUser>();
    const user = req.user;
    if (!user) {
      throw AppError.unauthorized('UNAUTHENTICATED', 'Authentication required');
    }
    if (!required.some((r) => user.roles.includes(r))) {
      throw AppError.forbidden('FORBIDDEN_ROLE', `Requires one of: ${required.join(', ')}`);
    }
    return true;
  }
}
