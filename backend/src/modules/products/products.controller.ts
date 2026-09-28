import {
  Body,
  Controller,
  Delete,
  Get,
  Param,
  Patch,
  Post,
  Query,
  UploadedFile,
  UseGuards,
  UseInterceptors,
} from '@nestjs/common';
import { FileInterceptor } from '@nestjs/platform-express';
import { ApiBearerAuth, ApiBody, ApiConsumes, ApiTags } from '@nestjs/swagger';
import { CurrentUser, VendorId } from '../../common/decorators/current-user.decorator.js';
import { Public } from '../../common/decorators/public.decorator.js';
import { Roles } from '../../common/decorators/roles.decorator.js';
import { AppError } from '../../common/errors/app-error.js';
import { VendorScopeGuard } from '../../common/guards/vendor-scope.guard.js';
import { oid } from '../../common/utils/ids.js';
import { MAX_IMAGE_BYTES } from '../images/images.service.js';
import {
  CreateProductDto,
  MovementsQueryDto,
  PublicProductsQueryDto,
  StockAdjustDto,
  UpdateProductDto,
  VendorProductsQueryDto,
} from './dto/product.dto.js';
import { ProductsService } from './products.service.js';
import { StockService } from './stock.service.js';

@ApiTags('products')
@Controller('products')
export class ProductsPublicController {
  constructor(private readonly products: ProductsService) {}

  @Public()
  @Get()
  list(@Query() query: PublicProductsQueryDto) {
    return this.products.listPublic(query);
  }

  @Public()
  @Get(':id')
  get(@Param('id') id: string) {
    return this.products.getPublic(id);
  }
}

@ApiTags('vendor')
@ApiBearerAuth()
@Roles('vendor_owner', 'vendor_staff')
@UseGuards(VendorScopeGuard)
@Controller('vendor/products')
export class VendorProductsController {
  constructor(
    private readonly products: ProductsService,
    private readonly stock: StockService,
  ) {}

  @Get()
  list(@VendorId() vendorId: string, @Query() query: VendorProductsQueryDto) {
    return this.products.listForVendor(vendorId, query);
  }

  @Post()
  create(@VendorId() vendorId: string, @Body() dto: CreateProductDto) {
    return this.products.create(vendorId, dto);
  }

  @Get(':id')
  get(@VendorId() vendorId: string, @Param('id') id: string) {
    return this.products.getForVendor(vendorId, id);
  }

  @Patch(':id')
  update(@VendorId() vendorId: string, @Param('id') id: string, @Body() dto: UpdateProductDto) {
    return this.products.update(vendorId, id, dto);
  }

  @Delete(':id')
  remove(@VendorId() vendorId: string, @Param('id') id: string) {
    return this.products.remove(vendorId, id);
  }

  @Post(':id/images')
  @ApiConsumes('multipart/form-data')
  @ApiBody({ schema: { type: 'object', properties: { file: { type: 'string', format: 'binary' } } } })
  @UseInterceptors(FileInterceptor('file', { limits: { fileSize: MAX_IMAGE_BYTES, files: 1 } }))
  addImage(
    @VendorId() vendorId: string,
    @CurrentUser('userId') userId: string,
    @Param('id') id: string,
    @UploadedFile() file: Express.Multer.File | undefined,
  ) {
    if (!file) throw AppError.badRequest('FILE_REQUIRED', 'Multipart field "file" is required');
    return this.products.addImage(vendorId, id, { buffer: file.buffer, mimetype: file.mimetype }, userId);
  }

  @Delete(':id/images/:imageId')
  removeImage(@VendorId() vendorId: string, @Param('id') id: string, @Param('imageId') imageId: string) {
    return this.products.removeImage(vendorId, id, imageId);
  }

  @Post(':id/stock')
  async adjustStock(
    @VendorId() vendorId: string,
    @CurrentUser('userId') userId: string,
    @Param('id') id: string,
    @Body() dto: StockAdjustDto,
  ) {
    const product = await this.products.getForVendor(vendorId, id);
    const result = await this.stock.adjust(product.vendorId, product._id, dto, oid(userId, 'userId'));
    const updated = await this.products.getForVendor(vendorId, id);
    return { ...result, product: updated };
  }
}

@ApiTags('vendor')
@ApiBearerAuth()
@Roles('vendor_owner', 'vendor_staff')
@UseGuards(VendorScopeGuard)
@Controller('vendor/inventory')
export class VendorInventoryController {
  constructor(private readonly stock: StockService) {}

  @Get('movements')
  movements(@VendorId() vendorId: string, @Query() query: MovementsQueryDto) {
    return this.stock.listMovements(vendorId, query);
  }
}
