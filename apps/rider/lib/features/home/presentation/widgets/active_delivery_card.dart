import 'package:core_models/core_models.dart';
import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';

/// Compact card for the delivery currently in progress.
class ActiveDeliveryCard extends StatelessWidget {
  const ActiveDeliveryCard({
    super.key,
    required this.delivery,
    required this.onOpen,
  });

  final Delivery delivery;
  final VoidCallback onOpen;

  @override
  Widget build(BuildContext context) {
    final scheme = context.colors;
    final pickedUp = delivery.status == DeliveryStatus.pickedUp;
    final address = delivery.dropoff?.addressSnapshot?.oneLine;
    return AppCard(
      onTap: onOpen,
      color: scheme.primaryContainer.withValues(alpha: 0.35),
      elevated: true,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              StatusChip.delivery(delivery.status),
              const Spacer(),
              if (delivery.orderNumber != null)
                Text(
                  '#${delivery.orderNumber}',
                  style: context.text.labelLarge?.copyWith(
                    color: scheme.onSurfaceVariant,
                  ),
                ),
            ],
          ),
          AppSpacing.gapMd,
          Text(
            pickedUp
                ? 'Deliver to ${delivery.customerName ?? 'customer'}'
                : 'Pick up at ${delivery.pickup?.vendorName ?? 'vendor'}',
            style: context.text.titleMedium,
          ),
          if ((pickedUp ? address : delivery.pickup?.line1) != null) ...[
            AppSpacing.gapXs,
            Text(
              pickedUp ? address! : delivery.pickup!.line1!,
              style: context.text.bodyMedium?.copyWith(
                color: scheme.onSurfaceVariant,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],
          AppSpacing.gapLg,
          AppButton.primary(
            label: pickedUp ? 'Continue to drop-off' : 'Continue to pickup',
            trailingIcon: Icons.arrow_forward_rounded,
            expanded: true,
            onPressed: onOpen,
          ),
        ],
      ),
    );
  }
}
