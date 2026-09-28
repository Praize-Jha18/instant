import 'package:core_models/core_models.dart';
import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';

import '../../../core/utils/format.dart';

/// Labels for the vendor-triggered transitions.
String actionLabel(SubOrderStatus next) => switch (next) {
      SubOrderStatus.accepted => 'Accept order',
      SubOrderStatus.preparing => 'Start preparing',
      SubOrderStatus.ready => 'Mark ready',
      SubOrderStatus.cancelled => 'Cancel order',
      SubOrderStatus.outForDelivery => 'Out for delivery',
      SubOrderStatus.delivered => 'Delivered',
      SubOrderStatus.placed => 'Place',
      SubOrderStatus.awaitingPayment => 'Awaiting payment',
    };

/// Renders one button per allowed vendor transition
/// (`vendorNextSubOrderStatuses`). Nothing else is ever offered.
class OrderActions extends StatelessWidget {
  const OrderActions({
    super.key,
    required this.status,
    required this.onAction,
    this.busy = false,
    this.enabled = true,
    this.disabledReason,
    this.compact = false,
  });

  final SubOrderStatus status;
  final Future<void> Function(SubOrderStatus next) onAction;
  final bool busy;
  final bool enabled;
  final String? disabledReason;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    final next = vendorNextSubOrderStatuses(status).toList()
      ..sort((a, b) => a == SubOrderStatus.cancelled ? 1 : (b == SubOrderStatus.cancelled ? -1 : 0));
    if (next.isEmpty) return const SizedBox.shrink();
    final buttons = <Widget>[
      for (final s in next)
        s == SubOrderStatus.cancelled
            ? AppButton.danger(
                key: ValueKey('action-${s.json}'),
                label: actionLabel(s),
                icon: Icons.close_rounded,
                size: compact ? AppButtonSize.small : AppButtonSize.medium,
                onPressed: enabled && !busy ? () => onAction(s) : null,
                tooltip: disabledReason,
              )
            : AppButton.primary(
                key: ValueKey('action-${s.json}'),
                label: actionLabel(s),
                icon: _icon(s),
                loading: busy,
                size: compact ? AppButtonSize.small : AppButtonSize.medium,
                onPressed: enabled && !busy ? () => onAction(s) : null,
                tooltip: disabledReason,
              ),
    ];
    return Wrap(spacing: AppSpacing.sm, runSpacing: AppSpacing.sm, children: buttons);
  }

  static IconData _icon(SubOrderStatus s) => switch (s) {
        SubOrderStatus.accepted => Icons.check_rounded,
        SubOrderStatus.preparing => Icons.soup_kitchen_outlined,
        SubOrderStatus.ready => Icons.inventory_outlined,
        _ => Icons.arrow_forward_rounded,
      };
}

/// Summary card used on the board and dashboard.
class OrderCard extends StatelessWidget {
  const OrderCard({super.key, required this.order, this.onTap, this.selected = false, this.trailing});

  final SubOrder order;
  final VoidCallback? onTap;
  final bool selected;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    return AppCard(
      onTap: onTap,
      color: selected ? scheme.primaryContainer.withValues(alpha: 0.35) : null,
      padding: const EdgeInsets.all(AppSpacing.md),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text('#${order.orderNumber ?? order.id.substring(order.id.length - 6).toUpperCase()}',
                          style: theme.textTheme.titleSmall, maxLines: 1, overflow: TextOverflow.ellipsis),
                    ),
                    StatusChip.subOrder(order.status, dense: true),
                  ],
                ),
                const SizedBox(height: AppSpacing.xs),
                Text(
                  '${order.customerName ?? 'Customer'} · ${order.itemCount} item${order.itemCount == 1 ? '' : 's'} · ${timeAgo(order.createdAt)}',
                  style: theme.textTheme.bodySmall?.copyWith(color: scheme.onSurfaceVariant),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: AppSpacing.xs),
                Text(
                  order.items.map((i) => '${i.qty}× ${i.nameSnapshot}').join(', '),
                  style: theme.textTheme.bodySmall,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          const SizedBox(width: AppSpacing.md),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              MoneyText.kobo(order.totalKobo, emphasize: true, style: theme.textTheme.titleSmall),
              if (trailing != null) ...[const SizedBox(height: AppSpacing.sm), trailing!],
            ],
          ),
        ],
      ),
    );
  }
}

/// Vertical timeline of status changes.
class OrderTimeline extends StatelessWidget {
  const OrderTimeline({super.key, required this.entries});

  final List<TimelineEntry> entries;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    if (entries.isEmpty) {
      return Text('No events yet', style: theme.textTheme.bodySmall?.copyWith(color: scheme.onSurfaceVariant));
    }
    final sorted = [...entries]..sort((a, b) => a.at.compareTo(b.at));
    return Column(
      children: [
        for (var i = 0; i < sorted.length; i++)
          IntrinsicHeight(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                SizedBox(
                  width: 24,
                  child: Column(
                    children: [
                      Container(
                        width: 10,
                        height: 10,
                        margin: const EdgeInsets.only(top: 5),
                        decoration: BoxDecoration(
                            color: i == sorted.length - 1 ? scheme.primary : scheme.outlineVariant, shape: BoxShape.circle),
                      ),
                      if (i != sorted.length - 1) Expanded(child: Container(width: 2, color: scheme.outlineVariant)),
                    ],
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: AppSpacing.md),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(titleCase(sorted[i].status), style: theme.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600)),
                        Text(formatDateTime(sorted[i].at), style: theme.textTheme.bodySmall?.copyWith(color: scheme.onSurfaceVariant)),
                        if ((sorted[i].note ?? '').isNotEmpty)
                          Text(sorted[i].note!, style: theme.textTheme.bodySmall),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }
}
