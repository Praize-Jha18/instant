import 'package:core_models/core_models.dart';
import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../app/providers.dart';
import '../../../app/routes.dart';
import '../../cart/presentation/cart_providers.dart';
import '../../catalog/data/catalog_providers.dart';
import '../../catalog/presentation/widgets/product_card.dart';

class ProductDetailScreen extends ConsumerStatefulWidget {
  const ProductDetailScreen({super.key, required this.productId});
  final String productId;

  @override
  ConsumerState<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends ConsumerState<ProductDetailScreen> {
  final _page = PageController();
  int _imageIndex = 0;
  String? _variantId;
  int _qty = 1;
  bool _adding = false;
  bool _fetched = false;

  @override
  void dispose() {
    _page.dispose();
    super.dispose();
  }

  /// Not in the store yet (deep link): fetch once and let the store emit it.
  Future<void> _fetchIfMissing() async {
    if (_fetched || !ref.read(isOnlineProvider)) return;
    _fetched = true;
    try {
      final product = await ref.read(apiClientProvider).catalog.product(widget.productId);
      await ref.read(localStoreProvider).upsert(Collections.products, product);
    } catch (_) {}
  }

  Future<void> _add(Product product, ProductVariant? variant) async {
    setState(() => _adding = true);
    HapticFeedback.mediumImpact();
    await ref.read(cartActionsProvider).add(product, variant: variant, qty: _qty);
    if (!mounted) return;
    setState(() => _adding = false);
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(
        content: Text('Added $_qty× ${product.name} to cart'),
        action: SnackBarAction(label: 'View cart', onPressed: () => context.go(AppRoutes.cart)),
      ));
  }

  @override
  Widget build(BuildContext context) {
    final productAsync = ref.watch(productProvider(widget.productId));
    final product = productAsync.value;
    final imageUrl = ref.watch(imageUrlProvider);
    final scheme = context.colors;

    if (product == null) {
      if (!productAsync.isLoading) WidgetsBinding.instance.addPostFrameCallback((_) => _fetchIfMissing());
      return Scaffold(
        appBar: AppBar(),
        body: productAsync.isLoading || !_fetched
            ? const Padding(padding: AppSpacing.page, child: SkeletonCard())
            : const ErrorState(title: 'Product not available', message: 'It may have been removed or not synced yet.'),
      );
    }

    final vendor = ref.watch(vendorProvider(product.vendorId)).value;
    final images = [...product.images]..sort((a, b) => a.sortOrder.compareTo(b.sortOrder));
    final variants = product.hasVariants ? product.variants : const <ProductVariant>[];
    final selectedVariant = product.variantById(_variantId) ??
        (variants.isEmpty ? null : variants.firstWhere((v) => v.inStock, orElse: () => variants.first));
    final stock = selectedVariant?.stock ?? product.stock;
    final price = selectedVariant?.priceKobo ?? product.basePriceKobo;
    final maxQty = stock.clamp(1, 99);
    final canAdd = stock > 0 && !_adding;
    if (_qty > maxQty) _qty = maxQty;

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: MediaQuery.sizeOf(context).width.clamp(280, 480),
            pinned: true,
            backgroundColor: scheme.surface,
            flexibleSpace: FlexibleSpaceBar(
              background: images.isEmpty
                  ? Hero(
                      tag: productHeroTag(product.id),
                      child: const AppImage(url: null, borderRadius: BorderRadius.zero),
                    )
                  : Stack(
                      fit: StackFit.expand,
                      children: [
                        PageView.builder(
                          controller: _page,
                          itemCount: images.length,
                          onPageChanged: (i) => setState(() => _imageIndex = i),
                          itemBuilder: (context, i) => AppImage(
                            url: imageUrl(images[i].imageId),
                            borderRadius: BorderRadius.zero,
                            heroTag: i == 0 ? productHeroTag(product.id) : null,
                          ),
                        ),
                        if (images.length > 1)
                          Positioned(
                            bottom: AppSpacing.md,
                            left: 0,
                            right: 0,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                for (var i = 0; i < images.length; i++)
                                  AnimatedContainer(
                                    duration: AppMotion.normal,
                                    curve: AppMotion.curve,
                                    margin: const EdgeInsets.symmetric(horizontal: 3),
                                    width: i == _imageIndex ? 18 : 6,
                                    height: 6,
                                    decoration: BoxDecoration(
                                      color: i == _imageIndex ? scheme.primary : scheme.surface.withValues(alpha: 0.8),
                                      borderRadius: AppRadius.pill,
                                    ),
                                  ),
                              ],
                            ),
                          ),
                      ],
                    ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(AppSpacing.lg, AppSpacing.lg, AppSpacing.lg, 120),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  FadeSlideIn(
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(child: Text(product.name, style: context.text.headlineSmall)),
                        const SizedBox(width: AppSpacing.md),
                        AnimatedSwitcher(
                          duration: AppMotion.fast,
                          child: MoneyText.kobo(
                            price,
                            key: ValueKey(price),
                            emphasize: true,
                            style: context.text.titleLarge,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  FadeSlideIn.staggered(
                    index: 1,
                    child: Wrap(
                      spacing: AppSpacing.sm,
                      runSpacing: AppSpacing.sm,
                      crossAxisAlignment: WrapCrossAlignment.center,
                      children: [
                        if (vendor != null)
                          ActionChip(
                            avatar: const Icon(Icons.storefront_outlined, size: 16),
                            label: Text(vendor.name),
                            onPressed: () => context.push(AppRoutes.vendor(vendor.id)),
                          ),
                        _StockChip(stock: stock),
                        if (product.rating.count > 0)
                          StatusChip(
                            label: '${product.rating.avg.toStringAsFixed(1)} (${product.rating.count})',
                            icon: Icons.star_rounded,
                            tone: StatusTone.warning,
                          ),
                      ],
                    ),
                  ),
                  if (variants.isNotEmpty) ...[
                    const SizedBox(height: AppSpacing.xl),
                    FadeSlideIn.staggered(index: 2, child: Text('Options', style: context.text.titleSmall)),
                    const SizedBox(height: AppSpacing.sm),
                    FadeSlideIn.staggered(
                      index: 3,
                      child: Wrap(
                        spacing: AppSpacing.sm,
                        runSpacing: AppSpacing.sm,
                        children: [
                          for (final v in variants)
                            ChoiceChip(
                              label: Text('${v.name} · ${Money.fromKobo(v.priceKobo).format(showDecimals: false)}'),
                              selected: v.id == selectedVariant?.id,
                              onSelected: v.inStock
                                  ? (_) {
                                      HapticFeedback.selectionClick();
                                      setState(() => _variantId = v.id);
                                    }
                                  : null,
                            ),
                        ],
                      ),
                    ),
                  ],
                  if (product.description != null && product.description!.isNotEmpty) ...[
                    const SizedBox(height: AppSpacing.xl),
                    FadeSlideIn.staggered(index: 4, child: Text('About', style: context.text.titleSmall)),
                    const SizedBox(height: AppSpacing.sm),
                    FadeSlideIn.staggered(
                      index: 5,
                      child: Text(product.description!, style: context.text.bodyLarge?.copyWith(color: scheme.onSurfaceVariant)),
                    ),
                  ],
                  if (product.tags.isNotEmpty) ...[
                    const SizedBox(height: AppSpacing.lg),
                    Wrap(
                      spacing: AppSpacing.sm,
                      runSpacing: AppSpacing.xs,
                      children: [for (final t in product.tags) StatusChip(label: t, dense: true)],
                    ),
                  ],
                ],
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: Material(
        color: scheme.surface,
        elevation: 8,
        shadowColor: Colors.black26,
        child: SafeArea(
          top: false,
          child: Padding(
            padding: AppSpacing.page,
            child: Row(
              children: [
                QuantityStepper(value: _qty, max: maxQty, enabled: stock > 0, onChanged: (v) => setState(() => _qty = v)),
                const SizedBox(width: AppSpacing.lg),
                Expanded(
                  child: AppButton.primary(
                    label: stock > 0 ? 'Add · ${Money.fromKobo(price * _qty).format(showDecimals: false)}' : 'Out of stock',
                    icon: Icons.add_shopping_cart_rounded,
                    expanded: true,
                    size: AppButtonSize.large,
                    loading: _adding,
                    onPressed: canAdd ? () => _add(product, selectedVariant) : null,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _StockChip extends StatelessWidget {
  const _StockChip({required this.stock});
  final int stock;

  @override
  Widget build(BuildContext context) {
    if (stock <= 0) return const StatusChip(label: 'Out of stock', tone: StatusTone.danger, icon: Icons.block_rounded);
    if (stock <= 5) {
      return StatusChip(label: 'Only $stock left', tone: StatusTone.warning, icon: Icons.local_fire_department_rounded);
    }
    return const StatusChip(label: 'In stock', tone: StatusTone.success, icon: Icons.check_circle_outline_rounded);
  }
}
