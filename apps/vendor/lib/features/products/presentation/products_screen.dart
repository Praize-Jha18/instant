import 'package:api_client/api_client.dart';
import 'package:core_models/core_models.dart';
import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../app/providers.dart';
import '../../../app/session.dart';
import '../../../core/utils/errors.dart';
import '../../../core/utils/format.dart';
import '../../../core/widgets/app_page.dart';
import 'stock_adjust_sheet.dart';

class ProductsScreen extends ConsumerStatefulWidget {
  const ProductsScreen({super.key});

  @override
  ConsumerState<ProductsScreen> createState() => _ProductsScreenState();
}

class _ProductsScreenState extends ConsumerState<ProductsScreen> {
  final _search = TextEditingController();
  ProductStatus? _status;
  bool _lowStockOnly = false;

  @override
  void dispose() {
    _search.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final products = ref.watch(productsStreamProvider);
    final online = ref.watch(isOnlineProvider);
    final api = ref.watch(apiClientProvider);
    final vendorId = ref.watch(sessionProvider.select((s) => s.user?.vendorId));
    return AppPage(
      title: 'Products',
      actions: [
        IconButton(
          tooltip: 'Refresh',
          icon: const Icon(Icons.refresh_rounded),
          onPressed: () => refreshCollections(ref, const [
            Collections.products,
            Collections.categories,
          ]),
        ),
      ],
      floatingActionButton: FloatingActionButton.extended(
        heroTag: 'new-product',
        tooltip: online
            ? 'New product'
            : 'Creating products requires a connection',
        onPressed: online ? () => context.go('/products/new') : null,
        icon: const Icon(Icons.add_rounded),
        label: const Text('New product'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(
              AppSpacing.lg,
              AppSpacing.sm,
              AppSpacing.lg,
              0,
            ),
            child: AppTextField(
              controller: _search,
              hint: 'Search by name, tag or SKU',
              prefixIcon: Icons.search_rounded,
              textInputAction: TextInputAction.search,
              onChanged: (_) => setState(() {}),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
            child: Row(
              children: [
                Expanded(
                  child: FilterChips<ProductStatus>(
                    options: ProductStatus.values,
                    selected: _status,
                    labelOf: (s) => titleCase(s.json),
                    onSelected: (s) => setState(() => _status = s),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(right: AppSpacing.lg),
                  child: FilterChip(
                    label: const Text('Low stock'),
                    avatar: const Icon(Icons.warning_amber_rounded, size: 16),
                    selected: _lowStockOnly,
                    onSelected: (v) => setState(() => _lowStockOnly = v),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: products.when(
              loading: () => LayoutBuilder(
                builder: (_, c) => GridView.count(
                  padding: AppSpacing.page,
                  crossAxisCount: c.maxWidth >= 700 ? 3 : 1,
                  childAspectRatio: c.maxWidth >= 700 ? 0.8 : 4,
                  children: List.generate(6, (_) => const SkeletonCard()),
                ),
              ),
              error: (e, _) => ErrorState(
                message: errorMessage(e),
                onRetry: () => refreshCollections(ref),
              ),
              data: (all) {
                final q = _search.text.trim().toLowerCase();
                final list = all.where((p) {
                  // Older local stores may contain products received before
                  // the backend scope was corrected. Never present those as
                  // editable to this vendor.
                  if (vendorId == null || p.vendorId != vendorId) return false;
                  if (_status != null && p.status != _status) return false;
                  if (_lowStockOnly && p.totalStock > 5) return false;
                  if (q.isEmpty) return true;
                  return p.name.toLowerCase().contains(q) ||
                      p.tags.any((t) => t.toLowerCase().contains(q)) ||
                      p.variants.any(
                        (v) =>
                            (v.sku ?? '').toLowerCase().contains(q) ||
                            v.name.toLowerCase().contains(q),
                      );
                }).toList();
                if (list.isEmpty) {
                  return EmptyState(
                    icon: Icons.inventory_2_outlined,
                    title: all.isEmpty ? 'No products yet' : 'Nothing matches',
                    message: all.isEmpty
                        ? 'Create your first product. Drafts are only visible to you.'
                        : 'Try a different search or filter.',
                    action: all.isEmpty
                        ? AppButton.primary(
                            label: 'New product',
                            icon: Icons.add_rounded,
                            onPressed: online
                                ? () => context.go('/products/new')
                                : null,
                            tooltip: 'You are offline',
                          )
                        : null,
                  );
                }
                return RefreshIndicator(
                  onRefresh: () => refreshCollections(ref, const [
                    Collections.products,
                    Collections.categories,
                  ]),
                  child: LayoutBuilder(
                    builder: (context, c) {
                      final wide = c.maxWidth >= 700;
                      if (!wide) {
                        return ListView.separated(
                          padding: const EdgeInsets.fromLTRB(
                            AppSpacing.lg,
                            AppSpacing.sm,
                            AppSpacing.lg,
                            96,
                          ),
                          itemCount: list.length,
                          separatorBuilder: (_, _) => AppSpacing.gapSm,
                          itemBuilder: (context, i) => FadeSlideIn.staggered(
                            index: i,
                            child: _ProductListTile(
                              product: list[i],
                              imageUrl: _thumb(api, list[i]),
                            ),
                          ),
                        );
                      }
                      final columns = (c.maxWidth / 260).floor().clamp(2, 5);
                      return GridView.builder(
                        padding: const EdgeInsets.fromLTRB(
                          AppSpacing.lg,
                          AppSpacing.sm,
                          AppSpacing.lg,
                          96,
                        ),
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: columns,
                          crossAxisSpacing: AppSpacing.md,
                          mainAxisSpacing: AppSpacing.md,
                          mainAxisExtent: 300,
                        ),
                        itemCount: list.length,
                        itemBuilder: (context, i) => FadeSlideIn.staggered(
                          index: i,
                          child: _ProductGridCard(
                            product: list[i],
                            imageUrl: _thumb(api, list[i]),
                          ),
                        ),
                      );
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  String? _thumb(ApiClient api, Product p) {
    final img = p.primaryImage;
    return img == null ? null : api.catalog.imageUrl(img.imageId, thumb: true);
  }
}

class _StockBadge extends StatelessWidget {
  const _StockBadge({required this.product});
  final Product product;

  @override
  Widget build(BuildContext context) {
    final low = product.totalStock <= 5;
    return StatusChip(
      label: '${product.totalStock} in stock',
      tone: product.totalStock == 0
          ? StatusTone.danger
          : (low ? StatusTone.warning : StatusTone.neutral),
      dense: true,
      icon: low ? Icons.warning_amber_rounded : null,
    );
  }
}

StatusTone _productTone(ProductStatus s) => switch (s) {
  ProductStatus.draft => StatusTone.neutral,
  ProductStatus.active => StatusTone.success,
  ProductStatus.archived => StatusTone.warning,
};

class _ProductListTile extends StatelessWidget {
  const _ProductListTile({required this.product, required this.imageUrl});
  final Product product;
  final String? imageUrl;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return AppCard(
      padding: const EdgeInsets.all(AppSpacing.sm),
      onTap: () => context.go('/products/${product.id}'),
      child: Row(
        children: [
          AppImage(
            url: imageUrl,
            width: 72,
            height: 72,
            heroTag: 'product-${product.id}',
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  product.name,
                  style: theme.textTheme.titleSmall,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: AppSpacing.xxs),
                Row(
                  children: [
                    MoneyText.kobo(
                      product.minPriceKobo,
                      showDecimals: false,
                      style: theme.textTheme.bodyMedium,
                    ),
                    if (product.hasVariants)
                      Text(
                        '  · ${product.variants.length} variants',
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: AppSpacing.xs),
                Wrap(
                  spacing: AppSpacing.xs,
                  children: [
                    StatusChip(
                      label: titleCase(product.status.json),
                      tone: _productTone(product.status),
                      dense: true,
                    ),
                    _StockBadge(product: product),
                  ],
                ),
              ],
            ),
          ),
          IconButton(
            tooltip: 'Adjust stock',
            icon: const Icon(Icons.tune_rounded),
            onPressed: () => showStockAdjustSheet(context, product: product),
          ),
        ],
      ),
    );
  }
}

class _ProductGridCard extends StatelessWidget {
  const _ProductGridCard({required this.product, required this.imageUrl});
  final Product product;
  final String? imageUrl;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return AppCard(
      padding: EdgeInsets.zero,
      onTap: () => context.go('/products/${product.id}'),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AppImage(
            url: imageUrl,
            aspectRatio: 1.4,
            borderRadius: BorderRadius.zero,
            heroTag: 'product-${product.id}',
          ),
          Padding(
            padding: const EdgeInsets.all(AppSpacing.md),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  product.name,
                  style: theme.textTheme.titleSmall,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: AppSpacing.xxs),
                MoneyText.kobo(
                  product.minPriceKobo,
                  showDecimals: false,
                  style: theme.textTheme.bodyMedium,
                ),
                const SizedBox(height: AppSpacing.sm),
                Row(
                  children: [
                    Expanded(
                      child: Wrap(
                        spacing: AppSpacing.xs,
                        runSpacing: AppSpacing.xs,
                        children: [
                          StatusChip(
                            label: titleCase(product.status.json),
                            tone: _productTone(product.status),
                            dense: true,
                          ),
                          _StockBadge(product: product),
                        ],
                      ),
                    ),
                    IconButton(
                      tooltip: 'Adjust stock',
                      visualDensity: VisualDensity.compact,
                      icon: const Icon(Icons.tune_rounded, size: 20),
                      onPressed: () =>
                          showStockAdjustSheet(context, product: product),
                    ),
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
