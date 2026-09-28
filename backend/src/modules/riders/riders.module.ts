import { Module } from '@nestjs/common';
import { MongooseModule } from '@nestjs/mongoose';
import { NotificationsModule } from '../notifications/notifications.module.js';
import { UsersModule } from '../users/users.module.js';
import { RiderSelfController, VendorRidersController } from './riders.controller.js';
import { RidersService } from './riders.service.js';
import { RiderLocation, RiderLocationSchema } from './schemas/rider-location.schema.js';
import { RiderProfile, RiderProfileSchema } from './schemas/rider-profile.schema.js';

@Module({
  imports: [
    MongooseModule.forFeature([
      { name: RiderProfile.name, schema: RiderProfileSchema },
      { name: RiderLocation.name, schema: RiderLocationSchema },
    ]),
    UsersModule,
    NotificationsModule,
  ],
  controllers: [RiderSelfController, VendorRidersController],
  providers: [RidersService],
  exports: [RidersService, MongooseModule],
})
export class RidersModule {}
