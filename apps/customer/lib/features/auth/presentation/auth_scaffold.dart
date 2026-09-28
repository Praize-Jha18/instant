import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';

/// Shared layout for the auth screens: title, subtitle and a centred column.
class AuthScaffold extends StatelessWidget {
  const AuthScaffold({
    super.key,
    required this.title,
    required this.subtitle,
    required this.children,
    this.showBack = false,
  });

  final String title;
  final String subtitle;
  final List<Widget> children;
  final bool showBack;

  @override
  Widget build(BuildContext context) {
    final scheme = context.colors;
    return Scaffold(
      appBar: showBack ? AppBar() : null,
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 440),
            child: ListView(
              padding: const EdgeInsets.fromLTRB(AppSpacing.xl, AppSpacing.xl, AppSpacing.xl, AppSpacing.xxl),
              children: [
                FadeSlideIn(
                  child: Container(
                    width: 56,
                    height: 56,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(color: scheme.primaryContainer, borderRadius: AppRadius.mdAll),
                    child: Icon(Icons.bolt_rounded, color: scheme.onPrimaryContainer, size: 32),
                  ),
                ),
                const SizedBox(height: AppSpacing.xl),
                FadeSlideIn.staggered(index: 1, child: Text(title, style: context.text.headlineMedium)),
                const SizedBox(height: AppSpacing.sm),
                FadeSlideIn.staggered(
                  index: 2,
                  child: Text(subtitle, style: context.text.bodyLarge?.copyWith(color: scheme.onSurfaceVariant)),
                ),
                const SizedBox(height: AppSpacing.xxl),
                for (var i = 0; i < children.length; i++) FadeSlideIn.staggered(index: i + 3, child: children[i]),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// Inline error banner for forms.
class FormErrorBanner extends StatelessWidget {
  const FormErrorBanner({super.key, required this.message});
  final String? message;

  @override
  Widget build(BuildContext context) {
    final semantic = context.semanticColors;
    return AnimatedSize(
      duration: AppMotion.normal,
      curve: AppMotion.curve,
      alignment: Alignment.topCenter,
      child: message == null
          ? const SizedBox(width: double.infinity)
          : Container(
              width: double.infinity,
              margin: const EdgeInsets.only(bottom: AppSpacing.lg),
              padding: const EdgeInsets.all(AppSpacing.md),
              decoration: BoxDecoration(color: semantic.dangerContainer, borderRadius: AppRadius.smAll),
              child: Row(
                children: [
                  Icon(Icons.error_outline_rounded, color: semantic.onDangerContainer, size: 20),
                  const SizedBox(width: AppSpacing.sm),
                  Expanded(
                    child: Text(message!, style: context.text.bodyMedium?.copyWith(color: semantic.onDangerContainer)),
                  ),
                ],
              ),
            ),
    );
  }
}
