export const PAYMENT_PROVIDER = Symbol('PAYMENT_PROVIDER');

export interface OrderForIntent {
  orderId: string;
  orderNumber: string;
  amountKobo: number;
  currency: 'NGN';
  customerId: string;
  customerEmail?: string;
  /** Stable per attempt so provider retries never double-charge. */
  idempotencyKey: string;
}

export interface CreatedIntent {
  clientSecret: string | null;
  providerRef: string;
}

export type PaymentEventType = 'payment.succeeded' | 'payment.failed' | 'ignored';

export interface PaymentEvent {
  /** Provider event id; webhook handling is idempotent on it (§8). */
  id: string;
  type: PaymentEventType;
  providerRef: string | null;
  amountKobo: number | null;
  raw: unknown;
}

export interface PaymentRef {
  providerRef: string;
}

/**
 * Payment mechanism (§8). `StripeProvider` first; `PaystackProvider` later
 * without touching order code.
 */
export interface PaymentProvider {
  readonly name: 'stripe' | 'mock';
  createIntent(order: OrderForIntent): Promise<CreatedIntent>;
  parseWebhook(rawBody: Buffer, headers: Record<string, string | string[] | undefined>): Promise<PaymentEvent>;
  refund(payment: PaymentRef, amountKobo: number): Promise<PaymentRef>;
  /** Best effort; providers may not support cancelling. */
  cancelIntent(payment: PaymentRef): Promise<void>;
}
