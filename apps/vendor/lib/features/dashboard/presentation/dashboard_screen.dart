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
import '../../orders/presentation/order_widgets.dart';

const _activeStatuses = [
  SubOrderStatus.placed,
  SubOrderStatus.accepted,
  SubOrderStatus.preparing,
  SubOrderStatus.ready,
  SubOrderStatus.outForDelivery,
  SubOrderStatus.delivered,
  SubOrderStatus.cancelled,
];

class DashboardScreen extends ConsumerWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final session = ref.watch(sessionProvider);
    final orders = ref.watch(subOrdersStreamProvider);
    final products = ref.watch(productsStreamProvider);
    final ledger = ref.watch(ledgerStreamProvider);
    final rtState = ref.watch(realtimeStateProvider).value;
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;

    return AppPage(
      title: session.vendor?.name ?? 'Dashboard',
      actions: [
        Tooltip(
          message: rtState == RealtimeConnectionState.connected ? 'Live updates connected' : 'Live updates ${rtState?.name ?? 'off'}',
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm),
            child: Center(child: OnlineDot(online: rtState == RealtimeConnectionState.connected)),
          ),
        ),
        IconButton(tooltip: 'Settings', icon: const Icon(Icons.settings_outlined), onPressed: () => context.go('/settings')),
      ],
      body: RefreshIndicator(
        onRefresh: () => refreshCollections(ref),
        child: orders.when(
          loading: () => const SkeletonList(),
          error: (e, _) => ErrorState(message: errorMessage(e), onRetry: () => refreshCollections(ref)),
          data: (all) {
            final today = all.where((o) => isToday(o.createdAt)).toList();
            final counts = <SubOrderStatus, int>{for (final s in _activeStatuses) s: 0};
            for (final o in today) {
              counts[o.status] = (counts[o.status] ?? 0) + 1;
            }
            final (revToday, rev7d, source) = _revenue(all, ledger.value);
            final lowStock = (products.value ?? const <Product>[])
                .where((p) => p.status != ProductStatus.archived && p.totalStock <= 5)
                .toList()
              ..sort((a, b) => a.totalStock.compareTo(b.totalStock));
            final attention = all.where((o) => o.status == SubOrderStatus.placed || o.status == SubOrderStatus.ready).toList();

            return ListView(
              padding: AppSpacing.page,
              children: [
                if (session.vendor?.status == VendorStatus.pending)
                  Padding(
                    padding: const EdgeInsets.only(bottom: AppSpacing.lg),
                    child: AppCard(
                      color: context.semanticColors.warningContainer,
                      outlined: false,
                      onTap: () => context.go('/approval'),
                      child: Row(children: [
                        Icon(Icons.hourglass_top_rounded, color: context.semanticColors.onWarningContainer),
                        const SizedBox(width: AppSpacing.md),
                        Expanded(
                            child: Text('Awaiting platform approval',
                                style: theme.textTheme.bodyMedium?.copyWith(color: context.semanticColors.onWarningContainer))),
                      ]),
                    ),
                  ),
                Text('Today', style: theme.textTheme.titleMedium),
                AppSpacing.gapSm,
                Wrap(
                  spacing: AppSpacing.sm,
                  runSpacing: AppSpacing.sm,
                  children: [
                    for (final s in _activeStatuses)
                      ActionChip(
                        avatar: CircleAvatar(
                          backgroundColor: scheme.surface,
                          child: Text('${counts[s]}', style: theme.textTheme.labelSmall),
                        ),
                        label: Text(StatusChip.subOrderLabel(s)),
                        onPressed: () => context.go('/orders'),
                      ),
                  ],
                ),
                AppSpacing.gapLg,
                LayoutBuilder(
                  builder: (context, c) {
                    final columns = c.maxWidth >= 900 ? 4 : 2;
                    return GridView.count(
                      crossAxisCount: columns,
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      crossAxisSpacing: AppSpacing.md,
                      mainAxisSpacing: AppSpacing.md,
                      childAspectRatio: columns == 4 ? 1.9 : 1.5,
                      children: [
                        StatTile(
                          label: 'Orders today',
                          icon: Icons.receipt_long_outlined,
                          value: Text('${today.length}'),
                          caption: '${counts[SubOrderStatus.placed]} awaiting acceptance',
                          onTap: () => context.go('/orders'),
                        ),
                        StatTile(
                          label: 'Revenue today',
                          icon: Icons.payments_outlined,
                          value: MoneyText.kobo(revToday, showDecimals: false, emphasize: true),
                          caption: source,
                          onTap: () => context.go('/finance'),
                        ),
                        StatTile(
                          label: 'Revenue 7 days',
                          icon: Icons.trending_up_rounded,
                          value: MoneyText.kobo(rev7d, showDecimals: false),
                          caption: source,
                          onTap: () => context.go('/finance'),
                        ),
                        StatTile(
                          label: 'Low stock',
                          icon: Icons.warning_amber_rounded,
                          tone: lowStock.isEmpty ? null : context.semanticColors.warning,
                          value: Text('${lowStock.length}'),
                          caption: 'products at 5 or fewer',
                          onTap: () => context.go('/products'),
                        ),
                      ],
                    );
                  },
                ),
                AppSpacing.gapXl,
                Text('Quick actions', style: theme.textTheme.titleMedium),
                AppSpacing.gapSm,
                Wrap(
                  spacing: AppSpacing.sm,
                  runSpacing: AppSpacing.sm,
                  children: [
                    AppButton.primary(label: 'New product', icon: Icons.add_rounded, onPressed: () => context.go('/products/new')),
                    AppButton.secondary(label: 'Orders board', icon: Icons.view_kanban_outlined, onPressed: () => context.go('/orders')),
                    AppButton.secondary(label: 'Deliveries map', icon: Icons.map_outlined, onPressed: () => context.go('/deliveries')),
                    AppButton.secondary(label: 'Request payout', icon: Icons.account_balance_outlined, onPressed: () => context.go('/finance')),
                  ],
                ),
                AppSpacing.gapXl,
                TwoPane(
                  primary: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      SectionHeader(
                        title: 'Needs attention',
                        subtitle: 'New orders and orders ready for pickup',
                        actionLabel: 'All orders',
                        onAction: () => context.go('/orders'),
                        padding: const EdgeInsets.only(bottom: AppSpacing.sm),
                      ),
                      if (attention.isEmpty)
                        const EmptyState(compact: true, icon: Icons.check_circle_outline, title: 'All caught up')
                      else
                        for (final o in attention.take(6))
                          Padding(
                            padding: const EdgeInsets.only(bottom: AppSpacing.sm),
                            child: OrderCard(order: o, onTap: () => context.go('/orders/${o.id}')),
                          ),
                    ],
                  ),
                  secondary: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      SectionHeader(
                        title: 'Low stock',
                        actionLabel: 'Products',
                        onAction: () => context.go('/products'),
                        padding: const EdgeInsets.only(bottom: AppSpacing.sm),
                      ),
                      if (lowStock.isEmpty)
                        const EmptyState(compact: true, icon: Icons.inventory_2_outlined, title: 'Stock looks healthy')
                      else
                        AppCard(
                          padding: EdgeInsets.zero,
                          child: Column(
                            children: [
                              for (final p in lowStock.take(8))
                                AppListTile(
                                  dense: true,
                                  title: p.name,
                                  subtitle: p.hasVariants ? '${p.variants.where((v) => v.stock <= 5).length} variants low' : null,
                                  trailing: StatusChip(
                                    label: '${p.totalStock} left',
                                    tone: p.totalStock == 0 ? StatusTone.danger : StatusTone.warning,
                                    dense: true,
                                  ),
                                  onTap: () => context.go('/products/${p.id}'),
                                  showChevron: false,
                                ),
                            ],
                          ),
                        ),
                    ],
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  /// Revenue from the ledger when available (sale rows), otherwise from
  /// delivered sub-orders' net amounts.
  (int, int, String) _revenue(List<SubOrder> orders, List<VendorLedgerEntry>? ledger) {
    final since7 = DateTime.now().subtract(const Duration(days: 7));
    if (ledger != null && ledger.isNotEmpty) {
      var today = 0, week = 0;
      for (final e in ledger) {
        if (e.type != LedgerEntryType.sale && e.type != LedgerEntryType.commission && e.type != LedgerEntryType.refund) continue;
        final at = e.createdAt?.toLocal();
        if (at == null) continue;
        if (isToday(at)) today += e.amountKobo;
        if (at.isAfter(since7)) week += e.amountKobo;
      }
      return (today, week, 'net, from ledger');
    }
    var today = 0, week = 0;
    for (final o in orders) {
      if (o.status != SubOrderStatus.delivered) continue;
      final at = (o.updatedAt ?? o.createdAt)?.toLocal();
      if (at == null) continue;
      if (isToday(at)) today += o.vendorNetKobo;
      if (at.isAfter(since7)) week += o.vendorNetKobo;
    }
    return (today, week, 'net, from delivered orders');
  }
}
