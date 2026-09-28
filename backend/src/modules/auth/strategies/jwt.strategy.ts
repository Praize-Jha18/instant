import { Injectable } from '@nestjs/common';
import { PassportStrategy } from '@nestjs/passport';
import { ExtractJwt, Strategy } from 'passport-jwt';
import { AppError } from '../../../common/errors/app-error.js';
import type { AuthUser, JwtPayload } from '../../../common/types/auth-user.js';
import { AppConfig } from '../../../config/app-config.service.js';
import { UsersService } from '../../users/users.service.js';

@Injectable()
export class JwtStrategy extends PassportStrategy(Strategy, 'jwt') {
  constructor(
    config: AppConfig,
    private readonly users: UsersService,
  ) {
    super({
      jwtFromRequest: ExtractJwt.fromAuthHeaderAsBearerToken(),
      ignoreExpiration: false,
      secretOrKey: config.jwtSecret,
      algorithms: ['HS256'],
    });
  }

  async validate(payload: JwtPayload): Promise<AuthUser> {
    const user = await this.users.findById(payload.sub);
    if (!user || user.status !== 'active') {
      throw AppError.unauthorized('ACCOUNT_INACTIVE', 'Account is suspended or missing');
    }
    return {
      userId: String(user._id),
      email: user.email,
      roles: user.roles,
      vendorId: user.vendorId ? String(user.vendorId) : undefined,
    };
  }
}
