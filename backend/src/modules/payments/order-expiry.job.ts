import { Injectable, Logger } from '@nestjs/common';
import { Cron, CronExpression } from '@nestjs/schedule';
import { OrdersService } from '../orders/orders.service.js';

/** Expires unpaid orders after 30 minutes and releases their stock (§6). */
@Injectable()
export class OrderExpiryJob {
  private readonly logger = new Logger(OrderExpiryJob.name);
  private running = false;

  constructor(private readonly orders: OrdersService) {}

  @Cron(CronExpression.EVERY_MINUTE)
  async run(): Promise<void> {
    if (this.running) return;
    this.running = true;
    try {
      const expired = await this.orders.expireUnpaid();
      if (expired > 0) this.logger.log(`Expired ${expired} unpaid order(s)`);
    } catch (err) {
      this.logger.error(`Order expiry sweep failed: ${err instanceof Error ? err.message : String(err)}`);
    } finally {
      this.running = false;
    }
  }
}
