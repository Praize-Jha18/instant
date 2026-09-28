import 'package:api_client/api_client.dart';
import 'package:core_models/core_models.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:instant_rider/features/location/domain/location_queue.dart';
import 'package:local_db/local_db.dart';

/// Transport that is never reached (the engine is not started in these tests).
class _NoopTransport implements SyncTransport {
  @override
  Future<SyncPullResponse> pull({required List<String> collections, DateTime? since, String? cursor, int? limit}) async =>
      SyncPullResponse(serverTime: DateTime.now().toUtc());

  @override
  Future<SyncPushResponse> push(List<SyncOp> ops) async => const SyncPushResponse();
}

RiderLocation _ping(int i) => RiderLocation(
      riderId: 'rider-1',
      vendorId: 'vendor-1',
      lat: 6.5 + i / 10000,
      lng: 3.3 + i / 10000,
      at: DateTime.utc(2026, 9, 28, 12, 0, i),
    );

void main() {
  late MemoryStore store;
  late SyncEngine engine;

  setUp(() {
    store = MemoryStore();
    engine = SyncEngine(
      store: store,
      api: _NoopTransport(),
      collections: Collections.riderSync,
      connectivity: ManualConnectivityMonitor(initiallyOnline: false),
    );
  });

  tearDown(() async {
    await engine.dispose();
    await store.close();
  });

  group('LocationPingQueue.opsToDrop', () {
    test('drops nothing at or under the cap', () {
      expect(LocationPingQueue.opsToDrop(['a', 'b', 'c'], 3), isEmpty);
      expect(LocationPingQueue.opsToDrop(['a'], 3), isEmpty);
      expect(LocationPingQueue.opsToDrop([], 3), isEmpty);
    });

    test('drops the oldest entries beyond the cap', () {
      expect(LocationPingQueue.opsToDrop(['a', 'b', 'c', 'd', 'e'], 3), ['a', 'b']);
    });
  });

  group('LocationPingQueue', () {
    test('queues pings as riderLocations upsert ops in the outbox', () async {
      final queue = LocationPingQueue(engine: engine, cap: 200);
      await queue.enqueue(_ping(0));
      await queue.enqueue(_ping(1));

      final pending = await store.pending();
      expect(pending, hasLength(2));
      expect(pending.every(LocationPingQueue.isLocationOp), isTrue);
      expect(pending.first.op.payload['lat'], 6.5);
      expect(await queue.pendingCount(), 2);
    });

    test('never keeps more than the cap, discarding the oldest first', () async {
      final queue = LocationPingQueue(engine: engine, cap: 200);
      for (var i = 0; i < 250; i++) {
        await queue.enqueue(_ping(i));
      }

      final pending = await queue.pending();
      expect(pending, hasLength(200));
      // The 50 oldest (seconds 0..49) are gone; the newest 200 remain in order.
      expect(pending.first.op.payload['at'], DateTime.utc(2026, 9, 28, 12, 0, 50).toIso8601String());
      expect(pending.last.op.payload['at'], DateTime.utc(2026, 9, 28, 12, 4, 9).toIso8601String());
      expect(await store.pendingCount(), 200);
    });

    test('capping leaves non-location ops untouched', () async {
      // An unrelated queued op (e.g. going online) must survive trimming.
      await engine.enqueueUpsert(
        Collections.riderProfiles,
        const RiderProfile(id: 'p1', userId: 'u1', vendorId: 'v1', isOnline: true),
      );
      final queue = LocationPingQueue(engine: engine, cap: 5);
      for (var i = 0; i < 12; i++) {
        await queue.enqueue(_ping(i));
      }

      final all = await store.pending();
      expect(all.where((e) => e.op.entity == Collections.riderProfiles), hasLength(1));
      expect(all.where(LocationPingQueue.isLocationOp), hasLength(5));
    });

    test('trim is idempotent and reports how many were dropped', () async {
      final queue = LocationPingQueue(engine: engine, cap: 3);
      for (var i = 0; i < 3; i++) {
        await engine.enqueueUpsert(Collections.riderLocations, _ping(i));
      }
      await engine.enqueueUpsert(Collections.riderLocations, _ping(3));
      await engine.enqueueUpsert(Collections.riderLocations, _ping(4));

      expect(await queue.trim(), 2);
      expect(await queue.trim(), 0);
      expect(await queue.pendingCount(), 3);
    });
  });
}
