import 'package:core_models/core_models.dart';
import 'package:design_system/design_system.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/utils/errors.dart';
import '../../../core/utils/format.dart';
import '../../../core/widgets/app_page.dart';
import '../data/admin_repository.dart';

class AdminDashboardScreen extends ConsumerWidget {
  const AdminDashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final stats = ref.watch(adminStatsProvider);
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    return AppPage(
      title: 'Platform overview',
      actions: [
        IconButton(tooltip: 'Refresh', icon: const Icon(Icons.refresh_rounded), onPressed: () => ref.invalidate(adminStatsProvider)),
      ],
      body: RefreshIndicator(
        onRefresh: () async => ref.invalidate(adminStatsProvider),
        child: stats.when(
          loading: () => const SkeletonList(),
          error: (e, _) => ErrorState(
            offline: isOfflineError(e),
            message: errorMessage(e),
            onRetry: () => ref.invalidate(adminStatsProvider),
          ),
          data: (s) => ListView(
            padding: AppSpacing.page,
            children: [
              LayoutBuilder(
                builder: (context, c) {
                  final columns = c.maxWidth >= 1000 ? 4 : (c.maxWidth >= 600 ? 3 : 2);
                  return GridView.count(
                    crossAxisCount: columns,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    crossAxisSpacing: AppSpacing.md,
                    mainAxisSpacing: AppSpacing.md,
                    childAspectRatio: columns >= 3 ? 1.8 : 1.4,
                    children: [
                      StatTile(
                        label: 'Revenue today',
                        icon: Icons.payments_outlined,
                        value: MoneyText.kobo(s.today.revenueKobo, showDecimals: false, emphasize: true),
                        caption: '${s.today.orders} paid orders',
                      ),
                      StatTile(
                        label: 'Revenue 7 days',
                        icon: Icons.trending_up_rounded,
                        value: MoneyText.kobo(s.last7d.revenueKobo, showDecimals: false),
                        caption: 'commission ${Money.fromKobo(s.last7d.commissionKobo).format(showDecimals: false)}',
                      ),
                      StatTile(
                        label: 'Open sub-orders',
                        icon: Icons.pending_actions_outlined,
                        value: Text('${s.openSubOrders}'),
                        caption: '${s.orders} orders total · ${s.paidOrders} paid',
                        onTap: () => context.go('/admin/orders'),
                      ),
                      StatTile(
                        label: 'Vendors',
                        icon: Icons.storefront_outlined,
                        value: Text('${s.totalVendors}'),
                        caption: '${s.vendorsByStatus['pending'] ?? 0} pending approval',
                        tone: (s.vendorsByStatus['pending'] ?? 0) > 0 ? context.semanticColors.warning : null,
                        onTap: () => context.go('/admin/vendors'),
                      ),
                      StatTile(
                        label: 'Users',
                        icon: Icons.people_outline,
                        value: Text('${s.users}'),
                        caption: '${s.customers} customers · ${s.riders} riders',
                        onTap: () => context.go('/admin/users'),
                      ),
                      StatTile(
                        label: 'Products',
                        icon: Icons.inventory_2_outlined,
                        value: Text('${s.activeProducts}'),
                        caption: 'active of ${s.products}',
                      ),
                    ],
                  );
                },
              ),
              AppSpacing.gapXl,
              AppCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Revenue by window', style: theme.textTheme.titleMedium),
                    Text('Gross paid-order revenue and the platform commission share',
                        style: theme.textTheme.bodySmall?.copyWith(color: scheme.onSurfaceVariant)),
                    AppSpacing.gapLg,
                    SizedBox(height: 220, child: RevenueBarChart(stats: s)),
                    AppSpacing.gapMd,
                    Wrap(
                      spacing: AppSpacing.lg,
                      children: [
                        _LegendItem(color: scheme.primary, label: 'Revenue'),
                        _LegendItem(color: scheme.tertiary, label: 'Commission'),
                      ],
                    ),
                  ],
                ),
              ),
              AppSpacing.gapLg,
              AppCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Vendors by status', style: theme.textTheme.titleMedium),
                    AppSpacing.gapMd,
                    for (final status in VendorStatus.values)
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: AppSpacing.xs),
                        child: Row(
                          children: [
                            StatusChip.vendor(status, dense: true),
                            const SizedBox(width: AppSpacing.md),
                            Expanded(
                              child: LinearProgressIndicator(
                                value: s.totalVendors == 0 ? 0 : (s.vendorsByStatus[status.json] ?? 0) / s.totalVendors,
                                minHeight: 8,
                                borderRadius: AppRadius.pill,
                              ),
                            ),
                            const SizedBox(width: AppSpacing.md),
                            SizedBox(width: 32, child: Text('${s.vendorsByStatus[status.json] ?? 0}', textAlign: TextAlign.end)),
                          ],
                        ),
                      ),
                  ],
                ),
              ),
              AppSpacing.gapLg,
              Center(
                child: Text('Generated ${formatDateTime(s.generatedAt)}',
                    style: theme.textTheme.bodySmall?.copyWith(color: scheme.onSurfaceVariant)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _LegendItem extends StatelessWidget {
  const _LegendItem({required this.color, required this.label});
  final Color color;
  final String label;

  @override
  Widget build(BuildContext context) => Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(width: 12, height: 12, decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(3))),
          const SizedBox(width: AppSpacing.xs),
          Text(label, style: Theme.of(context).textTheme.labelMedium),
        ],
      );
}

/// Grouped bars: revenue vs commission for today / 7 days / 30 days. One
/// axis, thin rounded marks, recessive grid, tooltips on hover.
class RevenueBarChart extends StatelessWidget {
  const RevenueBarChart({super.key, required this.stats});

  final AdminStatsView stats;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final windows = [('Today', stats.today), ('7 days', stats.last7d), ('30 days', stats.last30d)];
    final maxY = windows.map((w) => w.$2.revenueKobo).fold<int>(0, (a, b) => a > b ? a : b) / 100;
    final labelStyle = theme.textTheme.labelSmall?.copyWith(color: scheme.onSurfaceVariant);

    String short(double naira) {
      if (naira >= 1e6) return '₦${(naira / 1e6).toStringAsFixed(1)}M';
      if (naira >= 1e3) return '₦${(naira / 1e3).toStringAsFixed(0)}k';
      return '₦${naira.toStringAsFixed(0)}';
    }

    return BarChart(
      BarChartData(
        maxY: maxY <= 0 ? 1 : maxY * 1.15,
        alignment: BarChartAlignment.spaceAround,
        gridData: FlGridData(
          show: true,
          drawVerticalLine: false,
          getDrawingHorizontalLine: (_) => FlLine(color: scheme.outlineVariant.withValues(alpha: 0.4), strokeWidth: 1),
        ),
        borderData: FlBorderData(show: false),
        titlesData: FlTitlesData(
          topTitles: const AxisTitles(),
          rightTitles: const AxisTitles(),
          leftTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 52,
              getTitlesWidget: (v, meta) => Padding(
                padding: const EdgeInsets.only(right: 4),
                child: Text(short(v), style: labelStyle, textAlign: TextAlign.right),
              ),
            ),
          ),
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 24,
              getTitlesWidget: (v, meta) => Padding(
                padding: const EdgeInsets.only(top: 6),
                child: Text(windows[v.toInt().clamp(0, 2)].$1, style: labelStyle),
              ),
            ),
          ),
        ),
        barTouchData: BarTouchData(
          touchTooltipData: BarTouchTooltipData(
            getTooltipColor: (_) => scheme.inverseSurface,
            getTooltipItem: (group, _, rod, rodIndex) => BarTooltipItem(
              '${rodIndex == 0 ? 'Revenue' : 'Commission'}\n${Money.fromNaira(rod.toY).format(showDecimals: false)}',
              theme.textTheme.labelMedium!.copyWith(color: scheme.onInverseSurface),
            ),
          ),
        ),
        barGroups: [
          for (var i = 0; i < windows.length; i++)
            BarChartGroupData(
              x: i,
              barsSpace: 4,
              barRods: [
                BarChartRodData(
                  toY: windows[i].$2.revenueKobo / 100,
                  color: scheme.primary,
                  width: 18,
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(4)),
                ),
                BarChartRodData(
                  toY: windows[i].$2.commissionKobo / 100,
                  color: scheme.tertiary,
                  width: 18,
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(4)),
                ),
              ],
            ),
        ],
      ),
    );
  }
}
