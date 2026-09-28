import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../app/config.dart';
import '../../../app/session.dart';
import '../../../core/widgets/app_page.dart';
import '../../settings/presentation/theme_mode_tile.dart';

class AdminMoreScreen extends ConsumerWidget {
  const AdminMoreScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final session = ref.watch(sessionProvider);
    final theme = Theme.of(context);
    return AppPage(
      title: 'More',
      body: ListView(
        padding: AppSpacing.page,
        children: [
          AppCard(
            padding: EdgeInsets.zero,
            child: Column(children: [
              AppListTile(leadingIcon: Icons.payments_outlined, title: 'Payouts', subtitle: 'Requested vendor payouts', onTap: () => context.go('/admin/payouts')),
              const Divider(),
              AppListTile(leadingIcon: Icons.category_outlined, title: 'Categories', subtitle: 'Catalogue taxonomy', onTap: () => context.go('/admin/categories')),
            ]),
          ),
          AppSpacing.gapLg,
          const AppCard(padding: EdgeInsets.zero, child: ThemeModeTile()),
          AppSpacing.gapLg,
          AppCard(
            padding: EdgeInsets.zero,
            child: AppListTile(
              leadingIcon: Icons.logout_rounded,
              title: 'Sign out',
              subtitle: session.user?.email,
              showChevron: false,
              onTap: () async {
                final ok = await AppBottomSheet.confirm(context, title: 'Sign out?', confirmLabel: 'Sign out');
                if (ok) await ref.read(sessionProvider.notifier).logout();
              },
            ),
          ),
          AppSpacing.gapXl,
          Center(
            child: Text('API ${AppConfig.apiBaseUrl}\nWS ${AppConfig.wsUrl}',
                textAlign: TextAlign.center, style: theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.onSurfaceVariant)),
          ),
        ],
      ),
    );
  }
}
