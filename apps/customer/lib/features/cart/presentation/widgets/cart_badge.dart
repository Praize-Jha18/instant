import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';

/// Icon with a count badge that pops whenever the count changes.
class CartBadge extends StatefulWidget {
  const CartBadge({super.key, required this.count, required this.child});

  final int count;
  final Widget child;

  @override
  State<CartBadge> createState() => _CartBadgeState();
}

class _CartBadgeState extends State<CartBadge> with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(vsync: this, duration: AppMotion.slow);

  @override
  void didUpdateWidget(covariant CartBadge oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.count != widget.count && widget.count > 0) {
      _controller.forward(from: 0);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final scale = TweenSequence<double>([
      TweenSequenceItem(tween: Tween(begin: 1, end: 1.35), weight: 40),
      TweenSequenceItem(tween: Tween(begin: 1.35, end: 1), weight: 60),
    ]).animate(CurvedAnimation(parent: _controller, curve: AppMotion.curve));

    return Badge.count(
      count: widget.count,
      isLabelVisible: widget.count > 0,
      child: ScaleTransition(scale: scale, child: widget.child),
    );
  }
}
