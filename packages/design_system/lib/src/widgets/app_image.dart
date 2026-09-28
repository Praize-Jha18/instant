import 'dart:ui' as ui;

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../tokens/app_motion.dart';
import '../tokens/app_radius.dart';
import 'skeleton.dart';

/// Cached network image with a skeleton placeholder, blur + fade reveal and a
/// graceful error tile. Wrap in a [Hero] via [heroTag] for product images.
class AppImage extends StatelessWidget {
  const AppImage({
    super.key,
    required this.url,
    this.width,
    this.height,
    this.fit = BoxFit.cover,
    this.borderRadius = AppRadius.smAll,
    this.heroTag,
    this.aspectRatio,
    this.errorIcon = Icons.image_not_supported_outlined,
    this.headers,
    this.cacheKey,
    this.memCacheWidth,
    this.fadeDuration = AppMotion.slow,
  });

  /// Absolute URL; null or empty shows the error tile.
  final String? url;
  final double? width;
  final double? height;
  final BoxFit fit;
  final BorderRadius borderRadius;
  final Object? heroTag;

  /// When set, wraps in an [AspectRatio] (grids).
  final double? aspectRatio;
  final IconData errorIcon;
  final Map<String, String>? headers;
  final String? cacheKey;

  /// Decode width to save memory in lists.
  final int? memCacheWidth;
  final Duration fadeDuration;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final placeholder = Skeleton(width: width, height: height ?? double.infinity, borderRadius: borderRadius);
    final error = Container(
      width: width,
      height: height,
      color: scheme.surfaceContainerHighest,
      alignment: Alignment.center,
      child: Icon(errorIcon, color: scheme.onSurfaceVariant),
    );

    Widget image;
    final u = url;
    if (u == null || u.isEmpty) {
      image = error;
    } else {
      image = CachedNetworkImage(
        imageUrl: u,
        cacheKey: cacheKey,
        httpHeaders: headers,
        width: width,
        height: height,
        fit: fit,
        memCacheWidth: memCacheWidth,
        fadeInDuration: Duration.zero,
        fadeOutDuration: Duration.zero,
        placeholder: (_, _) => placeholder,
        errorWidget: (_, _, _) => error,
        imageBuilder: (context, provider) => _BlurFadeIn(
          duration: fadeDuration,
          child: Image(image: provider, width: width, height: height, fit: fit),
        ),
      );
    }

    if (heroTag != null) image = Hero(tag: heroTag!, child: image);
    if (aspectRatio != null) image = AspectRatio(aspectRatio: aspectRatio!, child: image);
    return ClipRRect(borderRadius: borderRadius, child: image);
  }
}

class _BlurFadeIn extends StatelessWidget {
  const _BlurFadeIn({required this.child, required this.duration});

  final Widget child;
  final Duration duration;

  @override
  Widget build(BuildContext context) {
    final reduce = MediaQuery.maybeDisableAnimationsOf(context) ?? false;
    if (reduce) return child;
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0, end: 1),
      duration: duration,
      curve: AppMotion.curve,
      child: child,
      builder: (context, t, child) {
        final sigma = (1 - t) * 8;
        return Opacity(
          opacity: t,
          child: sigma < 0.1
              ? child
              : ImageFiltered(
                  imageFilter: ui.ImageFilter.blur(sigmaX: sigma, sigmaY: sigma, tileMode: TileMode.decal),
                  child: child,
                ),
        );
      },
    );
  }
}
