import { Logger } from '@nestjs/common';
import { NestFactory } from '@nestjs/core';
import { SeedModule } from './seed.module.js';
import { SeedService } from './seed.service.js';

/**
 * `pnpm seed` — idempotent development data. Requires MONGODB_URI, JWT_SECRET,
 * ADMIN_EMAIL and ADMIN_PASSWORD in the environment (or .env).
 */
async function main(): Promise<void> {
  const logger = new Logger('Seed');
  const app = await NestFactory.createApplicationContext(SeedModule, { logger: ['error', 'warn', 'log'] });
  try {
    await app.get(SeedService).run();
  } catch (err) {
    logger.error(err instanceof Error ? (err.stack ?? err.message) : String(err));
    process.exitCode = 1;
  } finally {
    await app.close();
  }
}

await main();
