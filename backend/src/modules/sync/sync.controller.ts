import { Body, Controller, Get, HttpCode, Post, Query } from '@nestjs/common';
import { ApiBearerAuth, ApiTags } from '@nestjs/swagger';
import { CurrentUser } from '../../common/decorators/current-user.decorator.js';
import type { AuthUser } from '../../common/types/auth-user.js';
import { SyncPullQueryDto, SyncPushDto } from './dto/sync.dto.js';
import { SyncService } from './sync.service.js';

@ApiTags('sync')
@ApiBearerAuth()
@Controller('sync')
export class SyncController {
  constructor(private readonly sync: SyncService) {}

  @Get('pull')
  pull(@CurrentUser() user: AuthUser, @Query() query: SyncPullQueryDto) {
    return this.sync.pull(user, query);
  }

  @HttpCode(200)
  @Post('push')
  push(@CurrentUser() user: AuthUser, @Body() dto: SyncPushDto) {
    return this.sync.push(user, dto.ops);
  }
}
