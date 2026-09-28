import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../app/session.dart';

class _Blocked extends ConsumerWidget {
  const _Blocked({required this.icon, required this.title, required this.message});
  final IconData icon;
  final String title;
  final String message;

  @override
  Widget build(BuildContext context, WidgetRef ref) => Scaffold(
        body: SafeArea(
          child: EmptyState(
            icon: icon,
            title: title,
            message: message,
            action: AppButton.secondary(
              label: 'Sign out',
              icon: Icons.logout_rounded,
              onPressed: () => ref.read(sessionProvider.notifier).logout(),
            ),
          ),
        ),
      );
}

class SuspendedScreen extends StatelessWidget {
  const SuspendedScreen({super.key});

  @override
  Widget build(BuildContext context) => const _Blocked(
        icon: Icons.block_rounded,
        title: 'Your store is suspended',
        message: 'The platform team has suspended this vendor account. Contact support to resolve it.',
      );
}

class NoAccessScreen extends StatelessWidget {
  const NoAccessScreen({super.key});

  @override
  Widget build(BuildContext context) => const _Blocked(
        icon: Icons.no_accounts_outlined,
        title: 'No vendor or admin role',
        message: 'This account has no vendor or admin access. Sign in with a vendor account or register a store.',
      );
}
