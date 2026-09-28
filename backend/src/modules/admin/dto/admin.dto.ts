import { IsIn, IsOptional, IsString, MaxLength } from 'class-validator';
import { PaginationQueryDto } from '../../../common/dto/pagination-query.dto.js';
import { ROLES, type Role } from '../../../common/types/auth-user.js';
import { USER_STATUSES, type UserStatus } from '../../users/schemas/user.schema.js';

export class AdminUsersQueryDto extends PaginationQueryDto {
  @IsOptional() @IsString() @MaxLength(100) q?: string;
  @IsOptional() @IsIn([...ROLES]) role?: Role;
  @IsOptional() @IsIn([...USER_STATUSES]) status?: UserStatus;
}

export class SetUserStatusDto {
  @IsIn([...USER_STATUSES]) status: UserStatus;
}
