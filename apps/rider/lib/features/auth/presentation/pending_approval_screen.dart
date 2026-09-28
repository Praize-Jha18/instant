import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../app/providers.dart';
import '../../../core/errors.dart';
import '../../profile/data/vendor_lookup.dart';
import '../data/auth_controller.dart';
import '../data/rider_profile_provider.dart';

/// Shown while `riderProfiles.status == pending`. Pull to refresh re-fetches
/// the profile; realtime `changed` events on `riderProfiles` flow through the
/// store, so approval moves the rider to Home without any tap.
class PendingApprovalScreen extends ConsumerWidget {
  const PendingApprovalScreen({super.key});

  Future<void> _refresh(WidgetRef ref, BuildContext context) async {
    try {
      await ref.read(authControllerProvider.notifier).refreshProfile();
      await ref.read(syncEngineProvider).pull();
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(friendlyError(e))));
      }
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profile = ref.watch(currentRiderProfileProvider);
    final user = ref.watch(currentUserProvider);
    final vendorName = ref.watch(vendorNameProvider(profile?.vendorId ?? user?.vendorId)).value;
    final scheme = context.colors;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Account review'),
        actions: [
          TextButton(onPressed: () => ref.read(authControllerProvider.notifier).logout(), child: const Text('Sign out')),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () => _refresh(ref, context),
        child: ListView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: AppSpacing.page,
          children: [
            const SizedBox(height: AppSpacing.xxl),
            EmptyState(
              icon: Icons.hourglass_top_rounded,
              title: 'Waiting for vendor approval',
              message: vendorName != null
                  ? '$vendorName needs to approve your rider account. We will let you in the moment they do.'
                  : 'Your vendor needs to approve your rider account. We will let you in the moment they do.',
              action: AppButton.secondary(
                label: 'Check again',
                icon: Icons.refresh_rounded,
                onPressed: () => _refresh(ref, context),
              ),
            ),
            AppSpacing.gapXl,
            if (user != null)
              AppCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Signed in as', style: context.text.labelMedium?.copyWith(color: scheme.onSurfaceVariant)),
                    AppSpacing.gapXs,
                    Text(user.fullName, style: context.text.titleMedium),
                    Text(user.email, style: context.text.bodyMedium?.copyWith(color: scheme.onSurfaceVariant)),
                    if (profile != null) ...[
                      AppSpacing.gapMd,
                      Row(children: [StatusChip.rider(profile.status)]),
                    ],
                  ],
                ),
              ),
            AppSpacing.gapLg,
            Text(
              'Pull down to refresh.',
              textAlign: TextAlign.center,
              style: context.text.bodySmall?.copyWith(color: scheme.onSurfaceVariant),
            ),
          ],
        ),
      ),
    );
  }
}
