import { Body, Controller, Delete, Get, HttpCode, Param, Patch, Post, Query } from '@nestjs/common';
import { ApiBearerAuth, ApiTags } from '@nestjs/swagger';
import { CurrentUser } from '../../common/decorators/current-user.decorator.js';
import { Roles } from '../../common/decorators/roles.decorator.js';
import { oid } from '../../common/utils/ids.js';
import { CategoriesService } from '../categories/categories.service.js';
import { CreateCategoryDto, UpdateCategoryDto } from '../categories/dto/category.dto.js';
import { FailPayoutDto, MarkPayoutPaidDto, PayoutsQueryDto } from '../ledger/dto/ledger.dto.js';
import { LedgerService } from '../ledger/ledger.service.js';
import { AdminOrdersQueryDto, VendorOrdersQueryDto } from '../orders/dto/order.dto.js';
import { OrdersService } from '../orders/orders.service.js';
import { SubOrdersService } from '../orders/sub-orders.service.js';
import { UsersService } from '../users/users.service.js';
import { AdminUpdateVendorDto, AdminVendorsQueryDto } from '../vendors/dto/vendor.dto.js';
import { VendorsService } from '../vendors/vendors.service.js';
import { AdminService } from './admin.service.js';
import { AdminUsersQueryDto, SetUserStatusDto } from './dto/admin.dto.js';

@ApiTags('admin')
@ApiBearerAuth()
@Roles('admin')
@Controller('admin')
export class AdminController {
  constructor(
    private readonly admin: AdminService,
    private readonly vendors: VendorsService,
    private readonly users: UsersService,
    private readonly categories: CategoriesService,
    private readonly orders: OrdersService,
    private readonly subOrders: SubOrdersService,
    private readonly ledger: LedgerService,
  ) {}

  // vendors
  @Get('vendors') listVendors(@Query() query: AdminVendorsQueryDto) { return this.vendors.listAdmin(query); }
  @Get('vendors/:id') getVendor(@Param('id') id: string) { return this.vendors.getById(id); }
  @Patch('vendors/:id') updateVendor(@Param('id') id: string, @Body() dto: AdminUpdateVendorDto) { return this.vendors.adminUpdate(id, dto); }
  @HttpCode(200) @Post('vendors/:id/approve') approveVendor(@Param('id') id: string) { return this.vendors.setStatus(id, 'active'); }
  @HttpCode(200) @Post('vendors/:id/suspend') suspendVendor(@Param('id') id: string) { return this.vendors.setStatus(id, 'suspended'); }

  // orders
  @Get('orders') listOrders(@Query() query: AdminOrdersQueryDto) { return this.orders.listAdmin(query); }
  @Get('orders/:id') async getOrder(@Param('id') id: string) {
    const order = await this.orders.getById(oid(id, 'orderId'));
    return { order, subOrders: await this.subOrders.findByOrder(order._id) };
  }
  @Get('sub-orders') listSubOrders(@Query() query: VendorOrdersQueryDto & { vendorId?: string }) { return this.subOrders.listAdmin(query); }

  // users
  @Get('users') listUsers(@Query() query: AdminUsersQueryDto) { return this.users.list(query); }
  @Get('users/:id') getUser(@Param('id') id: string) { return this.users.getById(id); }
  @Patch('users/:id/status') setUserStatus(@Param('id') id: string, @Body() dto: SetUserStatusDto) { return this.users.setStatus(id, dto.status); }

  // payouts
  @Get('payouts') listPayouts(@Query() query: PayoutsQueryDto) { return this.ledger.listPayouts(query); }
  @HttpCode(200) @Post('payouts/:id/mark-paid') markPaid(@CurrentUser('userId') adminId: string, @Param('id') id: string, @Body() dto: MarkPayoutPaidDto) {
    return this.ledger.markPaid(id, adminId, dto.reference);
  }
  @HttpCode(200) @Post('payouts/:id/mark-failed') markFailed(@CurrentUser('userId') adminId: string, @Param('id') id: string, @Body() dto: FailPayoutDto) {
    return this.ledger.markFailed(id, adminId, dto.reason);
  }

  // categories
  @Get('categories') listCategories() { return this.categories.list(); }
  @Post('categories') createCategory(@Body() dto: CreateCategoryDto) { return this.categories.create(dto); }
  @Get('categories/:id') getCategory(@Param('id') id: string) { return this.categories.getById(id); }
  @Patch('categories/:id') updateCategory(@Param('id') id: string, @Body() dto: UpdateCategoryDto) { return this.categories.update(id, dto); }
  @Delete('categories/:id') removeCategory(@Param('id') id: string) { return this.categories.remove(id); }

  // stats
  @Get('stats') stats() { return this.admin.stats(); }
}
