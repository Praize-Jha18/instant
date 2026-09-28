import { Controller, Headers, HttpCode, Param, Post, Req } from '@nestjs/common';
import type { RawBodyRequest } from '@nestjs/common';
import { ApiBearerAuth, ApiTags } from '@nestjs/swagger';
import { SkipThrottle } from '@nestjs/throttler';
import type { Request } from 'express';
import { CurrentUser } from '../../common/decorators/current-user.decorator.js';
import { Public } from '../../common/decorators/public.decorator.js';
import type { AuthUser } from '../../common/types/auth-user.js';
import { OrdersService } from '../orders/orders.service.js';
import { PaymentsService } from './payments.service.js';

@ApiTags('payments')
@Controller('payments')
export class PaymentsController {
  constructor(
    private readonly payments: PaymentsService,
    private readonly orders: OrdersService,
  ) {}

  /** Stripe → us. Raw body (main.ts `rawBody: true`), signature verified by the provider. */
  @Public()
  @SkipThrottle()
  @HttpCode(200)
  @Post('webhook/stripe')
  webhook(@Req() req: RawBodyRequest<Request>, @Headers() headers: Record<string, string | string[] | undefined>) {
    return this.payments.handleWebhook(req.rawBody, headers);
  }

  @ApiBearerAuth()
  @HttpCode(200)
  @Post(':orderId/retry')
  retry(@CurrentUser() user: AuthUser, @Param('orderId') orderId: string) {
    return this.orders.retryPayment(user, orderId);
  }
}
