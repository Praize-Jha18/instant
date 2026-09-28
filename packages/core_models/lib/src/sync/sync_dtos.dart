import 'package:freezed_annotation/freezed_annotation.dart';

import '../converters/converters.dart';
import '../enums/enums.dart';

part 'sync_dtos.freezed.dart';
part 'sync_dtos.g.dart';

/// One queued client mutation (§7 push). [opId] is a uuid v4 minted by the
/// client; the server deduplicates on it.
///
/// For `custom` actions [customAction] names the action (e.g. `stock.adjust`)
/// and [payload] carries deltas, never absolutes, so replays are safe.
@freezed
abstract class SyncOp with _$SyncOp {
  const SyncOp._();

  const factory SyncOp({
    required String opId,
    required String entity,
    required SyncOpAction action,
    @JsonKey(name: 'customAction') String? customAction,
    @Default(<String, Object?>{}) Map<String, Object?> payload,
    @DateTimeConverter() required DateTime clientAt,
  }) = _SyncOp;

  factory SyncOp.fromJson(Map<String, dynamic> json) => _$SyncOpFromJson(json);

  /// The document id targeted by this op, when the payload carries one.
  String? get docId {
    final v = payload['id'] ?? payload['_id'];
    return v?.toString();
  }
}

/// Body of `POST /sync/push`.
@freezed
abstract class SyncPushRequest with _$SyncPushRequest {
  const factory SyncPushRequest({required List<SyncOp> ops}) = _SyncPushRequest;

  factory SyncPushRequest.fromJson(Map<String, dynamic> json) =>
      _$SyncPushRequestFromJson(json);
}

/// Per-op result inside a push response.
@freezed
abstract class SyncPushResult with _$SyncPushResult {
  const SyncPushResult._();

  const factory SyncPushResult({
    required String opId,
    required SyncOpStatus status,
    String? code,
    String? message,
    Map<String, Object?>? doc,
  }) = _SyncPushResult;

  factory SyncPushResult.fromJson(Map<String, dynamic> json) =>
      _$SyncPushResultFromJson(json);

  bool get isSettled =>
      status == SyncOpStatus.applied || status == SyncOpStatus.duplicate;
  bool get isRejected => status == SyncOpStatus.rejected;
}

/// Response of `POST /sync/push`.
@freezed
abstract class SyncPushResponse with _$SyncPushResponse {
  const factory SyncPushResponse({
    @Default(<SyncPushResult>[]) List<SyncPushResult> results,
  }) = _SyncPushResponse;

  factory SyncPushResponse.fromJson(Map<String, dynamic> json) =>
      _$SyncPushResponseFromJson(json);
}

/// Response of `GET /sync/pull`:
/// `{ changes: { products: [...] }, tombstones: { products: [ids] }, serverTime, nextCursor? }`.
@freezed
abstract class SyncPullResponse with _$SyncPullResponse {
  const SyncPullResponse._();

  const factory SyncPullResponse({
    @Default(<String, List<Map<String, Object?>>>{})
    Map<String, List<Map<String, Object?>>> changes,
    @Default(<String, List<String>>{}) Map<String, List<String>> tombstones,
    @DateTimeConverter() required DateTime serverTime,

    /// Present when large collections are paged inside the same call.
    String? nextCursor,
  }) = _SyncPullResponse;

  factory SyncPullResponse.fromJson(Map<String, dynamic> json) =>
      _$SyncPullResponseFromJson(json);

  bool get hasMore => nextCursor != null && nextCursor!.isNotEmpty;
  int get changeCount => changes.values.fold(0, (a, l) => a + l.length);
  int get tombstoneCount => tombstones.values.fold(0, (a, l) => a + l.length);
}
