import 'package:flutter/material.dart';

import '../tokens/app_radius.dart';
import '../tokens/app_spacing.dart';
import 'animated_pressable.dart';

/// Surface container with our radius and outline. Tappable when [onTap] is
/// set (scales on press).
class AppCard extends StatelessWidget {
  const AppCard({
    super.key,
    required this.child,
    this.onTap,
    this.onLongPress,
    this.padding = AppSpacing.card,
    this.margin = EdgeInsets.zero,
    this.color,
    this.borderRadius = AppRadius.mdAll,
    this.elevated = false,
    this.outlined = true,
    this.clipBehavior = Clip.antiAlias,
  });

  final Widget child;
  final VoidCallback? onTap;
  final VoidCallback? onLongPress;
  final EdgeInsetsGeometry padding;
  final EdgeInsetsGeometry margin;
  final Color? color;
  final BorderRadius borderRadius;

  /// Soft shadow instead of a flat surface.
  final bool elevated;
  final bool outlined;
  final Clip clipBehavior;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    Widget card = Container(
      margin: margin,
      clipBehavior: clipBehavior,
      decoration: BoxDecoration(
        color: color ?? scheme.surface,
        borderRadius: borderRadius,
        border: outlined ? Border.all(color: scheme.outlineVariant) : null,
        boxShadow: elevated
            ? [
                BoxShadow(
                  color: scheme.shadow.withValues(alpha: 0.10),
                  blurRadius: 24,
                  offset: const Offset(0, 10),
                ),
              ]
            : null,
      ),
      child: Padding(padding: padding, child: child),
    );
    if (onTap == null && onLongPress == null) return card;
    return AnimatedPressable(
      onTap: onTap,
      onLongPress: onLongPress,
      borderRadius: borderRadius,
      child: card,
    );
  }
}
