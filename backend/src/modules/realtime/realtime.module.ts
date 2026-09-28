import { Module } from '@nestjs/common';
import { AuthModule } from '../auth/auth.module.js';
import { DeliveriesModule } from '../deliveries/deliveries.module.js';
import { OrdersModule } from '../orders/orders.module.js';
import { RidersModule } from '../riders/riders.module.js';
import { UsersModule } from '../users/users.module.js';
import { ChangeStreamService } from './change-stream.service.js';
import { RealtimeGateway } from './realtime.gateway.js';

/** Gateway + change streams. The emitter itself lives in RealtimeCoreModule (global). */
@Module({
  imports: [AuthModule, UsersModule, RidersModule, OrdersModule, DeliveriesModule],
  providers: [RealtimeGateway, ChangeStreamService],
})
export class RealtimeModule {}
