import 'package:core_models/core_models.dart';
import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../app/providers.dart';
import '../../../core/utils/errors.dart';
import '../../../core/utils/format.dart';
import '../../../core/widgets/app_page.dart';
import '../data/admin_repository.dart';

class AdminOrdersScreen extends ConsumerStatefulWidget {
  const AdminOrdersScreen({super.key});

  @override
  ConsumerState<AdminOrdersScreen> createState() => _AdminOrdersScreenState();
}

class _AdminOrdersScreenState extends ConsumerState<AdminOrdersScreen> {
  PaymentStatus? _filter;
  Object? _error;

  @override
  void initState() {
    super.initState();
    Future.microtask(_refresh);
  }

  Future<void> _refresh() async {
    try {
      await ref.read(adminRepositoryProvider).refreshOrders(paymentStatus: _filter);
      if (mounted) setState(() => _error = null);
    } catch (e) {
      if (mounted) setState(() => _error = e);
    }
  }

  @override
  Widget build(BuildContext context) {
    final orders = ref.watch(ordersStreamProvider);
    final subOrders = ref.watch(subOrdersStreamProvider).value ?? const <SubOrder>[];
    final vendors = ref.watch(vendorsStreamProvider).value ?? const <Vendor>[];
    final vendorNames = {for (final v in vendors) v.id: v.name};
    final theme = Theme.of(context);
    return AppPage(
      title: 'Orders',
      actions: [IconButton(tooltip: 'Refresh', icon: const Icon(Icons.refresh_rounded), onPressed: _refresh)],
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
            child: FilterChips<PaymentStatus>(
              options: PaymentStatus.values,
              selected: _filter,
              labelOf: StatusChip.paymentLabel,
              onSelected: (s) {
                setState(() => _filter = s);
                _refresh();
              },
            ),
          ),
          Expanded(
            child: orders.when(
              loading: () => const SkeletonList(),
              error: (e, _) => ErrorState(message: errorMessage(e), onRetry: _refresh),
              data: (all) {
                final list = all.where((o) => _filter == null || o.paymentStatus == _filter).toList();
                if (list.isEmpty) {
                  return RefreshIndicator(
                    onRefresh: _refresh,
                    child: ListView(children: [
                      const SizedBox(height: 80),
                      if (_error != null && all.isEmpty)
                        ErrorState(offline: isOfflineError(_error), message: errorMessage(_error), onRetry: _refresh)
                      else
                        const EmptyState(icon: Icons.receipt_long_outlined, title: 'No orders'),
                    ]),
                  );
                }
                return RefreshIndicator(
                  onRefresh: _refresh,
                  child: ListView.separated(
                    padding: AppSpacing.page,
                    itemCount: list.length,
                    separatorBuilder: (_, _) => AppSpacing.gapSm,
                    itemBuilder: (context, i) {
                      final o = list[i];
                      final subs = subOrders.where((s) => s.orderId == o.id).toList();
                      return AppCard(
                        padding: const EdgeInsets.all(AppSpacing.md),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(children: [
                              Expanded(child: Text('#${o.orderNumber}', style: theme.textTheme.titleSmall)),
                              StatusChip.payment(o.paymentStatus, dense: true),
                              const SizedBox(width: AppSpacing.sm),
                              MoneyText.kobo(o.totalKobo, emphasize: true, style: theme.textTheme.titleSmall),
                            ]),
                            const SizedBox(height: AppSpacing.xxs),
                            Text(
                              '${formatDateTime(o.placedAt ?? o.createdAt)} · ${o.subOrderIds.length} vendor${o.subOrderIds.length == 1 ? '' : 's'} · ${o.addressSnapshot?.oneLine ?? 'no address'}',
                              style: theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.onSurfaceVariant),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                            if (subs.isNotEmpty) ...[
                              const SizedBox(height: AppSpacing.sm),
                              Wrap(
                                spacing: AppSpacing.sm,
                                runSpacing: AppSpacing.xs,
                                children: [
                                  for (final s in subs)
                                    Chip(
                                      visualDensity: VisualDensity.compact,
                                      avatar: StatusChip.subOrder(s.status, dense: true),
                                      label: Text(s.vendorName ?? vendorNames[s.vendorId] ?? s.vendorId.substring(s.vendorId.length - 4)),
                                    ),
                                ],
                              ),
                            ],
                          ],
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
}
