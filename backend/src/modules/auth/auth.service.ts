import { Inject, Injectable } from '@nestjs/common';
import { JwtService } from '@nestjs/jwt';
import { Types } from 'mongoose';
import { AppError } from '../../common/errors/app-error.js';
import type { JwtPayload, Role } from '../../common/types/auth-user.js';
import { AppConfig } from '../../config/app-config.service.js';
import { RidersService } from '../riders/riders.service.js';
import type { UserDocument } from '../users/schemas/user.schema.js';
import { UsersService } from '../users/users.service.js';
import { VendorsService } from '../vendors/vendors.service.js';
import type { LoginDto, RegisterDto } from './dto/auth.dto.js';
import { AUTH_PROVIDER, type AuthProvider } from './providers/auth-provider.interface.js';
import { RefreshTokenService } from './refresh-token.service.js';

export interface AuthTokens {
  accessToken: string;
  refreshToken: string;
  /** ISO expiry of the refresh token; access token expiry is in the JWT. */
  refreshExpiresAt: string;
  user: ReturnType<UserDocument['toJSON']>;
}

@Injectable()
export class AuthService {
  constructor(
    @Inject(AUTH_PROVIDER) private readonly provider: AuthProvider,
    private readonly users: UsersService,
    private readonly vendors: VendorsService,
    private readonly riders: RidersService,
    private readonly refreshTokens: RefreshTokenService,
    private readonly jwt: JwtService,
    private readonly config: AppConfig,
  ) {}

  async register(dto: RegisterDto): Promise<AuthTokens> {
    const roles: Role[] = [dto.role];
    let vendorId: Types.ObjectId | undefined;

    if (dto.role === 'rider') {
      if (!dto.vendorId) {
        throw AppError.badRequest('VENDOR_ID_REQUIRED', 'Riders must register under a vendor');
      }
      const vendor = await this.vendors.getById(new Types.ObjectId(dto.vendorId));
      if (vendor.status === 'suspended') {
        throw AppError.conflict('VENDOR_SUSPENDED', 'This vendor is suspended');
      }
      vendorId = vendor._id;
    }

    const credential = await this.provider.createCredential({ email: dto.email, password: dto.password });
    const user = await this.users.create({
      email: dto.email,
      passwordHash: credential.passwordHash,
      fullName: dto.fullName,
      phone: dto.phone,
      roles,
      vendorId,
    });

    if (dto.role === 'vendor_owner') {
      const vendor = await this.vendors.createPending({
        name: dto.vendorName?.trim() || `${dto.fullName.trim()}'s Store`,
        ownerUserId: user._id,
      });
      await this.users.attachVendor(user._id, vendor._id);
      user.vendorId = vendor._id;
    } else if (dto.role === 'rider' && vendorId) {
      await this.riders.createPendingProfile(user._id, vendorId);
    }

    return this.issueTokens(user, dto.deviceId);
  }

  async login(dto: LoginDto): Promise<AuthTokens> {
    const user = await this.provider.authenticate({ email: dto.email, password: dto.password });
    if (user.status !== 'active') {
      throw AppError.forbidden('ACCOUNT_SUSPENDED', 'This account is suspended');
    }
    return this.issueTokens(user, dto.deviceId);
  }

  async refresh(rawRefreshToken: string): Promise<AuthTokens> {
    const rotated = await this.refreshTokens.rotate(rawRefreshToken);
    const user = await this.users.findById(rotated.userId);
    if (!user || user.status !== 'active') {
      await this.refreshTokens.revokeFamily(rotated.familyId);
      throw AppError.unauthorized('ACCOUNT_INACTIVE', 'Account is suspended or missing');
    }
    return {
      accessToken: this.signAccess(user),
      refreshToken: rotated.token,
      refreshExpiresAt: rotated.expiresAt.toISOString(),
      user: user.toJSON(),
    };
  }

  async logout(rawRefreshToken: string): Promise<{ ok: true }> {
    await this.refreshTokens.revokeByRaw(rawRefreshToken);
    return { ok: true };
  }

  async me(userId: string): Promise<UserDocument> {
    return this.users.getById(userId);
  }

  private async issueTokens(user: UserDocument, deviceId?: string): Promise<AuthTokens> {
    const issued = await this.refreshTokens.issue(user._id, deviceId ?? 'unknown');
    return {
      accessToken: this.signAccess(user),
      refreshToken: issued.token,
      refreshExpiresAt: issued.expiresAt.toISOString(),
      user: user.toJSON(),
    };
  }

  private signAccess(user: UserDocument): string {
    const payload: JwtPayload = { sub: String(user._id), roles: user.roles };
    if (user.vendorId) payload.vendorId = String(user.vendorId);
    return this.jwt.sign(payload, { expiresIn: this.config.jwtAccessTtl, algorithm: 'HS256' });
  }
}
