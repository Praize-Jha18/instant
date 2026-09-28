import 'package:core_models/core_models.dart';
import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../app/session.dart';
import '../../../core/widgets/app_page.dart';

/// Shown while the vendor is `pending`. The owner can already complete the
/// profile and add draft products; the router lets `/products` and `/settings`
/// through in this state.
class AwaitingApprovalScreen extends ConsumerWidget {
  const AwaitingApprovalScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final session = ref.watch(sessionProvider);
    final vendor = session.vendor;
    final theme = Theme.of(context);
    final semantic = context.semanticColors;
    return AppPage(
      title: vendor?.name ?? 'Your store',
      actions: [
        IconButton(
          tooltip: 'Sign out',
          icon: const Icon(Icons.logout_rounded),
          onPressed: () => ref.read(sessionProvider.notifier).logout(),
        ),
      ],
      body: RefreshIndicator(
        onRefresh: () => ref.read(sessionProvider.notifier).refreshVendor(),
        child: ListView(
          padding: AppSpacing.page,
          children: [
            AppCard(
              color: semantic.warningContainer,
              outlined: false,
              child: Row(
                children: [
                  Icon(Icons.hourglass_top_rounded, color: semantic.onWarningContainer, size: 32),
                  const SizedBox(width: AppSpacing.lg),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Awaiting platform approval',
                            style: theme.textTheme.titleMedium?.copyWith(color: semantic.onWarningContainer)),
                        const SizedBox(height: AppSpacing.xs),
                        Text(
                          'An admin will review your store shortly. Meanwhile you can complete your profile and add products as drafts; they go live once you are approved.',
                          style: theme.textTheme.bodyMedium?.copyWith(color: semantic.onWarningContainer),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            AppSpacing.gapXl,
            const SectionHeader(title: 'Get ready', padding: EdgeInsets.only(bottom: AppSpacing.sm)),
            AppCard(
              padding: EdgeInsets.zero,
              child: Column(
                children: [
                  AppListTile(
                    leadingIcon: Icons.storefront_outlined,
                    title: 'Complete your store profile',
                    subtitle: _profileHint(vendor),
                    onTap: () => context.go('/settings'),
                  ),
                  const Divider(),
                  AppListTile(
                    leadingIcon: Icons.inventory_2_outlined,
                    title: 'Add products',
                    subtitle: 'Create drafts now and publish after approval',
                    onTap: () => context.go('/products'),
                  ),
                ],
              ),
            ),
            AppSpacing.gapXl,
            Center(
              child: Text('Pull down to check your status', style: theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.onSurfaceVariant)),
            ),
          ],
        ),
      ),
    );
  }

  String _profileHint(Vendor? vendor) {
    if (vendor == null) return 'Description, address, delivery fees and hours';
    final missing = <String>[
      if ((vendor.description ?? '').isEmpty) 'description',
      if (vendor.address == null) 'address',
      if (vendor.deliveryFee == null) 'delivery fee',
      if (vendor.openingHours.isEmpty) 'opening hours',
      if (vendor.payout == null) 'bank account',
    ];
    return missing.isEmpty ? 'Looks complete' : 'Missing: ${missing.join(', ')}';
  }
}
