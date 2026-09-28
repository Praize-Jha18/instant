import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../tokens/app_motion.dart';

/// Scales its child down while pressed and optionally fires haptics on tap.
/// Use it to make cards, tiles and custom controls feel tactile.
class AnimatedPressable extends StatefulWidget {
  const AnimatedPressable({
    super.key,
    required this.child,
    this.onTap,
    this.onLongPress,
    this.pressedScale = 0.97,
    this.duration = AppMotion.fast,
    this.haptic = false,
    this.enabled = true,
    this.borderRadius,
    this.semanticLabel,
  });

  final Widget child;
  final VoidCallback? onTap;
  final VoidCallback? onLongPress;

  /// Scale while pressed (1.0 disables the effect).
  final double pressedScale;
  final Duration duration;

  /// Fire [HapticFeedback.lightImpact] on tap.
  final bool haptic;
  final bool enabled;

  /// Clip radius for the ripple, if any.
  final BorderRadius? borderRadius;
  final String? semanticLabel;

  @override
  State<AnimatedPressable> createState() => _AnimatedPressableState();
}

class _AnimatedPressableState extends State<AnimatedPressable> {
  bool _pressed = false;

  bool get _interactive => widget.enabled && (widget.onTap != null || widget.onLongPress != null);

  void _set(bool v) {
    if (_pressed != v && mounted) setState(() => _pressed = v);
  }

  @override
  Widget build(BuildContext context) {
    final scale = _pressed && _interactive ? widget.pressedScale : 1.0;
    return Semantics(
      button: _interactive,
      label: widget.semanticLabel,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTapDown: _interactive ? (_) => _set(true) : null,
        onTapUp: _interactive ? (_) => _set(false) : null,
        onTapCancel: _interactive ? () => _set(false) : null,
        onTap: _interactive
            ? () {
                if (widget.haptic) HapticFeedback.lightImpact();
                widget.onTap?.call();
              }
            : null,
        onLongPress: _interactive ? widget.onLongPress : null,
        child: AnimatedScale(
          scale: scale,
          duration: widget.duration,
          curve: AppMotion.curve,
          child: AnimatedOpacity(
            opacity: widget.enabled ? 1 : 0.5,
            duration: widget.duration,
            child: widget.child,
          ),
        ),
      ),
    );
  }
}
