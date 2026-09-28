import { Inject, Injectable, Logger } from '@nestjs/common';
import { InjectModel } from '@nestjs/mongoose';
import { Model, Types } from 'mongoose';
import { randomUUID } from 'node:crypto';
import { notDeleted } from '../../common/schemas/base.js';
import { PAYMENT_PROVIDER, type PaymentEvent, type PaymentProvider } from './providers/payment-provider.interface.js';
import { Payment, type PaymentDocument, type PaymentRecordStatus } from './schemas/payment.schema.js';

export interface CheckoutPayment {
  paymentId: string;
  provider: string;
  providerRef: string;
  clientSecret: string | null;
  amountKobo: number;
  currency: string;
}

export interface CreateIntentInput {
  orderId: Types.ObjectId;
  orderNumber: string;
  amountKobo: number;
  customerId: Types.ObjectId;
  customerEmail?: string;
}

/**
 * Owns `payments` records and talks to the PaymentProvider. Has no knowledge
 * of orders beyond their id, so OrdersModule can depend on it without cycles.
 */
@Injectable()
export class PaymentIntentsService {
  private readonly logger = new Logger(PaymentIntentsService.name);

  constructor(
    @InjectModel(Payment.name) private readonly payments: Model<Payment>,
    @Inject(PAYMENT_PROVIDER) private readonly provider: PaymentProvider,
  ) {}

  get providerName(): string {
    return this.provider.name;
  }

  async createForOrder(input: CreateIntentInput): Promise<{ payment: PaymentDocument; checkout: CheckoutPayment }> {
    const idempotencyKey = `${String(input.orderId)}:${randomUUID()}`;
    const intent = await this.provider.createIntent({
      orderId: String(input.orderId),
      orderNumber: input.orderNumber,
      amountKobo: input.amountKobo,
      currency: 'NGN',
      customerId: String(input.customerId),
      customerEmail: input.customerEmail,
      idempotencyKey,
    });
    const payment = await this.payments.create({
      orderId: input.orderId,
      provider: this.provider.name,
      providerRef: intent.providerRef,
      amountKobo: input.amountKobo,
      currency: 'NGN',
      status: 'pending',
      rawEvents: [],
      idempotencyKey,
      clientSecret: intent.clientSecret,
    });
    return { payment, checkout: this.toCheckout(payment, intent.clientSecret) };
  }

  toCheckout(payment: PaymentDocument, clientSecret: string | null): CheckoutPayment {
    return {
      paymentId: String(payment._id),
      provider: payment.provider,
      providerRef: payment.providerRef,
      clientSecret,
      amountKobo: payment.amountKobo,
      currency: payment.currency,
    };
  }

  async findByOrder(orderId: Types.ObjectId): Promise<PaymentDocument | null> {
    return this.payments.findOne({ orderId, ...notDeleted }).sort({ _id: -1 }).exec();
  }

  async findByOrderWithSecret(orderId: Types.ObjectId): Promise<PaymentDocument | null> {
    return this.payments.findOne({ orderId, ...notDeleted }).sort({ _id: -1 }).select('+clientSecret').exec();
  }

  parseWebhook(rawBody: Buffer, headers: Record<string, string | string[] | undefined>): Promise<PaymentEvent> {
    return this.provider.parseWebhook(rawBody, headers);
  }

  /**
   * Atomically records the event on the payment. Returns null when the event
   * was already processed (or no payment matches), making webhooks idempotent.
   */
  async claimEvent(event: PaymentEvent): Promise<PaymentDocument | null> {
    if (!event.providerRef) return null;
    return this.payments
      .findOneAndUpdate(
        { providerRef: event.providerRef, 'rawEvents.id': { $ne: event.id } },
        { $push: { rawEvents: { $each: [{ id: event.id, type: event.type, at: new Date() }], $slice: -20 } } },
        { new: true },
      )
      .exec();
  }

  async setStatus(paymentId: Types.ObjectId, status: PaymentRecordStatus): Promise<void> {
    await this.payments.updateOne({ _id: paymentId }, { $set: { status } }).exec();
  }

  /** Refunds through the provider and updates the record. Errors are logged, not thrown. */
  async refund(payment: PaymentDocument, amountKobo: number, reason: string): Promise<boolean> {
    if (amountKobo <= 0) return true;
    try {
      await this.provider.refund({ providerRef: payment.providerRef }, amountKobo);
      const refundedKobo = payment.refundedKobo + amountKobo;
      await this.payments
        .updateOne(
          { _id: payment._id },
          { $set: { refundedKobo, status: refundedKobo >= payment.amountKobo ? 'refunded' : 'partially_refunded' } },
        )
        .exec();
      return true;
    } catch (err) {
      this.logger.error(`Refund failed for ${payment.providerRef} (${reason}): ${err instanceof Error ? err.message : String(err)}`);
      return false;
    }
  }

  async cancel(payment: PaymentDocument): Promise<void> {
    await this.provider.cancelIntent({ providerRef: payment.providerRef });
    await this.setStatus(payment._id, 'canceled');
  }
}
