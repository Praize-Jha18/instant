import 'package:core_models/core_models.dart';
import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../app/providers.dart';
import '../../../core/utils/errors.dart';
import '../../../core/utils/format.dart';
import '../../../core/widgets/app_page.dart';
import '../data/products_repository.dart';
import 'stock_adjust_sheet.dart';

class InventoryMovementsScreen extends ConsumerStatefulWidget {
  const InventoryMovementsScreen({super.key, required this.productId});

  final String productId;

  @override
  ConsumerState<InventoryMovementsScreen> createState() => _InventoryMovementsScreenState();
}

class _InventoryMovementsScreenState extends ConsumerState<InventoryMovementsScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(_refresh);
  }

  Future<void> _refresh() async {
    try {
      await ref.read(productsRepositoryProvider).refreshMovements(widget.productId);
    } catch (_) {
      await refreshCollections(ref, const [Collections.inventoryMovements]);
    }
  }

  @override
  Widget build(BuildContext context) {
    final product = ref.watch(productStreamProvider(widget.productId)).value;
    final movements = ref.watch(movementsStreamProvider(widget.productId));
    final theme = Theme.of(context);
    final semantic = context.semanticColors;
    return AppPage(
      title: 'Stock history',
      actions: [
        if (product != null)
          IconButton(
              tooltip: 'Adjust stock',
              icon: const Icon(Icons.tune_rounded),
              onPressed: () => showStockAdjustSheet(context, product: product)),
      ],
      body: movements.when(
        loading: () => const SkeletonList(),
        error: (e, _) => ErrorState(message: errorMessage(e), onRetry: _refresh),
        data: (list) => RefreshIndicator(
          onRefresh: _refresh,
          child: ListView(
            padding: AppSpacing.page,
            children: [
              if (product != null)
                AppCard(
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(product.name, style: theme.textTheme.titleMedium),
                            if (product.hasVariants)
                              for (final v in product.variants)
                                Text('${v.name}: ${v.stock}', style: theme.textTheme.bodySmall)
                            else
                              Text('${product.stock} in stock', style: theme.textTheme.bodySmall),
                          ],
                        ),
                      ),
                      Text('${product.totalStock}', style: theme.textTheme.headlineMedium),
                    ],
                  ),
                ),
              AppSpacing.gapLg,
              if (list.isEmpty)
                const EmptyState(compact: true, icon: Icons.history_rounded, title: 'No movements yet', message: 'Sales, restocks and adjustments appear here.')
              else
                for (final m in list)
                  AppListTile(
                    leading: CircleAvatar(
                      backgroundColor: m.delta >= 0 ? semantic.successContainer : semantic.dangerContainer,
                      child: Icon(m.delta >= 0 ? Icons.add_rounded : Icons.remove_rounded,
                          color: m.delta >= 0 ? semantic.onSuccessContainer : semantic.onDangerContainer),
                    ),
                    title: '${m.delta > 0 ? '+' : ''}${m.delta} · ${titleCase(m.reason.json)}',
                    subtitle: [
                      formatDateTime(m.createdAt),
                      if (m.variantId != null) product?.variantById(m.variantId)?.name ?? 'variant',
                      if ((m.note ?? '').isNotEmpty) m.note!,
                      if (m.orderId != null) 'order ${m.orderId!.substring(m.orderId!.length - 6)}',
                    ].join(' · '),
                    showChevron: false,
                  ),
            ],
          ),
        ),
      ),
    );
  }
}
