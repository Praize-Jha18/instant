import { Body, Controller, Get, Param, Patch, Post, Query, UseGuards } from '@nestjs/common';
import { ApiBearerAuth, ApiTags } from '@nestjs/swagger';
import { CurrentUser, VendorId } from '../../common/decorators/current-user.decorator.js';
import { Roles } from '../../common/decorators/roles.decorator.js';
import { VendorScopeGuard } from '../../common/guards/vendor-scope.guard.js';
import { RiderLocationDto, UpdateRiderProfileDto, VendorRidersQueryDto } from './dto/rider.dto.js';
import { RidersService } from './riders.service.js';

@ApiTags('rider')
@ApiBearerAuth()
@Roles('rider')
@Controller('rider')
export class RiderSelfController {
  constructor(private readonly riders: RidersService) {}

  @Get('profile')
  async profile(@CurrentUser('userId') userId: string) {
    const profile = await this.riders.requireByUserId(userId);
    const [summary] = await this.riders.summarise([profile]);
    return summary;
  }

  @Patch('profile')
  update(@CurrentUser('userId') userId: string, @Body() dto: UpdateRiderProfileDto) {
    return this.riders.updateOwn(userId, dto);
  }

  @Post('location')
  async location(@CurrentUser('userId') userId: string, @Body() dto: RiderLocationDto) {
    const profile = await this.riders.requireByUserId(userId);
    return this.riders.ingestLocation(profile, dto);
  }
}

@ApiTags('vendor')
@ApiBearerAuth()
@Roles('vendor_owner', 'vendor_staff')
@UseGuards(VendorScopeGuard)
@Controller('vendor/riders')
export class VendorRidersController {
  constructor(private readonly riders: RidersService) {}

  @Get()
  list(@VendorId() vendorId: string, @Query() query: VendorRidersQueryDto) {
    return this.riders.listForVendor(vendorId, query);
  }

  @Post(':id/approve')
  approve(@VendorId() vendorId: string, @Param('id') id: string) {
    return this.riders.setStatusByVendor(vendorId, id, 'active');
  }

  @Post(':id/suspend')
  suspend(@VendorId() vendorId: string, @Param('id') id: string) {
    return this.riders.setStatusByVendor(vendorId, id, 'suspended');
  }
}
