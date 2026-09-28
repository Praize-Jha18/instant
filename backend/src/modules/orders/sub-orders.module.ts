import { Module } from '@nestjs/common';
import { MongooseModule } from '@nestjs/mongoose';
import { SubOrder, SubOrderSchema } from './schemas/sub-order.schema.js';
import { SubOrdersService } from './sub-orders.service.js';

/** Split out so DeliveriesModule can transition sub-orders without a cycle. */
@Module({
  imports: [MongooseModule.forFeature([{ name: SubOrder.name, schema: SubOrderSchema }])],
  providers: [SubOrdersService],
  exports: [SubOrdersService, MongooseModule],
})
export class SubOrdersModule {}
