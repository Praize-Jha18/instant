import { Module } from '@nestjs/common';
import { MongooseModule } from '@nestjs/mongoose';
import { ImagesModule } from '../images/images.module.js';
import { NotificationsModule } from '../notifications/notifications.module.js';
import { Vendor, VendorSchema } from './schemas/vendor.schema.js';
import { VendorSelfController, VendorsPublicController } from './vendors.controller.js';
import { VendorsService } from './vendors.service.js';

@Module({
  imports: [MongooseModule.forFeature([{ name: Vendor.name, schema: VendorSchema }]), NotificationsModule, ImagesModule],
  controllers: [VendorsPublicController, VendorSelfController],
  providers: [VendorsService],
  exports: [VendorsService, MongooseModule],
})
export class VendorsModule {}
