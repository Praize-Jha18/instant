import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final scheme = context.colors;
    return Scaffold(
      body: Center(
        child: FadeSlideIn(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 88,
                height: 88,
                decoration: BoxDecoration(color: scheme.primaryContainer, borderRadius: AppRadius.lgAll),
                child: Icon(Icons.two_wheeler_rounded, size: 44, color: scheme.onPrimaryContainer),
              ),
              AppSpacing.gapXl,
              Text('Instant Rider', style: context.text.headlineSmall),
              AppSpacing.gapSm,
              Text('Getting things ready…', style: context.text.bodyMedium?.copyWith(color: scheme.onSurfaceVariant)),
              AppSpacing.gapXl,
              const SizedBox(width: 120, child: LinearProgressIndicator(minHeight: 3)),
            ],
          ),
        ),
      ),
    );
  }
}
