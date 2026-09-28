import 'package:core_models/core_models.dart';
import 'package:flutter/material.dart';

import '../tokens/app_colors.dart';
import '../tokens/app_spacing.dart';

/// Tone of a [StatusChip], mapped to semantic colours.
enum StatusTone { neutral, info, success, warning, danger, primary }

/// Small pill showing an order / delivery / payment status with the right
/// colour and a human label.
class StatusChip extends StatelessWidget {
  const StatusChip({
    super.key,
    required this.label,
    this.tone = StatusTone.neutral,
    this.icon,
    this.dense = false,
  });

  factory StatusChip.subOrder(SubOrderStatus status, {Key? key, bool dense = false}) => StatusChip(
        key: key,
        label: subOrderLabel(status),
        tone: subOrderTone(status),
        dense: dense,
      );

  factory StatusChip.delivery(DeliveryStatus status, {Key? key, bool dense = false}) => StatusChip(
        key: key,
        label: deliveryLabel(status),
        tone: deliveryTone(status),
        dense: dense,
      );

  factory StatusChip.payment(PaymentStatus status, {Key? key, bool dense = false}) => StatusChip(
        key: key,
        label: paymentLabel(status),
        tone: paymentTone(status),
        dense: dense,
      );

  factory StatusChip.vendor(VendorStatus status, {Key? key, bool dense = false}) => StatusChip(
        key: key,
        label: _title(status.json),
        tone: switch (status) {
          VendorStatus.pending => StatusTone.warning,
          VendorStatus.active => StatusTone.success,
          VendorStatus.suspended => StatusTone.danger,
        },
        dense: dense,
      );

  factory StatusChip.rider(RiderStatus status, {Key? key, bool dense = false}) => StatusChip(
        key: key,
        label: _title(status.json),
        tone: switch (status) {
          RiderStatus.pending => StatusTone.warning,
          RiderStatus.active => StatusTone.success,
          RiderStatus.suspended => StatusTone.danger,
        },
        dense: dense,
      );

  factory StatusChip.payout(PayoutStatus status, {Key? key, bool dense = false}) => StatusChip(
        key: key,
        label: _title(status.json),
        tone: switch (status) {
          PayoutStatus.requested => StatusTone.info,
          PayoutStatus.paid => StatusTone.success,
          PayoutStatus.failed => StatusTone.danger,
        },
        dense: dense,
      );

  final String label;
  final StatusTone tone;
  final IconData? icon;
  final bool dense;

  static String subOrderLabel(SubOrderStatus s) => switch (s) {
        SubOrderStatus.awaitingPayment => 'Awaiting payment',
        SubOrderStatus.placed => 'Placed',
        SubOrderStatus.accepted => 'Accepted',
        SubOrderStatus.preparing => 'Preparing',
        SubOrderStatus.ready => 'Ready',
        SubOrderStatus.outForDelivery => 'Out for delivery',
        SubOrderStatus.delivered => 'Delivered',
        SubOrderStatus.cancelled => 'Cancelled',
      };

  static StatusTone subOrderTone(SubOrderStatus s) => switch (s) {
        SubOrderStatus.awaitingPayment => StatusTone.warning,
        SubOrderStatus.placed => StatusTone.info,
        SubOrderStatus.accepted => StatusTone.info,
        SubOrderStatus.preparing => StatusTone.primary,
        SubOrderStatus.ready => StatusTone.primary,
        SubOrderStatus.outForDelivery => StatusTone.primary,
        SubOrderStatus.delivered => StatusTone.success,
        SubOrderStatus.cancelled => StatusTone.danger,
      };

  static String deliveryLabel(DeliveryStatus s) => switch (s) {
        DeliveryStatus.unassigned => 'Unassigned',
        DeliveryStatus.offered => 'Offered',
        DeliveryStatus.accepted => 'Accepted',
        DeliveryStatus.pickedUp => 'Picked up',
        DeliveryStatus.delivered => 'Delivered',
        DeliveryStatus.failed => 'Failed',
      };

  static StatusTone deliveryTone(DeliveryStatus s) => switch (s) {
        DeliveryStatus.unassigned => StatusTone.neutral,
        DeliveryStatus.offered => StatusTone.warning,
        DeliveryStatus.accepted => StatusTone.info,
        DeliveryStatus.pickedUp => StatusTone.primary,
        DeliveryStatus.delivered => StatusTone.success,
        DeliveryStatus.failed => StatusTone.danger,
      };

  static String paymentLabel(PaymentStatus s) => switch (s) {
        PaymentStatus.pending => 'Payment pending',
        PaymentStatus.paid => 'Paid',
        PaymentStatus.failed => 'Payment failed',
        PaymentStatus.refunded => 'Refunded',
        PaymentStatus.partiallyRefunded => 'Partially refunded',
      };

  static StatusTone paymentTone(PaymentStatus s) => switch (s) {
        PaymentStatus.pending => StatusTone.warning,
        PaymentStatus.paid => StatusTone.success,
        PaymentStatus.failed => StatusTone.danger,
        PaymentStatus.refunded => StatusTone.neutral,
        PaymentStatus.partiallyRefunded => StatusTone.info,
      };

  static String _title(String snake) => snake
      .split('_')
      .map((w) => w.isEmpty ? w : '${w[0].toUpperCase()}${w.substring(1)}')
      .join(' ');

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final semantic = context.semanticColors;
    final (bg, fg) = switch (tone) {
      StatusTone.neutral => (scheme.surfaceContainerHighest, scheme.onSurfaceVariant),
      StatusTone.info => (semantic.infoContainer, semantic.onInfoContainer),
      StatusTone.success => (semantic.successContainer, semantic.onSuccessContainer),
      StatusTone.warning => (semantic.warningContainer, semantic.onWarningContainer),
      StatusTone.danger => (semantic.dangerContainer, semantic.onDangerContainer),
      StatusTone.primary => (scheme.primaryContainer, scheme.onPrimaryContainer),
    };
    final style = (dense ? Theme.of(context).textTheme.labelSmall : Theme.of(context).textTheme.labelMedium)
        ?.copyWith(color: fg, fontWeight: FontWeight.w600);
    return Semantics(
      label: 'Status: $label',
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: dense ? AppSpacing.sm : AppSpacing.md,
          vertical: dense ? AppSpacing.xxs : AppSpacing.xs + 1,
        ),
        decoration: BoxDecoration(color: bg, borderRadius: BorderRadius.circular(999)),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (icon != null) ...[Icon(icon, size: dense ? 12 : 14, color: fg), const SizedBox(width: AppSpacing.xs)],
            Text(label, style: style),
          ],
        ),
      ),
    );
  }
}
