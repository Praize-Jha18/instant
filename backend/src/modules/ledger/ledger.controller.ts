import { Body, Controller, Get, Post, Query, UseGuards } from '@nestjs/common';
import { ApiBearerAuth, ApiTags } from '@nestjs/swagger';
import { CurrentUser, VendorId } from '../../common/decorators/current-user.decorator.js';
import { PaginationQueryDto } from '../../common/dto/pagination-query.dto.js';
import { Roles } from '../../common/decorators/roles.decorator.js';
import { VendorScopeGuard } from '../../common/guards/vendor-scope.guard.js';
import { PayoutsQueryDto, RequestPayoutDto } from './dto/ledger.dto.js';
import { LedgerService } from './ledger.service.js';

@ApiTags('vendor')
@ApiBearerAuth()
@Roles('vendor_owner', 'vendor_staff')
@UseGuards(VendorScopeGuard)
@Controller('vendor')
export class VendorLedgerController {
  constructor(private readonly ledger: LedgerService) {}

  @Get('ledger')
  ledgerList(@VendorId() vendorId: string, @Query() query: PaginationQueryDto) {
    return this.ledger.listLedger(vendorId, query);
  }

  @Get('payouts')
  payouts(@VendorId() vendorId: string, @Query() query: PayoutsQueryDto) {
    query.vendorId = vendorId;
    return this.ledger.listPayouts(query);
  }

  @Roles('vendor_owner')
  @Post('payouts')
  request(@VendorId() vendorId: string, @CurrentUser('userId') userId: string, @Body() dto: RequestPayoutDto) {
    return this.ledger.requestPayout(vendorId, userId, dto.amountKobo);
  }
}
