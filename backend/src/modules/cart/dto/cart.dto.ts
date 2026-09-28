import { ApiProperty, ApiPropertyOptional } from '@nestjs/swagger';
import { Type } from 'class-transformer';
import { ArrayMaxSize, IsArray, IsInt, IsMongoId, IsOptional, IsString, Max, MaxLength, Min, ValidateNested } from 'class-validator';

export class CartItemDto {
  @ApiProperty() @IsMongoId() productId: string;
  @ApiPropertyOptional() @IsOptional() @IsMongoId() variantId?: string | null;
  @ApiProperty() @IsMongoId() vendorId: string;
  @ApiProperty() @IsInt() @Min(1) @Max(999) qty: number;
  @ApiProperty() @IsInt() @Min(0) priceKoboSnapshot: number;
  @ApiProperty() @IsString() @MaxLength(200) nameSnapshot: string;
  @ApiPropertyOptional() @IsOptional() @IsString() @MaxLength(120) variantNameSnapshot?: string | null;
  @ApiPropertyOptional() @IsOptional() @IsMongoId() imageId?: string | null;
}

export class ReplaceCartDto {
  @ApiProperty({ type: [CartItemDto] })
  @IsArray()
  @ArrayMaxSize(100)
  @ValidateNested({ each: true })
  @Type(() => CartItemDto)
  items: CartItemDto[];
}
