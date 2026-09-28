import { ApiProperty, ApiPropertyOptional } from '@nestjs/swagger';
import { Transform } from 'class-transformer';
import { IsBoolean, IsIn, IsMongoId, IsOptional, IsString, Length } from 'class-validator';
import { PaginationQueryDto } from '../../../common/dto/pagination-query.dto.js';
import { DELIVERY_STATUSES, type DeliveryStatus } from '../../orders/order-state-machine.js';

export class AssignDeliveryDto {
  @ApiProperty() @IsMongoId() riderId: string;
}

export class RespondDeliveryDto {
  @ApiProperty()
  @Transform(({ value }) => (value === 'true' ? true : value === 'false' ? false : value))
  @IsBoolean()
  accept: boolean;
}

export class DeliverDto {
  /** Required unless a proof photo is uploaded. */
  @ApiPropertyOptional() @IsOptional() @IsString() @Length(4, 8) otp?: string;
}

export class DeliveriesQueryDto extends PaginationQueryDto {
  @IsOptional() @IsIn([...DELIVERY_STATUSES]) status?: DeliveryStatus;
}
