import 'package:core_models/core_models.dart';

import 'base_api.dart';

/// The two sync calls (§7) as an interface, so `local_db`'s SyncEngine can be
/// driven by [SyncApi] in apps and by a fake in tests.
abstract interface class SyncTransport {
  /// `GET /sync/pull`.
  Future<SyncPullResponse> pull({
    required List<String> collections,
    DateTime? since,
    String? cursor,
    int? limit,
  });

  /// `POST /sync/push`.
  Future<SyncPushResponse> push(List<SyncOp> ops);
}

/// Sync routes (§7) over HTTP.
class SyncApi extends BaseApi implements SyncTransport {
  const SyncApi(super.client);

  /// `GET /sync/pull?since=<iso>&collections=a,b[&cursor=]`.
  ///
  /// [since] null means "everything" (first sync). The server applies a 2 s
  /// overlap for clock skew, so callers pass the stored cursor as-is.
  @override
  Future<SyncPullResponse> pull({
    required List<String> collections,
    DateTime? since,
    String? cursor,
    int? limit,
  }) async {
    final body = await client.get('/sync/pull', query: {
      'since': (since ?? DateTime.fromMillisecondsSinceEpoch(0, isUtc: true)).toUtc().toIso8601String(),
      'collections': collections.join(','),
      'cursor': cursor,
      'limit': limit,
    });
    return SyncPullResponse.fromJson(unwrap(body));
  }

  /// `POST /sync/push { ops }`. The server is idempotent on `opId`.
  @override
  Future<SyncPushResponse> push(List<SyncOp> ops) async {
    if (ops.isEmpty) return const SyncPushResponse();
    final body = await client.post('/sync/push', data: SyncPushRequest(ops: ops).toJson());
    return SyncPushResponse.fromJson(unwrap(body));
  }
}
