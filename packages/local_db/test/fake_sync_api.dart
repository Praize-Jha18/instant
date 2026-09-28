import 'package:api_client/api_client.dart';
import 'package:core_models/core_models.dart';

/// A scriptable [SyncTransport].
class FakeSyncApi implements SyncTransport {
  FakeSyncApi();

  /// Pull pages keyed by `since` cursor (null = first sync); each entry is a
  /// list of pages so paging can be exercised.
  final List<SyncPullResponse> pullPages = [];
  final List<({List<String> collections, DateTime? since, String? cursor})> pullCalls = [];
  final List<List<SyncOp>> pushCalls = [];
  final Set<String> seenOpIds = {};

  /// Ops that the "server" rejects, with codes.
  final Map<String, String> rejectWithCode = {};

  /// When set, every call throws it.
  ApiException? failWith;

  SyncPullResponse Function(List<String> collections, DateTime? since, String? cursor)? onPull;

  @override
  Future<SyncPullResponse> pull({
    required List<String> collections,
    DateTime? since,
    String? cursor,
    int? limit,
  }) async {
    if (failWith != null) throw failWith!;
    pullCalls.add((collections: collections, since: since, cursor: cursor));
    final custom = onPull;
    if (custom != null) return custom(collections, since, cursor);
    if (pullPages.isEmpty) {
      return SyncPullResponse(serverTime: DateTime.now().toUtc());
    }
    return pullPages.removeAt(0);
  }

  @override
  Future<SyncPushResponse> push(List<SyncOp> ops) async {
    if (failWith != null) throw failWith!;
    pushCalls.add(ops);
    return SyncPushResponse(
      results: [
        for (final op in ops)
          if (rejectWithCode.containsKey(op.opId))
            SyncPushResult(opId: op.opId, status: SyncOpStatus.rejected, code: rejectWithCode[op.opId])
          else if (!seenOpIds.add(op.opId))
            SyncPushResult(opId: op.opId, status: SyncOpStatus.duplicate)
          else
            SyncPushResult(
              opId: op.opId,
              status: SyncOpStatus.applied,
              doc: op.action == SyncOpAction.upsert ? {...op.payload, 'version': 2} : null,
            ),
      ],
    );
  }
}
