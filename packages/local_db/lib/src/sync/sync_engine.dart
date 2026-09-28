import 'dart:async';

import 'package:api_client/api_client.dart';
import 'package:core_models/core_models.dart';
import 'package:uuid/uuid.dart';

import '../local_store.dart';
import 'connectivity_monitor.dart';
import 'sync_status.dart';

/// Drives the offline protocol of §7 against a [LocalStore].
///
/// - [pull] fetches changes since each collection's cursor, upserts them,
///   deletes tombstones and stores `serverTime` as the new cursor.
/// - [pushOutbox] sends pending ops in order and removes `applied`/`duplicate`
///   ones; `rejected` ops stay in the outbox flagged for the UI.
/// - [start] wires connectivity, realtime connection state and the outbox so
///   that a reconnect or a new op triggers a debounced, single-flight sync,
///   and applies realtime `changed`/`removed` events straight into the store.
///
/// Apps typically create one engine per signed-in session:
/// ```dart
/// final engine = SyncEngine(store: store, api: client.sync,
///     realtime: realtime, collections: Collections.customerSync);
/// await engine.start();
/// ```
class SyncEngine {
  SyncEngine({
    required this.store,
    required this.api,
    required this.collections,
    this.realtime,
    ConnectivityMonitor? connectivity,
    this.debounce = const Duration(milliseconds: 400),
    this.periodicInterval,
    this.pushBatchSize = 50,
    this.pullPageLimit,
  }) : connectivity = connectivity ?? ConnectivityPlusMonitor();

  final LocalStore store;
  final SyncTransport api;
  final RealtimeClient? realtime;
  final ConnectivityMonitor connectivity;

  /// Collections pulled by default (e.g. [Collections.customerSync]).
  final List<String> collections;

  /// Delay between a trigger and the sync it schedules (coalesces bursts).
  final Duration debounce;

  /// Optional safety-net interval for a full sync while started.
  final Duration? periodicInterval;

  /// Max ops per `POST /sync/push`.
  final int pushBatchSize;

  /// Optional `limit` forwarded to `GET /sync/pull`.
  final int? pullPageLimit;

  final _status = StreamController<SyncStatus>.broadcast();
  SyncStatus _current = const SyncStatus();
  Future<void>? _inFlight;
  bool _syncAgain = false;
  Timer? _debounceTimer;
  Timer? _periodicTimer;
  final List<StreamSubscription<Object?>> _subs = [];
  bool _started = false;
  bool _online = true;
  static const _uuid = Uuid();

  /// Status changes (idle / syncing / offline / error with pending count).
  Stream<SyncStatus> get status => _status.stream;
  SyncStatus get currentStatus => _current;
  bool get isStarted => _started;
  bool get isOnline => _online;

  // ---- lifecycle -----------------------------------------------------------

  /// Subscribes to connectivity, realtime and the outbox, then syncs once.
  Future<void> start() async {
    if (_started) return;
    _started = true;
    _online = await connectivity.isOnline();
    await _refreshCounts();
    _emit(_current.copyWith(phase: _online ? SyncPhase.idle : SyncPhase.offline));

    _subs.add(connectivity.onlineChanges.listen((online) {
      final was = _online;
      _online = online;
      if (!online) {
        _emit(_current.copyWith(phase: SyncPhase.offline));
      } else if (!was) {
        _emit(_current.copyWith(phase: SyncPhase.idle, clearError: true));
        requestSync();
      }
    }));

    final rt = realtime;
    if (rt != null) {
      _subs.add(rt.connectionState.listen((state) {
        if (state == RealtimeConnectionState.connected) requestSync();
      }));
      _subs.add(rt.changed.listen(applyChanged));
      _subs.add(rt.removed.listen(applyRemoved));
    }

    // Only an increase (a newly enqueued op) schedules a push; decreases are
    // the push itself draining the outbox.
    int? lastPending;
    _subs.add(store.watchPendingCount().listen((count) {
      _emit(_current.copyWith(pendingCount: count));
      final previous = lastPending;
      lastPending = count;
      if (previous != null && count > previous) requestSync();
    }));

    final interval = periodicInterval;
    if (interval != null) {
      _periodicTimer = Timer.periodic(interval, (_) => requestSync());
    }

    requestSync(immediate: true);
  }

  /// Stops listening; the store is left untouched.
  Future<void> stop() async {
    _started = false;
    _debounceTimer?.cancel();
    _periodicTimer?.cancel();
    for (final s in _subs) {
      await s.cancel();
    }
    _subs.clear();
  }

  Future<void> dispose() async {
    await stop();
    await _status.close();
  }

  // ---- triggers ------------------------------------------------------------

  /// Schedules a debounced push + pull. Safe to call from anywhere.
  void requestSync({bool immediate = false}) {
    _debounceTimer?.cancel();
    if (immediate) {
      unawaited(sync());
      return;
    }
    _debounceTimer = Timer(debounce, () => unawaited(sync()));
  }

  /// Push then pull, single-flight. If a sync is running another one is
  /// queued to run right after it (so late triggers are never lost).
  Future<void> sync() {
    final running = _inFlight;
    if (running != null) {
      _syncAgain = true;
      return running;
    }
    final future = _runSync();
    _inFlight = future;
    return future;
  }

  Future<void> _runSync() async {
    try {
      do {
        _syncAgain = false;
        if (!_online && !(await connectivity.isOnline())) {
          _emit(_current.copyWith(phase: SyncPhase.offline));
          return;
        }
        _online = true;
        _emit(_current.copyWith(phase: SyncPhase.syncing, clearError: true));
        final push = await pushOutbox(emitStatus: false);
        if (push.remaining > 0 && _current.phase == SyncPhase.offline) return;
        await pull(emitStatus: false);
        if (_current.phase == SyncPhase.syncing) {
          _emit(_current.copyWith(phase: SyncPhase.idle, clearError: true));
        }
      } while (_syncAgain);
    } finally {
      _inFlight = null;
    }
  }

  // ---- pull ----------------------------------------------------------------

  /// Pulls [only] (default: [collections]) using the stored cursors, applies
  /// changes and tombstones and advances cursors to `serverTime`.
  ///
  /// Documents with a pending outbox op are not overwritten by the pull; the
  /// following push settles them and the next pull brings the server copy.
  Future<PullResult> pull({List<String>? only, bool emitStatus = true}) async {
    final targets = only ?? collections;
    if (targets.isEmpty) return const PullResult();
    if (emitStatus) _emit(_current.copyWith(phase: SyncPhase.syncing, clearError: true));

    // One request per distinct cursor value (usually a single group).
    final groups = <DateTime?, List<String>>{};
    for (final c in targets) {
      final cursor = await store.getCursor(c);
      groups.putIfAbsent(cursor, () => []).add(c);
    }

    var applied = 0, removed = 0, skipped = 0;
    DateTime? serverTime;
    try {
      final protectedIds = await _pendingTargets();
      for (final entry in groups.entries) {
        String? pageCursor;
        do {
          final res = await api.pull(
            collections: entry.value,
            since: entry.key,
            cursor: pageCursor,
            limit: pullPageLimit,
          );
          for (final change in res.changes.entries) {
            final protectedSet = protectedIds[change.key] ?? const <String>{};
            final docs = <Map<String, dynamic>>[];
            for (final raw in change.value) {
              final doc = Map<String, dynamic>.from(raw);
              final id = readId(doc, 'id')?.toString();
              if (id != null && protectedSet.contains(id)) {
                skipped++;
                continue;
              }
              docs.add(doc);
            }
            if (docs.isNotEmpty) {
              await store.upsertAllJson(change.key, docs);
              applied += docs.length;
            }
          }
          for (final tomb in res.tombstones.entries) {
            removed += await store.deleteAll(tomb.key, tomb.value);
          }
          serverTime = res.serverTime;
          pageCursor = res.hasMore ? res.nextCursor : null;
        } while (pageCursor != null);
        for (final c in entry.value) {
          await store.setCursor(c, serverTime);
        }
      }
      _emit(_current.copyWith(
        phase: emitStatus ? SyncPhase.idle : _current.phase,
        lastSyncedAt: serverTime,
        clearError: true,
      ));
      return PullResult(applied: applied, removed: removed, skipped: skipped, serverTime: serverTime);
    } on ApiException catch (e) {
      _fail(e);
      rethrow;
    } catch (e) {
      _fail(e);
      rethrow;
    }
  }

  // ---- push ----------------------------------------------------------------

  /// Pushes pending ops in batches, in order. Stops at the first transport
  /// failure (ops stay pending) and never blocks on rejected ops.
  Future<PushResult> pushOutbox({bool emitStatus = true}) async {
    var applied = 0, duplicate = 0, rejected = 0;
    if (emitStatus) _emit(_current.copyWith(phase: SyncPhase.syncing, clearError: true));
    try {
      while (true) {
        final batch = await store.pending(limit: pushBatchSize);
        if (batch.isEmpty) break;
        final ops = batch.map((e) => e.op).toList();
        final SyncPushResponse res;
        try {
          res = await api.push(ops);
        } catch (e) {
          for (final entry in batch) {
            await store.markAttempted(entry.opId);
          }
          rethrow;
        }
        final byId = {for (final r in res.results) r.opId: r};
        var progressed = false;
        for (final entry in batch) {
          final r = byId[entry.opId];
          if (r == null) continue; // server did not answer for it; retry later
          progressed = true;
          switch (r.status) {
            case SyncOpStatus.applied:
              applied++;
              await store.markApplied(entry.opId);
              final doc = r.doc;
              if (doc != null && doc.isNotEmpty) {
                await store.upsertJson(entry.op.entity, Map<String, dynamic>.from(doc));
              }
            case SyncOpStatus.duplicate:
              duplicate++;
              await store.markApplied(entry.opId);
            case SyncOpStatus.rejected:
              rejected++;
              await store.markRejected(entry.opId, code: r.code, message: r.message);
          }
        }
        if (!progressed) {
          for (final entry in batch) {
            await store.markAttempted(entry.opId);
          }
          break; // avoid a hot loop on a server that returns nothing
        }
      }
      await _refreshCounts();
      if (emitStatus) _emit(_current.copyWith(phase: SyncPhase.idle, clearError: true));
      return PushResult(
        applied: applied,
        duplicate: duplicate,
        rejected: rejected,
        remaining: await store.pendingCount(),
      );
    } on ApiException catch (e) {
      await _refreshCounts();
      _fail(e);
      return PushResult(
        applied: applied,
        duplicate: duplicate,
        rejected: rejected,
        remaining: await store.pendingCount(),
      );
    }
  }

  // ---- outbox helpers ------------------------------------------------------

  /// Enqueues [op] and schedules a push.
  Future<void> enqueue(SyncOp op) async {
    await store.enqueue(op);
    if (_started) requestSync();
  }

  /// Writes [model] locally and queues an `upsert` op for it.
  Future<SyncOp> enqueueUpsert<T extends Object>(String collection, T model) async {
    await store.upsert(collection, model);
    final codec = ModelRegistry.forCollection(collection);
    final payload = codec == null
        ? Map<String, Object?>.from(model as Map)
        : codec.encodeDynamic(model);
    final op = SyncOp(
      opId: newOpId(),
      entity: collection,
      action: SyncOpAction.upsert,
      payload: payload,
      clientAt: DateTime.now().toUtc(),
    );
    await enqueue(op);
    return op;
  }

  /// Deletes locally and queues a `delete` op.
  Future<SyncOp> enqueueDelete(String collection, String id) async {
    await store.delete(collection, id);
    final op = SyncOp(
      opId: newOpId(),
      entity: collection,
      action: SyncOpAction.delete,
      payload: {'id': id},
      clientAt: DateTime.now().toUtc(),
    );
    await enqueue(op);
    return op;
  }

  /// Queues a `custom` op (e.g. `stock.adjust` with a delta payload).
  Future<SyncOp> enqueueCustom(
    String entity,
    String customAction,
    Map<String, Object?> payload,
  ) async {
    final op = SyncOp(
      opId: newOpId(),
      entity: entity,
      action: SyncOpAction.custom,
      customAction: customAction,
      payload: payload,
      clientAt: DateTime.now().toUtc(),
    );
    await enqueue(op);
    return op;
  }

  /// Moves a rejected op back to pending and schedules a push.
  Future<void> retryRejected(String opId) async {
    await store.retry(opId);
    await _refreshCounts();
    if (_started) requestSync();
  }

  /// Drops a rejected op.
  Future<void> discardRejected(String opId) async {
    await store.discard(opId);
    await _refreshCounts();
  }

  /// A fresh uuid v4 op id.
  static String newOpId() => _uuid.v4();

  // ---- realtime ------------------------------------------------------------

  /// Applies a realtime `changed` event (skipped while a pending op targets
  /// the same document).
  Future<void> applyChanged(ChangedEvent event) async {
    if (event.doc.isEmpty) return;
    final protectedIds = await _pendingTargets();
    if (protectedIds[event.collection]?.contains(event.id) ?? false) return;
    final doc = Map<String, dynamic>.from(event.doc);
    doc.putIfAbsent('id', () => event.id);
    await store.upsertJson(event.collection, doc);
  }

  /// Applies a realtime `removed` event.
  Future<void> applyRemoved(RemovedEvent event) => store.delete(event.collection, event.id);

  // ---- internals -----------------------------------------------------------

  Future<Map<String, Set<String>>> _pendingTargets() async {
    final out = <String, Set<String>>{};
    for (final entry in await store.pending()) {
      if (entry.op.action == SyncOpAction.custom) continue;
      final id = entry.op.docId;
      if (id != null) out.putIfAbsent(entry.op.entity, () => {}).add(id);
    }
    return out;
  }

  Future<void> _refreshCounts() async {
    final pending = await store.pendingCount();
    final rejected = (await store.rejected()).length;
    _emit(_current.copyWith(pendingCount: pending, rejectedCount: rejected));
  }

  void _fail(Object error) {
    final offline = error is ApiException && error.isOffline;
    if (offline) _online = false;
    _emit(_current.copyWith(phase: offline ? SyncPhase.offline : SyncPhase.error, error: error));
  }

  void _emit(SyncStatus next) {
    if (next == _current) return;
    _current = next;
    if (!_status.isClosed) _status.add(next);
  }
}
