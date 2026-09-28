import { Module } from '@nestjs/common';
import { MongooseModule } from '@nestjs/mongoose';
import { AppConfig } from '../../config/app-config.service.js';
import { PaymentIntentsService } from './payment-intents.service.js';
import { MockPaymentProvider } from './providers/mock.provider.js';
import { PAYMENT_PROVIDER, type PaymentProvider } from './providers/payment-provider.interface.js';
import { StripeProvider } from './providers/stripe.provider.js';
import { Payment, PaymentSchema } from './schemas/payment.schema.js';

/** Provider + payment records. No dependency on orders (see PaymentsModule for the webhook). */
@Module({
  imports: [MongooseModule.forFeature([{ name: Payment.name, schema: PaymentSchema }])],
  providers: [
    StripeProvider,
    MockPaymentProvider,
    {
      provide: PAYMENT_PROVIDER,
      inject: [AppConfig, StripeProvider, MockPaymentProvider],
      useFactory: (config: AppConfig, stripe: StripeProvider, mock: MockPaymentProvider): PaymentProvider => {
        if (config.paymentsProvider === 'mock') {
          if (config.isProduction) throw new Error('PAYMENTS_PROVIDER=mock is not allowed in production');
          return mock;
        }
        return stripe;
      },
    },
    PaymentIntentsService,
  ],
  exports: [PAYMENT_PROVIDER, PaymentIntentsService, MongooseModule],
})
export class PaymentsCoreModule {}
