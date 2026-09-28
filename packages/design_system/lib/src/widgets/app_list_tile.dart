import 'package:flutter/material.dart';

import '../tokens/app_radius.dart';
import '../tokens/app_spacing.dart';
import 'animated_pressable.dart';

/// Themed list row: leading (icon or widget), title, subtitle, trailing
/// (chevron by default when tappable). Press feedback via [AnimatedPressable].
class AppListTile extends StatelessWidget {
  const AppListTile({
    super.key,
    required this.title,
    this.subtitle,
    this.leading,
    this.leadingIcon,
    this.trailing,
    this.onTap,
    this.showChevron = true,
    this.padding = AppSpacing.listItem,
    this.dense = false,
    this.selected = false,
    this.enabled = true,
  });

  final String title;
  final String? subtitle;
  final Widget? leading;
  final IconData? leadingIcon;
  final Widget? trailing;
  final VoidCallback? onTap;
  final bool showChevron;
  final EdgeInsetsGeometry padding;
  final bool dense;
  final bool selected;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final lead = leading ??
        (leadingIcon != null
            ? Container(
                width: dense ? 36 : 44,
                height: dense ? 36 : 44,
                decoration: BoxDecoration(color: scheme.surfaceContainerHighest, borderRadius: AppRadius.smAll),
                child: Icon(leadingIcon, color: scheme.onSurfaceVariant, size: dense ? 18 : 22),
              )
            : null);
    final trail = trailing ??
        (onTap != null && showChevron ? Icon(Icons.chevron_right_rounded, color: scheme.onSurfaceVariant) : null);

    final row = Container(
      padding: padding,
      decoration: BoxDecoration(
        color: selected ? scheme.primaryContainer.withValues(alpha: 0.4) : Colors.transparent,
        borderRadius: AppRadius.smAll,
      ),
      child: Row(
        children: [
          if (lead != null) ...[lead, const SizedBox(width: AppSpacing.md)],
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  title,
                  style: (dense ? theme.textTheme.bodyMedium : theme.textTheme.bodyLarge)
                      ?.copyWith(fontWeight: FontWeight.w500, color: enabled ? scheme.onSurface : scheme.onSurfaceVariant),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                if (subtitle != null)
                  Padding(
                    padding: const EdgeInsets.only(top: AppSpacing.xxs),
                    child: Text(
                      subtitle!,
                      style: (dense ? theme.textTheme.bodySmall : theme.textTheme.bodyMedium)
                          ?.copyWith(color: scheme.onSurfaceVariant),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
              ],
            ),
          ),
          if (trail != null) ...[const SizedBox(width: AppSpacing.sm), trail],
        ],
      ),
    );

    return AnimatedPressable(
      onTap: onTap,
      enabled: enabled,
      pressedScale: 0.985,
      borderRadius: AppRadius.smAll,
      child: row,
    );
  }
}
