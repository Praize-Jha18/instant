import 'package:flutter/material.dart';

import '../tokens/app_colors.dart';
import '../tokens/app_radius.dart';
import '../tokens/app_spacing.dart';

/// Shimmering placeholder block. Wrap several in a [SkeletonList] for lists.
class Skeleton extends StatefulWidget {
  const Skeleton({
    super.key,
    this.width,
    this.height = 16,
    this.borderRadius = AppRadius.smAll,
    this.animate = true,
  });

  /// A circle of [size].
  const Skeleton.circle({super.key, double size = 40, this.animate = true})
      : width = size,
        height = size,
        borderRadius = AppRadius.pill;

  /// A text line; [width] as a fraction is handled by the parent's constraints.
  const Skeleton.text({super.key, this.width, this.height = 14, this.animate = true})
      : borderRadius = const BorderRadius.all(Radius.circular(6));

  final double? width;
  final double height;
  final BorderRadius borderRadius;
  final bool animate;

  @override
  State<Skeleton> createState() => _SkeletonState();
}

class _SkeletonState extends State<Skeleton> with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 1400),
  );

  @override
  void initState() {
    super.initState();
    if (widget.animate) _controller.repeat();
  }

  @override
  void didUpdateWidget(covariant Skeleton oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.animate && !_controller.isAnimating) _controller.repeat();
    if (!widget.animate && _controller.isAnimating) _controller.stop();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final semantic = context.semanticColors;
    final reduce = MediaQuery.maybeDisableAnimationsOf(context) ?? false;
    return Semantics(
      label: 'Loading',
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, _) {
          final t = reduce ? 0.5 : _controller.value;
          return Container(
            width: widget.width,
            height: widget.height,
            decoration: BoxDecoration(
              borderRadius: widget.borderRadius,
              gradient: LinearGradient(
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
                stops: [
                  (t * 2 - 1).clamp(0.0, 1.0),
                  (t * 2 - 0.5).clamp(0.0, 1.0),
                  (t * 2).clamp(0.0, 1.0),
                ],
                colors: [semantic.skeletonBase, semantic.skeletonHighlight, semantic.skeletonBase],
              ),
            ),
          );
        },
      ),
    );
  }
}

/// A column of list-item skeletons (avatar + two lines) or a custom
/// [itemBuilder]. Drop-in while the first `LocalStore` snapshot loads.
class SkeletonList extends StatelessWidget {
  const SkeletonList({
    super.key,
    this.itemCount = 6,
    this.itemBuilder,
    this.padding = AppSpacing.page,
    this.spacing = AppSpacing.md,
    this.shrinkWrap = false,
    this.physics = const NeverScrollableScrollPhysics(),
  });

  final int itemCount;
  final IndexedWidgetBuilder? itemBuilder;
  final EdgeInsetsGeometry padding;
  final double spacing;
  final bool shrinkWrap;
  final ScrollPhysics physics;

  @override
  Widget build(BuildContext context) => ListView.separated(
        padding: padding,
        physics: physics,
        shrinkWrap: shrinkWrap,
        itemCount: itemCount,
        separatorBuilder: (_, _) => SizedBox(height: spacing),
        itemBuilder: itemBuilder ?? (_, _) => const SkeletonListTile(),
      );
}

/// Avatar + title + subtitle placeholder shaped like [ListTile].
class SkeletonListTile extends StatelessWidget {
  const SkeletonListTile({super.key, this.leadingSize = 56, this.leadingRadius = AppRadius.smAll});

  final double leadingSize;
  final BorderRadius leadingRadius;

  @override
  Widget build(BuildContext context) => Row(
        children: [
          Skeleton(width: leadingSize, height: leadingSize, borderRadius: leadingRadius),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Skeleton.text(width: 160),
                SizedBox(height: AppSpacing.sm),
                Skeleton.text(width: 100),
              ],
            ),
          ),
        ],
      );
}

/// Image-card placeholder (image + two lines), for product grids.
class SkeletonCard extends StatelessWidget {
  const SkeletonCard({super.key, this.imageAspectRatio = 1});

  final double imageAspectRatio;

  @override
  Widget build(BuildContext context) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AspectRatio(
            aspectRatio: imageAspectRatio,
            child: const Skeleton(height: double.infinity, borderRadius: AppRadius.mdAll),
          ),
          const SizedBox(height: AppSpacing.sm),
          const Skeleton.text(width: 120),
          const SizedBox(height: AppSpacing.xs),
          const Skeleton.text(width: 60),
        ],
      );
}
