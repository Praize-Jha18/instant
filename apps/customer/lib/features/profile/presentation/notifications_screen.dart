import 'package:core_models/core_models.dart';
import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../app/providers.dart';
import '../../../app/routes.dart';
import '../../../core/errors.dart';
import '../../../core/formatters.dart';
import '../../../core/widgets/list_phase.dart';
import 'notification_providers.dart';

class NotificationsScreen extends ConsumerWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final async = ref.watch(notificationsProvider);
    final items = async.value ?? const <AppNotification>[];
    final status = ref.watch(syncStatusProvider).value;
    final engine = ref.watch(syncEngineProvider);
    final actions = ref.read(notificationActionsProvider);
    final scheme = context.colors;
    final phase = async.isLoading && !async.hasValue ? ListPhase.loading : resolveListPhase(count: items.length, status: status);

    Future<void> refresh() async {
      try {
        await engine.pull(only: const [Collections.notifications]);
      } catch (e) {
        if (context.mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(describeError(e))));
      }
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Notifications'),
        actions: [
          if (items.any((n) => !n.isRead))
            TextButton(onPressed: () => actions.markAllRead(items), child: const Text('Mark all read')),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: refresh,
        child: PhaseView(
          phase: phase,
          onRetry: refresh,
          emptyIcon: Icons.notifications_none_rounded,
          emptyTitle: 'Nothing here yet',
          emptyMessage: 'Order updates and offers will appear here.',
          loading: (_) => const SkeletonList(itemCount: 5),
          ready: (_) => ListView.separated(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
            itemCount: items.length,
            separatorBuilder: (_, _) => const Divider(indent: AppSpacing.lg, endIndent: AppSpacing.lg),
            itemBuilder: (context, i) {
              final n = items[i];
              return FadeSlideIn.staggered(
                index: i,
                child: AppListTile(
                  leading: Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: n.isRead ? scheme.surfaceContainerHighest : scheme.primaryContainer,
                      borderRadius: AppRadius.smAll,
                    ),
                    child: Icon(_iconFor(n.type), color: n.isRead ? scheme.onSurfaceVariant : scheme.onPrimaryContainer),
                  ),
                  title: n.title,
                  subtitle: '${n.body.isEmpty ? '' : '${n.body}\n'}${formatRelative(n.createdAt)}',
                  showChevron: false,
                  trailing: n.isRead
                      ? null
                      : Container(width: 8, height: 8, decoration: BoxDecoration(color: scheme.primary, shape: BoxShape.circle)),
                  onTap: () {
                    actions.markRead(n);
                    final orderId = n.data['orderId']?.toString();
                    if (orderId != null && orderId.isNotEmpty) context.push(AppRoutes.order(orderId));
                  },
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  IconData _iconFor(String type) {
    final t = type.toLowerCase();
    if (t.contains('deliver')) return Icons.delivery_dining_rounded;
    if (t.contains('order')) return Icons.receipt_long_rounded;
    if (t.contains('pay')) return Icons.payment_rounded;
    return Icons.notifications_rounded;
  }
}
