import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../app/providers.dart';
import '../data/auth_controller.dart';

/// Blocked screen for `riderProfiles.status == suspended`.
class SuspendedScreen extends ConsumerWidget {
  const SuspendedScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(title: const Text('Account suspended')),
      body: RefreshIndicator(
        onRefresh: () async {
          await ref.read(authControllerProvider.notifier).refreshProfile();
          await ref.read(syncEngineProvider).pull();
        },
        child: ListView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: AppSpacing.page,
          children: [
            const SizedBox(height: AppSpacing.xxl),
            ErrorState(
              icon: Icons.block_rounded,
              title: 'Your rider account is suspended',
              message: 'You cannot go online or receive deliveries right now. '
                  'Contact your vendor to have your account reinstated.',
              onRetry: () => ref.read(authControllerProvider.notifier).logout(),
              retryLabel: 'Sign out',
            ),
          ],
        ),
      ),
    );
  }
}
