import { Logger } from '@nestjs/common';
import { JwtService } from '@nestjs/jwt';
import { InjectModel } from '@nestjs/mongoose';
import {
  ConnectedSocket,
  MessageBody,
  OnGatewayConnection,
  OnGatewayDisconnect,
  OnGatewayInit,
  SubscribeMessage,
  WebSocketGateway,
  WebSocketServer,
} from '@nestjs/websockets';
import { plainToInstance } from 'class-transformer';
import { validateSync } from 'class-validator';
import { Model, Types } from 'mongoose';
import type { Namespace, Socket } from 'socket.io';
import { notDeleted } from '../../common/schemas/base.js';
import { hasRole, type AuthUser, type JwtPayload } from '../../common/types/auth-user.js';
import { isObjectId } from '../../common/utils/ids.js';
import { Delivery } from '../deliveries/schemas/delivery.schema.js';
import { Order } from '../orders/schemas/order.schema.js';
import { SubOrder } from '../orders/schemas/sub-order.schema.js';
import { RiderLocationDto } from '../riders/dto/rider.dto.js';
import { RidersService } from '../riders/riders.service.js';
import { UsersService } from '../users/users.service.js';
import { RealtimeService } from './realtime.service.js';

interface SocketData {
  user?: AuthUser;
}

type AuthedSocket = Socket & { data: SocketData };

interface Ack {
  ok: boolean;
  room?: string;
  error?: string;
  stored?: boolean;
}

const ROOM_PATTERN = /^(user|vendor|order|delivery):([a-f\d]{24})$/i;

/**
 * Socket.IO namespace `/rt` (§7). Auth via access token in the handshake
 * (`auth.token` or `Authorization: Bearer`). Rooms: user:{id}, vendor:{id},
 * order:{id}, delivery:{id}; every subscription is authorised against ownership.
 */
@WebSocketGateway({ namespace: '/rt' })
export class RealtimeGateway implements OnGatewayInit, OnGatewayConnection, OnGatewayDisconnect {
  private readonly logger = new Logger(RealtimeGateway.name);

  @WebSocketServer()
  namespace: Namespace;

  constructor(
    private readonly jwt: JwtService,
    private readonly users: UsersService,
    private readonly riders: RidersService,
    private readonly realtime: RealtimeService,
    @InjectModel(Order.name) private readonly orders: Model<Order>,
    @InjectModel(SubOrder.name) private readonly subOrders: Model<SubOrder>,
    @InjectModel(Delivery.name) private readonly deliveries: Model<Delivery>,
  ) {}

  afterInit(namespace: Namespace): void {
    this.realtime.attach(namespace);
    this.logger.log('Realtime namespace /rt ready');
  }

  async handleConnection(client: AuthedSocket): Promise<void> {
    const token = this.extractToken(client);
    if (!token) {
      client.emit('error', { code: 'UNAUTHENTICATED', message: 'Missing access token' });
      client.disconnect(true);
      return;
    }
    try {
      const payload = this.jwt.verify<JwtPayload>(token, { algorithms: ['HS256'] });
      const user = await this.users.findById(payload.sub);
      if (!user || user.status !== 'active') throw new Error('inactive');
      const authUser: AuthUser = {
        userId: String(user._id),
        email: user.email,
        roles: user.roles,
        vendorId: user.vendorId ? String(user.vendorId) : undefined,
      };
      client.data.user = authUser;
      await client.join(`user:${authUser.userId}`);
      if (authUser.vendorId && hasRole(authUser, 'vendor_owner', 'vendor_staff')) {
        await client.join(`vendor:${authUser.vendorId}`);
      }
      client.emit('ready', { userId: authUser.userId, rooms: [...client.rooms].filter((r) => r !== client.id) });
    } catch {
      client.emit('error', { code: 'UNAUTHENTICATED', message: 'Invalid or expired access token' });
      client.disconnect(true);
    }
  }

  handleDisconnect(): void {
    // Nothing to clean up: rooms are per-socket.
  }

  @SubscribeMessage('subscribe')
  async subscribe(@ConnectedSocket() client: AuthedSocket, @MessageBody() body: { room?: string } | undefined): Promise<Ack> {
    const user = client.data.user;
    const room = body?.room;
    if (!user) return { ok: false, error: 'UNAUTHENTICATED' };
    if (!room || !ROOM_PATTERN.test(room)) return { ok: false, error: 'INVALID_ROOM' };
    if (!(await this.mayJoin(user, room))) return { ok: false, room, error: 'FORBIDDEN' };
    await client.join(room);
    return { ok: true, room };
  }

  @SubscribeMessage('unsubscribe')
  async unsubscribe(@ConnectedSocket() client: AuthedSocket, @MessageBody() body: { room?: string } | undefined): Promise<Ack> {
    const room = body?.room;
    if (!room) return { ok: false, error: 'INVALID_ROOM' };
    await client.leave(room);
    return { ok: true, room };
  }

  /** Rider position; persisted (throttled to 1 write / 3 s) and rebroadcast to the delivery room. */
  @SubscribeMessage('rider.location')
  async riderLocation(@ConnectedSocket() client: AuthedSocket, @MessageBody() body: unknown): Promise<Ack> {
    const user = client.data.user;
    if (!user || !hasRole(user, 'rider')) return { ok: false, error: 'FORBIDDEN' };
    const dto = plainToInstance(RiderLocationDto, body ?? {});
    if (validateSync(dto, { whitelist: true }).length > 0) return { ok: false, error: 'VALIDATION_ERROR' };
    try {
      const profile = await this.riders.requireByUserId(user.userId);
      const { stored } = await this.riders.ingestLocation(profile, dto);
      return { ok: true, stored };
    } catch (err) {
      return { ok: false, error: err instanceof Error ? err.message : 'ERROR' };
    }
  }

  private extractToken(client: Socket): string | null {
    const auth = client.handshake.auth as Record<string, unknown> | undefined;
    const fromAuth = auth?.['token'];
    if (typeof fromAuth === 'string' && fromAuth.length > 0) return fromAuth.replace(/^Bearer\s+/i, '');
    const header = client.handshake.headers.authorization;
    if (typeof header === 'string' && header.toLowerCase().startsWith('bearer ')) return header.slice(7);
    const q = client.handshake.query['token'];
    if (typeof q === 'string' && q.length > 0) return q;
    return null;
  }

  private async mayJoin(user: AuthUser, room: string): Promise<boolean> {
    const match = ROOM_PATTERN.exec(room);
    if (!match) return false;
    const [, kind, id] = match;
    if (!id || !isObjectId(id)) return false;
    if (hasRole(user, 'admin')) return true;
    const me = user.userId;
    const oid = new Types.ObjectId(id);

    switch (kind) {
      case 'user':
        return id === me;
      case 'vendor': {
        if (user.vendorId === id) return true;
        if (!hasRole(user, 'rider')) return false;
        const profile = await this.riders.findByUserId(me);
        return profile !== null && profile.vendorId.equals(oid);
      }
      case 'order': {
        const order = await this.orders.findOne({ _id: oid, ...notDeleted }).select('customerId').lean().exec();
        if (order && String(order.customerId) === me) return true;
        if (user.vendorId) {
          const owns = await this.subOrders.exists({
            orderId: oid,
            vendorId: new Types.ObjectId(user.vendorId),
            status: { $ne: 'awaiting_payment' },
          });
          return owns !== null;
        }
        return false;
      }
      case 'delivery': {
        const delivery = await this.deliveries
          .findOne({ _id: oid, ...notDeleted })
          .select('vendorId customerId riderUserId')
          .lean()
          .exec();
        if (!delivery) return false;
        if (String(delivery.customerId) === me) return true;
        if (user.vendorId && String(delivery.vendorId) === user.vendorId) return true;
        return delivery.riderUserId !== null && String(delivery.riderUserId) === me;
      }
      default:
        return false;
    }
  }
}
