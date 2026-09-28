import Joi from 'joi';

export type NodeEnv = 'development' | 'test' | 'production';
export type PaymentsProviderName = 'stripe' | 'mock';
/** Duration accepted by jsonwebtoken (`ms` format), e.g. `15m`. */
export type JwtTtl = `${number}${'ms' | 's' | 'm' | 'h' | 'd'}`;

export interface EnvVars {
  NODE_ENV: NodeEnv;
  PORT: number;
  MONGODB_URI: string;
  JWT_SECRET: string;
  JWT_ACCESS_TTL: JwtTtl;
  REFRESH_TTL_DAYS: number;
  STRIPE_SECRET_KEY: string;
  STRIPE_WEBHOOK_SECRET: string;
  CORS_ORIGINS: string;
  ADMIN_EMAIL: string;
  ADMIN_PASSWORD: string;
  PAYMENTS_PROVIDER: PaymentsProviderName;
  ATLAS_SEARCH_INDEX: string;
}

export const envValidationSchema = Joi.object<EnvVars, true>({
  NODE_ENV: Joi.string()
    .valid('development', 'test', 'production')
    .default('development'),
  PORT: Joi.number().port().default(3000),
  MONGODB_URI: Joi.string()
    .uri({ scheme: ['mongodb', 'mongodb+srv'] })
    .default('mongodb://localhost:27017/instant'),
  JWT_SECRET: Joi.string().min(16).required(),
  JWT_ACCESS_TTL: Joi.string()
    .pattern(/^\d+(ms|s|m|h|d)$/)
    .default('15m') as unknown as Joi.StringSchema<JwtTtl>,
  REFRESH_TTL_DAYS: Joi.number().integer().min(1).max(365).default(30),
  STRIPE_SECRET_KEY: Joi.string().allow('').default(''),
  STRIPE_WEBHOOK_SECRET: Joi.string().allow('').default(''),
  CORS_ORIGINS: Joi.string().allow('').default('*'),
  ADMIN_EMAIL: Joi.string().email({ tlds: { allow: false } }).allow('').default(''),
  ADMIN_PASSWORD: Joi.string().allow('').default(''),
  PAYMENTS_PROVIDER: Joi.string().valid('stripe', 'mock').default('stripe'),
  ATLAS_SEARCH_INDEX: Joi.string().allow('').default(''),
});
