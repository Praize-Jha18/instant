import { Injectable } from '@nestjs/common';
import { ConfigService } from '@nestjs/config';
import type { EnvVars, JwtTtl, NodeEnv, PaymentsProviderName } from './env.validation.js';

/**
 * Typed access to validated environment variables (ARCHITECTURE §10).
 */
@Injectable()
export class AppConfig {
  constructor(private readonly config: ConfigService<EnvVars, true>) {}

  get nodeEnv(): NodeEnv {
    return this.config.get('NODE_ENV', { infer: true });
  }

  get isProduction(): boolean {
    return this.nodeEnv === 'production';
  }

  get port(): number {
    return this.config.get('PORT', { infer: true });
  }

  get mongodbUri(): string {
    return this.config.get('MONGODB_URI', { infer: true });
  }

  get jwtSecret(): string {
    return this.config.get('JWT_SECRET', { infer: true });
  }

  get jwtAccessTtl(): JwtTtl {
    return this.config.get('JWT_ACCESS_TTL', { infer: true });
  }

  get refreshTtlDays(): number {
    return this.config.get('REFRESH_TTL_DAYS', { infer: true });
  }

  get stripeSecretKey(): string {
    return this.config.get('STRIPE_SECRET_KEY', { infer: true });
  }

  get stripeWebhookSecret(): string {
    return this.config.get('STRIPE_WEBHOOK_SECRET', { infer: true });
  }

  /** `true` means any origin (dev), otherwise an explicit allow-list. */
  get corsOrigins(): true | string[] {
    const raw = this.config.get('CORS_ORIGINS', { infer: true }).trim();
    if (raw === '' || raw === '*') return true;
    return raw
      .split(',')
      .map((s) => s.trim())
      .filter((s) => s.length > 0);
  }

  get adminEmail(): string {
    return this.config.get('ADMIN_EMAIL', { infer: true });
  }

  get adminPassword(): string {
    return this.config.get('ADMIN_PASSWORD', { infer: true });
  }

  get paymentsProvider(): PaymentsProviderName {
    return this.config.get('PAYMENTS_PROVIDER', { infer: true });
  }

  get atlasSearchIndex(): string {
    return this.config.get('ATLAS_SEARCH_INDEX', { infer: true });
  }
}
