import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:local_db/local_db.dart';

import '../features/deliveries/data/deliveries_providers.dart';
import 'providers.dart';

/// Bottom-navigation scaffold shared by Home, Deliveries and Profile, with the
/// global [ConnectivityBanner] pinned above the content.
class RiderShell extends ConsumerWidget {
  const RiderShell({super.key, required this.navigationShell});

  final StatefulNavigationShell navigationShell;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final engine = ref.watch(syncEngineProvider);
    final offers = ref.watch(offeredDeliveriesProvider).length;
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
          Expanded(child: navigationShell),
        ],
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: navigationShell.currentIndex,
        onDestinationSelected: (i) {
          HapticFeedback.selectionClick();
          navigationShell.goBranch(i, initialLocation: i == navigationShell.currentIndex);
        },
        destinations: [
          NavigationDestination(
            icon: Badge.count(count: offers, isLabelVisible: offers > 0, child: const Icon(Icons.home_outlined)),
            selectedIcon: Badge.count(count: offers, isLabelVisible: offers > 0, child: const Icon(Icons.home_rounded)),
            label: 'Home',
          ),
          const NavigationDestination(
            icon: Icon(Icons.local_shipping_outlined),
            selectedIcon: Icon(Icons.local_shipping_rounded),
            label: 'Deliveries',
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
