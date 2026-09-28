import 'dart:io';

import 'package:core_models/core_models.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:local_db/local_db.dart';

/// These run only when the ObjectBox native library is available to the
/// test host (`bash <(curl -s https://raw.githubusercontent.com/objectbox/objectbox-dart/main/install.sh)`).
/// Apps get the library from objectbox_flutter_libs automatically.
void main() {
  ObjectBoxStore? store;
  String? skipReason;

  setUpAll(() async {
    try {
      store = await ObjectBoxStore.open(
          directory: 'memory:local-db-test-${DateTime.now().microsecondsSinceEpoch}');
    } catch (e) {
      skipReason = 'ObjectBox native library not available on this host: '
          '${e.toString().split('\n').first}';
      stderr.writeln('Skipping ObjectBox tests: $skipReason');
    }
  });

  tearDownAll(() => store?.close());

  test('documents, cursors and outbox round trip through ObjectBox', () async {
    if (store == null) {
      markTestSkipped(skipReason!);
      return;
    }
    final s = store!;
    await s.clear();
    await s.upsertJson(Collections.products, {'_id': 'p1', 'vendorId': 'v', 'name': 'A', 'slug': 'a'});
    await s.upsert(Collections.products, const Product(id: 'p2', vendorId: 'v', name: 'B', slug: 'b'));
    // Replace by unique key.
    await s.upsert(Collections.products, const Product(id: 'p2', vendorId: 'v', name: 'B2', slug: 'b'));
    expect(await s.count(Collections.products), 2);
    expect((await s.getById<Product>(Collections.products, 'p2'))?.name, 'B2');

    final first = await s.watchAll<Product>(Collections.products).first;
    expect(first.length, 2);
    expect(await s.delete(Collections.products, 'p1'), isTrue);
    expect(await s.count(Collections.products), 1);

    await s.setCursor(Collections.products, DateTime.utc(2026, 3));
    expect(await s.getCursor(Collections.products), DateTime.utc(2026, 3));

    final op = SyncOp(
        opId: 'op1', entity: Collections.carts, action: SyncOpAction.upsert, payload: {'id': 'u'}, clientAt: DateTime.utc(2026));
    await s.enqueue(op);
    await s.enqueue(op);
    expect(await s.pendingCount(), 1);
    expect((await s.pending()).single.op, op);
    await s.markRejected('op1', code: 'X');
    expect(await s.pendingCount(), 0);
    expect((await s.rejected()).single.errorCode, 'X');
    await s.retry('op1');
    await s.markApplied('op1');
    expect(await s.pendingCount(), 0);
  });
}
