import { Injectable } from '@nestjs/common';
import { InjectModel } from '@nestjs/mongoose';
import { Model, Types } from 'mongoose';
import { createHash, randomBytes, randomUUID } from 'node:crypto';
import { AppError } from '../../common/errors/app-error.js';
import { AppConfig } from '../../config/app-config.service.js';
import { RefreshToken } from './schemas/refresh-token.schema.js';

export interface IssuedRefreshToken {
  token: string;
  familyId: string;
  expiresAt: Date;
}

export interface RotatedRefreshToken extends IssuedRefreshToken {
  userId: Types.ObjectId;
  deviceId: string;
}

export function hashToken(raw: string): string {
  return createHash('sha256').update(raw).digest('hex');
}

/**
 * Opaque, hashed, rotating refresh tokens with family revocation on reuse (§3).
 */
@Injectable()
export class RefreshTokenService {
  constructor(
    @InjectModel(RefreshToken.name) private readonly tokens: Model<RefreshToken>,
    private readonly config: AppConfig,
  ) {}

  private ttlMs(): number {
    return this.config.refreshTtlDays * 24 * 60 * 60 * 1000;
  }

  async issue(
    userId: Types.ObjectId,
    deviceId = 'unknown',
    familyId: string = randomUUID(),
  ): Promise<IssuedRefreshToken> {
    const token = randomBytes(64).toString('base64url');
    const expiresAt = new Date(Date.now() + this.ttlMs());
    await this.tokens.create({
      userId,
      tokenHash: hashToken(token),
      familyId,
      deviceId,
      expiresAt,
      revokedAt: null,
      replacedByHash: null,
    });
    return { token, familyId, expiresAt };
  }

  /**
   * Consumes `raw` and returns a fresh token in the same family.
   * A previously rotated (revoked) token being presented again means theft:
   * the whole family is revoked.
   */
  async rotate(raw: string): Promise<RotatedRefreshToken> {
    const tokenHash = hashToken(raw);
    const current = await this.tokens.findOne({ tokenHash }).exec();
    if (!current) {
      throw AppError.unauthorized('INVALID_REFRESH_TOKEN', 'Refresh token is not recognised');
    }
    if (current.revokedAt) {
      await this.revokeFamily(current.familyId);
      throw AppError.unauthorized(
        'REFRESH_TOKEN_REUSED',
        'Refresh token reuse detected; all sessions for this device were revoked',
      );
    }
    if (current.expiresAt.getTime() <= Date.now()) {
      throw AppError.unauthorized('REFRESH_TOKEN_EXPIRED', 'Refresh token expired');
    }

    const next = randomBytes(64).toString('base64url');
    const nextHash = hashToken(next);
    const revoked = await this.tokens
      .findOneAndUpdate(
        { _id: current._id, revokedAt: null },
        { $set: { revokedAt: new Date(), replacedByHash: nextHash } },
        { new: true },
      )
      .exec();
    if (!revoked) {
      // Lost a race with a concurrent rotation of the same token: treat as reuse.
      await this.revokeFamily(current.familyId);
      throw AppError.unauthorized('REFRESH_TOKEN_REUSED', 'Refresh token reuse detected');
    }

    const expiresAt = new Date(Date.now() + this.ttlMs());
    await this.tokens.create({
      userId: current.userId,
      tokenHash: nextHash,
      familyId: current.familyId,
      deviceId: current.deviceId,
      expiresAt,
      revokedAt: null,
      replacedByHash: null,
    });
    return {
      token: next,
      familyId: current.familyId,
      expiresAt,
      userId: current.userId,
      deviceId: current.deviceId,
    };
  }

  async revokeFamily(familyId: string): Promise<void> {
    await this.tokens
      .updateMany({ familyId, revokedAt: null }, { $set: { revokedAt: new Date() } })
      .exec();
  }

  /** Logout: revokes the presented token's whole family (the device session). */
  async revokeByRaw(raw: string): Promise<boolean> {
    const doc = await this.tokens.findOne({ tokenHash: hashToken(raw) }).exec();
    if (!doc) return false;
    await this.revokeFamily(doc.familyId);
    return true;
  }

  async revokeAllForUser(userId: Types.ObjectId): Promise<void> {
    await this.tokens
      .updateMany({ userId, revokedAt: null }, { $set: { revokedAt: new Date() } })
      .exec();
  }
}
