import 'dart:async';

import 'package:core_models/core_models.dart';

import 'doc_codec.dart';
import 'local_store.dart';
import 'outbox_entry.dart';

/// In-memory [LocalStore] used on web and in tests. Documents are kept as
/// JSON (exactly like the ObjectBox store) and decoded on read, so both
/// implementations behave identically.
class MemoryStore implements LocalStore {
  MemoryStore();

  final Map<String, Map<String, _MemDoc>> _collections = {};
  final Map<String, DateTime> _cursors = {};
  final List<OutboxEntry> _outbox = [];

  final _collectionChanges = StreamController<String>.broadcast();
  final _outboxChanges = StreamController<void>.broadcast();
  bool _closed = false;

  // ---- documents -----------------------------------------------------------

  Map<String, _MemDoc> _bucket(String collection) =>
      _collections.putIfAbsent(collection, () => {});

  void _notify(String collection) {
    if (!_collectionChanges.isClosed) _collectionChanges.add(collection);
  }

  @override
  Future<void> upsert<T extends Object>(String collection, T model) async {
    _put(collection, DocCodec.encode(collection, model));
    _notify(collection);
  }

  @override
  Future<void> upsertAll<T extends Object>(String collection, Iterable<T> models) async {
    var any = false;
    for (final m in models) {
      _put(collection, DocCodec.encode(collection, m));
      any = true;
    }
    if (any) _notify(collection);
  }

  @override
  Future<void> upsertJson(String collection, Map<String, dynamic> json) =>
      upsert<Map<String, dynamic>>(collection, json);

  @override
  Future<void> upsertAllJson(String collection, Iterable<Map<String, dynamic>> docs) =>
      upsertAll<Map<String, dynamic>>(collection, docs);

  void _put(String collection, EncodedDoc doc) {
    _bucket(collection)[doc.id] = _MemDoc(doc.json, doc.updatedAt);
  }

  @override
  Future<bool> delete(String collection, String id) async {
    final removed = _bucket(collection).remove(id) != null;
    if (removed) _notify(collection);
    return removed;
  }

  @override
  Future<int> deleteAll(String collection, Iterable<String> ids) async {
    final bucket = _bucket(collection);
    var n = 0;
    for (final id in ids) {
      if (bucket.remove(id) != null) n++;
    }
    if (n > 0) _notify(collection);
    return n;
  }

  @override
  Future<T?> getById<T extends Object>(String collection, String id) async =>
      _readOne<T>(collection, id);

  @override
  Future<List<T>> getAll<T extends Object>(String collection) async => _readAll<T>(collection);

  @override
  Stream<List<T>> watchAll<T extends Object>(
    String collection, {
    bool Function(T model)? filter,
    int Function(T a, T b)? sortBy,
  }) {
    List<T> snapshot() {
      var list = _readAll<T>(collection);
      if (filter != null) list = list.where(filter).toList();
      if (sortBy != null) list.sort(sortBy);
      return list;
    }

    return _watch(collection, snapshot).distinct(listEquals);
  }

  @override
  Stream<T?> watchById<T extends Object>(String collection, String id) =>
      _watch(collection, () => _readOne<T>(collection, id)).distinct();

  // Stream.multi (not async*) so cancelling never waits for the next change.
  Stream<R> _watch<R>(String collection, R Function() snapshot) => Stream<R>.multi((controller) {
        controller.add(snapshot());
        final sub = _collectionChanges.stream
            .where((changed) => changed == collection || changed == _all)
            .listen((_) => controller.add(snapshot()), onDone: controller.close);
        controller.onCancel = sub.cancel;
      });

  @override
  Future<List<T>> query<T extends Object>(String collection, bool Function(T model) predicate) async =>
      _readAll<T>(collection).where(predicate).toList();

  @override
  Future<int> count(String collection) async => _bucket(collection).length;

  @override
  Future<void> clearCollection(String collection) async {
    _bucket(collection).clear();
    _notify(collection);
  }

  T? _readOne<T extends Object>(String collection, String id) {
    final doc = _bucket(collection)[id];
    if (doc == null) return null;
    return DocCodec.cast<T>(collection, doc.decoded(collection));
  }

  List<T> _readAll<T extends Object>(String collection) => _bucket(collection)
      .values
      .map((d) => DocCodec.cast<T>(collection, d.decoded(collection)))
      .toList();

  // ---- cursors -------------------------------------------------------------

  @override
  Future<DateTime?> getCursor(String collection) async => _cursors[collection];

  @override
  Future<void> setCursor(String collection, DateTime cursor) async {
    _cursors[collection] = cursor.toUtc();
  }

  @override
  Future<Map<String, DateTime>> allCursors() async => Map.unmodifiable(_cursors);

  @override
  Future<void> clearCursors() async => _cursors.clear();

  // ---- outbox --------------------------------------------------------------

  void _notifyOutbox() {
    if (!_outboxChanges.isClosed) _outboxChanges.add(null);
  }

  @override
  Future<void> enqueue(SyncOp op) async {
    if (_outbox.any((e) => e.opId == op.opId)) return;
    _outbox.add(OutboxEntry(op: op, enqueuedAt: DateTime.now().toUtc()));
    _notifyOutbox();
  }

  @override
  Future<List<OutboxEntry>> pending({int? limit}) async {
    final list = _outbox.where((e) => e.isPending).toList();
    return limit == null ? list : list.take(limit).toList();
  }

  @override
  Future<List<OutboxEntry>> rejected() async => _outbox.where((e) => e.isRejected).toList();

  @override
  Stream<List<OutboxEntry>> watchPending() =>
      _watchOutbox(() => _outbox.where((e) => e.isPending).toList()).distinct(listEquals);

  @override
  Future<void> markApplied(String opId) async {
    final before = _outbox.length;
    _outbox.removeWhere((e) => e.opId == opId);
    if (_outbox.length != before) _notifyOutbox();
  }

  @override
  Future<void> markRejected(String opId, {String? code, String? message}) async =>
      _update(opId, (e) => e.copyWith(
            state: OutboxState.rejected,
            attempts: e.attempts + 1,
            errorCode: code,
            errorMessage: message,
            lastAttemptAt: DateTime.now().toUtc(),
          ));

  @override
  Future<void> markAttempted(String opId) async =>
      _update(opId, (e) => e.copyWith(attempts: e.attempts + 1, lastAttemptAt: DateTime.now().toUtc()));

  @override
  Future<void> retry(String opId) async =>
      _update(opId, (e) => e.copyWith(state: OutboxState.pending, clearError: true));

  @override
  Future<void> discard(String opId) => markApplied(opId);

  void _update(String opId, OutboxEntry Function(OutboxEntry) fn) {
    final i = _outbox.indexWhere((e) => e.opId == opId);
    if (i == -1) return;
    _outbox[i] = fn(_outbox[i]);
    _notifyOutbox();
  }

  @override
  Future<int> pendingCount() async => _outbox.where((e) => e.isPending).length;

  @override
  Stream<int> watchPendingCount() =>
      _watchOutbox(() => _outbox.where((e) => e.isPending).length).distinct();

  Stream<R> _watchOutbox<R>(R Function() snapshot) => Stream<R>.multi((controller) {
        controller.add(snapshot());
        final sub = _outboxChanges.stream
            .listen((_) => controller.add(snapshot()), onDone: controller.close);
        controller.onCancel = sub.cancel;
      });

  @override
  Future<void> clearOutbox() async {
    _outbox.clear();
    _notifyOutbox();
  }

  // ---- lifecycle -----------------------------------------------------------

  @override
  Future<void> clear() async {
    _collections.clear();
    _cursors.clear();
    _outbox.clear();
    _notify(_all);
    _notifyOutbox();
  }

  @override
  Future<void> close() async {
    if (_closed) return;
    _closed = true;
    await _collectionChanges.close();
    await _outboxChanges.close();
  }

  static const String _all = '*';
}

class _MemDoc {
  _MemDoc(this.json, this.updatedAt);
  final Map<String, dynamic> json;
  final DateTime updatedAt;
  Object? _decoded;

  Object decoded(String collection) => _decoded ??= DocCodec.decode(collection, json);
}
