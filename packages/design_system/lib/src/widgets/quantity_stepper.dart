import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../tokens/app_motion.dart';
import '../tokens/app_radius.dart';
import '../tokens/app_spacing.dart';
import '../tokens/app_typography.dart';

/// `− 2 +` control for cart quantities. Fires selection haptics and clamps to
/// [min]/[max]. When [value] equals [min] and [onRemove] is set, the minus
/// button becomes a delete action.
class QuantityStepper extends StatelessWidget {
  const QuantityStepper({
    super.key,
    required this.value,
    required this.onChanged,
    this.min = 1,
    this.max = 99,
    this.onRemove,
    this.enabled = true,
    this.compact = false,
  });

  final int value;
  final ValueChanged<int> onChanged;
  final int min;
  final int max;
  final VoidCallback? onRemove;
  final bool enabled;
  final bool compact;

  void _set(int next) {
    if (next < min || next > max) return;
    HapticFeedback.selectionClick();
    onChanged(next);
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final size = compact ? 32.0 : 40.0;
    final atMin = value <= min;
    final atMax = value >= max;
    final showRemove = atMin && onRemove != null;

    return Container(
      decoration: BoxDecoration(
        color: scheme.surfaceContainerHighest.withValues(alpha: 0.6),
        borderRadius: AppRadius.pill,
        border: Border.all(color: scheme.outlineVariant.withValues(alpha: 0.6)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _StepButton(
            icon: showRemove ? Icons.delete_outline_rounded : Icons.remove_rounded,
            tooltip: showRemove ? 'Remove' : 'Decrease',
            size: size,
            onPressed: !enabled
                ? null
                : showRemove
                    ? () {
                        HapticFeedback.selectionClick();
                        onRemove!();
                      }
                    : atMin
                        ? null
                        : () => _set(value - 1),
            destructive: showRemove,
          ),
          AnimatedSwitcher(
            duration: AppMotion.fast,
            transitionBuilder: (child, anim) => FadeTransition(
              opacity: anim,
              child: ScaleTransition(scale: Tween(begin: 0.8, end: 1.0).animate(anim), child: child),
            ),
            child: SizedBox(
              key: ValueKey(value),
              width: compact ? 28 : 36,
              child: Text(
                '$value',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.titleSmall?.copyWith(fontFeatures: AppTypography.tabularFigures),
              ),
            ),
          ),
          _StepButton(
            icon: Icons.add_rounded,
            tooltip: 'Increase',
            size: size,
            onPressed: !enabled || atMax ? null : () => _set(value + 1),
          ),
        ],
      ),
    );
  }
}

class _StepButton extends StatelessWidget {
  const _StepButton({
    required this.icon,
    required this.tooltip,
    required this.size,
    required this.onPressed,
    this.destructive = false,
  });

  final IconData icon;
  final String tooltip;
  final double size;
  final VoidCallback? onPressed;
  final bool destructive;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return IconButton(
      tooltip: tooltip,
      onPressed: onPressed,
      iconSize: size * 0.5,
      padding: EdgeInsets.zero,
      constraints: BoxConstraints.tightFor(width: size + AppSpacing.xs, height: size),
      style: IconButton.styleFrom(
        shape: const CircleBorder(),
        foregroundColor: destructive ? scheme.error : scheme.onSurface,
      ),
      icon: Icon(icon),
    );
  }
}
