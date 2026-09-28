import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../app/session.dart';

class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({super.key});

  @override
  ConsumerState<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() => ref.read(sessionProvider.notifier).restore());
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Scaffold(
      body: Center(
        child: FadeSlideIn(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 72,
                height: 72,
                decoration: BoxDecoration(color: scheme.primary, borderRadius: AppRadius.lgAll),
                child: Icon(Icons.storefront_rounded, color: scheme.onPrimary, size: 36),
              ),
              AppSpacing.gapLg,
              Text('Instant Vendor', style: Theme.of(context).textTheme.titleLarge),
              AppSpacing.gapXl,
              const SizedBox(width: 120, child: LinearProgressIndicator()),
            ],
          ),
        ),
      ),
    );
  }
}
