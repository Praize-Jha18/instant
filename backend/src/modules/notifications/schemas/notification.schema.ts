import { Prop, Schema } from '@nestjs/mongoose';
import { HydratedDocument, Schema as MongooseSchema, SchemaTypes, Types } from 'mongoose';
import { BaseDocument, buildSchema } from '../../../common/schemas/base.js';

@Schema({ collection: 'notifications' })
export class Notification extends BaseDocument {
  @Prop({ type: SchemaTypes.ObjectId, ref: 'User', required: true, index: true })
  userId: Types.ObjectId;

  @Prop({ required: true })
  type: string;

  @Prop({ required: true })
  title: string;

  @Prop({ default: '' })
  body: string;

  @Prop({ type: MongooseSchema.Types.Mixed, default: {} })
  data: Record<string, unknown>;

  @Prop({ type: Date, default: null })
  readAt: Date | null;
}

export type NotificationDocument = HydratedDocument<Notification>;
export const NotificationSchema = buildSchema(Notification);
NotificationSchema.index({ userId: 1, readAt: 1, _id: -1 });
