import 'package:core_models/core_models.dart';

import '../local_store.dart';
import '../outbox_entry.dart';

/// Web placeholder: ObjectBox has no browser build. [LocalStore.open]
/// returns a `MemoryStore` on web, so this is never instantiated there.
class ObjectBoxStore implements LocalStore {
  ObjectBoxStore._();

  static Future<ObjectBoxStore> open({String? directory, String name = 'instant'}) =>
      throw UnsupportedError('ObjectBox is not available on web; use MemoryStore');

  Never _unsupported() => throw UnsupportedError('ObjectBox is not available on web');

  @override
  Future<void> upsert<T extends Object>(String collection, T model) => _unsupported();
  @override
  Future<void> upsertAll<T extends Object>(String collection, Iterable<T> models) => _unsupported();
  @override
  Future<void> upsertJson(String collection, Map<String, dynamic> json) => _unsupported();
  @override
  Future<void> upsertAllJson(String collection, Iterable<Map<String, dynamic>> docs) => _unsupported();
  @override
  Future<bool> delete(String collection, String id) => _unsupported();
  @override
  Future<int> deleteAll(String collection, Iterable<String> ids) => _unsupported();
  @override
  Future<T?> getById<T extends Object>(String collection, String id) => _unsupported();
  @override
  Future<List<T>> getAll<T extends Object>(String collection) => _unsupported();
  @override
  Stream<List<T>> watchAll<T extends Object>(String collection,
          {bool Function(T model)? filter, int Function(T a, T b)? sortBy}) =>
      _unsupported();
  @override
  Stream<T?> watchById<T extends Object>(String collection, String id) => _unsupported();
  @override
  Future<List<T>> query<T extends Object>(String collection, bool Function(T model) predicate) =>
      _unsupported();
  @override
  Future<int> count(String collection) => _unsupported();
  @override
  Future<void> clearCollection(String collection) => _unsupported();
  @override
  Future<void> clear() => _unsupported();
  @override
  Future<void> close() => _unsupported();
  @override
  Future<DateTime?> getCursor(String collection) => _unsupported();
  @override
  Future<void> setCursor(String collection, DateTime cursor) => _unsupported();
  @override
  Future<Map<String, DateTime>> allCursors() => _unsupported();
  @override
  Future<void> clearCursors() => _unsupported();
  @override
  Future<void> enqueue(SyncOp op) => _unsupported();
  @override
  Stream<List<OutboxEntry>> watchPending() => _unsupported();
  @override
  Future<List<OutboxEntry>> pending({int? limit}) => _unsupported();
  @override
  Future<List<OutboxEntry>> rejected() => _unsupported();
  @override
  Future<void> markApplied(String opId) => _unsupported();
  @override
  Future<void> markRejected(String opId, {String? code, String? message}) => _unsupported();
  @override
  Future<void> markAttempted(String opId) => _unsupported();
  @override
  Future<void> retry(String opId) => _unsupported();
  @override
  Future<void> discard(String opId) => _unsupported();
  @override
  Future<int> pendingCount() => _unsupported();
  @override
  Stream<int> watchPendingCount() => _unsupported();
  @override
  Future<void> clearOutbox() => _unsupported();
}
