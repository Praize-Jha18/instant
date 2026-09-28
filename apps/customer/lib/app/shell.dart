import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:local_db/local_db.dart';

import '../features/cart/presentation/cart_providers.dart';
import '../features/cart/presentation/widgets/cart_badge.dart';
import 'providers.dart';

/// Bottom-navigation shell with the global connectivity banner on top.
class AppShell extends ConsumerWidget {
  const AppShell({super.key, required this.navigationShell});

  final StatefulNavigationShell navigationShell;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final engine = ref.watch(syncEngineProvider);
    final status = ref.watch(syncStatusProvider).value;
    final bannerVisible = status != null &&
        (status.isOffline || status.isSyncing || status.phase == SyncPhase.error || status.hasPending);
    final cartCount = ref.watch(cartCountProvider);

    return Scaffold(
      body: Column(
        children: [
          ConnectivityBanner.stream<SyncStatus>(
            stream: engine.status,
            initialData: engine.currentStatus,
            offline: (s) => s.isOffline,
            pendingCount: (s) => s.pendingCount,
            syncing: (s) => s.isSyncing,
            error: (s) => s.phase == SyncPhase.error,
            onRetry: () => engine.requestSync(immediate: true),
          ),
          Expanded(
            // The banner already consumed the status-bar inset.
            child: MediaQuery.removePadding(
              context: context,
              removeTop: bannerVisible,
              child: navigationShell,
            ),
          ),
        ],
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: navigationShell.currentIndex,
        animationDuration: AppMotion.slow,
        onDestinationSelected: (index) => navigationShell.goBranch(
          index,
          initialLocation: index == navigationShell.currentIndex,
        ),
        destinations: [
          const NavigationDestination(
            icon: Icon(Icons.storefront_outlined),
            selectedIcon: Icon(Icons.storefront_rounded),
            label: 'Home',
          ),
          const NavigationDestination(
            icon: Icon(Icons.search_rounded),
            selectedIcon: Icon(Icons.saved_search_rounded),
            label: 'Search',
          ),
          NavigationDestination(
            icon: CartBadge(count: cartCount, child: const Icon(Icons.shopping_bag_outlined)),
            selectedIcon: CartBadge(count: cartCount, child: const Icon(Icons.shopping_bag_rounded)),
            label: 'Cart',
          ),
          const NavigationDestination(
            icon: Icon(Icons.receipt_long_outlined),
            selectedIcon: Icon(Icons.receipt_long_rounded),
            label: 'Orders',
          ),
          const NavigationDestination(
            icon: Icon(Icons.person_outline_rounded),
            selectedIcon: Icon(Icons.person_rounded),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}
