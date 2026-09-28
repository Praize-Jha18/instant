import 'package:flutter/material.dart';

import '../tokens/app_spacing.dart';
import 'fade_slide_in.dart';

/// Centered illustration-less empty state with an optional action.
class EmptyState extends StatelessWidget {
  const EmptyState({
    super.key,
    required this.title,
    this.message,
    this.icon = Icons.inbox_outlined,
    this.action,
    this.compact = false,
  });

  final String title;
  final String? message;
  final IconData icon;

  /// Usually an [AppButton].
  final Widget? action;

  /// Smaller spacing for inline use inside cards.
  final bool compact;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    return Center(
      child: FadeSlideIn(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(compact ? AppSpacing.lg : AppSpacing.xxl),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 360),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: compact ? 56 : 80,
                  height: compact ? 56 : 80,
                  decoration: BoxDecoration(color: scheme.primaryContainer, shape: BoxShape.circle),
                  child: Icon(icon, size: compact ? 28 : 40, color: scheme.onPrimaryContainer),
                ),
                SizedBox(height: compact ? AppSpacing.md : AppSpacing.xl),
                Text(title, style: theme.textTheme.titleMedium, textAlign: TextAlign.center),
                if (message != null) ...[
                  const SizedBox(height: AppSpacing.sm),
                  Text(
                    message!,
                    style: theme.textTheme.bodyMedium?.copyWith(color: scheme.onSurfaceVariant),
                    textAlign: TextAlign.center,
                  ),
                ],
                if (action != null) ...[const SizedBox(height: AppSpacing.xl), action!],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
