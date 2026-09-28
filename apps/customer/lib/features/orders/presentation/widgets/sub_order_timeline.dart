import 'package:core_models/core_models.dart';
import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';

import '../../../../core/formatters.dart';
import '../../domain/order_rules.dart';

/// Vertical step timeline for one sub-order.
class SubOrderTimeline extends StatelessWidget {
  const SubOrderTimeline({super.key, required this.subOrder});
  final SubOrder subOrder;

  @override
  Widget build(BuildContext context) {
    final scheme = context.colors;
    final semantic = context.semanticColors;
    final status = subOrder.status;
    final cancelled = status == SubOrderStatus.cancelled;
    final reachedAt = <String, DateTime>{for (final t in subOrder.timeline) t.status: t.at};
    final currentIndex = kSubOrderTimeline.indexOf(status);

    final steps = cancelled
        ? [
            ...kSubOrderTimeline.takeWhile((s) => reachedAt.containsKey(s.json)),
            SubOrderStatus.cancelled,
          ]
        : status == SubOrderStatus.awaitingPayment
            ? [SubOrderStatus.awaitingPayment, ...kSubOrderTimeline]
            : kSubOrderTimeline;

    return Column(
      children: [
        for (var i = 0; i < steps.length; i++)
          _Step(
            label: StatusChip.subOrderLabel(steps[i]),
            at: reachedAt[steps[i].json],
            done: steps[i] == SubOrderStatus.cancelled
                ? true
                : steps[i] == status || (currentIndex >= 0 && kSubOrderTimeline.indexOf(steps[i]) < currentIndex) ||
                    (status == SubOrderStatus.delivered),
            current: steps[i] == status,
            last: i == steps.length - 1,
            color: steps[i] == SubOrderStatus.cancelled ? semantic.danger : scheme.primary,
          ),
      ],
    );
  }
}

class _Step extends StatelessWidget {
  const _Step({
    required this.label,
    required this.at,
    required this.done,
    required this.current,
    required this.last,
    required this.color,
  });

  final String label;
  final DateTime? at;
  final bool done;
  final bool current;
  final bool last;
  final Color color;

  @override
  Widget build(BuildContext context) {
    final scheme = context.colors;
    final dotColor = done ? color : scheme.outlineVariant;
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SizedBox(
            width: 24,
            child: Column(
              children: [
                AnimatedContainer(
                  duration: AppMotion.normal,
                  width: current ? 14 : 10,
                  height: current ? 14 : 10,
                  margin: const EdgeInsets.only(top: 4),
                  decoration: BoxDecoration(
                    color: dotColor,
                    shape: BoxShape.circle,
                    boxShadow: current ? [BoxShadow(color: color.withValues(alpha: 0.35), blurRadius: 8)] : null,
                  ),
                ),
                if (!last) Expanded(child: Container(width: 2, color: done ? color.withValues(alpha: 0.5) : scheme.outlineVariant)),
              ],
            ),
          ),
          const SizedBox(width: AppSpacing.sm),
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(bottom: last ? 0 : AppSpacing.md),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: context.text.bodyMedium?.copyWith(
                      fontWeight: current ? FontWeight.w600 : FontWeight.w500,
                      color: done ? scheme.onSurface : scheme.onSurfaceVariant,
                    ),
                  ),
                  if (at != null)
                    Text(formatDateTime(at), style: context.text.bodySmall?.copyWith(color: scheme.onSurfaceVariant)),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
