import 'package:core_models/core_models.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../app/providers.dart';
import '../../auth/presentation/session_controller.dart';

final notificationsProvider = StreamProvider<List<AppNotification>>((ref) {
  final userId = ref.watch(currentUserIdProvider);
  final store = ref.watch(localStoreProvider);
  DateTime when(AppNotification n) => n.createdAt ?? DateTime.fromMillisecondsSinceEpoch(0);
  return store.watchAll<AppNotification>(
    Collections.notifications,
    filter: (n) => n.deletedAt == null && (userId.isEmpty || n.userId == userId),
    sortBy: (a, b) => when(b).compareTo(when(a)),
  );
});

final unreadNotificationCountProvider = Provider<int>(
  (ref) => (ref.watch(notificationsProvider).value ?? const []).where((n) => !n.isRead).length,
);

class NotificationActions {
  NotificationActions(this._ref);
  final Ref _ref;

  /// Marks read locally right away and tells the server when online
  /// (`POST /notifications/:id/read`, contract §11). Notifications are not an
  /// outbox-tier entity, so the server call is best-effort.
  Future<void> markRead(AppNotification n) async {
    if (n.isRead) return;
    await _ref.read(localStoreProvider).upsert(Collections.notifications, n.copyWith(readAt: DateTime.now().toUtc()));
    if (!_ref.read(isOnlineProvider)) return;
    try {
      await _ref.read(apiClientProvider).post('/notifications/${n.id}/read');
    } catch (_) {}
  }

  Future<void> markAllRead(List<AppNotification> all) async {
    final store = _ref.read(localStoreProvider);
    final now = DateTime.now().toUtc();
    await store.upsertAll(Collections.notifications, [for (final n in all) if (!n.isRead) n.copyWith(readAt: now)]);
    if (!_ref.read(isOnlineProvider)) return;
    try {
      await _ref.read(apiClientProvider).post('/notifications/read-all');
    } catch (_) {}
  }
}

final notificationActionsProvider = Provider<NotificationActions>(NotificationActions.new);
