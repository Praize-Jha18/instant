import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';

/// Full-screen "order placed" burst shown once after a successful payment.
class SuccessOverlay extends StatefulWidget {
  const SuccessOverlay({super.key, required this.onDone});
  final VoidCallback onDone;

  @override
  State<SuccessOverlay> createState() => _SuccessOverlayState();
}

class _SuccessOverlayState extends State<SuccessOverlay> with SingleTickerProviderStateMixin {
  late final AnimationController _controller =
      AnimationController(vsync: this, duration: const Duration(milliseconds: 1800));

  @override
  void initState() {
    super.initState();
    _controller.forward().whenComplete(() {
      if (mounted) widget.onDone();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final scheme = context.colors;
    final semantic = context.semanticColors;
    final pop = CurvedAnimation(parent: _controller, curve: const Interval(0, 0.35, curve: Curves.elasticOut));
    final fadeOut = CurvedAnimation(parent: _controller, curve: const Interval(0.75, 1, curve: Curves.easeIn));
    final ring = CurvedAnimation(parent: _controller, curve: const Interval(0.05, 0.6, curve: Curves.easeOutCubic));

    return AnimatedBuilder(
      animation: _controller,
      builder: (context, _) => IgnorePointer(
        child: Opacity(
          opacity: 1 - fadeOut.value,
          child: Container(
            color: scheme.surface.withValues(alpha: 0.92),
            alignment: Alignment.center,
            child: Stack(
              alignment: Alignment.center,
              children: [
                Transform.scale(
                  scale: 1 + ring.value * 1.8,
                  child: Container(
                    width: 96,
                    height: 96,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: semantic.success.withValues(alpha: (1 - ring.value) * 0.6), width: 3),
                    ),
                  ),
                ),
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Transform.scale(
                      scale: pop.value,
                      child: Container(
                        width: 96,
                        height: 96,
                        decoration: BoxDecoration(color: semantic.success, shape: BoxShape.circle),
                        child: Icon(Icons.check_rounded, size: 56, color: semantic.onSuccess),
                      ),
                    ),
                    const SizedBox(height: AppSpacing.xl),
                    Opacity(
                      opacity: ring.value,
                      child: Text('Order placed!', style: context.text.headlineSmall),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
