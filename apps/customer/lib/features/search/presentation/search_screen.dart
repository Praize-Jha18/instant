import 'package:core_models/core_models.dart';
import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../app/providers.dart';
import '../../catalog/data/catalog_providers.dart';
import '../../catalog/presentation/widgets/product_card.dart';
import 'search_notifier.dart';

class SearchScreen extends ConsumerStatefulWidget {
  const SearchScreen({super.key, this.initialQuery, this.initialCategoryId});

  final String? initialQuery;
  final String? initialCategoryId;

  @override
  ConsumerState<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends ConsumerState<SearchScreen> {
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.initialQuery ?? ref.read(productSearchProvider).query);
    WidgetsBinding.instance.addPostFrameCallback((_) => _applyInitial());
  }

  @override
  void didUpdateWidget(covariant SearchScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.initialCategoryId != widget.initialCategoryId || oldWidget.initialQuery != widget.initialQuery) {
      _applyInitial();
    }
  }

  void _applyInitial() {
    final notifier = ref.read(productSearchProvider.notifier);
    if (widget.initialQuery != null) {
      _controller.text = widget.initialQuery!;
      notifier.setQuery(widget.initialQuery!);
    }
    if (widget.initialCategoryId != null) notifier.setCategory(widget.initialCategoryId);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(productSearchProvider);
    final notifier = ref.read(productSearchProvider.notifier);
    final categories = ref.watch(categoriesProvider).value ?? const <Category>[];
    final vendors = ref.watch(vendorsByIdProvider);
    final online = ref.watch(isOnlineProvider);
    final scheme = context.colors;

    return Scaffold(
      appBar: AppBar(
        titleSpacing: 0,
        title: Padding(
          padding: const EdgeInsets.only(right: AppSpacing.lg),
          child: AppTextField(
            controller: _controller,
            hint: 'Search products',
            prefixIcon: Icons.search_rounded,
            textInputAction: TextInputAction.search,
            autofocus: widget.initialQuery == null && widget.initialCategoryId == null,
            onChanged: notifier.setQuery,
            onSubmitted: (_) => notifier.run(),
            suffix: state.query.isEmpty
                ? null
                : IconButton(
                    tooltip: 'Clear',
                    icon: const Icon(Icons.close_rounded),
                    onPressed: () {
                      _controller.clear();
                      notifier.setQuery('');
                    },
                  ),
          ),
        ),
      ),
      body: Column(
        children: [
          if (categories.isNotEmpty)
            SizedBox(
              height: 52,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg, vertical: AppSpacing.sm),
                itemCount: categories.length,
                separatorBuilder: (_, _) => const SizedBox(width: AppSpacing.sm),
                itemBuilder: (context, i) {
                  final c = categories[i];
                  final selected = c.id == state.categoryId;
                  return FilterChip(
                    label: Text(c.name),
                    selected: selected,
                    onSelected: (_) => notifier.setCategory(selected ? null : c.id),
                  );
                },
              ),
            ),
          if (state.searched && state.fromLocal && !state.loading)
            Padding(
              padding: const EdgeInsets.fromLTRB(AppSpacing.lg, 0, AppSpacing.lg, AppSpacing.sm),
              child: Row(
                children: [
                  Icon(online ? Icons.storage_rounded : Icons.wifi_off_rounded, size: 14, color: scheme.onSurfaceVariant),
                  const SizedBox(width: AppSpacing.xs),
                  Text(
                    online ? 'Showing saved results' : 'Offline: searching saved products',
                    style: context.text.bodySmall?.copyWith(color: scheme.onSurfaceVariant),
                  ),
                ],
              ),
            ),
          Expanded(
            child: AnimatedSwitcher(
              duration: AppMotion.normal,
              child: !state.searched
                  ? const EmptyState(
                      key: ValueKey('idle'),
                      icon: Icons.manage_search_rounded,
                      title: 'Find something to order',
                      message: 'Search by name or pick a category.',
                    )
                  : state.loading && state.results.isEmpty
                      ? const ProductGridSkeleton(key: ValueKey('loading'))
                      : state.results.isEmpty
                          ? EmptyState(
                              key: const ValueKey('empty'),
                              icon: Icons.search_off_rounded,
                              title: 'No matches',
                              message: 'Try a different word${online ? '' : ' or reconnect to search everything'}.',
                            )
                          : ProductGrid(
                              key: const ValueKey('results'),
                              products: state.results,
                              vendorNames: {for (final v in vendors.values) v.id: v.name},
                              padding: const EdgeInsets.fromLTRB(AppSpacing.lg, AppSpacing.sm, AppSpacing.lg, AppSpacing.xl),
                            ),
            ),
          ),
        ],
      ),
    );
  }
}
