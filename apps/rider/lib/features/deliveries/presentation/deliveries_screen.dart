import 'package:core_models/core_models.dart';
import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../app/providers.dart';
import '../../../app/redirect.dart';
import '../../../core/formatters.dart';
import '../data/deliveries_providers.dart';

/// History of this rider's deliveries, newest first, straight from the store.
class DeliveriesScreen extends ConsumerWidget {
  const DeliveriesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final async = ref.watch(myDeliveriesProvider);
    return Scaffold(
      appBar: AppBar(title: const Text('Deliveries')),
      body: RefreshIndicator(
        onRefresh: () => ref.read(syncEngineProvider).pull(),
        child: async.when(
          loading: () => const SkeletonList(),
          error: (e, _) => ErrorState(onRetry: () => ref.invalidate(myDeliveriesProvider)),
          data: (items) {
            final list = items.where((d) => d.status != DeliveryStatus.offered).toList();
            if (list.isEmpty) {
              return ListView(
                physics: const AlwaysScrollableScrollPhysics(),
                children: const [
                  SizedBox(height: 120),
                  EmptyState(
                    icon: Icons.local_shipping_outlined,
                    title: 'No deliveries yet',
                    message: 'Accepted deliveries and your history will appear here.',
                  ),
                ],
              );
            }
            return ListView.separated(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: AppSpacing.page,
              itemCount: list.length,
              separatorBuilder: (_, _) => AppSpacing.gapMd,
              itemBuilder: (context, i) => FadeSlideIn.staggered(
                index: i,
                child: DeliveryTile(delivery: list[i], onTap: () => context.go(Routes.delivery(list[i].id))),
              ),
            );
          },
        ),
      ),
    );
  }
}

class DeliveryTile extends StatelessWidget {
  const DeliveryTile({super.key, required this.delivery, required this.onTap});

  final Delivery delivery;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final scheme = context.colors;
    final when = delivery.updatedAt ?? delivery.createdAt;
    final active = delivery.status == DeliveryStatus.accepted || delivery.status == DeliveryStatus.pickedUp;
    return AppCard(
      onTap: onTap,
      padding: const EdgeInsets.all(AppSpacing.md),
      color: active ? scheme.primaryContainer.withValues(alpha: 0.25) : null,
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(color: scheme.surfaceContainerHighest, borderRadius: AppRadius.smAll),
            child: Icon(
              switch (delivery.status) {
                DeliveryStatus.delivered => Icons.check_rounded,
                DeliveryStatus.failed => Icons.close_rounded,
                DeliveryStatus.pickedUp => Icons.route_rounded,
                _ => Icons.local_shipping_outlined,
              },
              color: scheme.onSurfaceVariant,
            ),
          ),
          AppSpacing.gapMd,
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  delivery.orderNumber != null ? 'Order #${delivery.orderNumber}' : 'Delivery',
                  style: context.text.bodyLarge?.copyWith(fontWeight: FontWeight.w600),
                ),
                AppSpacing.gapXs,
                Text(
                  delivery.dropoff?.addressSnapshot?.oneLine ?? delivery.customerName ?? 'Customer',
                  style: context.text.bodyMedium?.copyWith(color: scheme.onSurfaceVariant),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                if (when != null) ...[
                  AppSpacing.gapXs,
                  Text(Fmt.relativeDay(when), style: context.text.bodySmall?.copyWith(color: scheme.onSurfaceVariant)),
                ],
              ],
            ),
          ),
          AppSpacing.gapSm,
          StatusChip.delivery(delivery.status, dense: true),
        ],
      ),
    );
  }
}
