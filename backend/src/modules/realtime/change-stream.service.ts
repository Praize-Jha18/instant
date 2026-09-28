import { Injectable, Logger, OnApplicationBootstrap, OnModuleDestroy } from '@nestjs/common';
import { InjectConnection } from '@nestjs/mongoose';
import type { Connection, mongo } from 'mongoose';
import { RealtimeService, type RealtimeCollection } from './realtime.service.js';

const WATCHED: ReadonlyArray<{ collection: RealtimeCollection; model: string }> = [
  { collection: 'orders', model: 'Order' },
  { collection: 'subOrders', model: 'SubOrder' },
  { collection: 'deliveries', model: 'Delivery' },
  { collection: 'products', model: 'Product' },
  { collection: 'riderProfiles', model: 'RiderProfile' },
  { collection: 'notifications', model: 'Notification' },
];

/**
 * Fans MongoDB change streams out to socket rooms (§7). Change streams need a
 * replica set; without one we log a clear warning and services keep emitting
 * directly through RealtimeService.
 */
@Injectable()
export class ChangeStreamService implements OnApplicationBootstrap, OnModuleDestroy {
  private readonly logger = new Logger(ChangeStreamService.name);
  private readonly streams: mongo.ChangeStream[] = [];
  private degraded = false;

  constructor(
    @InjectConnection() private readonly connection: Connection,
    private readonly realtime: RealtimeService,
  ) {}

  async onApplicationBootstrap(): Promise<void> {
    if (!(await this.isReplicaSet())) {
      this.logger.warn(
        'MongoDB is not a replica set: change streams disabled; realtime events are emitted directly from services. ' +
          'Use Atlas or run mongod with --replSet to enable change streams.',
      );
      return;
    }
    for (const { collection, model } of WATCHED) {
      try {
        const stream = this.connection.model(model).watch([], { fullDocument: 'updateLookup' });
        stream.on('change', (change: mongo.ChangeStreamDocument<mongo.Document>) => this.onChange(collection, model, change));
        stream.on('error', (err: Error) => this.fallback(`change stream on ${collection} failed: ${err.message}`));
        this.streams.push(stream);
      } catch (err) {
        this.fallback(`could not open change stream on ${collection}: ${err instanceof Error ? err.message : String(err)}`);
        return;
      }
    }
    this.realtime.changeStreamsActive = true;
    this.logger.log(`Watching change streams: ${WATCHED.map((w) => w.collection).join(', ')}`);
  }

  async onModuleDestroy(): Promise<void> {
    await this.closeAll();
  }

  private onChange(collection: RealtimeCollection, model: string, change: mongo.ChangeStreamDocument<mongo.Document>): void {
    try {
      if (change.operationType === 'insert' || change.operationType === 'update' || change.operationType === 'replace') {
        const full = change.fullDocument;
        if (!full) return;
        const doc = this.connection.model(model).hydrate(full);
        this.realtime.emitChangedForce(collection, doc);
      }
      // Hard deletes never happen (soft delete only); tombstones arrive as updates with deletedAt set.
    } catch (err) {
      this.logger.error(`Failed to fan out ${collection} change: ${err instanceof Error ? err.message : String(err)}`);
    }
  }

  private async isReplicaSet(): Promise<boolean> {
    try {
      const db = this.connection.db;
      if (!db) return false;
      const hello = (await db.admin().command({ hello: 1 })) as { setName?: string; msg?: string };
      return typeof hello.setName === 'string' || hello.msg === 'isdbgrid';
    } catch (err) {
      this.logger.warn(`Could not determine replica set status: ${err instanceof Error ? err.message : String(err)}`);
      return false;
    }
  }

  private fallback(reason: string): void {
    if (this.degraded) return;
    this.degraded = true;
    this.realtime.changeStreamsActive = false;
    this.logger.warn(`Falling back to direct realtime emission: ${reason}`);
    void this.closeAll();
  }

  private async closeAll(): Promise<void> {
    const open = this.streams.splice(0, this.streams.length);
    await Promise.all(
      open.map(async (s) => {
        try {
          await s.close();
        } catch {
          /* ignore */
        }
      }),
    );
  }
}
