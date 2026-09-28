import { ApiProperty, ApiPropertyOptional } from '@nestjs/swagger';
import { Type } from 'class-transformer';
import {
  ArrayMaxSize,
  ArrayMinSize,
  IsArray,
  IsDateString,
  IsIn,
  IsInt,
  IsObject,
  IsOptional,
  IsString,
  IsUUID,
  Max,
  MaxLength,
  Min,
  ValidateNested,
} from 'class-validator';

export const SYNC_ACTIONS = ['upsert', 'delete', 'custom'] as const;
export type SyncAction = (typeof SYNC_ACTIONS)[number];

export class SyncPullQueryDto {
  @ApiPropertyOptional({ example: '2026-01-01T00:00:00.000Z' })
  @IsOptional()
  @IsDateString()
  since?: string;

  @ApiProperty({ example: 'products,vendors,categories,orders,subOrders,deliveries' })
  @IsString()
  @MaxLength(500)
  collections: string;

  @ApiPropertyOptional() @IsOptional() @IsString() cursor?: string;

  @ApiPropertyOptional() @IsOptional() @Type(() => Number) @IsInt() @Min(1) @Max(500) limit?: number;
}

export class SyncOpDto {
  @ApiProperty() @IsUUID('4') opId: string;
  @ApiProperty() @IsString() @MaxLength(60) entity: string;
  @ApiProperty({ enum: SYNC_ACTIONS }) @IsIn([...SYNC_ACTIONS]) action: SyncAction;
  @ApiPropertyOptional({ description: "Name of a custom action, e.g. stock.adjust (clients may also put it in payload.name)" })
  @IsOptional()
  @IsString()
  @MaxLength(80)
  customAction?: string;
  @ApiPropertyOptional({ type: Object }) @IsOptional() @IsObject() payload?: Record<string, unknown>;
  @ApiProperty() @IsDateString() clientAt: string;
}

export class SyncPushDto {
  @ApiProperty({ type: [SyncOpDto] })
  @IsArray()
  @ArrayMinSize(1)
  @ArrayMaxSize(500)
  @ValidateNested({ each: true })
  @Type(() => SyncOpDto)
  ops: SyncOpDto[];
}

export interface SyncOpResult {
  opId: string;
  status: 'applied' | 'duplicate' | 'rejected';
  code?: string;
  message?: string;
  doc?: unknown;
}

export interface SyncPushResponse {
  results: SyncOpResult[];
  serverTime: string;
}

export interface SyncPullResponse {
  changes: Record<string, unknown[]>;
  tombstones: Record<string, string[]>;
  serverTime: string;
  /** Present when at least one collection has more rows; pass back as `cursor` with the same `since`. */
  nextCursor?: string;
}
