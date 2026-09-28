import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../app/config.dart';
import '../../../app/providers.dart';
import '../../../app/routes.dart';
import '../../../app/theme_mode_controller.dart';
import '../../addresses/data/address_providers.dart';
import '../../auth/domain/session_state.dart';
import '../../auth/presentation/session_controller.dart';
import 'notification_providers.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final session = ref.watch(sessionControllerProvider);
    final user = session is SignedIn ? session.user : null;
    final offlineSession = session is SignedIn && session.offline;
    final addresses = ref.watch(addressesProvider).value ?? const [];
    final unread = ref.watch(unreadNotificationCountProvider);
    final mode = ref.watch(themeModeProvider);
    final status = ref.watch(syncStatusProvider).value;
    final config = ref.watch(appConfigProvider);
    final scheme = context.colors;

    final initials = (user?.fullName ?? '?')
        .split(' ')
        .where((p) => p.isNotEmpty)
        .take(2)
        .map((p) => p[0].toUpperCase())
        .join();

    return Scaffold(
      appBar: AppBar(title: const Text('Profile')),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(AppSpacing.lg, AppSpacing.sm, AppSpacing.lg, AppSpacing.xxl),
        children: [
          FadeSlideIn(
            child: AppCard(
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 28,
                    backgroundColor: scheme.primaryContainer,
                    foregroundColor: scheme.onPrimaryContainer,
                    child: Text(initials, style: context.text.titleLarge?.copyWith(color: scheme.onPrimaryContainer)),
                  ),
                  const SizedBox(width: AppSpacing.lg),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(user?.fullName ?? '', style: context.text.titleMedium),
                        Text(user?.email ?? '', style: context.text.bodyMedium?.copyWith(color: scheme.onSurfaceVariant)),
                        if (user?.phone != null)
                          Text(user!.phone!, style: context.text.bodySmall?.copyWith(color: scheme.onSurfaceVariant)),
                        if (offlineSession) ...[
                          const SizedBox(height: AppSpacing.xs),
                          const StatusChip(label: 'Offline session', tone: StatusTone.warning, dense: true),
                        ],
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.lg),
          FadeSlideIn.staggered(
            index: 1,
            child: AppCard(
              padding: EdgeInsets.zero,
              child: Column(
                children: [
                  AppListTile(
                    leadingIcon: Icons.location_on_outlined,
                    title: 'Addresses',
                    subtitle: addresses.isEmpty ? 'Add a delivery address' : '${addresses.length} saved',
                    onTap: () => context.push(AppRoutes.addresses),
                  ),
                  const Divider(indent: AppSpacing.lg, endIndent: AppSpacing.lg),
                  AppListTile(
                    leadingIcon: Icons.notifications_none_rounded,
                    title: 'Notifications',
                    subtitle: unread == 0 ? 'You are all caught up' : '$unread unread',
                    trailing: unread == 0 ? null : Badge.count(count: unread),
                    onTap: () => context.push(AppRoutes.notifications),
                  ),
                  const Divider(indent: AppSpacing.lg, endIndent: AppSpacing.lg),
                  AppListTile(
                    leadingIcon: Icons.receipt_long_outlined,
                    title: 'Orders',
                    onTap: () => context.go(AppRoutes.orders),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.lg),
          FadeSlideIn.staggered(
            index: 2,
            child: AppCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Appearance', style: context.text.titleSmall),
                  const SizedBox(height: AppSpacing.md),
                  SegmentedButton<ThemeMode>(
                    segments: const [
                      ButtonSegment(value: ThemeMode.system, label: Text('System'), icon: Icon(Icons.brightness_auto_rounded)),
                      ButtonSegment(value: ThemeMode.light, label: Text('Light'), icon: Icon(Icons.light_mode_outlined)),
                      ButtonSegment(value: ThemeMode.dark, label: Text('Dark'), icon: Icon(Icons.dark_mode_outlined)),
                    ],
                    selected: {mode},
                    onSelectionChanged: (s) => ref.read(themeModeProvider.notifier).set(s.first),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.lg),
          FadeSlideIn.staggered(
            index: 3,
            child: AppCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Sync', style: context.text.titleSmall),
                  const SizedBox(height: AppSpacing.xs),
                  Text(
                    status == null
                        ? '—'
                        : status.isOffline
                            ? 'Offline · ${status.pendingCount} change${status.pendingCount == 1 ? '' : 's'} waiting'
                            : status.lastSyncedAt == null
                                ? 'Not synced yet'
                                : 'Last synced ${_ago(status.lastSyncedAt!)}'
                                    '${status.pendingCount > 0 ? ' · ${status.pendingCount} pending' : ''}',
                    style: context.text.bodyMedium?.copyWith(color: scheme.onSurfaceVariant),
                  ),
                  if ((status?.rejectedCount ?? 0) > 0)
                    Padding(
                      padding: const EdgeInsets.only(top: AppSpacing.xs),
                      child: Text('${status!.rejectedCount} change${status.rejectedCount == 1 ? '' : 's'} rejected by the server',
                          style: context.text.bodySmall?.copyWith(color: context.semanticColors.danger)),
                    ),
                  const SizedBox(height: AppSpacing.sm),
                  AppButton.ghost(
                    label: 'Sync now',
                    icon: Icons.sync_rounded,
                    size: AppButtonSize.small,
                    onPressed: () => ref.read(syncEngineProvider).requestSync(immediate: true),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.xl),
          FadeSlideIn.staggered(
            index: 4,
            child: AppButton.danger(
              label: 'Log out',
              icon: Icons.logout_rounded,
              expanded: true,
              onPressed: () async {
                final ok = await AppBottomSheet.confirm(
                  context,
                  title: 'Log out?',
                  message: 'Your cart and saved data on this device will be cleared.',
                  confirmLabel: 'Log out',
                  destructive: true,
                );
                if (ok) await ref.read(sessionControllerProvider.notifier).logout();
              },
            ),
          ),
          const SizedBox(height: AppSpacing.lg),
          Center(
            child: Text(
              'Instant customer · ${config.apiBaseUrl}',
              style: context.text.bodySmall?.copyWith(color: scheme.outline),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }

  String _ago(DateTime t) {
    final d = DateTime.now().difference(t.toLocal());
    if (d.inMinutes < 1) return 'just now';
    if (d.inMinutes < 60) return '${d.inMinutes} min ago';
    if (d.inHours < 24) return '${d.inHours} h ago';
    return '${d.inDays} d ago';
  }
}
