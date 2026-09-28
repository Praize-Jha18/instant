import 'package:core_models/core_models.dart';
import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../app/providers.dart';
import '../../../app/routes.dart';
import '../../../core/errors.dart';
import '../../../core/widgets/list_phase.dart';
import '../../auth/presentation/session_controller.dart';
import '../../catalog/data/catalog_providers.dart';
import '../../catalog/data/location_controller.dart';
import '../../catalog/domain/vendor_helpers.dart';
import '../../catalog/presentation/widgets/product_card.dart';
import '../../catalog/presentation/widgets/vendor_card.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(currentUserProvider);
    final vendorsAsync = ref.watch(vendorsProvider);
    final categories = ref.watch(categoriesProvider).value ?? const <Category>[];
    final featured = ref.watch(featuredProductsProvider);
    final vendorsById = ref.watch(vendorsByIdProvider);
    final location = ref.watch(locationProvider).value;
    final promptDismissed = ref.watch(locationPromptDismissedProvider);
    final status = ref.watch(syncStatusProvider).value;
    final engine = ref.watch(syncEngineProvider);
    final scheme = context.colors;

    final vendors = sortVendorsByDistance(vendorsAsync.value ?? const [], location);
    final phase = vendorsAsync.isLoading && !vendorsAsync.hasValue
        ? ListPhase.loading
        : resolveListPhase(count: vendors.length + featured.length, status: status);

    Future<void> refresh() async {
      ref.read(locationProvider.notifier).refresh();
      try {
        await engine.pull();
      } catch (e) {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(describeError(e))));
        }
      }
    }

    final firstName = (user?.fullName ?? '').split(' ').first;

    return Scaffold(
      body: RefreshIndicator(
        onRefresh: refresh,
        child: CustomScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          slivers: [
            SliverAppBar(
              floating: true,
              snap: true,
              toolbarHeight: 72,
              title: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(firstName.isEmpty ? 'Hello' : 'Hello, $firstName', style: context.text.titleLarge),
                  Text(
                    location == null ? 'Set your location for nearby vendors' : 'Vendors near you',
                    style: context.text.bodySmall?.copyWith(color: scheme.onSurfaceVariant),
                  ),
                ],
              ),
              actions: [
                IconButton(
                  tooltip: 'Notifications',
                  onPressed: () => context.push(AppRoutes.notifications),
                  icon: const Icon(Icons.notifications_none_rounded),
                ),
              ],
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(AppSpacing.lg, AppSpacing.xs, AppSpacing.lg, AppSpacing.md),
                child: FadeSlideIn(child: _SearchBar(onTap: () => context.go(AppRoutes.search))),
              ),
            ),
            if (location == null && !promptDismissed)
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(AppSpacing.lg, 0, AppSpacing.lg, AppSpacing.md),
                  child: FadeSlideIn.staggered(index: 1, child: const _LocationPrompt()),
                ),
              ),
            if (categories.isNotEmpty) ...[
              const SliverToBoxAdapter(child: SectionHeader(title: 'Categories')),
              SliverToBoxAdapter(
                child: SizedBox(
                  height: 44,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    padding: AppSpacing.pageH,
                    itemCount: categories.length,
                    separatorBuilder: (_, _) => const SizedBox(width: AppSpacing.sm),
                    itemBuilder: (context, i) => FadeSlideIn.staggered(
                      index: i,
                      offset: const Offset(0.08, 0),
                      child: ActionChip(
                        avatar: const Icon(Icons.category_outlined, size: 16),
                        label: Text(categories[i].name),
                        onPressed: () => context.go(AppRoutes.searchWith(categoryId: categories[i].id)),
                      ),
                    ),
                  ),
                ),
              ),
              const SliverToBoxAdapter(child: SizedBox(height: AppSpacing.md)),
            ],
            switch (phase) {
              ListPhase.loading => const SliverToBoxAdapter(child: _HomeSkeleton()),
              ListPhase.ready => SliverMainAxisGroup(slivers: [
                  if (vendors.isNotEmpty) ...[
                    SliverToBoxAdapter(
                      child: SectionHeader(
                        title: location == null ? 'Vendors' : 'Near you',
                        subtitle: location == null ? null : 'Sorted by distance',
                      ),
                    ),
                    SliverToBoxAdapter(
                      child: SizedBox(
                        height: 236,
                        child: ListView.separated(
                          scrollDirection: Axis.horizontal,
                          padding: AppSpacing.pageH,
                          itemCount: vendors.length,
                          separatorBuilder: (_, _) => const SizedBox(width: AppSpacing.md),
                          itemBuilder: (context, i) => FadeSlideIn.staggered(
                            index: i,
                            offset: const Offset(0.08, 0),
                            child: VendorCard(
                              vendor: vendors[i],
                              distanceKm: vendors[i].distanceFrom(location),
                              width: 260,
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SliverToBoxAdapter(child: SizedBox(height: AppSpacing.lg)),
                  ],
                  if (featured.isNotEmpty) ...[
                    SliverToBoxAdapter(
                      child: SectionHeader(
                        title: 'Featured',
                        actionLabel: 'See all',
                        onAction: () => context.go(AppRoutes.search),
                      ),
                    ),
                    SliverPadding(
                      padding: const EdgeInsets.fromLTRB(AppSpacing.lg, 0, AppSpacing.lg, AppSpacing.xxl),
                      sliver: SliverGrid(
                        gridDelegate: ProductGrid.gridDelegate,
                        delegate: SliverChildBuilderDelegate(
                          (context, i) => FadeSlideIn.staggered(
                            index: i,
                            child: ProductCard(product: featured[i], vendorName: vendorsById[featured[i].vendorId]?.name),
                          ),
                          childCount: featured.length,
                        ),
                      ),
                    ),
                  ],
                ]),
              ListPhase.empty => const SliverFillRemaining(
                  hasScrollBody: false,
                  child: EmptyState(
                    icon: Icons.storefront_outlined,
                    title: 'No vendors yet',
                    message: 'Vendors are being onboarded. Pull to refresh in a while.',
                  ),
                ),
              ListPhase.offline => SliverFillRemaining(
                  hasScrollBody: false,
                  child: ErrorState(offline: true, onRetry: refresh),
                ),
              ListPhase.error => SliverFillRemaining(
                  hasScrollBody: false,
                  child: ErrorState(onRetry: refresh),
                ),
            },
          ],
        ),
      ),
    );
  }
}

class _SearchBar extends StatelessWidget {
  const _SearchBar({required this.onTap});
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final scheme = context.colors;
    return AnimatedPressable(
      onTap: onTap,
      borderRadius: AppRadius.pill,
      semanticLabel: 'Search products and vendors',
      child: Container(
        height: 48,
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
        decoration: BoxDecoration(color: scheme.surfaceContainerHighest.withValues(alpha: 0.6), borderRadius: AppRadius.pill),
        child: Row(
          children: [
            Icon(Icons.search_rounded, color: scheme.onSurfaceVariant),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: Text(
                'Search products and vendors',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: context.text.bodyLarge?.copyWith(color: scheme.onSurfaceVariant),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _LocationPrompt extends ConsumerWidget {
  const _LocationPrompt();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final scheme = context.colors;
    final loading = ref.watch(locationProvider).isLoading;
    return AppCard(
      color: scheme.primaryContainer,
      outlined: false,
      child: Row(
        children: [
          Icon(Icons.near_me_outlined, color: scheme.onPrimaryContainer),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('See vendors near you', style: context.text.titleSmall?.copyWith(color: scheme.onPrimaryContainer)),
                Text('Share your location to sort by distance and estimate delivery.',
                    style: context.text.bodySmall?.copyWith(color: scheme.onPrimaryContainer)),
                const SizedBox(height: AppSpacing.sm),
                Row(
                  children: [
                    AppButton.primary(
                      label: 'Enable',
                      size: AppButtonSize.small,
                      loading: loading,
                      onPressed: () async {
                        final ok = await ref.read(locationProvider.notifier).request();
                        await ref.read(locationPromptDismissedProvider.notifier).dismiss();
                        if (!ok && context.mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Location unavailable. You can still browse all vendors.')),
                          );
                        }
                      },
                    ),
                    const SizedBox(width: AppSpacing.sm),
                    AppButton.ghost(
                      label: 'Not now',
                      size: AppButtonSize.small,
                      onPressed: () => ref.read(locationPromptDismissedProvider.notifier).dismiss(),
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

class _HomeSkeleton extends StatelessWidget {
  const _HomeSkeleton();

  @override
  Widget build(BuildContext context) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(padding: AppSpacing.page, child: Skeleton(width: 140, height: 20)),
          SizedBox(
            height: 220,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              padding: AppSpacing.pageH,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: 3,
              separatorBuilder: (_, _) => const SizedBox(width: AppSpacing.md),
              itemBuilder: (_, _) => const SizedBox(width: 260, child: SkeletonCard(imageAspectRatio: 16 / 9)),
            ),
          ),
          const Padding(padding: AppSpacing.page, child: Skeleton(width: 120, height: 20)),
          const ProductGridSkeleton(count: 4),
        ],
      );
}
