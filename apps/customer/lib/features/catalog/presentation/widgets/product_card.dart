import 'package:core_models/core_models.dart';
import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/providers.dart';
import '../../../../app/routes.dart';

/// Hero tag shared by list cards and the product detail gallery.
String productHeroTag(String productId) => 'product-image-$productId';

class ProductCard extends ConsumerWidget {
  const ProductCard({
    super.key,
    required this.product,
    this.vendorName,
    this.hero = true,
  });

  final Product product;
  final String? vendorName;
  final bool hero;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final imageUrl = ref.watch(imageUrlProvider);
    final scheme = context.colors;
    final text = context.text;
    final url = imageUrl(product.primaryImage?.imageId, thumb: true);
    final outOfStock = !product.inStock;

    return AppCard(
      padding: EdgeInsets.zero,
      onTap: () => context.push(AppRoutes.product(product.id)),
      elevated: true,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Stack(
              fit: StackFit.expand,
              children: [
                AppImage(
                  url: url,
                  borderRadius: BorderRadius.zero,
                  heroTag: hero ? productHeroTag(product.id) : null,
                ),
                if (outOfStock)
                  Positioned(
                    top: AppSpacing.sm,
                    left: AppSpacing.sm,
                    child: StatusChip(
                      label: 'Sold out',
                      tone: StatusTone.danger,
                      dense: true,
                    ),
                  ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(AppSpacing.md),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  product.name,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: text.titleSmall?.copyWith(
                    fontWeight: FontWeight.w700,
                    height: 1.2,
                  ),
                ),
                if (vendorName != null) ...[
                  const SizedBox(height: AppSpacing.xxs),
                  Text(
                    vendorName!,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: text.bodySmall?.copyWith(
                      color: scheme.onSurfaceVariant,
                    ),
                  ),
                ],
                const SizedBox(height: AppSpacing.md),
                Row(
                  children: [
                    Expanded(
                      child: MoneyText.kobo(
                        product.minPriceKobo,
                        emphasize: true,
                        showDecimals: false,
                      ),
                    ),
                    if (product.rating.count > 0) ...[
                      Icon(
                        Icons.star_rounded,
                        size: 15,
                        color: scheme.onSurface,
                      ),
                      const SizedBox(width: AppSpacing.xxs),
                      Text(
                        product.rating.avg.toStringAsFixed(1),
                        style: text.labelMedium,
                      ),
                    ],
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// Grid of product cards with a staggered entrance.
class ProductGrid extends StatelessWidget {
  const ProductGrid({
    super.key,
    required this.products,
    this.vendorNames = const {},
    this.padding = AppSpacing.pageH,
    this.shrinkWrap = false,
    this.physics,
  });

  final List<Product> products;
  final Map<String, String> vendorNames;
  final EdgeInsetsGeometry padding;
  final bool shrinkWrap;
  final ScrollPhysics? physics;

  static const SliverGridDelegate gridDelegate =
      SliverGridDelegateWithMaxCrossAxisExtent(
        maxCrossAxisExtent: 220,
        mainAxisSpacing: AppSpacing.md,
        crossAxisSpacing: AppSpacing.md,
        childAspectRatio: 0.62,
      );

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      padding: padding,
      shrinkWrap: shrinkWrap,
      physics: physics,
      gridDelegate: gridDelegate,
      itemCount: products.length,
      itemBuilder: (context, i) => FadeSlideIn.staggered(
        index: i,
        child: ProductCard(
          product: products[i],
          vendorName: vendorNames[products[i].vendorId],
        ),
      ),
    );
  }
}

class ProductGridSkeleton extends StatelessWidget {
  const ProductGridSkeleton({
    super.key,
    this.count = 6,
    this.padding = AppSpacing.pageH,
  });

  final int count;
  final EdgeInsetsGeometry padding;

  @override
  Widget build(BuildContext context) => GridView.builder(
    padding: padding,
    physics: const NeverScrollableScrollPhysics(),
    shrinkWrap: true,
    gridDelegate: ProductGrid.gridDelegate,
    itemCount: count,
    itemBuilder: (_, _) => const SkeletonCard(),
  );
}
