import 'package:api_client/api_client.dart';
import 'package:core_models/core_models.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:local_db/local_db.dart';

import 'fake_sync_api.dart';

Map<String, dynamic> _productJson(String id, {String name = 'P'}) => {
      '_id': id,
      'vendorId': 'v1',
      'name': name,
      'slug': id,
      'updatedAt': '2026-01-01T00:00:00.000Z',
    };

Address _address(String id, {String line1 = 'x'}) => Address(
    id: id, userId: 'u1', line1: line1, city: 'Lagos', state: 'LA', lat: 1, lng: 2);

void main() {
  late MemoryStore store;
  late FakeSyncApi api;
  late ManualConnectivityMonitor connectivity;
  late SyncEngine engine;

  setUp(() {
    store = MemoryStore();
    api = FakeSyncApi();
    connectivity = ManualConnectivityMonitor();
    engine = SyncEngine(
      store: store,
      api: api,
      connectivity: connectivity,
      collections: const [Collections.products, Collections.addresses],
      debounce: const Duration(milliseconds: 10),
    );
  });

  tearDown(() async {
    await engine.dispose();
    await connectivity.dispose();
    await store.close();
  });

  group('pull', () {
    test('applies changes and tombstones and stores serverTime as cursor', () async {
      await store.upsertJson(Collections.products, _productJson('old'));
      final t1 = DateTime.utc(2026, 1, 2);
      api.pullPages.add(SyncPullResponse(
        changes: {
          Collections.products: [_productJson('p1'), _productJson('p2')],
        },
        tombstones: {
          Collections.products: ['old', 'missing'],
        },
        serverTime: t1,
      ));

      final result = await engine.pull();
      expect(result.applied, 2);
      expect(result.removed, 1);
      expect(await store.getById<Product>(Collections.products, 'old'), isNull);
      expect((await store.getAll<Product>(Collections.products)).map((p) => p.id), containsAll(['p1', 'p2']));
      expect(await store.getCursor(Collections.products), t1);
      expect(await store.getCursor(Collections.addresses), t1);
      expect(api.pullCalls.single.since, isNull, reason: 'first sync has no cursor');
      expect(api.pullCalls.single.collections, [Collections.products, Collections.addresses]);
      expect(engine.currentStatus.lastSyncedAt, t1);
      expect(engine.currentStatus.phase, SyncPhase.idle);

      // Next pull uses the cursor.
      api.pullPages.add(SyncPullResponse(serverTime: DateTime.utc(2026, 1, 3)));
      await engine.pull();
      expect(api.pullCalls.last.since, t1);
    });

    test('follows nextCursor pages inside one pull', () async {
      api.pullPages.addAll([
        SyncPullResponse(
          changes: {Collections.products: [_productJson('p1')]},
          serverTime: DateTime.utc(2026, 1, 2),
          nextCursor: 'page2',
        ),
        SyncPullResponse(
          changes: {Collections.products: [_productJson('p2')]},
          serverTime: DateTime.utc(2026, 1, 2),
        ),
      ]);
      final result = await engine.pull(only: const [Collections.products]);
      expect(result.applied, 2);
      expect(api.pullCalls.map((c) => c.cursor), [null, 'page2']);
    });

    test('does not overwrite documents with a pending outbox op', () async {
      await engine.enqueueUpsert(Collections.addresses, _address('a1', line1: 'local edit'));
      api.pullPages.add(SyncPullResponse(
        changes: {
          Collections.addresses: [_address('a1', line1: 'server').toJson(), _address('a2').toJson()],
        },
        serverTime: DateTime.utc(2026, 1, 2),
      ));
      final result = await engine.pull();
      expect(result.skipped, 1);
      expect(result.applied, 1);
      expect((await store.getById<Address>(Collections.addresses, 'a1'))?.line1, 'local edit');
    });

    test('offline error → offline status, cursor untouched', () async {
      api.failWith = const ApiException.offline();
      await expectLater(engine.pull(), throwsA(isA<OfflineException>()));
      expect(engine.currentStatus.phase, SyncPhase.offline);
      expect(await store.getCursor(Collections.products), isNull);
    });
  });

  group('push', () {
    test('removes applied ops, keeps rejected ones, applies returned docs', () async {
      final ok = await engine.enqueueUpsert(Collections.addresses, _address('a1'));
      final bad = await engine.enqueueUpsert(Collections.addresses, _address('a2'));
      await engine.enqueueDelete(Collections.addresses, 'a3');
      api.rejectWithCode[bad.opId] = 'VALIDATION_ERROR';

      final result = await engine.pushOutbox();
      expect(result.applied, 2);
      expect(result.rejected, 1);
      expect(result.remaining, 0);
      expect(api.pushCalls.single.map((o) => o.opId), [ok.opId, bad.opId, isA<String>()]);

      expect(await store.pendingCount(), 0);
      final rejected = await store.rejected();
      expect(rejected.single.opId, bad.opId);
      expect(rejected.single.errorCode, 'VALIDATION_ERROR');
      expect(engine.currentStatus.rejectedCount, 1);
      // Server-authoritative doc from the push response landed in the store.
      expect((await store.getById<Address>(Collections.addresses, 'a1'))?.version, 2);
    });

    test('replay is idempotent: duplicates are settled like applied', () async {
      final op = await engine.enqueueUpsert(Collections.addresses, _address('a1'));
      await engine.pushOutbox();
      expect(await store.pendingCount(), 0);
      // Simulate the client not having received the first response.
      await store.enqueue(op);
      final result = await engine.pushOutbox();
      expect(result.duplicate, 1);
      expect(await store.pendingCount(), 0);
      expect(api.pushCalls.length, 2);
    });

    test('transport failure keeps ops pending and reports offline', () async {
      await engine.enqueueUpsert(Collections.addresses, _address('a1'));
      api.failWith = const ApiException.offline();
      final result = await engine.pushOutbox();
      expect(result.remaining, 1);
      expect(engine.currentStatus.phase, SyncPhase.offline);
      expect((await store.pending()).single.attempts, 1);

      api.failWith = null;
      final again = await engine.pushOutbox();
      expect(again.applied, 1);
      expect(engine.currentStatus.phase, SyncPhase.idle);
    });

    test('batches in order', () async {
      final small = SyncEngine(
        store: store,
        api: api,
        connectivity: connectivity,
        collections: const [],
        pushBatchSize: 2,
      );
      final ids = <String>[];
      for (var i = 0; i < 5; i++) {
        ids.add((await small.enqueueUpsert(Collections.addresses, _address('a$i'))).opId);
      }
      await small.pushOutbox();
      expect(api.pushCalls.map((b) => b.length), [2, 2, 1]);
      expect(api.pushCalls.expand((b) => b).map((o) => o.opId), ids);
      await small.dispose();
    });

    test('retryRejected re-queues and discardRejected drops', () async {
      final bad = await engine.enqueueUpsert(Collections.addresses, _address('a1'));
      api.rejectWithCode[bad.opId] = 'NOPE';
      await engine.pushOutbox();
      expect((await store.rejected()).length, 1);
      api.rejectWithCode.clear();
      await engine.retryRejected(bad.opId);
      await engine.pushOutbox();
      expect(await store.rejected(), isEmpty);
      expect(await store.pendingCount(), 0);
    });
  });

  group('start / triggers', () {
    test('start syncs once, then new ops and reconnects trigger a debounced sync', () async {
      final statuses = <SyncPhase>[];
      engine.status.listen((s) => statuses.add(s.phase));
      await engine.start();
      await Future<void>.delayed(const Duration(milliseconds: 30));
      expect(api.pullCalls.length, 1);
      expect(engine.currentStatus.phase, SyncPhase.idle);

      // Enqueue two ops quickly → one push.
      await engine.enqueueUpsert(Collections.addresses, _address('a1'));
      await engine.enqueueUpsert(Collections.addresses, _address('a2'));
      await Future<void>.delayed(const Duration(milliseconds: 60));
      expect(api.pushCalls.length, 1);
      expect(api.pushCalls.single.length, 2);
      expect(api.pullCalls.length, 2);

      // Going offline then online triggers a pull.
      connectivity.online = false;
      await pumpEventQueue();
      expect(engine.currentStatus.phase, SyncPhase.offline);
      connectivity.online = true;
      await Future<void>.delayed(const Duration(milliseconds: 60));
      expect(api.pullCalls.length, 3);
      expect(engine.currentStatus.phase, SyncPhase.idle);
      expect(statuses, contains(SyncPhase.syncing));
    });

    test('sync is single-flight and re-runs when triggered mid-flight', () async {
      var pulls = 0;
      api.onPull = (c, s, cur) {
        pulls++;
        return SyncPullResponse(serverTime: DateTime.utc(2026, 1, pulls));
      };
      final f1 = engine.sync();
      final f2 = engine.sync();
      expect(identical(f1, f2), isTrue);
      await f1;
      // A trigger during the run queues exactly one more pass.
      expect(pulls, 2);
    });

    test('realtime events are applied into the store', () async {
      await engine.applyChanged(ChangedEvent(
        collection: Collections.products,
        id: 'p9',
        doc: _productJson('p9', name: 'Live'),
      ));
      expect((await store.getById<Product>(Collections.products, 'p9'))?.name, 'Live');
      await engine.applyRemoved(RemovedEvent(collection: Collections.products, id: 'p9'));
      expect(await store.getById<Product>(Collections.products, 'p9'), isNull);
    });
  });
}
