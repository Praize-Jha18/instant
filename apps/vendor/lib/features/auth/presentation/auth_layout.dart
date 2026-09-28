import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';

/// Centered card layout shared by login and registration.
class AuthLayout extends StatelessWidget {
  const AuthLayout({super.key, required this.title, this.subtitle, required this.child, this.maxWidth = 460});

  final String title;
  final String? subtitle;
  final Widget child;
  final double maxWidth;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: AppSpacing.page,
            child: ConstrainedBox(
              constraints: BoxConstraints(maxWidth: maxWidth),
              child: FadeSlideIn(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Row(
                      children: [
                        Container(
                          width: 44,
                          height: 44,
                          decoration: BoxDecoration(color: scheme.primary, borderRadius: AppRadius.smAll),
                          child: Icon(Icons.storefront_rounded, color: scheme.onPrimary),
                        ),
                        const SizedBox(width: AppSpacing.md),
                        Text('Instant Vendor', style: theme.textTheme.titleMedium),
                      ],
                    ),
                    AppSpacing.gapXl,
                    Text(title, style: theme.textTheme.headlineSmall),
                    if (subtitle != null) ...[
                      AppSpacing.gapXs,
                      Text(subtitle!, style: theme.textTheme.bodyMedium?.copyWith(color: scheme.onSurfaceVariant)),
                    ],
                    AppSpacing.gapXl,
                    child,
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

String? requiredField(String? v, [String label = 'This field']) =>
    (v == null || v.trim().isEmpty) ? '$label is required' : null;

String? emailValidator(String? v) {
  if (v == null || v.trim().isEmpty) return 'Email is required';
  if (!RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$').hasMatch(v.trim())) return 'Enter a valid email';
  return null;
}

String? passwordValidator(String? v) {
  if (v == null || v.isEmpty) return 'Password is required';
  if (v.length < 8) return 'At least 8 characters';
  return null;
}
