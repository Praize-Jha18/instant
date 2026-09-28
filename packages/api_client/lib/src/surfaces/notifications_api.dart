import 'package:core_models/core_models.dart';

import 'base_api.dart';

/// Notification routes (ARCHITECTURE §11): `/notifications`.
class NotificationsApi extends BaseApi {
  const NotificationsApi(super.client);

  /// `GET /notifications`.
  Future<Paginated<AppNotification>> list({String? cursor, int? limit, bool? unreadOnly}) async {
    final body = await client.get('/notifications', query: {
      'cursor': ?cursor,
      'limit': ?limit,
      'unreadOnly': ?unreadOnly,
    });
    return asPage(body, AppNotification.fromJson);
  }

  /// `GET /notifications/unread-count` → number of unread notifications.
  Future<int> unreadCount() async {
    final body = unwrap(await client.get('/notifications/unread-count'));
    return (body['count'] as num?)?.toInt() ?? 0;
  }

  /// `POST /notifications/:id/read`.
  Future<AppNotification> markRead(String id) async {
    return AppNotification.fromJson(unwrap(await client.post('/notifications/$id/read')));
  }

  /// `POST /notifications/read-all` → number of notifications updated.
  Future<int> markAllRead() async {
    final body = unwrap(await client.post('/notifications/read-all'));
    return (body['updated'] as num?)?.toInt() ?? 0;
  }
}
