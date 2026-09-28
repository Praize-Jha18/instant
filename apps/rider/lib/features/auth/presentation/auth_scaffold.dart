import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';

/// Shared layout for the sign-in / register screens.
class AuthScaffold extends StatelessWidget {
  const AuthScaffold({
    super.key,
    required this.title,
    required this.subtitle,
    required this.child,
    this.showBack = false,
  });

  final String title;
  final String subtitle;
  final Widget child;
  final bool showBack;

  @override
  Widget build(BuildContext context) {
    final scheme = context.colors;
    return Scaffold(
      appBar: showBack ? AppBar() : null,
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 480),
            child: ListView(
              padding: const EdgeInsets.fromLTRB(AppSpacing.lg, AppSpacing.xxl, AppSpacing.lg, AppSpacing.xxl),
              children: [
                FadeSlideIn(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: 56,
                        height: 56,
                        decoration: BoxDecoration(color: scheme.primaryContainer, borderRadius: AppRadius.mdAll),
                        child: Icon(Icons.two_wheeler_rounded, color: scheme.onPrimaryContainer, size: 30),
                      ),
                      AppSpacing.gapXl,
                      Text(title, style: context.text.headlineMedium),
                      AppSpacing.gapSm,
                      Text(subtitle, style: context.text.bodyLarge?.copyWith(color: scheme.onSurfaceVariant)),
                    ],
                  ),
                ),
                AppSpacing.gapXxl,
                FadeSlideIn(delay: AppMotion.stagger * 2, child: child),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
