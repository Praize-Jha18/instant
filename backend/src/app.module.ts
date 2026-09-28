import { Module } from '@nestjs/common';
import { APP_GUARD } from '@nestjs/core';
import { ScheduleModule } from '@nestjs/schedule';
import { ThrottlerGuard, ThrottlerModule } from '@nestjs/throttler';
import { JwtAuthGuard } from './common/guards/jwt-auth.guard.js';
import { RolesGuard } from './common/guards/roles.guard.js';
import { AppConfigModule } from './config/config.module.js';
import { DatabaseModule } from './database/database.module.js';
import { AddressesModule } from './modules/addresses/addresses.module.js';
import { AdminModule } from './modules/admin/admin.module.js';
import { PaymentsModule } from './modules/payments/payments.module.js';
import { AuthModule } from './modules/auth/auth.module.js';
import { CartModule } from './modules/cart/cart.module.js';
import { DeliveriesModule } from './modules/deliveries/deliveries.module.js';
import { LedgerModule } from './modules/ledger/ledger.module.js';
import { OrdersModule } from './modules/orders/orders.module.js';
import { PaymentsCoreModule } from './modules/payments/payments-core.module.js';
import { CategoriesModule } from './modules/categories/categories.module.js';
import { ImagesModule } from './modules/images/images.module.js';
import { ProductsModule } from './modules/products/products.module.js';
import { NotificationsModule } from './modules/notifications/notifications.module.js';
import { RealtimeCoreModule } from './modules/realtime/realtime-core.module.js';
import { RealtimeModule } from './modules/realtime/realtime.module.js';
import { SyncModule } from './modules/sync/sync.module.js';
import { RidersModule } from './modules/riders/riders.module.js';
import { UsersModule } from './modules/users/users.module.js';
import { VendorsModule } from './modules/vendors/vendors.module.js';

@Module({
  imports: [
    AppConfigModule,
    DatabaseModule,
    ScheduleModule.forRoot(),
    ThrottlerModule.forRoot([{ name: 'default', ttl: 60_000, limit: 300 }]),
    RealtimeCoreModule,
    UsersModule,
    NotificationsModule,
    VendorsModule,
    RidersModule,
    AuthModule,
    ImagesModule,
    CategoriesModule,
    ProductsModule,
    AddressesModule,
    CartModule,
    LedgerModule,
    PaymentsCoreModule,
    DeliveriesModule,
    OrdersModule,
    PaymentsModule,
    AdminModule,
    SyncModule,
    RealtimeModule,
  ],
  providers: [
    { provide: APP_GUARD, useClass: ThrottlerGuard },
    { provide: APP_GUARD, useClass: JwtAuthGuard },
    { provide: APP_GUARD, useClass: RolesGuard },
  ],
})
export class AppModule {}
