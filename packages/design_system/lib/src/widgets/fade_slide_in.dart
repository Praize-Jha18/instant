import 'package:flutter/material.dart';

import '../tokens/app_motion.dart';

/// Fades and slides its child in once when first built. Use [delay] (or
/// [FadeSlideIn.staggered]) to cascade list items.
class FadeSlideIn extends StatefulWidget {
  const FadeSlideIn({
    super.key,
    required this.child,
    this.delay = Duration.zero,
    this.duration = AppMotion.slow,
    this.offset = const Offset(0, 0.08),
    this.curve = AppMotion.curve,
    this.enabled = true,
  });

  /// Convenience for lists: `delay = index * AppMotion.stagger` (capped).
  FadeSlideIn.staggered({
    Key? key,
    required int index,
    required Widget child,
    int maxStagger = 8,
    Duration duration = AppMotion.slow,
    Offset offset = const Offset(0, 0.08),
  }) : this(
          key: key,
          child: child,
          delay: AppMotion.stagger * index.clamp(0, maxStagger),
          duration: duration,
          offset: offset,
        );

  final Widget child;
  final Duration delay;
  final Duration duration;

  /// Start offset as a fraction of the child's size.
  final Offset offset;
  final Curve curve;

  /// When false the child is shown immediately (e.g. reduced motion).
  final bool enabled;

  @override
  State<FadeSlideIn> createState() => _FadeSlideInState();
}

class _FadeSlideInState extends State<FadeSlideIn> with SingleTickerProviderStateMixin {
  late final AnimationController _controller =
      AnimationController(vsync: this, duration: widget.duration);
  late final Animation<double> _fade =
      CurvedAnimation(parent: _controller, curve: widget.curve);
  late final Animation<Offset> _slide =
      Tween<Offset>(begin: widget.offset, end: Offset.zero).animate(_fade);

  @override
  void initState() {
    super.initState();
    if (!widget.enabled) {
      _controller.value = 1;
      return;
    }
    if (widget.delay == Duration.zero) {
      _controller.forward();
    } else {
      Future<void>.delayed(widget.delay, () {
        if (mounted) _controller.forward();
      });
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final reduce = MediaQuery.maybeDisableAnimationsOf(context) ?? false;
    if (reduce) return widget.child;
    return FadeTransition(
      opacity: _fade,
      child: SlideTransition(position: _slide, child: widget.child),
    );
  }
}
