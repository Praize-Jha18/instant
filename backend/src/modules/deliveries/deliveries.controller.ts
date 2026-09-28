import { Body, Controller, Get, Param, Post, Query, UploadedFile, UseGuards, UseInterceptors } from '@nestjs/common';
import { FileInterceptor } from '@nestjs/platform-express';
import { ApiBearerAuth, ApiConsumes, ApiTags } from '@nestjs/swagger';
import { CurrentUser, VendorId } from '../../common/decorators/current-user.decorator.js';
import { Roles } from '../../common/decorators/roles.decorator.js';
import { VendorScopeGuard } from '../../common/guards/vendor-scope.guard.js';
import { MAX_IMAGE_BYTES } from '../images/images.service.js';
import { DeliveriesService } from './deliveries.service.js';
import { AssignDeliveryDto, DeliverDto, DeliveriesQueryDto, RespondDeliveryDto } from './dto/delivery.dto.js';

@ApiTags('vendor')
@ApiBearerAuth()
@Roles('vendor_owner', 'vendor_staff')
@UseGuards(VendorScopeGuard)
@Controller('vendor/deliveries')
export class VendorDeliveriesController {
  constructor(private readonly deliveries: DeliveriesService) {}

  @Get()
  list(@VendorId() vendorId: string, @Query() query: DeliveriesQueryDto) {
    return this.deliveries.listForVendor(vendorId, query);
  }

  @Get(':id')
  get(@VendorId() vendorId: string, @Param('id') id: string) {
    return this.deliveries.getForVendor(vendorId, id);
  }

  @Post(':id/assign')
  assign(@VendorId() vendorId: string, @CurrentUser('userId') userId: string, @Param('id') id: string, @Body() dto: AssignDeliveryDto) {
    return this.deliveries.assign(vendorId, id, dto.riderId, userId);
  }

  @Post(':id/auto-assign')
  autoAssign(@VendorId() vendorId: string, @CurrentUser('userId') userId: string, @Param('id') id: string) {
    return this.deliveries.autoAssign(vendorId, id, userId);
  }
}

@ApiTags('rider')
@ApiBearerAuth()
@Roles('rider')
@Controller('rider/deliveries')
export class RiderDeliveriesController {
  constructor(private readonly deliveries: DeliveriesService) {}

  @Get()
  list(@CurrentUser('userId') userId: string, @Query() query: DeliveriesQueryDto) {
    return this.deliveries.listForRider(userId, query);
  }

  @Get(':id')
  async get(@CurrentUser('userId') userId: string, @Param('id') id: string) {
    const { delivery } = await this.deliveries.getForRider(userId, id);
    return delivery;
  }

  @Post(':id/respond')
  respond(@CurrentUser('userId') userId: string, @Param('id') id: string, @Body() dto: RespondDeliveryDto) {
    return this.deliveries.respond(userId, id, dto.accept);
  }

  @Post(':id/pickup')
  pickup(@CurrentUser('userId') userId: string, @Param('id') id: string) {
    return this.deliveries.pickup(userId, id);
  }

  @Post(':id/deliver')
  @ApiConsumes('application/json', 'multipart/form-data')
  @UseInterceptors(FileInterceptor('photo', { limits: { fileSize: MAX_IMAGE_BYTES, files: 1 } }))
  deliver(
    @CurrentUser('userId') userId: string,
    @Param('id') id: string,
    @Body() dto: DeliverDto,
    @UploadedFile() photo: Express.Multer.File | undefined,
  ) {
    return this.deliveries.deliver(userId, id, {
      otp: dto.otp,
      photo: photo ? { buffer: photo.buffer, mimetype: photo.mimetype } : undefined,
    });
  }
}
