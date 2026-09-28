import { Module } from '@nestjs/common';
import { MongooseModule } from '@nestjs/mongoose';
import { ImagesModule } from '../images/images.module.js';
import { LedgerModule } from '../ledger/ledger.module.js';
import { NotificationsModule } from '../notifications/notifications.module.js';
import { SubOrdersModule } from '../orders/sub-orders.module.js';
import { RidersModule } from '../riders/riders.module.js';
import { UsersModule } from '../users/users.module.js';
import { RiderDeliveriesController, VendorDeliveriesController } from './deliveries.controller.js';
import { DeliveriesService } from './deliveries.service.js';
import { Delivery, DeliverySchema } from './schemas/delivery.schema.js';

@Module({
  imports: [
    MongooseModule.forFeature([{ name: Delivery.name, schema: DeliverySchema }]),
    SubOrdersModule,
    RidersModule,
    LedgerModule,
    NotificationsModule,
    ImagesModule,
    UsersModule,
  ],
  controllers: [VendorDeliveriesController, RiderDeliveriesController],
  providers: [DeliveriesService],
  exports: [DeliveriesService, MongooseModule],
})
export class DeliveriesModule {}
