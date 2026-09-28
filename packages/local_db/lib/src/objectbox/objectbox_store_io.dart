import 'dart:async';
import 'dart:convert';

import 'package:core_models/core_models.dart' hide Order;
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

import '../../objectbox.g.dart';
import '../doc_codec.dart';
import '../local_store.dart';
import '../outbox_entry.dart';
import 'entities.dart';

/// ObjectBox-backed [LocalStore] for Android, iOS and macOS.
///
/// Documents live in a single generic [Doc] box keyed by `collection/docId`;
/// see `entities.dart`. Use [LocalStore.open] rather than constructing this
/// directly so web falls back to `MemoryStore`.
class ObjectBoxStore implements LocalStore {
  ObjectBoxStore._(this.store)
      : _docs = store.box<Doc>(),
        _outbox = store.box<OutboxEntryEntity>(),
        _cursors = store.box<SyncCursorEntity>();

  /// Opens (or creates) the database. [directory] defaults to
  /// `<app documents>/<name>`; pass `memory:<id>` for an in-memory database.
  static Future<ObjectBoxStore> open({String? directory, String name = 'instant'}) async {
    final String dir;
    if (directory != null) {
      dir = directory;
    } else {
      final docs = await getApplicationDocumentsDirectory();
      dir = p.join(docs.path, name);
    }
    final store = Store.isOpen(dir)
        ? Store.attach(getObjectBoxModel(), dir)
        : await openStore(directory: dir);
    return ObjectBoxStore._(store);
  }

  /// Wraps an already opened [Store] (tests, isolates).
  factory ObjectBoxStore.fromStore(Store store) => ObjectBoxStore._(store);

  /// The underlying ObjectBox store.
  final Store store;
  final Box<Doc> _docs;
  final Box<OutboxEntryEntity> _outbox;
  final Box<SyncCursorEntity> _cursors;

  // ---- documents -----------------------------------------------------------

  @override
  Future<void> upsert<T extends Object>(String collection, T model) async {
    _docs.put(_toDoc(collection, DocCodec.encode(collection, model)));
  }

  @override
  Future<void> upsertAll<T extends Object>(String collection, Iterable<T> models) async {
    final docs = [for (final m in models) _toDoc(collection, DocCodec.encode(collection, m))];
    if (docs.isNotEmpty) _docs.putMany(docs);
  }

  @override
  Future<void> upsertJson(String collection, Map<String, dynamic> json) =>
      upsert<Map<String, dynamic>>(collection, json);

  @override
  Future<void> upsertAllJson(String collection, Iterable<Map<String, dynamic>> docs) =>
      upsertAll<Map<String, dynamic>>(collection, docs);

  Doc _toDoc(String collection, EncodedDoc encoded) => Doc(
        collection: collection,
        docId: encoded.id,
        json: jsonEncode(encoded.json),
        updatedAt: encoded.updatedAt,
      );

  @override
  Future<bool> delete(String collection, String id) async {
    final q = _docs.query(Doc_.key.equals(Doc.keyFor(collection, id))).build();
    try {
      return q.remove() > 0;
    } finally {
      q.close();
    }
  }

  @override
  Future<int> deleteAll(String collection, Iterable<String> ids) async {
    final keys = [for (final id in ids) Doc.keyFor(collection, id)];
    if (keys.isEmpty) return 0;
    final q = _docs.query(Doc_.key.oneOf(keys)).build();
    try {
      return q.remove();
    } finally {
      q.close();
    }
  }

  @override
  Future<T?> getById<T extends Object>(String collection, String id) async {
    final q = _docs.query(Doc_.key.equals(Doc.keyFor(collection, id))).build();
    try {
      final doc = q.findFirst();
      return doc == null ? null : _decode<T>(doc);
    } finally {
      q.close();
    }
  }

  @override
  Future<List<T>> getAll<T extends Object>(String collection) async {
    final q = _collectionQuery(collection).build();
    try {
      return q.find().map(_decode<T>).toList();
    } finally {
      q.close();
    }
  }

  @override
  Stream<List<T>> watchAll<T extends Object>(
    String collection, {
    bool Function(T model)? filter,
    int Function(T a, T b)? sortBy,
  }) =>
      _collectionQuery(collection).watch(triggerImmediately: true).map((q) {
        var list = q.find().map(_decode<T>).toList();
        if (filter != null) list = list.where(filter).toList();
        if (sortBy != null) list.sort(sortBy);
        return list;
      }).distinct(listEquals);

  @override
  Stream<T?> watchById<T extends Object>(String collection, String id) => _docs
      .query(Doc_.key.equals(Doc.keyFor(collection, id)))
      .watch(triggerImmediately: true)
      .map((q) {
        final doc = q.findFirst();
        return doc == null ? null : _decode<T>(doc);
      })
      .distinct();

  @override
  Future<List<T>> query<T extends Object>(String collection, bool Function(T model) predicate) async =>
      (await getAll<T>(collection)).where(predicate).toList();

  @override
  Future<int> count(String collection) async {
    final q = _collectionQuery(collection).build();
    try {
      return q.count();
    } finally {
      q.close();
    }
  }

  @override
  Future<void> clearCollection(String collection) async {
    final q = _collectionQuery(collection).build();
    try {
      q.remove();
    } finally {
      q.close();
    }
  }

  QueryBuilder<Doc> _collectionQuery(String collection) =>
      _docs.query(Doc_.collection.equals(collection))..order(Doc_.updatedAt, flags: Order.descending);

  T _decode<T extends Object>(Doc doc) => DocCodec.cast<T>(
        doc.collection,
        DocCodec.decode(doc.collection, jsonDecode(doc.json) as Map<String, dynamic>),
      );

  // ---- cursors -------------------------------------------------------------

  @override
  Future<DateTime?> getCursor(String collection) async {
    final q = _cursors.query(SyncCursorEntity_.collection.equals(collection)).build();
    try {
      return q.findFirst()?.cursor.toUtc();
    } finally {
      q.close();
    }
  }

  @override
  Future<void> setCursor(String collection, DateTime cursor) async {
    _cursors.put(SyncCursorEntity(collection: collection, cursor: cursor.toUtc()));
  }

  @override
  Future<Map<String, DateTime>> allCursors() async =>
      {for (final c in _cursors.getAll()) c.collection: c.cursor.toUtc()};

  @override
  Future<void> clearCursors() async {
    _cursors.removeAll();
  }

  // ---- outbox --------------------------------------------------------------

  @override
  Future<void> enqueue(SyncOp op) async {
    final existing = _outbox.query(OutboxEntryEntity_.opId.equals(op.opId)).build();
    try {
      if (existing.count() > 0) return;
    } finally {
      existing.close();
    }
    _outbox.put(OutboxEntryEntity(
      opId: op.opId,
      entity: op.entity,
      action: op.action.json,
      customAction: op.customAction,
      payloadJson: jsonEncode(op.payload),
      clientAt: op.clientAt.toUtc(),
      enqueuedAt: DateTime.now().toUtc(),
    ));
  }

  QueryBuilder<OutboxEntryEntity> _stateQuery(OutboxState state) =>
      _outbox.query(OutboxEntryEntity_.state.equals(state.index))..order(OutboxEntryEntity_.id);

  @override
  Future<List<OutboxEntry>> pending({int? limit}) async {
    final q = _stateQuery(OutboxState.pending).build();
    try {
      if (limit != null) q.limit = limit;
      return q.find().map(_toEntry).toList();
    } finally {
      q.close();
    }
  }

  @override
  Future<List<OutboxEntry>> rejected() async {
    final q = _stateQuery(OutboxState.rejected).build();
    try {
      return q.find().map(_toEntry).toList();
    } finally {
      q.close();
    }
  }

  @override
  Stream<List<OutboxEntry>> watchPending() => _stateQuery(OutboxState.pending)
      .watch(triggerImmediately: true)
      .map((q) => q.find().map(_toEntry).toList())
      .distinct(listEquals);

  @override
  Future<void> markApplied(String opId) async {
    final q = _outbox.query(OutboxEntryEntity_.opId.equals(opId)).build();
    try {
      q.remove();
    } finally {
      q.close();
    }
  }

  @override
  Future<void> markRejected(String opId, {String? code, String? message}) async => _update(opId, (e) {
        e
          ..state = OutboxState.rejected.index
          ..attempts += 1
          ..errorCode = code
          ..errorMessage = message
          ..lastAttemptAt = DateTime.now().toUtc();
      });

  @override
  Future<void> markAttempted(String opId) async => _update(opId, (e) {
        e
          ..attempts += 1
          ..lastAttemptAt = DateTime.now().toUtc();
      });

  @override
  Future<void> retry(String opId) async => _update(opId, (e) {
        e
          ..state = OutboxState.pending.index
          ..errorCode = null
          ..errorMessage = null;
      });

  @override
  Future<void> discard(String opId) => markApplied(opId);

  void _update(String opId, void Function(OutboxEntryEntity) fn) {
    final q = _outbox.query(OutboxEntryEntity_.opId.equals(opId)).build();
    try {
      final e = q.findFirst();
      if (e == null) return;
      fn(e);
      _outbox.put(e);
    } finally {
      q.close();
    }
  }

  @override
  Future<int> pendingCount() async {
    final q = _stateQuery(OutboxState.pending).build();
    try {
      return q.count();
    } finally {
      q.close();
    }
  }

  @override
  Stream<int> watchPendingCount() =>
      _stateQuery(OutboxState.pending).watch(triggerImmediately: true).map((q) => q.count()).distinct();

  @override
  Future<void> clearOutbox() async {
    _outbox.removeAll();
  }

  OutboxEntry _toEntry(OutboxEntryEntity e) => OutboxEntry(
        op: SyncOp(
          opId: e.opId,
          entity: e.entity,
          action: SyncOpAction.fromJson(e.action),
          customAction: e.customAction,
          payload: Map<String, Object?>.from(jsonDecode(e.payloadJson) as Map),
          clientAt: e.clientAt.toUtc(),
        ),
        enqueuedAt: e.enqueuedAt.toUtc(),
        state: OutboxState.values[e.state],
        attempts: e.attempts,
        errorCode: e.errorCode,
        errorMessage: e.errorMessage,
        lastAttemptAt: e.lastAttemptAt?.toUtc(),
      );

  // ---- lifecycle -----------------------------------------------------------

  @override
  Future<void> clear() async {
    store.runInTransaction(TxMode.write, () {
      _docs.removeAll();
      _outbox.removeAll();
      _cursors.removeAll();
    });
  }

  @override
  Future<void> close() async {
    if (!store.isClosed()) store.close();
  }
}
