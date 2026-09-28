import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../app/providers.dart';
import '../../../app/session.dart';
import '../../../core/widgets/app_page.dart';
import 'theme_mode_tile.dart';

/// Phone-only hub for the destinations that do not fit the bottom bar.
class MoreScreen extends ConsumerWidget {
  const MoreScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final session = ref.watch(sessionProvider);
    final pending = ref.watch(syncStatusProvider).value?.pendingCount ?? 0;
    return AppPage(
      title: 'More',
      body: ListView(
        padding: AppSpacing.page,
        children: [
          AppCard(
            padding: EdgeInsets.zero,
            child: Column(
              children: [
                AppListTile(leadingIcon: Icons.map_outlined, title: 'Deliveries map', subtitle: 'Live rider positions', onTap: () => context.go('/deliveries')),
                const Divider(),
                AppListTile(
                    leadingIcon: Icons.account_balance_wallet_outlined,
                    title: 'Finance',
                    subtitle: 'Ledger, balance and payouts',
                    onTap: () => context.go('/finance')),
                const Divider(),
                AppListTile(
                    leadingIcon: Icons.settings_outlined,
                    title: 'Settings',
                    subtitle: 'Store profile, address, hours, bank account',
                    onTap: () => context.go('/settings')),
              ],
            ),
          ),
          AppSpacing.gapLg,
          const AppCard(padding: EdgeInsets.zero, child: ThemeModeTile()),
          AppSpacing.gapLg,
          AppCard(
            padding: EdgeInsets.zero,
            child: Column(
              children: [
                AppListTile(
                  leadingIcon: Icons.sync_rounded,
                  title: 'Sync now',
                  subtitle: pending > 0 ? '$pending change${pending == 1 ? '' : 's'} waiting' : 'Everything is up to date',
                  showChevron: false,
                  onTap: () => ref.read(syncEngineProvider)?.requestSync(immediate: true),
                ),
                const Divider(),
                AppListTile(
                  leadingIcon: Icons.logout_rounded,
                  title: 'Sign out',
                  subtitle: session.user?.email,
                  showChevron: false,
                  onTap: () async {
                    final ok = await AppBottomSheet.confirm(context, title: 'Sign out?', confirmLabel: 'Sign out');
                    if (ok) await ref.read(sessionProvider.notifier).logout();
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
