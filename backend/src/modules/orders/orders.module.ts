import { Module } from '@nestjs/common';
import { MongooseModule } from '@nestjs/mongoose';
import { AddressesModule } from '../addresses/addresses.module.js';
import { CartModule } from '../cart/cart.module.js';
import { DeliveriesModule } from '../deliveries/deliveries.module.js';
import { NotificationsModule } from '../notifications/notifications.module.js';
import { PaymentsCoreModule } from '../payments/payments-core.module.js';
import { ProductsModule } from '../products/products.module.js';
import { RidersModule } from '../riders/riders.module.js';
import { UsersModule } from '../users/users.module.js';
import { VendorsModule } from '../vendors/vendors.module.js';
import { OrdersController, VendorOrdersController } from './orders.controller.js';
import { OrdersService } from './orders.service.js';
import { Order, OrderSchema } from './schemas/order.schema.js';
import { SubOrdersModule } from './sub-orders.module.js';
import { VendorOrdersService } from './vendor-orders.service.js';

@Module({
  imports: [
    MongooseModule.forFeature([{ name: Order.name, schema: OrderSchema }]),
    SubOrdersModule,
    CartModule,
    AddressesModule,
    ProductsModule,
    VendorsModule,
    PaymentsCoreModule,
    DeliveriesModule,
    RidersModule,
    UsersModule,
    NotificationsModule,
  ],
  controllers: [OrdersController, VendorOrdersController],
  providers: [OrdersService, VendorOrdersService],
  exports: [OrdersService, VendorOrdersService, SubOrdersModule, MongooseModule],
})
export class OrdersModule {}
