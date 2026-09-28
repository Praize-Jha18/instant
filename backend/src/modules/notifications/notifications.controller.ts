import { Controller, Get, Param, Post, Query } from '@nestjs/common';
import { ApiBearerAuth, ApiTags } from '@nestjs/swagger';
import { Type } from 'class-transformer';
import { IsBoolean, IsOptional } from 'class-validator';
import { CurrentUser } from '../../common/decorators/current-user.decorator.js';
import { PaginationQueryDto } from '../../common/dto/pagination-query.dto.js';
import { NotificationsService } from './notifications.service.js';

class ListNotificationsQueryDto extends PaginationQueryDto {
  @IsOptional()
  @Type(() => Boolean)
  @IsBoolean()
  unread?: boolean;
}

@ApiTags('notifications')
@ApiBearerAuth()
@Controller('notifications')
export class NotificationsController {
  constructor(private readonly notifications: NotificationsService) {}

  @Get()
  list(@CurrentUser('userId') userId: string, @Query() query: ListNotificationsQueryDto) {
    return this.notifications.list(userId, query);
  }

  @Get('unread-count')
  async unreadCount(@CurrentUser('userId') userId: string) {
    return { count: await this.notifications.unreadCount(userId) };
  }

  @Post('read-all')
  readAll(@CurrentUser('userId') userId: string) {
    return this.notifications.markAllRead(userId);
  }

  @Post(':id/read')
  read(@CurrentUser('userId') userId: string, @Param('id') id: string) {
    return this.notifications.markRead(userId, id);
  }
}
