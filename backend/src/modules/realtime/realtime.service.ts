import { Injectable, Logger } from '@nestjs/common';
import type { Namespace } from 'socket.io';

export type RealtimeCollection =
  | 'orders'
  | 'subOrders'
  | 'deliveries'
  | 'products'
  | 'riderProfiles'
  | 'notifications'
  | 'vendors'
  | 'payouts'
  | 'vendorLedger'
  | 'carts'
  | 'addresses';

export interface ChangedEvent {
  collection: RealtimeCollection;
  id: string;
  doc: Record<string, unknown>;
}

export interface RemovedEvent {
  collection: RealtimeCollection;
  id: string;
}

export interface RiderLocationEvent {
  deliveryId: string | null;
  riderId: string;
  lat: number;
  lng: number;
  heading: number | null;
  at: string;
}

type Serializable = Record<string, unknown> | { toJSON(): unknown };

export function toPlain(doc: Serializable): Record<string, unknown> {
  if (typeof (doc as { toJSON?: unknown }).toJSON === 'function') {
    return (doc as { toJSON(): Record<string, unknown> }).toJSON();
  }
  return doc as Record<string, unknown>;
}

function str(value: unknown): string | null {
  if (value === null || value === undefined) return null;
  if (typeof value === 'string') return value;
  if (typeof value === 'number' || typeof value === 'boolean') return String(value);
  if (typeof value === 'object' && 'toHexString' in value && typeof (value as { toHexString: unknown }).toHexString === 'function') {
    return (value as { toHexString(): string }).toHexString();
  }
  return null;
}

/**
 * Resolves which rooms a document change is fanned out to (§7).
 */
export function roomsFor(collection: RealtimeCollection, doc: Record<string, unknown>): string[] {
  const id = str(doc['id'] ?? doc['_id']);
  const rooms = new Set<string>();
  const user = (v: unknown) => {
    const s = str(v);
    if (s) rooms.add(`user:${s}`);
  };
  const vendor = (v: unknown) => {
    const s = str(v);
    if (s) rooms.add(`vendor:${s}`);
  };
  switch (collection) {
    case 'orders':
      user(doc['customerId']);
      if (id) rooms.add(`order:${id}`);
      break;
    case 'subOrders':
      user(doc['customerId']);
      if (doc['orderId']) rooms.add(`order:${str(doc['orderId'])}`);
      if (doc['status'] !== 'awaiting_payment') vendor(doc['vendorId']);
      break;
    case 'deliveries':
      vendor(doc['vendorId']);
      if (id) rooms.add(`delivery:${id}`);
      if (doc['orderId']) rooms.add(`order:${str(doc['orderId'])}`);
      user(doc['riderUserId']);
      user(doc['customerId']);
      break;
    case 'products':
    case 'payouts':
    case 'vendorLedger':
      vendor(doc['vendorId']);
      break;
    case 'riderProfiles':
      vendor(doc['vendorId']);
      user(doc['userId']);
      break;
    case 'notifications':
    case 'carts':
    case 'addresses':
      user(doc['userId']);
      break;
    case 'vendors':
      if (id) rooms.add(`vendor:${id}`);
      user(doc['ownerUserId']);
      break;
  }
  return [...rooms];
}

/**
 * Single emission point for realtime events. Services call `emitChanged`
 * after every write; when MongoDB change streams are active the direct
 * emission is suppressed so clients receive each change once.
 */
@Injectable()
export class RealtimeService {
  private readonly logger = new Logger(RealtimeService.name);
  private namespace: Namespace | null = null;
  changeStreamsActive = false;

  attach(namespace: Namespace): void {
    this.namespace = namespace;
  }

  get isAttached(): boolean {
    return this.namespace !== null;
  }

  emitChanged(collection: RealtimeCollection, doc: Serializable, extraRooms: string[] = []): void {
    if (this.changeStreamsActive) return;
    this.emitChangedForce(collection, doc, extraRooms);
  }

  emitRemoved(collection: RealtimeCollection, doc: Serializable, extraRooms: string[] = []): void {
    if (this.changeStreamsActive) return;
    this.emitRemovedForce(collection, doc, extraRooms);
  }

  /** Used by the change-stream fan-out; bypasses the suppression flag. */
  emitChangedForce(collection: RealtimeCollection, doc: Serializable, extraRooms: string[] = []): void {
    const plain = toPlain(doc);
    const id = str(plain['id'] ?? plain['_id']);
    if (!id) return;
    if (plain['deletedAt']) {
      this.emitRemovedForce(collection, plain, extraRooms);
      return;
    }
    const payload: ChangedEvent = { collection, id, doc: plain };
    this.emitToRooms([...roomsFor(collection, plain), ...extraRooms], 'changed', payload);
  }

  emitRemovedForce(collection: RealtimeCollection, doc: Serializable, extraRooms: string[] = []): void {
    const plain = toPlain(doc);
    const id = str(plain['id'] ?? plain['_id']);
    if (!id) return;
    const payload: RemovedEvent = { collection, id };
    this.emitToRooms([...roomsFor(collection, plain), ...extraRooms], 'removed', payload);
  }

  emitRiderLocation(rooms: string[], event: RiderLocationEvent): void {
    this.emitToRooms(rooms, 'rider.location', event);
  }

  emitToRooms(rooms: string[], event: string, payload: unknown): void {
    if (!this.namespace) {
      this.logger.verbose(`No socket namespace attached; dropping ${event}`);
      return;
    }
    const unique = [...new Set(rooms)];
    if (unique.length === 0) return;
    this.namespace.to(unique).emit(event, payload);
  }
}
