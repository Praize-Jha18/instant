import { Module } from '@nestjs/common';
import { AppConfigModule } from '../config/config.module.js';
import { DatabaseModule } from '../database/database.module.js';
import { AddressesModule } from '../modules/addresses/addresses.module.js';
import { CategoriesModule } from '../modules/categories/categories.module.js';
import { ImagesModule } from '../modules/images/images.module.js';
import { ProductsModule } from '../modules/products/products.module.js';
import { RealtimeCoreModule } from '../modules/realtime/realtime-core.module.js';
import { RidersModule } from '../modules/riders/riders.module.js';
import { UsersModule } from '../modules/users/users.module.js';
import { VendorsModule } from '../modules/vendors/vendors.module.js';
import { SeedService } from './seed.service.js';

/** Minimal module graph for `pnpm seed` (no HTTP, sockets or cron). */
@Module({
  imports: [
    AppConfigModule,
    DatabaseModule,
    RealtimeCoreModule,
    UsersModule,
    VendorsModule,
    CategoriesModule,
    ProductsModule,
    ImagesModule,
    RidersModule,
    AddressesModule,
  ],
  providers: [SeedService],
})
export class SeedModule {}
