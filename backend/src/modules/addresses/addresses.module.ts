import { Module } from '@nestjs/common';
import { MongooseModule } from '@nestjs/mongoose';
import { AddressesController } from './addresses.controller.js';
import { AddressesService } from './addresses.service.js';
import { Address, AddressSchema } from './schemas/address.schema.js';

@Module({
  imports: [MongooseModule.forFeature([{ name: Address.name, schema: AddressSchema }])],
  controllers: [AddressesController],
  providers: [AddressesService],
  exports: [AddressesService, MongooseModule],
})
export class AddressesModule {}
