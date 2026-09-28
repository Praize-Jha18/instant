import 'package:core_models/core_models.dart';
import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../app/providers.dart';
import '../../../core/utils/errors.dart';
import '../../../core/utils/format.dart';
import '../../../core/widgets/app_page.dart';
import '../data/orders_repository.dart';
import 'assign_rider_sheet.dart';
import 'order_widgets.dart';

class OrderDetailScreen extends ConsumerWidget {
  const OrderDetailScreen({super.key, required this.subOrderId});

  final String subOrderId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final order = ref.watch(subOrderStreamProvider(subOrderId));
    return AppPage(
      title: order.value?.orderNumber != null ? 'Order #${order.value!.orderNumber}' : 'Order',
      body: order.when(
        loading: () => const SkeletonList(),
        error: (e, _) => ErrorState(message: errorMessage(e)),
        data: (o) => o == null
            ? EmptyState(
                icon: Icons.receipt_long_outlined,
                title: 'Order not found',
                message: 'It may have been removed or not synced yet.',
                action: AppButton.secondary(label: 'Back to orders', onPressed: () => context.go('/orders')),
              )
            : SingleChildScrollView(padding: AppSpacing.page, child: OrderDetailView(order: o)),
      ),
    );
  }
}

/// Full order detail; also embedded in the wide-screen board.
class OrderDetailView extends ConsumerStatefulWidget {
  const OrderDetailView({super.key, required this.order});

  final SubOrder order;

  @override
  ConsumerState<OrderDetailView> createState() => _OrderDetailViewState();
}

class _OrderDetailViewState extends ConsumerState<OrderDetailView> {
  bool _busy = false;

  Future<void> _transition(SubOrderStatus next) async {
    String? note;
    if (next == SubOrderStatus.cancelled) {
      final ok = await AppBottomSheet.confirm(
        context,
        title: 'Cancel this order?',
        message: 'The customer will be refunded and reserved stock released.',
        confirmLabel: 'Cancel order',
        cancelLabel: 'Keep order',
        destructive: true,
      );
      if (!ok) return;
      note = 'Cancelled by vendor';
    }
    setState(() => _busy = true);
    try {
      await ref.read(ordersRepositoryProvider).updateStatus(widget.order.id, next, note: note);
      if (mounted) showSnack(context, 'Order ${StatusChip.subOrderLabel(next).toLowerCase()}');
    } catch (e) {
      if (mounted) showError(context, e);
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final o = widget.order;
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final online = ref.watch(isOnlineProvider);
    final delivery = o.deliveryId == null ? null : ref.watch(deliveryStreamProvider(o.deliveryId!)).value;
    final address = delivery?.dropoff?.addressSnapshot;

    final header = AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(child: Text('#${o.orderNumber ?? o.id}', style: theme.textTheme.titleLarge)),
              StatusChip.subOrder(o.status),
            ],
          ),
          const SizedBox(height: AppSpacing.xs),
          Text('Placed ${formatDateTime(o.createdAt)} · ${o.customerName ?? 'Customer'}',
              style: theme.textTheme.bodySmall?.copyWith(color: scheme.onSurfaceVariant)),
          const SizedBox(height: AppSpacing.lg),
          OrderActions(
            status: o.status,
            busy: _busy,
            enabled: online,
            disabledReason: 'You are offline',
            onAction: _transition,
          ),
        ],
      ),
    );

    final items = AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Items', style: theme.textTheme.titleMedium),
          const SizedBox(height: AppSpacing.md),
          for (final item in o.items)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: AppSpacing.xs),
              child: Row(
                children: [
                  SizedBox(width: 36, child: Text('${item.qty}×', style: theme.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600))),
                  Expanded(child: Text(item.nameSnapshot, style: theme.textTheme.bodyMedium)),
                  MoneyText.kobo(item.lineTotalKobo, style: theme.textTheme.bodyMedium),
                ],
              ),
            ),
          const Divider(height: AppSpacing.xl),
          _totalRow(context, 'Subtotal', o.subtotalKobo),
          _totalRow(context, 'Delivery fee', o.deliveryFeeKobo),
          _totalRow(context, 'Platform commission', -o.commissionKobo),
          const SizedBox(height: AppSpacing.xs),
          Row(
            children: [
              Expanded(child: Text('You earn', style: theme.textTheme.titleSmall)),
              MoneyText.kobo(o.vendorNetKobo, emphasize: true, style: theme.textTheme.titleMedium),
            ],
          ),
        ],
      ),
    );

    final customer = AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Delivery address', style: theme.textTheme.titleMedium),
          const SizedBox(height: AppSpacing.md),
          if (address != null) ...[
            Text(address.oneLine, style: theme.textTheme.bodyMedium),
            if ((address.phone ?? '').isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(top: AppSpacing.xs),
                child: Row(children: [
                  const Icon(Icons.phone_outlined, size: 16),
                  const SizedBox(width: AppSpacing.xs),
                  Text(address.phone!, style: theme.textTheme.bodyMedium),
                ]),
              ),
          ] else if (delivery?.customerName != null || o.customerName != null)
            Text(delivery?.customerName ?? o.customerName ?? '', style: theme.textTheme.bodyMedium)
          else
            Text(
              o.status.index < SubOrderStatus.ready.index
                  ? 'The address snapshot is attached to the delivery, created when the order is marked ready.'
                  : 'Address not available',
              style: theme.textTheme.bodySmall?.copyWith(color: scheme.onSurfaceVariant),
            ),
        ],
      ),
    );

    final timeline = AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Timeline', style: theme.textTheme.titleMedium),
          const SizedBox(height: AppSpacing.md),
          OrderTimeline(entries: o.timeline),
        ],
      ),
    );

    final showDelivery = o.status == SubOrderStatus.ready ||
        o.status == SubOrderStatus.outForDelivery ||
        (o.status == SubOrderStatus.delivered && delivery != null);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        header,
        if (showDelivery) ...[AppSpacing.gapLg, DeliveryCard(order: o, delivery: delivery)],
        AppSpacing.gapLg,
        TwoPane(
          primary: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [items, AppSpacing.gapLg, customer]),
          secondary: timeline,
        ),
      ],
    );
  }

  Widget _totalRow(BuildContext context, String label, int kobo) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.xxs),
      child: Row(
        children: [
          Expanded(child: Text(label, style: theme.textTheme.bodyMedium?.copyWith(color: theme.colorScheme.onSurfaceVariant))),
          MoneyText.kobo(kobo, style: theme.textTheme.bodyMedium),
        ],
      ),
    );
  }
}

/// Delivery status + rider assignment once the order is ready.
class DeliveryCard extends ConsumerWidget {
  const DeliveryCard({super.key, required this.order, required this.delivery});

  final SubOrder order;
  final Delivery? delivery;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final online = ref.watch(isOnlineProvider);
    final d = delivery;
    final rider = d?.riderId == null ? null : ref.watch(riderStreamProvider(d!.riderId!)).value;
    final canAssign = d != null && (d.status == DeliveryStatus.unassigned || d.status == DeliveryStatus.offered);

    return AppCard(
      color: scheme.primaryContainer.withValues(alpha: 0.25),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.local_shipping_outlined, color: scheme.primary),
              const SizedBox(width: AppSpacing.sm),
              Expanded(child: Text('Delivery', style: theme.textTheme.titleMedium)),
              if (d != null) StatusChip.delivery(d.status),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          if (d == null)
            Row(
              children: [
                const SizedBox.square(dimension: 16, child: CircularProgressIndicator(strokeWidth: 2)),
                const SizedBox(width: AppSpacing.sm),
                Expanded(
                  child: Text('Creating the delivery…', style: theme.textTheme.bodyMedium?.copyWith(color: scheme.onSurfaceVariant)),
                ),
              ],
            )
          else ...[
            if (rider != null || d.riderId != null)
              DetailRow(label: 'Rider', value: rider?.fullName ?? 'Rider ${d.riderId!.substring(d.riderId!.length - 4)}',
                  trailing: rider == null ? null : OnlineDot(online: rider.isOnline))
            else
              DetailRow(label: 'Rider', value: 'Not assigned yet'),
            if (d.offeredTo.isNotEmpty)
              DetailRow(
                label: 'Offers',
                value: d.offeredTo.map((o) => '${o.riderId.substring(o.riderId.length - 4)}: ${o.response ?? 'pending'}').join(', '),
              ),
            if (d.proof?.otpVerifiedAt != null) DetailRow(label: 'Proof', value: 'OTP verified ${formatTime(d.proof!.otpVerifiedAt)}'),
            if (canAssign) ...[
              const SizedBox(height: AppSpacing.md),
              Wrap(
                spacing: AppSpacing.sm,
                runSpacing: AppSpacing.sm,
                children: [
                  AppButton.primary(
                    label: d.status == DeliveryStatus.offered ? 'Reassign rider' : 'Assign rider',
                    icon: Icons.person_add_alt_outlined,
                    onPressed: online ? () => showAssignRiderSheet(context, delivery: d) : null,
                    tooltip: 'You are offline',
                  ),
                  AppButton.secondary(
                    label: 'Auto-assign nearest',
                    icon: Icons.near_me_outlined,
                    onPressed: online
                        ? () async {
                            try {
                              await ref.read(ordersRepositoryProvider).autoAssign(d.id);
                              if (context.mounted) showSnack(context, 'Delivery offered to the nearest rider');
                            } catch (e) {
                              if (context.mounted) showError(context, e);
                            }
                          }
                        : null,
                    tooltip: 'You are offline',
                  ),
                ],
              ),
            ],
          ],
        ],
      ),
    );
  }
}
