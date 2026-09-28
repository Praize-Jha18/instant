import { Module } from '@nestjs/common';
import { MongooseModule } from '@nestjs/mongoose';
import { AddressesModule } from '../addresses/addresses.module.js';
import { CartModule } from '../cart/cart.module.js';
import { ProductsModule } from '../products/products.module.js';
import { RidersModule } from '../riders/riders.module.js';
import { SyncOp, SyncOpSchema } from './schemas/sync-op.schema.js';
import { SyncPushHandlers } from './sync-push.handlers.js';
import { SyncController } from './sync.controller.js';
import { SyncService } from './sync.service.js';

@Module({
  imports: [
    MongooseModule.forFeature([{ name: SyncOp.name, schema: SyncOpSchema }]),
    CartModule,
    AddressesModule,
    RidersModule,
    ProductsModule,
  ],
  controllers: [SyncController],
  providers: [SyncService, SyncPushHandlers],
  exports: [SyncService],
})
export class SyncModule {}
