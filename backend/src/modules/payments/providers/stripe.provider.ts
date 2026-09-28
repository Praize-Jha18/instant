import { Injectable, Logger } from '@nestjs/common';
import Stripe from 'stripe';
import { AppError } from '../../../common/errors/app-error.js';
import { AppConfig } from '../../../config/app-config.service.js';
import type { CreatedIntent, OrderForIntent, PaymentEvent, PaymentProvider, PaymentRef } from './payment-provider.interface.js';

function headerValue(headers: Record<string, string | string[] | undefined>, name: string): string | undefined {
  const v = headers[name] ?? headers[name.toLowerCase()];
  return Array.isArray(v) ? v[0] : v;
}

@Injectable()
export class StripeProvider implements PaymentProvider {
  readonly name = 'stripe' as const;
  private readonly logger = new Logger(StripeProvider.name);
  private readonly client: Stripe | null;

  constructor(private readonly config: AppConfig) {
    this.client = config.stripeSecretKey ? new Stripe(config.stripeSecretKey) : null;
    if (!this.client) this.logger.warn('STRIPE_SECRET_KEY is empty; payments will fail until it is set');
  }

  private stripe(): Stripe {
    if (!this.client) {
      throw AppError.unavailable('PAYMENT_PROVIDER_UNAVAILABLE', 'Stripe is not configured on this server');
    }
    return this.client;
  }

  async createIntent(order: OrderForIntent): Promise<CreatedIntent> {
    const intent = await this.stripe().paymentIntents.create(
      {
        amount: order.amountKobo,
        currency: 'ngn',
        automatic_payment_methods: { enabled: true },
        metadata: { orderId: order.orderId, orderNumber: order.orderNumber, customerId: order.customerId },
        receipt_email: order.customerEmail,
        description: `Instant order ${order.orderNumber}`,
      },
      { idempotencyKey: order.idempotencyKey },
    );
    return { clientSecret: intent.client_secret, providerRef: intent.id };
  }

  async parseWebhook(rawBody: Buffer, headers: Record<string, string | string[] | undefined>): Promise<PaymentEvent> {
    const signature = headerValue(headers, 'stripe-signature');
    if (!signature) throw AppError.badRequest('MISSING_SIGNATURE', 'stripe-signature header is required');
    if (!this.config.stripeWebhookSecret) {
      throw AppError.unavailable('WEBHOOK_NOT_CONFIGURED', 'STRIPE_WEBHOOK_SECRET is not set');
    }
    let event: Stripe.Event;
    try {
      event = this.stripe().webhooks.constructEvent(rawBody, signature, this.config.stripeWebhookSecret);
    } catch (err) {
      const message = err instanceof Error ? err.message : 'invalid signature';
      throw AppError.badRequest('INVALID_SIGNATURE', `Webhook signature verification failed: ${message}`);
    }

    switch (event.type) {
      case 'payment_intent.succeeded': {
        const pi = event.data.object;
        return { id: event.id, type: 'payment.succeeded', providerRef: pi.id, amountKobo: pi.amount_received, raw: event };
      }
      case 'payment_intent.payment_failed':
      case 'payment_intent.canceled': {
        const pi = event.data.object;
        return { id: event.id, type: 'payment.failed', providerRef: pi.id, amountKobo: pi.amount, raw: event };
      }
      default:
        return { id: event.id, type: 'ignored', providerRef: null, amountKobo: null, raw: event };
    }
  }

  async refund(payment: PaymentRef, amountKobo: number): Promise<PaymentRef> {
    const refund = await this.stripe().refunds.create({ payment_intent: payment.providerRef, amount: amountKobo });
    return { providerRef: refund.id };
  }

  async cancelIntent(payment: PaymentRef): Promise<void> {
    try {
      await this.stripe().paymentIntents.cancel(payment.providerRef);
    } catch (err) {
      this.logger.warn(`Could not cancel intent ${payment.providerRef}: ${err instanceof Error ? err.message : String(err)}`);
    }
  }
}
