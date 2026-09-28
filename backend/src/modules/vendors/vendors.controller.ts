import { Body, Controller, Get, Param, Patch, Post, Query, UploadedFile, UseGuards, UseInterceptors } from '@nestjs/common';
import { FileInterceptor } from '@nestjs/platform-express';
import { ApiBearerAuth, ApiBody, ApiConsumes, ApiTags } from '@nestjs/swagger';
import { CurrentUser, VendorId } from '../../common/decorators/current-user.decorator.js';
import { AppError } from '../../common/errors/app-error.js';
import { MAX_IMAGE_BYTES } from '../images/images.service.js';
import { Public } from '../../common/decorators/public.decorator.js';
import { Roles } from '../../common/decorators/roles.decorator.js';
import { VendorScopeGuard } from '../../common/guards/vendor-scope.guard.js';
import { PublicVendorsQueryDto, UpdateVendorDto } from './dto/vendor.dto.js';
import { VendorsService } from './vendors.service.js';

@ApiTags('vendors')
@Controller('vendors')
export class VendorsPublicController {
  constructor(private readonly vendors: VendorsService) {}

  @Public()
  @Get()
  list(@Query() query: PublicVendorsQueryDto) {
    return this.vendors.listPublic(query);
  }

  @Public()
  @Get(':slug')
  bySlug(@Param('slug') slug: string) {
    return this.vendors.getPublicBySlug(slug);
  }
}

@ApiTags('vendor')
@ApiBearerAuth()
@Roles('vendor_owner', 'vendor_staff')
@UseGuards(VendorScopeGuard)
@Controller('vendor')
export class VendorSelfController {
  constructor(private readonly vendors: VendorsService) {}

  @Get()
  me(@VendorId() vendorId: string) {
    return this.vendors.getById(vendorId);
  }

  @Roles('vendor_owner')
  @Patch()
  update(@VendorId() vendorId: string, @Body() dto: UpdateVendorDto) {
    return this.vendors.updateOwn(vendorId, dto);
  }

  @Roles('vendor_owner')
  @Post('logo')
  @ApiConsumes('multipart/form-data')
  @ApiBody({ schema: { type: 'object', properties: { file: { type: 'string', format: 'binary' } } } })
  @UseInterceptors(FileInterceptor('file', { limits: { fileSize: MAX_IMAGE_BYTES, files: 1 } }))
  uploadLogo(
    @VendorId() vendorId: string,
    @CurrentUser('userId') userId: string,
    @UploadedFile() file: Express.Multer.File | undefined,
  ) {
    return this.uploadImage(vendorId, userId, 'logo', file);
  }

  @Roles('vendor_owner')
  @Post('cover')
  @ApiConsumes('multipart/form-data')
  @ApiBody({ schema: { type: 'object', properties: { file: { type: 'string', format: 'binary' } } } })
  @UseInterceptors(FileInterceptor('file', { limits: { fileSize: MAX_IMAGE_BYTES, files: 1 } }))
  uploadCover(
    @VendorId() vendorId: string,
    @CurrentUser('userId') userId: string,
    @UploadedFile() file: Express.Multer.File | undefined,
  ) {
    return this.uploadImage(vendorId, userId, 'cover', file);
  }

  private uploadImage(vendorId: string, userId: string, kind: 'logo' | 'cover', file: Express.Multer.File | undefined) {
    if (!file) throw AppError.badRequest('FILE_REQUIRED', 'Multipart field "file" is required');
    return this.vendors.setImage(vendorId, kind, { buffer: file.buffer, mimetype: file.mimetype }, userId);
  }
}
