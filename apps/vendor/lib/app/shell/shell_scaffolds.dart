import 'package:core_models/core_models.dart';
import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:local_db/local_db.dart';

import '../../features/orders/presentation/new_order_alerts.dart';
import '../../features/riders/data/rider_locations.dart';
import '../providers.dart';
import '../router.dart';
import '../session.dart';
import 'app_shell.dart';

/// Connectivity banner wired to the session's sync engine.
class SyncBanner extends ConsumerWidget {
  const SyncBanner({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final engine = ref.watch(syncEngineProvider);
    if (engine == null) return const SizedBox.shrink();
    return ConnectivityBanner.stream<SyncStatus>(
      stream: engine.status,
      initialData: engine.currentStatus,
      offline: (s) => s.isOffline,
      pendingCount: (s) => s.pendingCount,
      syncing: (s) => s.isSyncing,
      error: (s) => s.phase == SyncPhase.error || s.rejectedCount > 0,
      onRetry: () => engine.requestSync(immediate: true),
    );
  }
}

/// Theme toggle + sign out, used in the rail footer on wide layouts.
class RailFooter extends ConsumerWidget {
  const RailFooter({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final mode = ref.watch(themeModeProvider);
    final dark = mode == ThemeMode.dark || (mode == ThemeMode.system && Theme.of(context).brightness == Brightness.dark);
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        IconButton(
          tooltip: dark ? 'Light mode' : 'Dark mode',
          icon: Icon(dark ? Icons.light_mode_outlined : Icons.dark_mode_outlined),
          onPressed: () => ref.read(themeModeProvider.notifier).set(dark ? ThemeMode.light : ThemeMode.dark),
        ),
        IconButton(
          tooltip: 'Sign out',
          icon: const Icon(Icons.logout_rounded),
          onPressed: () async {
            final ok = await AppBottomSheet.confirm(context, title: 'Sign out?', confirmLabel: 'Sign out');
            if (ok) await ref.read(sessionProvider.notifier).logout();
          },
        ),
      ],
    );
  }
}

class VendorShellScaffold extends ConsumerWidget {
  const VendorShellScaffold({super.key, required this.navigationShell});

  final StatefulNavigationShell navigationShell;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Keep the app-wide watchers alive while the vendor shell is mounted.
    ref.watch(newOrderAlertsProvider);
    ref.watch(riderLocationsProvider);
    ref.watch(deliveryRoomsProvider);

    final pending = ref.watch(sessionProvider.select((s) => s.vendorStatus == VendorStatus.pending));
    final unseenOrders = ref.watch(newOrderAlertsProvider.select((s) => s.unseen));

    final destinations = pending
        ? const [
            ShellDestination(label: 'Approval', icon: Icons.hourglass_top_rounded, branch: VendorBranch.approval),
            ShellDestination(
                label: 'Products',
                icon: Icons.inventory_2_outlined,
                selectedIcon: Icons.inventory_2,
                branch: VendorBranch.products),
            ShellDestination(
                label: 'Settings', icon: Icons.settings_outlined, selectedIcon: Icons.settings, branch: VendorBranch.settings),
          ]
        : const [
            ShellDestination(label: 'Home', icon: Icons.home_outlined, selectedIcon: Icons.home, branch: VendorBranch.dashboard),
            ShellDestination(
                label: 'Orders', icon: Icons.receipt_long_outlined, selectedIcon: Icons.receipt_long, branch: VendorBranch.orders),
            ShellDestination(
                label: 'Products',
                icon: Icons.inventory_2_outlined,
                selectedIcon: Icons.inventory_2,
                branch: VendorBranch.products),
            ShellDestination(
                label: 'Riders', icon: Icons.two_wheeler_outlined, selectedIcon: Icons.two_wheeler, branch: VendorBranch.riders),
            ShellDestination(
                label: 'Deliveries', icon: Icons.map_outlined, selectedIcon: Icons.map, branch: VendorBranch.deliveries, compact: false),
            ShellDestination(
                label: 'Finance',
                icon: Icons.account_balance_wallet_outlined,
                selectedIcon: Icons.account_balance_wallet,
                branch: VendorBranch.finance,
                compact: false),
            ShellDestination(
                label: 'Settings',
                icon: Icons.settings_outlined,
                selectedIcon: Icons.settings,
                branch: VendorBranch.settings,
                compact: false),
            ShellDestination(label: 'More', icon: Icons.more_horiz_rounded, branch: VendorBranch.more, isMore: true),
          ];

    return AppShell(
      destinations: destinations,
      currentBranch: navigationShell.currentIndex,
      onSelectBranch: (b) => navigationShell.goBranch(b, initialLocation: b == navigationShell.currentIndex),
      banner: const SyncBanner(),
      badges: {VendorBranch.orders: unseenOrders},
      railTrailing: const RailFooter(),
      child: navigationShell,
    );
  }
}

class AdminShellScaffold extends ConsumerWidget {
  const AdminShellScaffold({super.key, required this.navigationShell});

  final StatefulNavigationShell navigationShell;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    const destinations = [
      ShellDestination(label: 'Dashboard', icon: Icons.dashboard_outlined, selectedIcon: Icons.dashboard, branch: AdminBranch.dashboard),
      ShellDestination(label: 'Vendors', icon: Icons.storefront_outlined, selectedIcon: Icons.storefront, branch: AdminBranch.vendors),
      ShellDestination(label: 'Orders', icon: Icons.receipt_long_outlined, selectedIcon: Icons.receipt_long, branch: AdminBranch.orders),
      ShellDestination(label: 'Users', icon: Icons.people_outline, selectedIcon: Icons.people, branch: AdminBranch.users),
      ShellDestination(
          label: 'Payouts', icon: Icons.payments_outlined, selectedIcon: Icons.payments, branch: AdminBranch.payouts, compact: false),
      ShellDestination(
          label: 'Categories', icon: Icons.category_outlined, selectedIcon: Icons.category, branch: AdminBranch.categories, compact: false),
      ShellDestination(label: 'More', icon: Icons.more_horiz_rounded, branch: AdminBranch.more, isMore: true),
    ];
    return AppShell(
      destinations: destinations,
      currentBranch: navigationShell.currentIndex,
      onSelectBranch: (b) => navigationShell.goBranch(b, initialLocation: b == navigationShell.currentIndex),
      banner: const SyncBanner(),
      railTrailing: const RailFooter(),
      child: navigationShell,
    );
  }
}
