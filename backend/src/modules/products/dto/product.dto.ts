import { ApiProperty, ApiPropertyOptional } from '@nestjs/swagger';
import { Transform, Type } from 'class-transformer';
import {
  ArrayMaxSize,
  IsArray,
  IsIn,
  IsInt,
  IsMongoId,
  IsNotEmpty,
  IsObject,
  IsOptional,
  IsString,
  MaxLength,
  Min,
  MinLength,
  ValidateNested,
} from 'class-validator';
import { PaginationQueryDto } from '../../../common/dto/pagination-query.dto.js';
import { INVENTORY_REASONS, type InventoryReason } from '../schemas/inventory-movement.schema.js';
import { PRODUCT_STATUSES, type ProductStatus } from '../schemas/product.schema.js';

export class ProductVariantDto {
  /** Present when updating an existing variant. Empty string / null are treated as "new variant". */
  @ApiPropertyOptional()
  @Transform(({ value }) => (value === '' || value === null ? undefined : (value as unknown)))
  @IsOptional()
  @IsMongoId()
  id?: string;
  @ApiProperty() @IsString() @MinLength(1) @MaxLength(80) name: string;
  @ApiPropertyOptional() @IsOptional() @IsString() @MaxLength(64) sku?: string;
  @ApiProperty() @IsInt() @Min(0) priceKobo: number;
  /** Initial stock for new variants only; existing stock is server-authoritative. */
  @ApiPropertyOptional() @IsOptional() @IsInt() @Min(0) stock?: number;
  @ApiPropertyOptional() @IsOptional() @IsObject() attributes?: Record<string, string>;
}

export class CreateProductDto {
  @ApiProperty() @IsString() @MinLength(1) @MaxLength(160) name: string;
  @ApiPropertyOptional() @IsOptional() @IsString() @MaxLength(5000) description?: string;
  @ApiPropertyOptional({ type: [String] }) @IsOptional() @IsArray() @IsMongoId({ each: true }) @ArrayMaxSize(10) categoryIds?: string[];
  @ApiProperty() @IsInt() @Min(0) basePriceKobo: number;
  @ApiPropertyOptional({ type: [ProductVariantDto] })
  @IsOptional()
  @ValidateNested({ each: true })
  @Type(() => ProductVariantDto)
  @ArrayMaxSize(50)
  variants?: ProductVariantDto[];
  /** Initial stock when the product has no variants. */
  @ApiPropertyOptional() @IsOptional() @IsInt() @Min(0) stock?: number;
  @ApiPropertyOptional({ enum: PRODUCT_STATUSES }) @IsOptional() @IsIn([...PRODUCT_STATUSES]) status?: ProductStatus;
  @ApiPropertyOptional({ type: [String] }) @IsOptional() @IsArray() @IsString({ each: true }) @ArrayMaxSize(20) tags?: string[];
}

/** One entry of a product image reorder. */
export class ProductImageOrderDto {
  @ApiProperty() @IsMongoId() imageId: string;
  @ApiProperty() @IsInt() @Min(0) sortOrder: number;
}

export class UpdateProductDto {
  /** Reorders existing images. Must list exactly the images currently attached (upload/delete use the image routes). */
  @ApiPropertyOptional({ type: [ProductImageOrderDto] })
  @IsOptional()
  @ValidateNested({ each: true })
  @Type(() => ProductImageOrderDto)
  @ArrayMaxSize(10)
  images?: ProductImageOrderDto[];
  @ApiPropertyOptional() @IsOptional() @IsString() @MinLength(1) @MaxLength(160) name?: string;
  @ApiPropertyOptional() @IsOptional() @IsString() @MaxLength(5000) description?: string;
  @ApiPropertyOptional({ type: [String] }) @IsOptional() @IsArray() @IsMongoId({ each: true }) @ArrayMaxSize(10) categoryIds?: string[];
  @ApiPropertyOptional() @IsOptional() @IsInt() @Min(0) basePriceKobo?: number;
  @ApiPropertyOptional({ type: [ProductVariantDto] })
  @IsOptional()
  @ValidateNested({ each: true })
  @Type(() => ProductVariantDto)
  @ArrayMaxSize(50)
  variants?: ProductVariantDto[];
  @ApiPropertyOptional({ enum: PRODUCT_STATUSES }) @IsOptional() @IsIn([...PRODUCT_STATUSES]) status?: ProductStatus;
  @ApiPropertyOptional({ type: [String] }) @IsOptional() @IsArray() @IsString({ each: true }) @ArrayMaxSize(20) tags?: string[];
}

/** Offline-safe text edits (sync push). */
export class ProductTextPatchDto {
  @IsOptional() @IsString() @MinLength(1) @MaxLength(160) name?: string;
  @IsOptional() @IsString() @MaxLength(5000) description?: string;
  @IsOptional() @IsArray() @IsString({ each: true }) @ArrayMaxSize(20) tags?: string[];
}

export class StockAdjustDto {
  @ApiPropertyOptional() @IsOptional() @IsMongoId() variantId?: string;
  @ApiProperty() @IsInt() @IsNotEmpty() delta: number;
  @ApiProperty({ enum: INVENTORY_REASONS }) @IsIn([...INVENTORY_REASONS]) reason: InventoryReason;
  @ApiPropertyOptional() @IsOptional() @IsString() @MaxLength(500) note?: string;
}

export class PublicProductsQueryDto extends PaginationQueryDto {
  @IsOptional() @IsMongoId() vendorId?: string;
  @IsOptional() @IsMongoId() categoryId?: string;
  @IsOptional() @IsString() @MaxLength(100) q?: string;
}

export class VendorProductsQueryDto extends PaginationQueryDto {
  @IsOptional() @IsIn([...PRODUCT_STATUSES]) status?: ProductStatus;
  @IsOptional() @IsString() @MaxLength(100) q?: string;
}

export class MovementsQueryDto extends PaginationQueryDto {
  @IsOptional() @IsMongoId() productId?: string;
}
