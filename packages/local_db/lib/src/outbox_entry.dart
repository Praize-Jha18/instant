import 'package:core_models/core_models.dart';
import 'package:flutter/foundation.dart';

/// Lifecycle of an outbox op on the client.
enum OutboxState {
  /// Waiting to be pushed (or to be retried after a transport failure).
  pending,

  /// The server rejected it; the UI should surface it and the user may retry
  /// or discard it.
  rejected,
}

/// A [SyncOp] queued in the outbox with its client-side bookkeeping.
@immutable
class OutboxEntry {
  const OutboxEntry({
    required this.op,
    required this.enqueuedAt,
    this.state = OutboxState.pending,
    this.attempts = 0,
    this.errorCode,
    this.errorMessage,
    this.lastAttemptAt,
  });

  final SyncOp op;
  final DateTime enqueuedAt;
  final OutboxState state;
  final int attempts;
  final String? errorCode;
  final String? errorMessage;
  final DateTime? lastAttemptAt;

  String get opId => op.opId;
  bool get isPending => state == OutboxState.pending;
  bool get isRejected => state == OutboxState.rejected;

  OutboxEntry copyWith({
    OutboxState? state,
    int? attempts,
    String? errorCode,
    String? errorMessage,
    DateTime? lastAttemptAt,
    bool clearError = false,
  }) =>
      OutboxEntry(
        op: op,
        enqueuedAt: enqueuedAt,
        state: state ?? this.state,
        attempts: attempts ?? this.attempts,
        errorCode: clearError ? null : (errorCode ?? this.errorCode),
        errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
        lastAttemptAt: lastAttemptAt ?? this.lastAttemptAt,
      );

  @override
  bool operator ==(Object other) =>
      other is OutboxEntry &&
      other.op == op &&
      other.state == state &&
      other.attempts == attempts &&
      other.errorCode == errorCode &&
      other.errorMessage == errorMessage;

  @override
  int get hashCode => Object.hash(op, state, attempts, errorCode, errorMessage);

  @override
  String toString() => 'OutboxEntry(${op.entity}.${op.action.json} $opId $state)';
}
