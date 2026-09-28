import { ApiPropertyOptional } from '@nestjs/swagger';
import { Type } from 'class-transformer';
import {
  IsBoolean,
  ValidateIf,
  IsIn,
  IsInt,
  IsNumber,
  IsOptional,
  IsString,
  Matches,
  Max,
  MaxLength,
  Min,
  ValidateNested,
} from 'class-validator';
import { PaginationQueryDto } from '../../../common/dto/pagination-query.dto.js';
import { VENDOR_STATUSES, type VendorStatus } from '../schemas/vendor.schema.js';

export class VendorAddressDto {
  @IsOptional() @IsString() @MaxLength(200) line1?: string;
  @IsOptional() @IsString() @MaxLength(100) city?: string;
  @IsOptional() @IsString() @MaxLength(100) state?: string;
  @IsOptional() @IsString() @MaxLength(2) country?: string;
  @IsOptional() @IsNumber() @Min(-90) @Max(90) lat?: number;
  @IsOptional() @IsNumber() @Min(-180) @Max(180) lng?: number;
}

export class VendorDeliveryFeeDto {
  @IsOptional() @IsInt() @Min(0) baseKobo?: number;
  @IsOptional() @IsInt() @Min(0) perKmKobo?: number;
  @IsOptional() @IsInt() @Min(0) freeAboveKobo?: number | null;
}

/**
 * Accepts either `day` (0 = Sunday … 6 = Saturday, stored form) or `weekday`
 * (1 = Monday … 7 = Sunday, the Dart model's form). See ARCHITECTURE §11.
 */
export class OpeningHoursDto {
  @ValidateIf((o: OpeningHoursDto) => o.weekday === undefined) @IsInt() @Min(0) @Max(6) day?: number;
  @ValidateIf((o: OpeningHoursDto) => o.day === undefined) @IsInt() @Min(1) @Max(7) weekday?: number;
  @Matches(/^\d{2}:\d{2}$/) open: string;
  @Matches(/^\d{2}:\d{2}$/) close: string;
  @IsOptional() @IsBoolean() closed?: boolean;
}

/** Normalises an OpeningHoursDto to the stored `{ day, open, close, closed }` shape. */
export function normaliseOpeningHours(hours: OpeningHoursDto[]): Array<{ day: number; open: string; close: string; closed: boolean }> {
  return hours.map((h) => ({
    day: h.day ?? (h.weekday === 7 ? 0 : (h.weekday as number)),
    open: h.open,
    close: h.close,
    closed: h.closed ?? false,
  }));
}

export class VendorPayoutDetailsDto {
  @IsOptional() @IsString() @MaxLength(100) bankName?: string;
  @IsOptional() @IsString() @MaxLength(32) accountNumber?: string;
  @IsOptional() @IsString() @MaxLength(120) accountName?: string;
}

/** Fields a vendor owner may change on their own profile. */
export class UpdateVendorDto {
  @ApiPropertyOptional() @IsOptional() @IsString() @MaxLength(120) name?: string;
  @ApiPropertyOptional() @IsOptional() @IsString() @MaxLength(2000) description?: string;
  @ApiPropertyOptional() @IsOptional() @ValidateNested() @Type(() => VendorAddressDto) address?: VendorAddressDto;
  @ApiPropertyOptional() @IsOptional() @ValidateNested() @Type(() => VendorDeliveryFeeDto) deliveryFee?: VendorDeliveryFeeDto;
  @ApiPropertyOptional() @IsOptional() @IsNumber() @Min(0.5) @Max(200) deliveryRadiusKm?: number;
  @ApiPropertyOptional() @IsOptional() @ValidateNested({ each: true }) @Type(() => OpeningHoursDto) openingHours?: OpeningHoursDto[];
  @ApiPropertyOptional() @IsOptional() @ValidateNested() @Type(() => VendorPayoutDetailsDto) payout?: VendorPayoutDetailsDto;
}

/** Admin may additionally change commission and status. */
export class AdminUpdateVendorDto extends UpdateVendorDto {
  @ApiPropertyOptional() @IsOptional() @IsInt() @Min(0) @Max(10_000) commissionBps?: number;
  @ApiPropertyOptional({ enum: VENDOR_STATUSES }) @IsOptional() @IsIn([...VENDOR_STATUSES]) status?: VendorStatus;
}

export class PublicVendorsQueryDto extends PaginationQueryDto {
  /** `lat,lng` */
  @IsOptional() @IsString() @Matches(/^-?\d+(\.\d+)?,\s*-?\d+(\.\d+)?$/) near?: string;
  @IsOptional() @IsString() @MaxLength(100) q?: string;
}

export class AdminVendorsQueryDto extends PaginationQueryDto {
  @IsOptional() @IsIn([...VENDOR_STATUSES]) status?: VendorStatus;
  @IsOptional() @IsString() @MaxLength(100) q?: string;
}
