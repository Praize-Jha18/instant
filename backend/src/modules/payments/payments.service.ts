import { Injectable, Logger } from '@nestjs/common';
import { AppError } from '../../common/errors/app-error.js';
import { OrdersService } from '../orders/orders.service.js';
import { PaymentIntentsService } from './payment-intents.service.js';

export interface WebhookResult {
  received: true;
  eventId: string;
  outcome: 'paid' | 'already_paid' | 'refunded' | 'failed' | 'duplicate' | 'ignored' | 'unknown_payment';
}

/**
 * Webhook orchestration (§8): verify → claim event id → apply order outcome.
 */
@Injectable()
export class PaymentsService {
  private readonly logger = new Logger(PaymentsService.name);

  constructor(
    private readonly paymentIntents: PaymentIntentsService,
    private readonly orders: OrdersService,
  ) {}

  async handleWebhook(rawBody: Buffer | undefined, headers: Record<string, string | string[] | undefined>): Promise<WebhookResult> {
    if (!rawBody || rawBody.length === 0) {
      throw AppError.badRequest('RAW_BODY_REQUIRED', 'Webhook requires the raw request body');
    }
    const event = await this.paymentIntents.parseWebhook(rawBody, headers);
    if (event.type === 'ignored') return { received: true, eventId: event.id, outcome: 'ignored' };

    const payment = await this.paymentIntents.claimEvent(event);
    if (!payment) {
      this.logger.log(`Webhook ${event.id} for ${event.providerRef ?? '?'}: duplicate or unknown payment`);
      return { received: true, eventId: event.id, outcome: event.providerRef ? 'duplicate' : 'unknown_payment' };
    }

    if (event.type === 'payment.succeeded') {
      if (event.amountKobo !== null && event.amountKobo < payment.amountKobo) {
        this.logger.warn(`Webhook ${event.id}: amount ${event.amountKobo} < expected ${payment.amountKobo}`);
      }
      const result = await this.orders.confirmPayment(payment);
      return { received: true, eventId: event.id, outcome: result.status === 'ignored' ? 'unknown_payment' : result.status };
    }

    const order = await this.orders.findById(payment.orderId);
    if (order) await this.orders.failPayment(order, 'payment_failed');
    else await this.paymentIntents.setStatus(payment._id, 'failed');
    return { received: true, eventId: event.id, outcome: 'failed' };
  }
}
