import { ApiProperty, ApiPropertyOptional } from '@nestjs/swagger';
import { Type } from 'class-transformer';
import {
  ArrayMaxSize,
  IsBoolean,
  IsDateString,
  IsIn,
  IsNumber,
  IsOptional,
  IsString,
  Max,
  MaxLength,
  Min,
  ValidateNested,
} from 'class-validator';
import { PaginationQueryDto } from '../../../common/dto/pagination-query.dto.js';
import { RIDER_STATUSES, type RiderStatus } from '../schemas/rider-profile.schema.js';

export class UpdateRiderProfileDto {
  @ApiPropertyOptional() @IsOptional() @IsBoolean() isOnline?: boolean;
  @ApiPropertyOptional() @IsOptional() @IsString() @MaxLength(40) vehicleType?: string;
  @ApiPropertyOptional() @IsOptional() @IsString() @MaxLength(20) plateNumber?: string;
}

export class RiderLocationDto {
  @ApiProperty() @IsNumber() @Min(-90) @Max(90) lat: number;
  @ApiProperty() @IsNumber() @Min(-180) @Max(180) lng: number;
  @ApiPropertyOptional() @IsOptional() @IsNumber() @Min(0) @Max(360) heading?: number;
  @ApiPropertyOptional() @IsOptional() @IsNumber() @Min(0) speed?: number;
  @ApiProperty() @IsDateString() at: string;
}

export class RiderLocationBatchDto {
  @ValidateNested({ each: true })
  @Type(() => RiderLocationDto)
  @ArrayMaxSize(500)
  points: RiderLocationDto[];
}

export class VendorRidersQueryDto extends PaginationQueryDto {
  @IsOptional() @IsIn([...RIDER_STATUSES]) status?: RiderStatus;
}
