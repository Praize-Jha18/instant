import 'package:flutter/material.dart';

import '../tokens/app_colors.dart';
import '../tokens/app_spacing.dart';
import 'app_button.dart';
import 'fade_slide_in.dart';

/// Error placeholder with a retry button. Pass [offline] to switch the copy
/// and icon to the connectivity variant.
class ErrorState extends StatelessWidget {
  const ErrorState({
    super.key,
    this.title,
    this.message,
    this.onRetry,
    this.retryLabel = 'Try again',
    this.offline = false,
    this.icon,
    this.compact = false,
  });

  final String? title;
  final String? message;
  final VoidCallback? onRetry;
  final String retryLabel;
  final bool offline;
  final IconData? icon;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final semantic = context.semanticColors;
    final resolvedTitle = title ?? (offline ? 'You are offline' : 'Something went wrong');
    final resolvedMessage = message ??
        (offline
            ? 'Check your connection. We will keep what you have and sync when you are back.'
            : 'Please try again in a moment.');
    final resolvedIcon = icon ?? (offline ? Icons.wifi_off_rounded : Icons.error_outline_rounded);
    final bg = offline ? semantic.warningContainer : semantic.dangerContainer;
    final fg = offline ? semantic.onWarningContainer : semantic.onDangerContainer;

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
                  decoration: BoxDecoration(color: bg, shape: BoxShape.circle),
                  child: Icon(resolvedIcon, size: compact ? 28 : 40, color: fg),
                ),
                SizedBox(height: compact ? AppSpacing.md : AppSpacing.xl),
                Text(resolvedTitle, style: theme.textTheme.titleMedium, textAlign: TextAlign.center),
                const SizedBox(height: AppSpacing.sm),
                Text(
                  resolvedMessage,
                  style: theme.textTheme.bodyMedium?.copyWith(color: theme.colorScheme.onSurfaceVariant),
                  textAlign: TextAlign.center,
                ),
                if (onRetry != null) ...[
                  const SizedBox(height: AppSpacing.xl),
                  AppButton.secondary(label: retryLabel, icon: Icons.refresh_rounded, onPressed: onRetry),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
