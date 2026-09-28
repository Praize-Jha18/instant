import 'package:core_models/core_models.dart';
import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../app/providers.dart';
import '../../../core/utils/errors.dart';
import '../../../core/widgets/app_page.dart';
import '../data/orders_repository.dart';
import 'new_order_alerts.dart';
import 'order_detail_screen.dart';
import 'order_widgets.dart';

const _boardStatuses = [
  SubOrderStatus.placed,
  SubOrderStatus.accepted,
  SubOrderStatus.preparing,
  SubOrderStatus.ready,
  SubOrderStatus.outForDelivery,
  SubOrderStatus.delivered,
  SubOrderStatus.cancelled,
];

class OrdersBoardScreen extends ConsumerStatefulWidget {
  const OrdersBoardScreen({super.key});

  @override
  ConsumerState<OrdersBoardScreen> createState() => _OrdersBoardScreenState();
}

class _OrdersBoardScreenState extends ConsumerState<OrdersBoardScreen> {
  SubOrderStatus? _filter = SubOrderStatus.placed;
  String? _selectedId;

  @override
  void initState() {
    super.initState();
    Future.microtask(() => ref.read(newOrderAlertsProvider.notifier).markSeen());
  }

  @override
  Widget build(BuildContext context) {
    ref.listen(newOrderAlertsProvider, (_, next) {
      if (next.unseen > 0) ref.read(newOrderAlertsProvider.notifier).markSeen();
    });
    final orders = ref.watch(subOrdersStreamProvider);
    final wide = MediaQuery.sizeOf(context).width >= 900;

    return AppPage(
      title: 'Orders',
      actions: [
        IconButton(
          tooltip: 'Refresh',
          icon: const Icon(Icons.refresh_rounded),
          onPressed: () => refreshCollections(ref, const [Collections.subOrders, Collections.deliveries]),
        ),
      ],
      body: orders.when(
        loading: () => const SkeletonList(),
        error: (e, _) => ErrorState(message: errorMessage(e), onRetry: () => refreshCollections(ref)),
        data: (all) {
          final counts = <SubOrderStatus, int>{for (final s in _boardStatuses) s: 0};
          for (final o in all) {
            counts[o.status] = (counts[o.status] ?? 0) + 1;
          }
          final list = _filter == null ? all : all.where((o) => o.status == _filter).toList();
          final selected = wide ? list.where((o) => o.id == _selectedId).firstOrNull ?? list.firstOrNull : null;

          final listView = RefreshIndicator(
            onRefresh: () => refreshCollections(ref, const [Collections.subOrders, Collections.deliveries]),
            child: list.isEmpty
                ? ListView(
                    children: [
                      const SizedBox(height: 80),
                      EmptyState(
                        icon: Icons.receipt_long_outlined,
                        title: _filter == null ? 'No orders yet' : 'No ${StatusChip.subOrderLabel(_filter!).toLowerCase()} orders',
                        message: 'New paid orders appear here instantly.',
                      ),
                    ],
                  )
                : ListView.separated(
                    padding: AppSpacing.page,
                    itemCount: list.length,
                    separatorBuilder: (_, _) => AppSpacing.gapSm,
                    itemBuilder: (context, i) {
                      final o = list[i];
                      return FadeSlideIn.staggered(
                        index: i,
                        child: OrderCard(
                          order: o,
                          selected: wide && selected?.id == o.id,
                          trailing: _QuickAction(order: o),
                          onTap: () {
                            if (wide) {
                              setState(() => _selectedId = o.id);
                            } else {
                              context.go('/orders/${o.id}');
                            }
                          },
                        ),
                      );
                    },
                  ),
          );

          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
                child: FilterChips<SubOrderStatus>(
                  options: _boardStatuses,
                  selected: _filter,
                  counts: counts,
                  labelOf: StatusChip.subOrderLabel,
                  onSelected: (s) => setState(() => _filter = s),
                ),
              ),
              Expanded(
                child: wide
                    ? Row(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          SizedBox(width: 420, child: listView),
                          const VerticalDivider(width: 1),
                          Expanded(
                            child: selected == null
                                ? const EmptyState(icon: Icons.touch_app_outlined, title: 'Select an order', compact: true)
                                : SingleChildScrollView(
                                    key: ValueKey(selected.id),
                                    padding: AppSpacing.page,
                                    child: OrderDetailView(order: selected),
                                  ),
                          ),
                        ],
                      )
                    : listView,
              ),
            ],
          );
        },
      ),
    );
  }
}

/// The single most likely next action, right on the card.
class _QuickAction extends ConsumerStatefulWidget {
  const _QuickAction({required this.order});
  final SubOrder order;

  @override
  ConsumerState<_QuickAction> createState() => _QuickActionState();
}

class _QuickActionState extends ConsumerState<_QuickAction> {
  bool _busy = false;

  @override
  Widget build(BuildContext context) {
    final next = vendorNextSubOrderStatuses(widget.order.status).where((s) => s != SubOrderStatus.cancelled).firstOrNull;
    if (next == null) return const SizedBox.shrink();
    final online = ref.watch(isOnlineProvider);
    return AppButton.secondary(
      label: actionLabel(next),
      size: AppButtonSize.small,
      loading: _busy,
      tooltip: 'You are offline',
      onPressed: online
          ? () async {
              setState(() => _busy = true);
              try {
                await ref.read(ordersRepositoryProvider).updateStatus(widget.order.id, next);
              } catch (e) {
                if (context.mounted) showError(context, e);
              } finally {
                if (mounted) setState(() => _busy = false);
              }
            }
          : null,
    );
  }
}
