import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../tokens/app_colors.dart';
import '../tokens/app_motion.dart';
import '../tokens/app_spacing.dart';

/// Visual variants of [AppButton].
enum AppButtonVariant { primary, secondary, ghost, danger }

/// Sizes of [AppButton].
enum AppButtonSize { small, medium, large }

/// The platform button: four variants, loading state and haptic feedback on
/// tap. Disabled when [onPressed] is null or [loading] is true.
class AppButton extends StatelessWidget {
  const AppButton({
    super.key,
    required this.label,
    this.onPressed,
    this.variant = AppButtonVariant.primary,
    this.size = AppButtonSize.medium,
    this.loading = false,
    this.icon,
    this.trailingIcon,
    this.expanded = false,
    this.haptic = true,
    this.tooltip,
  });

  const AppButton.primary({
    super.key,
    required this.label,
    this.onPressed,
    this.size = AppButtonSize.medium,
    this.loading = false,
    this.icon,
    this.trailingIcon,
    this.expanded = false,
    this.haptic = true,
    this.tooltip,
  }) : variant = AppButtonVariant.primary;

  const AppButton.secondary({
    super.key,
    required this.label,
    this.onPressed,
    this.size = AppButtonSize.medium,
    this.loading = false,
    this.icon,
    this.trailingIcon,
    this.expanded = false,
    this.haptic = true,
    this.tooltip,
  }) : variant = AppButtonVariant.secondary;

  const AppButton.ghost({
    super.key,
    required this.label,
    this.onPressed,
    this.size = AppButtonSize.medium,
    this.loading = false,
    this.icon,
    this.trailingIcon,
    this.expanded = false,
    this.haptic = false,
    this.tooltip,
  }) : variant = AppButtonVariant.ghost;

  const AppButton.danger({
    super.key,
    required this.label,
    this.onPressed,
    this.size = AppButtonSize.medium,
    this.loading = false,
    this.icon,
    this.trailingIcon,
    this.expanded = false,
    this.haptic = true,
    this.tooltip,
  }) : variant = AppButtonVariant.danger;

  final String label;
  final VoidCallback? onPressed;
  final AppButtonVariant variant;
  final AppButtonSize size;

  /// Shows a spinner in place of the icon and disables the button.
  final bool loading;
  final IconData? icon;
  final IconData? trailingIcon;

  /// Stretch to the parent's width.
  final bool expanded;

  /// Fire [HapticFeedback.mediumImpact] on tap (primary actions, §9).
  final bool haptic;

  /// Shown when the button is disabled (e.g. "You are offline").
  final String? tooltip;

  bool get _enabled => onPressed != null && !loading;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final semantic = context.semanticColors;
    final height = switch (size) {
      AppButtonSize.small => 40.0,
      AppButtonSize.medium => AppSpacing.tapTarget,
      AppButtonSize.large => 56.0,
    };
    final padding = switch (size) {
      AppButtonSize.small => const EdgeInsets.symmetric(horizontal: AppSpacing.md),
      AppButtonSize.medium => const EdgeInsets.symmetric(horizontal: AppSpacing.xl),
      AppButtonSize.large => const EdgeInsets.symmetric(horizontal: AppSpacing.xxl),
    };

    void handle() {
      if (haptic) HapticFeedback.mediumImpact();
      onPressed?.call();
    }

    final onTap = _enabled ? handle : null;
    final child = _Content(
      label: label,
      icon: icon,
      trailingIcon: trailingIcon,
      loading: loading,
      size: size,
    );

    final Widget button = switch (variant) {
      AppButtonVariant.primary => FilledButton(
          onPressed: onTap,
          style: FilledButton.styleFrom(minimumSize: Size(0, height), padding: padding),
          child: child,
        ),
      AppButtonVariant.secondary => OutlinedButton(
          onPressed: onTap,
          style: OutlinedButton.styleFrom(
            minimumSize: Size(0, height),
            padding: padding,
            foregroundColor: scheme.onSurface,
          ),
          child: child,
        ),
      AppButtonVariant.ghost => TextButton(
          onPressed: onTap,
          style: TextButton.styleFrom(minimumSize: Size(0, height), padding: padding),
          child: child,
        ),
      AppButtonVariant.danger => FilledButton(
          onPressed: onTap,
          style: FilledButton.styleFrom(
            minimumSize: Size(0, height),
            padding: padding,
            backgroundColor: semantic.danger,
            foregroundColor: semantic.onDanger,
            disabledBackgroundColor: semantic.danger.withValues(alpha: 0.35),
          ),
          child: child,
        ),
    };

    Widget result = AnimatedOpacity(
      opacity: loading ? 0.85 : 1,
      duration: AppMotion.fast,
      child: expanded ? SizedBox(width: double.infinity, child: button) : button,
    );
    if (tooltip != null && !_enabled) {
      result = Tooltip(message: tooltip!, child: result);
    }
    return result;
  }
}

class _Content extends StatelessWidget {
  const _Content({
    required this.label,
    required this.icon,
    required this.trailingIcon,
    required this.loading,
    required this.size,
  });

  final String label;
  final IconData? icon;
  final IconData? trailingIcon;
  final bool loading;
  final AppButtonSize size;

  @override
  Widget build(BuildContext context) {
    final iconSize = size == AppButtonSize.small ? 16.0 : 20.0;
    final leading = loading
        ? SizedBox.square(
            dimension: iconSize,
            child: CircularProgressIndicator.adaptive(
              strokeWidth: 2,
              valueColor: AlwaysStoppedAnimation(IconTheme.of(context).color ?? DefaultTextStyle.of(context).style.color),
            ),
          )
        : (icon != null ? Icon(icon, size: iconSize) : null);
    return AnimatedSize(
      duration: AppMotion.fast,
      curve: AppMotion.curve,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (leading != null) ...[leading, const SizedBox(width: AppSpacing.sm)],
          Flexible(child: Text(label, maxLines: 1, overflow: TextOverflow.ellipsis)),
          if (trailingIcon != null) ...[
            const SizedBox(width: AppSpacing.sm),
            Icon(trailingIcon, size: iconSize),
          ],
        ],
      ),
    );
  }
}
