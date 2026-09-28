import 'package:core_models/core_models.dart';

import 'objectbox/objectbox_store_web.dart'
    if (dart.library.io) 'objectbox/objectbox_store_io.dart';
import 'outbox_entry.dart';
import 'platform/is_web.dart';
import 'memory_store.dart';

/// Per-collection pull cursors (§7: the server's `serverTime` of the last pull).
abstract interface class SyncCursorStore {
  Future<DateTime?> getCursor(String collection);
  Future<void> setCursor(String collection, DateTime cursor);
  Future<Map<String, DateTime>> allCursors();
  Future<void> clearCursors();
}

/// Queue of client mutations awaiting `POST /sync/push` (§7).
abstract interface class OutboxStore {
  /// Appends [op]. Order of enqueueing is the order of pushing.
  Future<void> enqueue(SyncOp op);

  /// Pending ops in push order. Emits immediately and on every change.
  Stream<List<OutboxEntry>> watchPending();

  /// Pending ops in push order.
  Future<List<OutboxEntry>> pending({int? limit});

  /// Rejected ops, oldest first.
  Future<List<OutboxEntry>> rejected();

  /// Removes the op (server returned `applied` or `duplicate`).
  Future<void> markApplied(String opId);

  /// Keeps the op but flags it rejected so the UI can surface it.
  Future<void> markRejected(String opId, {String? code, String? message});

  /// Increments the attempt counter after a transport failure.
  Future<void> markAttempted(String opId);

  /// Moves a rejected op back to pending.
  Future<void> retry(String opId);

  /// Drops an op entirely (typically a rejected one the user dismissed).
  Future<void> discard(String opId);

  Future<int> pendingCount();

  /// Emits immediately and whenever the pending count changes.
  Stream<int> watchPendingCount();

  Future<void> clearOutbox();
}

/// The app-facing local database (§7). Every screen reads from here; the
/// network only fills it. Documents are stored per [collection] (see
/// [Collections]) keyed by their string id and decoded through
/// [ModelRegistry]; collections without a registered codec round-trip as
/// `Map<String, dynamic>`.
///
/// Type parameters are the model type of the collection (e.g. `Product` for
/// `Collections.products`) or `Object`/`Map<String, dynamic>` for raw access.
abstract interface class LocalStore implements SyncCursorStore, OutboxStore {
  /// Opens the platform store: [MemoryStore] on web, [ObjectBoxStore]
  /// elsewhere. [directory] overrides ObjectBox's default documents folder.
  static Future<LocalStore> open({String? directory, String name = 'instant'}) async {
    if (isWeb) return MemoryStore();
    return ObjectBoxStore.open(directory: directory, name: name);
  }

  /// Inserts or replaces one model.
  Future<void> upsert<T extends Object>(String collection, T model);

  /// Inserts or replaces many models in one transaction.
  Future<void> upsertAll<T extends Object>(String collection, Iterable<T> models);

  /// Inserts or replaces a raw document (`id`/`_id` required).
  Future<void> upsertJson(String collection, Map<String, dynamic> json);

  /// Inserts or replaces raw documents in one transaction.
  Future<void> upsertAllJson(String collection, Iterable<Map<String, dynamic>> docs);

  /// Removes a document. Returns true when something was removed.
  Future<bool> delete(String collection, String id);

  /// Removes many documents. Returns the number removed.
  Future<int> deleteAll(String collection, Iterable<String> ids);

  Future<T?> getById<T extends Object>(String collection, String id);

  Future<List<T>> getAll<T extends Object>(String collection);

  /// Emits the current contents immediately, then again after every change to
  /// the collection. [filter] and [sortBy] are applied in memory; identical
  /// consecutive lists are suppressed.
  Stream<List<T>> watchAll<T extends Object>(
    String collection, {
    bool Function(T model)? filter,
    int Function(T a, T b)? sortBy,
  });

  /// Emits the document (or null) immediately and after every change.
  Stream<T?> watchById<T extends Object>(String collection, String id);

  /// One-off filtered read.
  Future<List<T>> query<T extends Object>(String collection, bool Function(T model) predicate);

  Future<int> count(String collection);

  /// Removes every document of one collection.
  Future<void> clearCollection(String collection);

  /// Wipes documents, cursors and outbox (sign-out).
  Future<void> clear();

  Future<void> close();
}
