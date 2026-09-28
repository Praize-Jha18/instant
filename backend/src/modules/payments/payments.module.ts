import { Module } from '@nestjs/common';
import { OrdersModule } from '../orders/orders.module.js';
import { OrderExpiryJob } from './order-expiry.job.js';
import { PaymentsController } from './payments.controller.js';
import { PaymentsCoreModule } from './payments-core.module.js';
import { PaymentsService } from './payments.service.js';

@Module({
  imports: [PaymentsCoreModule, OrdersModule],
  controllers: [PaymentsController],
  providers: [PaymentsService, OrderExpiryJob],
  exports: [PaymentsService],
})
export class PaymentsModule {}
