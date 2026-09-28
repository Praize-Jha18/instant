import 'package:core_models/core_models.dart';
import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../app/providers.dart';
import '../../../app/routes.dart';
import '../../../core/errors.dart';
import '../../../core/formatters.dart';
import '../../../core/widgets/list_phase.dart';
import '../domain/order_rules.dart';
import 'order_providers.dart';

class OrdersScreen extends ConsumerWidget {
  const OrdersScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ordersAsync = ref.watch(ordersProvider);
    final subOrders = ref.watch(subOrdersByOrderProvider).value ?? const <String, List<SubOrder>>{};
    final status = ref.watch(syncStatusProvider).value;
    final engine = ref.watch(syncEngineProvider);
    final orders = ordersAsync.value ?? const <Order>[];
    final phase = ordersAsync.isLoading && !ordersAsync.hasValue
        ? ListPhase.loading
        : resolveListPhase(count: orders.length, status: status);

    Future<void> refresh() async {
      try {
        await engine.pull();
      } catch (e) {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(describeError(e))));
        }
      }
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Orders')),
      body: RefreshIndicator(
        onRefresh: refresh,
        child: PhaseView(
          phase: phase,
          onRetry: refresh,
          emptyIcon: Icons.receipt_long_outlined,
          emptyTitle: 'No orders yet',
          emptyMessage: 'Your orders will show up here, even offline.',
          emptyAction: AppButton.secondary(label: 'Browse vendors', onPressed: () => context.go(AppRoutes.home)),
          loading: (_) => const SkeletonList(itemCount: 5),
          ready: (_) => ListView.separated(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.fromLTRB(AppSpacing.lg, AppSpacing.sm, AppSpacing.lg, AppSpacing.xl),
            itemCount: orders.length,
            separatorBuilder: (_, _) => const SizedBox(height: AppSpacing.md),
            itemBuilder: (context, i) => FadeSlideIn.staggered(
              index: i,
              child: _OrderTile(order: orders[i], subOrders: subOrders[orders[i].id] ?? orders[i].subOrders),
            ),
          ),
        ),
      ),
    );
  }
}

class _OrderTile extends StatelessWidget {
  const _OrderTile({required this.order, required this.subOrders});
  final Order order;
  final List<SubOrder> subOrders;

  @override
  Widget build(BuildContext context) {
    final scheme = context.colors;
    final headline = headlineStatus(subOrders);
    final vendors = subOrders.map((s) => s.vendorName ?? 'Vendor').toSet().join(', ');
    return AppCard(
      onTap: () => context.push(AppRoutes.order(order.id)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(child: Text('Order ${order.orderNumber}', style: context.text.titleSmall)),
              MoneyText.kobo(order.totalKobo, emphasize: true),
            ],
          ),
          const SizedBox(height: AppSpacing.xxs),
          Text(
            [formatDateTime(order.placedAt ?? order.createdAt), if (vendors.isNotEmpty) vendors].join(' · '),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: context.text.bodySmall?.copyWith(color: scheme.onSurfaceVariant),
          ),
          const SizedBox(height: AppSpacing.sm),
          Wrap(
            spacing: AppSpacing.sm,
            runSpacing: AppSpacing.xs,
            children: [
              if (!order.isPaid) StatusChip.payment(order.paymentStatus, dense: true),
              if (subOrders.length <= 1 && headline != null)
                StatusChip.subOrder(headline, dense: true)
              else
                for (final s in subOrders)
                  StatusChip(
                    label: '${s.vendorName ?? 'Vendor'}: ${StatusChip.subOrderLabel(s.status)}',
                    tone: StatusChip.subOrderTone(s.status),
                    dense: true,
                  ),
            ],
          ),
        ],
      ),
    );
  }
}
