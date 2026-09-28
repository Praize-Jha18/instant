import { Injectable } from '@nestjs/common';
import { randomUUID } from 'node:crypto';
import { AppError } from '../../../common/errors/app-error.js';
import type { CreatedIntent, OrderForIntent, PaymentEvent, PaymentProvider, PaymentRef } from './payment-provider.interface.js';

interface MockWebhookBody {
  id?: unknown;
  type?: unknown;
  providerRef?: unknown;
  amountKobo?: unknown;
}

/**
 * Development-only provider (PAYMENTS_PROVIDER=mock). Webhook body:
 * `{ id, type: 'payment_intent.succeeded' | 'payment_intent.payment_failed', providerRef }`.
 */
@Injectable()
export class MockPaymentProvider implements PaymentProvider {
  readonly name = 'mock' as const;

  async createIntent(order: OrderForIntent): Promise<CreatedIntent> {
    const ref = `mock_pi_${order.orderId}_${randomUUID().slice(0, 8)}`;
    return { clientSecret: `${ref}_secret`, providerRef: ref };
  }

  async parseWebhook(rawBody: Buffer): Promise<PaymentEvent> {
    let body: MockWebhookBody;
    try {
      body = JSON.parse(rawBody.toString('utf8')) as MockWebhookBody;
    } catch {
      throw AppError.badRequest('INVALID_WEBHOOK_BODY', 'Body must be JSON');
    }
    const id = typeof body.id === 'string' ? body.id : randomUUID();
    const providerRef = typeof body.providerRef === 'string' ? body.providerRef : null;
    const amountKobo = typeof body.amountKobo === 'number' ? body.amountKobo : null;
    const type =
      body.type === 'payment_intent.succeeded'
        ? 'payment.succeeded'
        : body.type === 'payment_intent.payment_failed' || body.type === 'payment_intent.canceled'
          ? 'payment.failed'
          : 'ignored';
    return { id, type, providerRef, amountKobo, raw: body };
  }

  async refund(payment: PaymentRef): Promise<PaymentRef> {
    return { providerRef: `mock_re_${payment.providerRef}` };
  }

  async cancelIntent(): Promise<void> {
    return;
  }
}
