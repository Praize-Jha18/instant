import { Injectable } from '@nestjs/common';
import { InjectModel } from '@nestjs/mongoose';
import { Model, QueryFilter, Types } from 'mongoose';
import { AppError } from '../../common/errors/app-error.js';
import { clampLimit, idCursorFilter, idPage, type Page } from '../../common/pagination/cursor.js';
import { notDeleted } from '../../common/schemas/base.js';
import { oid } from '../../common/utils/ids.js';
import { RealtimeService } from '../realtime/realtime.service.js';
import { Notification, type NotificationDocument } from './schemas/notification.schema.js';

export interface NotifyInput {
  type: string;
  title: string;
  body?: string;
  data?: Record<string, unknown>;
}

@Injectable()
export class NotificationsService {
  constructor(
    @InjectModel(Notification.name) private readonly notifications: Model<Notification>,
    private readonly realtime: RealtimeService,
  ) {}

  async notify(userId: Types.ObjectId | string, input: NotifyInput): Promise<NotificationDocument> {
    const doc = await this.notifications.create({
      userId: new Types.ObjectId(String(userId)),
      type: input.type,
      title: input.title,
      body: input.body ?? '',
      data: input.data ?? {},
      readAt: null,
    });
    this.realtime.emitChanged('notifications', doc);
    return doc;
  }

  async notifyMany(userIds: Array<Types.ObjectId | string>, input: NotifyInput): Promise<void> {
    const unique = [...new Set(userIds.map(String))];
    await Promise.all(unique.map((id) => this.notify(id, input)));
  }

  async list(
    userId: string,
    query: { cursor?: string; limit?: number; unread?: boolean },
  ): Promise<Page<NotificationDocument>> {
    const limit = clampLimit(query.limit);
    const filter: QueryFilter<Notification> = {
      userId: oid(userId, 'userId'),
      ...notDeleted,
      ...idCursorFilter(query.cursor),
    };
    if (query.unread) filter.readAt = null;
    const docs = await this.notifications.find(filter).sort({ _id: -1 }).limit(limit + 1).exec();
    return idPage(docs, limit);
  }

  async markRead(userId: string, id: string): Promise<NotificationDocument> {
    const doc = await this.notifications
      .findOneAndUpdate(
        { _id: oid(id), userId: oid(userId, 'userId'), ...notDeleted },
        { $set: { readAt: new Date() } },
        { new: true },
      )
      .exec();
    if (!doc) throw AppError.notFound('NOTIFICATION_NOT_FOUND', 'Notification not found');
    this.realtime.emitChanged('notifications', doc);
    return doc;
  }

  async markAllRead(userId: string): Promise<{ updated: number }> {
    const res = await this.notifications
      .updateMany({ userId: oid(userId, 'userId'), readAt: null, ...notDeleted }, { $set: { readAt: new Date() } })
      .exec();
    return { updated: res.modifiedCount };
  }

  async unreadCount(userId: string): Promise<number> {
    return this.notifications.countDocuments({ userId: oid(userId, 'userId'), readAt: null, ...notDeleted }).exec();
  }
}
