import { ApiProperty, ApiPropertyOptional } from '@nestjs/swagger';
import { IsIn, IsMongoId, IsOptional, IsString, MaxLength } from 'class-validator';
import { PaginationQueryDto } from '../../../common/dto/pagination-query.dto.js';
import { SUB_ORDER_STATUSES, type SubOrderStatus } from '../order-state-machine.js';
import { ORDER_PAYMENT_STATUSES, type OrderPaymentStatus } from '../schemas/order.schema.js';

export class CreateOrderDto {
  @ApiProperty() @IsMongoId() addressId: string;
  @ApiPropertyOptional() @IsOptional() @IsString() @MaxLength(500) note?: string;
}

export class CancelOrderDto {
  @ApiPropertyOptional() @IsOptional() @IsString() @MaxLength(500) reason?: string;
}

export class VendorOrdersQueryDto extends PaginationQueryDto {
  @ApiPropertyOptional({ enum: SUB_ORDER_STATUSES }) @IsOptional() @IsIn([...SUB_ORDER_STATUSES]) status?: SubOrderStatus;
}

export class UpdateSubOrderStatusDto {
  @ApiProperty({ enum: SUB_ORDER_STATUSES }) @IsIn([...SUB_ORDER_STATUSES]) status: SubOrderStatus;
  @ApiPropertyOptional() @IsOptional() @IsString() @MaxLength(500) note?: string;
}

export class AdminOrdersQueryDto extends PaginationQueryDto {
  @IsOptional() @IsIn([...ORDER_PAYMENT_STATUSES]) paymentStatus?: OrderPaymentStatus;
  @IsOptional() @IsMongoId() customerId?: string;
}
