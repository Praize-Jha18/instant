import 'package:core_models/core_models.dart';
import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../app/providers.dart';
import '../../../core/errors.dart';
import '../../../core/formatters.dart';
import '../../../core/geo.dart';
import '../../addresses/data/address_providers.dart';
import '../../catalog/data/catalog_providers.dart';
import '../../catalog/data/location_controller.dart';
import '../../catalog/domain/vendor_helpers.dart';
import '../../catalog/presentation/widgets/product_card.dart';

class VendorScreen extends ConsumerWidget {
  const VendorScreen({super.key, required this.vendorId});
  final String vendorId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final vendorAsync = ref.watch(vendorProvider(vendorId));
    final vendor = vendorAsync.value;
    final products = ref.watch(vendorProductsProvider(vendorId));
    final categories = ref.watch(categoriesByIdProvider);
    final imageUrl = ref.watch(imageUrlProvider);
    final engine = ref.watch(syncEngineProvider);
    final online = ref.watch(isOnlineProvider);
    final address = ref.watch(selectedAddressProvider);
    final myLocation = ref.watch(locationProvider).value;
    final scheme = context.colors;

    Future<void> refresh() async {
      try {
        await engine.pull(only: const [Collections.vendors, Collections.products, Collections.categories]);
      } catch (e) {
        if (context.mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(describeError(e))));
      }
    }

    if (vendor == null) {
      return Scaffold(
        appBar: AppBar(),
        body: vendorAsync.isLoading
            ? const SkeletonList(itemCount: 4)
            : ErrorState(
                title: 'Vendor not available',
                message: online ? 'It may have been removed or not synced yet.' : null,
                offline: !online,
                onRetry: refresh,
              ),
      );
    }

    final from = address == null ? myLocation : GeoPoint(lat: address.lat, lng: address.lng);
    final distance = vendor.distanceFrom(from);
    final fee = vendor.estimateDeliveryKobo(distance: distance ?? 0, subtotalKobo: 0);
    final now = DateTime.now();
    final open = vendor.isOpenAt(now);
    final hours = vendor.hoursFor(now);

    // Group by first category; uncategorised last.
    final groups = <String?, List<Product>>{};
    for (final p in products) {
      final key = p.categoryIds.isEmpty ? null : p.categoryIds.first;
      groups.putIfAbsent(key, () => []).add(p);
    }
    final groupKeys = groups.keys.toList()
      ..sort((a, b) {
        if (a == null) return 1;
        if (b == null) return -1;
        return (categories[a]?.sortOrder ?? 0).compareTo(categories[b]?.sortOrder ?? 0);
      });

    return Scaffold(
      body: RefreshIndicator(
        onRefresh: refresh,
        child: CustomScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          slivers: [
            SliverAppBar(
              expandedHeight: 220,
              pinned: true,
              stretch: true,
              flexibleSpace: FlexibleSpaceBar(
                stretchModes: const [StretchMode.zoomBackground],
                background: Stack(
                  fit: StackFit.expand,
                  children: [
                    AppImage(
                      url: imageUrl(vendor.coverImageId ?? vendor.logoImageId),
                      borderRadius: BorderRadius.zero,
                      errorIcon: Icons.storefront_outlined,
                    ),
                    DecoratedBox(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [Colors.black.withValues(alpha: 0.35), Colors.transparent, Colors.black.withValues(alpha: 0.45)],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: AppSpacing.page,
                child: FadeSlideIn(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            padding: const EdgeInsets.all(2),
                            decoration: BoxDecoration(color: scheme.surface, borderRadius: AppRadius.mdAll),
                            child: AppImage(
                              url: imageUrl(vendor.logoImageId, thumb: true),
                              width: 64,
                              height: 64,
                              borderRadius: AppRadius.mdAll,
                              errorIcon: Icons.store_rounded,
                            ),
                          ),
                          const SizedBox(width: AppSpacing.md),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(vendor.name, style: context.text.headlineSmall),
                                if (vendor.description != null && vendor.description!.isNotEmpty) ...[
                                  const SizedBox(height: AppSpacing.xxs),
                                  Text(vendor.description!,
                                      style: context.text.bodyMedium?.copyWith(color: scheme.onSurfaceVariant)),
                                ],
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: AppSpacing.lg),
                      Wrap(
                        spacing: AppSpacing.sm,
                        runSpacing: AppSpacing.sm,
                        children: [
                          StatusChip(
                            label: open
                                ? 'Open${hours == null ? '' : ' until ${hours.close}'}'
                                : hours == null || hours.closed
                                    ? 'Closed today'
                                    : 'Closed · opens ${hours.open}',
                            tone: open ? StatusTone.success : StatusTone.neutral,
                            icon: Icons.schedule_rounded,
                          ),
                          if (distance != null)
                            StatusChip(label: formatDistance(distance), icon: Icons.near_me_outlined, tone: StatusTone.info),
                          if (fee != null)
                            StatusChip(
                              label: fee == 0 ? 'Free delivery' : 'Delivery ~${Money.fromKobo(fee).format(showDecimals: false)}',
                              icon: Icons.delivery_dining_outlined,
                              tone: StatusTone.primary,
                            ),
                        ],
                      ),
                      if (vendor.openingHours.isNotEmpty) ...[
                        const SizedBox(height: AppSpacing.md),
                        _OpeningHours(hours: vendor.openingHours, today: now.weekday),
                      ],
                      if (address == null && myLocation == null && fee != null) ...[
                        const SizedBox(height: AppSpacing.sm),
                        Text('Delivery estimate from the store; select an address for an exact figure.',
                            style: context.text.bodySmall?.copyWith(color: scheme.onSurfaceVariant)),
                      ],
                    ],
                  ),
                ),
              ),
            ),
            if (products.isEmpty)
              const SliverFillRemaining(
                hasScrollBody: false,
                child: EmptyState(icon: Icons.inventory_2_outlined, title: 'No products yet', compact: true),
              )
            else
              for (final key in groupKeys) ...[
                SliverToBoxAdapter(
                  child: SectionHeader(
                    title: key == null ? 'Other' : (categories[key]?.name ?? 'Other'),
                    subtitle: '${groups[key]!.length} item${groups[key]!.length == 1 ? '' : 's'}',
                  ),
                ),
                SliverPadding(
                  padding: const EdgeInsets.fromLTRB(AppSpacing.lg, 0, AppSpacing.lg, AppSpacing.lg),
                  sliver: SliverGrid(
                    gridDelegate: ProductGrid.gridDelegate,
                    delegate: SliverChildBuilderDelegate(
                      (context, i) => FadeSlideIn.staggered(index: i, child: ProductCard(product: groups[key]![i])),
                      childCount: groups[key]!.length,
                    ),
                  ),
                ),
              ],
            const SliverToBoxAdapter(child: SizedBox(height: AppSpacing.xxl)),
          ],
        ),
      ),
    );
  }
}

class _OpeningHours extends StatelessWidget {
  const _OpeningHours({required this.hours, required this.today});
  final List<OpeningHours> hours;
  final int today;

  @override
  Widget build(BuildContext context) {
    final scheme = context.colors;
    final sorted = [...hours]..sort((a, b) => a.weekday.compareTo(b.weekday));
    return ExpansionTile(
      tilePadding: EdgeInsets.zero,
      childrenPadding: const EdgeInsets.only(bottom: AppSpacing.sm),
      title: Text('Opening hours', style: context.text.titleSmall),
      shape: const Border(),
      collapsedShape: const Border(),
      children: [
        for (final h in sorted)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: AppSpacing.xxs),
            child: Row(
              children: [
                SizedBox(
                  width: 48,
                  child: Text(weekdayName(h.weekday),
                      style: context.text.bodyMedium?.copyWith(fontWeight: h.weekday == today ? FontWeight.w700 : null)),
                ),
                Text(h.closed ? 'Closed' : '${h.open} – ${h.close}',
                    style: context.text.bodyMedium?.copyWith(color: h.closed ? scheme.onSurfaceVariant : null)),
              ],
            ),
          ),
      ],
    );
  }
}
