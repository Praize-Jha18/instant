import 'package:flutter/foundation.dart';

/// What the [SyncEngine] is doing right now.
enum SyncPhase {
  /// Online, nothing in flight.
  idle,

  /// A push and/or pull is running.
  syncing,

  /// No connectivity (or the last request failed with a transport error).
  offline,

  /// The last sync failed with a non-transport error; see [SyncStatus.error].
  error,
}

/// Snapshot emitted by `SyncEngine.status`.
@immutable
class SyncStatus {
  const SyncStatus({
    this.phase = SyncPhase.idle,
    this.pendingCount = 0,
    this.rejectedCount = 0,
    this.lastSyncedAt,
    this.error,
  });

  final SyncPhase phase;

  /// Ops waiting in the outbox.
  final int pendingCount;

  /// Ops the server rejected that still need user attention.
  final int rejectedCount;

  /// Server time of the last successful pull.
  final DateTime? lastSyncedAt;

  /// Last error when [phase] is [SyncPhase.error] (or offline cause).
  final Object? error;

  bool get isOffline => phase == SyncPhase.offline;
  bool get isSyncing => phase == SyncPhase.syncing;
  bool get hasPending => pendingCount > 0;

  SyncStatus copyWith({
    SyncPhase? phase,
    int? pendingCount,
    int? rejectedCount,
    DateTime? lastSyncedAt,
    Object? error,
    bool clearError = false,
  }) =>
      SyncStatus(
        phase: phase ?? this.phase,
        pendingCount: pendingCount ?? this.pendingCount,
        rejectedCount: rejectedCount ?? this.rejectedCount,
        lastSyncedAt: lastSyncedAt ?? this.lastSyncedAt,
        error: clearError ? null : (error ?? this.error),
      );

  @override
  bool operator ==(Object other) =>
      other is SyncStatus &&
      other.phase == phase &&
      other.pendingCount == pendingCount &&
      other.rejectedCount == rejectedCount &&
      other.lastSyncedAt == lastSyncedAt &&
      other.error == error;

  @override
  int get hashCode => Object.hash(phase, pendingCount, rejectedCount, lastSyncedAt, error);

  @override
  String toString() => 'SyncStatus($phase, pending: $pendingCount, rejected: $rejectedCount)';
}

/// Outcome of one `SyncEngine.pull`.
@immutable
class PullResult {
  const PullResult({this.applied = 0, this.removed = 0, this.skipped = 0, this.serverTime});
  final int applied;
  final int removed;

  /// Docs left untouched because a pending outbox op targets them.
  final int skipped;
  final DateTime? serverTime;

  @override
  String toString() => 'PullResult(applied: $applied, removed: $removed, skipped: $skipped)';
}

/// Outcome of one `SyncEngine.pushOutbox`.
@immutable
class PushResult {
  const PushResult({this.applied = 0, this.duplicate = 0, this.rejected = 0, this.remaining = 0});
  final int applied;
  final int duplicate;
  final int rejected;

  /// Ops still pending (transport failure mid-way).
  final int remaining;

  int get settled => applied + duplicate;

  @override
  String toString() =>
      'PushResult(applied: $applied, duplicate: $duplicate, rejected: $rejected, remaining: $remaining)';
}
