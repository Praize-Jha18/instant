import 'package:core_models/core_models.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:local_db/local_db.dart';

Product _product(String id, {String name = 'P', int stock = 1}) => Product(
      id: id,
      vendorId: 'v1',
      name: name,
      slug: id,
      stock: stock,
      status: ProductStatus.active,
      updatedAt: DateTime.utc(2026, 1, 1),
    );

void main() {
  late MemoryStore store;

  setUp(() => store = MemoryStore());
  tearDown(() => store.close());

  group('documents', () {
    test('upsert / getById / getAll / delete round trip typed models', () async {
      await store.upsert(Collections.products, _product('p1'));
      await store.upsertAll(Collections.products, [_product('p2'), _product('p3')]);
      expect(await store.count(Collections.products), 3);
      final p = await store.getById<Product>(Collections.products, 'p2');
      expect(p, _product('p2'));
      expect((await store.getAll<Product>(Collections.products)).length, 3);
      expect(await store.delete(Collections.products, 'p2'), isTrue);
      expect(await store.delete(Collections.products, 'p2'), isFalse);
      expect(await store.getById<Product>(Collections.products, 'p2'), isNull);
      expect(await store.deleteAll(Collections.products, ['p1', 'p3', 'nope']), 2);
    });

    test('raw JSON with _id is normalised and decoded through the registry', () async {
      await store.upsertJson(Collections.categories, {'_id': 'c1', 'name': 'A', 'slug': 'a'});
      final c = await store.getById<Category>(Collections.categories, 'c1');
      expect(c?.id, 'c1');
      // Unregistered collections round-trip as maps.
      await store.upsertJson('favourites', {'id': 'f1', 'productId': 'p1'});
      final f = await store.getById<Map<String, dynamic>>('favourites', 'f1');
      expect(f?['productId'], 'p1');
    });

    test('query and watchAll with filter/sort', () async {
      await store.upsertAll(Collections.products, [
        _product('a', name: 'Zed', stock: 0),
        _product('b', name: 'Alpha', stock: 5),
      ]);
      final inStock = await store.query<Product>(Collections.products, (p) => p.inStock);
      expect(inStock.map((p) => p.id), ['b']);

      final emissions = <List<String>>[];
      final sub = store
          .watchAll<Product>(Collections.products, sortBy: (a, b) => a.name.compareTo(b.name))
          .listen((list) => emissions.add(list.map((p) => p.name).toList()));
      await pumpEventQueue();
      expect(emissions, [
        ['Alpha', 'Zed']
      ]);
      await store.upsert(Collections.products, _product('c', name: 'Mid'));
      await pumpEventQueue();
      expect(emissions.last, ['Alpha', 'Mid', 'Zed']);
      // Unrelated collection does not emit.
      await store.upsert(Collections.categories, const Category(id: 'x', name: 'x', slug: 'x'));
      await pumpEventQueue();
      expect(emissions.length, 2);
      // Identical write is suppressed.
      await store.upsert(Collections.products, _product('c', name: 'Mid'));
      await pumpEventQueue();
      expect(emissions.length, 2);
      await sub.cancel();
    });

    test('watchById emits null → model → null', () async {
      final seen = <String?>[];
      final sub = store
          .watchById<Product>(Collections.products, 'p1')
          .listen((p) => seen.add(p?.name));
      await pumpEventQueue();
      await store.upsert(Collections.products, _product('p1', name: 'One'));
      await pumpEventQueue();
      await store.delete(Collections.products, 'p1');
      await pumpEventQueue();
      expect(seen, [null, 'One', null]);
      await sub.cancel();
    });

    test('clear wipes docs, cursors and outbox', () async {
      await store.upsert(Collections.products, _product('p1'));
      await store.setCursor(Collections.products, DateTime.utc(2026));
      await store.enqueue(SyncOp(
          opId: 'o1', entity: 'carts', action: SyncOpAction.upsert, clientAt: DateTime.utc(2026)));
      await store.clear();
      expect(await store.count(Collections.products), 0);
      expect(await store.getCursor(Collections.products), isNull);
      expect(await store.pendingCount(), 0);
    });
  });

  group('outbox', () {
    SyncOp op(String id) => SyncOp(
        opId: id, entity: Collections.addresses, action: SyncOpAction.upsert, payload: {'id': id}, clientAt: DateTime.utc(2026));

    test('keeps insertion order, dedupes, and tracks states', () async {
      await store.enqueue(op('a'));
      await store.enqueue(op('b'));
      await store.enqueue(op('a'));
      expect((await store.pending()).map((e) => e.opId), ['a', 'b']);
      expect(await store.pendingCount(), 2);

      await store.markRejected('a', code: 'STALE');
      expect((await store.pending()).map((e) => e.opId), ['b']);
      final rejected = await store.rejected();
      expect(rejected.single.errorCode, 'STALE');
      expect(rejected.single.attempts, 1);

      await store.retry('a');
      expect((await store.pending()).map((e) => e.opId), ['a', 'b']);
      await store.markApplied('b');
      await store.discard('a');
      expect(await store.pendingCount(), 0);
    });

    test('watchPendingCount emits current then changes', () async {
      final counts = <int>[];
      final sub = store.watchPendingCount().listen(counts.add);
      await pumpEventQueue();
      await store.enqueue(op('a'));
      await pumpEventQueue();
      await store.markApplied('a');
      await pumpEventQueue();
      expect(counts, [0, 1, 0]);
      await sub.cancel();
    });
  });

  test('cursors', () async {
    expect(await store.getCursor('x'), isNull);
    await store.setCursor('x', DateTime.utc(2026, 2));
    expect(await store.getCursor('x'), DateTime.utc(2026, 2));
    expect(await store.allCursors(), {'x': DateTime.utc(2026, 2)});
    await store.clearCursors();
    expect(await store.allCursors(), isEmpty);
  });
}
