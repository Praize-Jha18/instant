import { ApiPropertyOptional } from '@nestjs/swagger';
import { IsIn, IsInt, IsMongoId, IsOptional, IsString, MaxLength, Min } from 'class-validator';
import { PaginationQueryDto } from '../../../common/dto/pagination-query.dto.js';
import { PAYOUT_STATUSES, type PayoutStatus } from '../schemas/payout.schema.js';

export class RequestPayoutDto {
  /** Defaults to the full available balance. */
  @ApiPropertyOptional() @IsOptional() @IsInt() @Min(1) amountKobo?: number;
}

export class MarkPayoutPaidDto {
  @ApiPropertyOptional() @IsOptional() @IsString() @MaxLength(120) reference?: string;
}

export class FailPayoutDto {
  @ApiPropertyOptional() @IsOptional() @IsString() @MaxLength(500) reason?: string;
}

export class PayoutsQueryDto extends PaginationQueryDto {
  @IsOptional() @IsIn([...PAYOUT_STATUSES]) status?: PayoutStatus;
  @IsOptional() @IsMongoId() vendorId?: string;
}
