import { Module } from '@nestjs/common';
import { CategoriesModule } from '../categories/categories.module.js';
import { LedgerModule } from '../ledger/ledger.module.js';
import { OrdersModule } from '../orders/orders.module.js';
import { ProductsModule } from '../products/products.module.js';
import { UsersModule } from '../users/users.module.js';
import { VendorsModule } from '../vendors/vendors.module.js';
import { AdminController } from './admin.controller.js';
import { AdminService } from './admin.service.js';

@Module({
  imports: [UsersModule, VendorsModule, CategoriesModule, ProductsModule, OrdersModule, LedgerModule],
  controllers: [AdminController],
  providers: [AdminService],
})
export class AdminModule {}
