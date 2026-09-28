import { Body, Controller, Get, HttpCode, Param, Post, Query, UseGuards } from '@nestjs/common';
import { ApiBearerAuth, ApiTags } from '@nestjs/swagger';
import { CurrentUser, VendorId } from '../../common/decorators/current-user.decorator.js';
import { PaginationQueryDto } from '../../common/dto/pagination-query.dto.js';
import { Roles } from '../../common/decorators/roles.decorator.js';
import { VendorScopeGuard } from '../../common/guards/vendor-scope.guard.js';
import type { AuthUser } from '../../common/types/auth-user.js';
import { CancelOrderDto, CreateOrderDto, UpdateSubOrderStatusDto, VendorOrdersQueryDto } from './dto/order.dto.js';
import { OrdersService } from './orders.service.js';
import { VendorOrdersService } from './vendor-orders.service.js';

@ApiTags('orders')
@ApiBearerAuth()
@Controller('orders')
export class OrdersController {
  constructor(private readonly orders: OrdersService) {}

  @Post()
  create(@CurrentUser() user: AuthUser, @Body() dto: CreateOrderDto) {
    return this.orders.create(user, dto);
  }

  @Get()
  list(@CurrentUser('userId') userId: string, @Query() query: PaginationQueryDto) {
    return this.orders.list(userId, query);
  }

  @Get(':id')
  get(@CurrentUser('userId') userId: string, @Param('id') id: string) {
    return this.orders.get(userId, id);
  }

  @Get(':id/checkout')
  checkout(@CurrentUser() user: AuthUser, @Param('id') id: string) {
    return this.orders.checkoutDetails(user, id);
  }

  @HttpCode(200)
  @Post(':id/cancel')
  cancel(@CurrentUser('userId') userId: string, @Param('id') id: string, @Body() dto: CancelOrderDto) {
    return this.orders.cancel(userId, id, dto.reason);
  }

  @Get(':id/tracking')
  tracking(@CurrentUser('userId') userId: string, @Param('id') id: string) {
    return this.orders.tracking(userId, id);
  }
}

@ApiTags('vendor')
@ApiBearerAuth()
@Roles('vendor_owner', 'vendor_staff')
@UseGuards(VendorScopeGuard)
@Controller('vendor/orders')
export class VendorOrdersController {
  constructor(private readonly vendorOrders: VendorOrdersService) {}

  @Get()
  list(@VendorId() vendorId: string, @Query() query: VendorOrdersQueryDto) {
    return this.vendorOrders.list(vendorId, query);
  }

  @Get(':subOrderId')
  get(@VendorId() vendorId: string, @Param('subOrderId') subOrderId: string) {
    return this.vendorOrders.get(vendorId, subOrderId);
  }

  @HttpCode(200)
  @Post(':subOrderId/status')
  setStatus(
    @VendorId() vendorId: string,
    @CurrentUser('userId') userId: string,
    @Param('subOrderId') subOrderId: string,
    @Body() dto: UpdateSubOrderStatusDto,
  ) {
    return this.vendorOrders.setStatus(vendorId, subOrderId, userId, dto);
  }
}
