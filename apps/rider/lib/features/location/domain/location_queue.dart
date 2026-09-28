import 'package:core_models/core_models.dart';
import 'package:local_db/local_db.dart';

import '../../../app/config.dart';

/// Offline queue for rider GPS pings.
///
/// Each ping becomes an `upsert riderLocations` op in the engine's outbox (so
/// it rides the normal `POST /sync/push` path). The outbox is capped: when more
/// than [cap] location ops are pending, the oldest are discarded, so a long
/// offline ride never floods storage or the first push after reconnect.
class LocationPingQueue {
  LocationPingQueue({required this.engine, this.cap = AppConfig.maxQueuedLocationPings})
      : assert(cap > 0, 'cap must be positive');

  final SyncEngine engine;
  final int cap;

  /// Queues [location] and trims the queue to [cap]. Returns the queued op.
  Future<SyncOp> enqueue(RiderLocation location) async {
    final op = await engine.enqueueUpsert(Collections.riderLocations, location);
    await trim();
    return op;
  }

  /// Pending location pings, oldest first.
  Future<List<OutboxEntry>> pending() async {
    final all = await engine.store.pending();
    return all.where(isLocationOp).toList();
  }

  Future<int> pendingCount() async => (await pending()).length;

  /// Drops the oldest pings beyond [cap]. Returns how many were dropped.
  Future<int> trim() async {
    final ops = await pending();
    final drop = opsToDrop(ops.map((e) => e.opId).toList(), cap);
    for (final id in drop) {
      await engine.store.discard(id);
    }
    return drop.length;
  }

  /// True for outbox entries produced by this queue.
  static bool isLocationOp(OutboxEntry e) =>
      e.op.entity == Collections.riderLocations && e.op.action == SyncOpAction.upsert;

  /// Pure capping rule: given op ids oldest-first, the ids to discard so that
  /// at most [cap] remain (always the oldest).
  static List<String> opsToDrop(List<String> oldestFirst, int cap) {
    final excess = oldestFirst.length - cap;
    if (excess <= 0) return const [];
    return oldestFirst.sublist(0, excess);
  }
}
