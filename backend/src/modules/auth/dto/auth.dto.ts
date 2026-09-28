import { ApiProperty, ApiPropertyOptional } from '@nestjs/swagger';
import {
  IsEmail,
  IsIn,
  IsMongoId,
  IsOptional,
  IsString,
  MaxLength,
  MinLength,
} from 'class-validator';

export const REGISTER_ROLES = ['customer', 'rider', 'vendor_owner'] as const;
export type RegisterRole = (typeof REGISTER_ROLES)[number];

export class RegisterDto {
  @ApiProperty()
  @IsEmail()
  email: string;

  @ApiProperty({ minLength: 8 })
  @IsString()
  @MinLength(8)
  @MaxLength(128)
  password: string;

  @ApiProperty()
  @IsString()
  @MinLength(2)
  @MaxLength(120)
  fullName: string;

  @ApiPropertyOptional()
  @IsOptional()
  @IsString()
  @MaxLength(32)
  phone?: string;

  @ApiProperty({ enum: REGISTER_ROLES })
  @IsIn([...REGISTER_ROLES])
  role: RegisterRole;

  /** Required when role = rider. */
  @ApiPropertyOptional()
  @IsOptional()
  @IsMongoId()
  vendorId?: string;

  /** Optional store name when role = vendor_owner (defaults to "<fullName>'s Store"). */
  @ApiPropertyOptional()
  @IsOptional()
  @IsString()
  @MinLength(2)
  @MaxLength(120)
  vendorName?: string;

  @ApiPropertyOptional()
  @IsOptional()
  @IsString()
  @MaxLength(128)
  deviceId?: string;
}

export class LoginDto {
  @ApiProperty()
  @IsEmail()
  email: string;

  @ApiProperty()
  @IsString()
  @MinLength(1)
  @MaxLength(128)
  password: string;

  @ApiPropertyOptional()
  @IsOptional()
  @IsString()
  @MaxLength(128)
  deviceId?: string;
}

export class RefreshDto {
  @ApiProperty()
  @IsString()
  @MinLength(16)
  refreshToken: string;
}

export class LogoutDto extends RefreshDto {}
