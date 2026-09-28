import 'package:core_models/core_models.dart';
import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../app/providers.dart';
import '../../../app/routes.dart';
import '../../../core/errors.dart';
import '../../../core/formatters.dart';
import '../../catalog/data/catalog_providers.dart';
import '../data/orders_repository.dart';
import '../domain/order_rules.dart';
import 'order_providers.dart';
import 'widgets/sub_order_timeline.dart';
import 'widgets/success_overlay.dart';

class OrderDetailScreen extends ConsumerStatefulWidget {
  const OrderDetailScreen({super.key, required this.orderId, this.celebrate = false});

  final String orderId;
  final bool celebrate;

  @override
  ConsumerState<OrderDetailScreen> createState() => _OrderDetailScreenState();
}

class _OrderDetailScreenState extends ConsumerState<OrderDetailScreen> {
  late bool _celebrating = widget.celebrate;
  bool _cancelling = false;

  Future<void> _cancel() async {
    final ok = await AppBottomSheet.confirm(
      context,
      title: 'Cancel this order?',
      message: 'Any payment will be refunded to your card.',
      confirmLabel: 'Cancel order',
      cancelLabel: 'Keep it',
      destructive: true,
    );
    if (!ok || !mounted) return;
    setState(() => _cancelling = true);
    try {
      await ref.read(ordersRepositoryProvider).cancelOrder(widget.orderId);
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Order cancelled')));
    } catch (e) {
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(describeError(e))));
    } finally {
      if (mounted) setState(() => _cancelling = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    // Joins the order room and refreshes while this screen is mounted.
    final watcher = ref.watch(orderWatcherProvider(widget.orderId));
    final orderAsync = ref.watch(orderProvider(widget.orderId));
    final order = orderAsync.value;
    final subOrders = ref.watch(subOrdersProvider(widget.orderId)).value ?? const <SubOrder>[];
    final effectiveSubs = subOrders.isNotEmpty ? subOrders : (order?.subOrders ?? const <SubOrder>[]);
    final vendors = ref.watch(vendorsByIdProvider);
    final otps = ref.watch(deliveryOtpsProvider);
    final online = ref.watch(isOnlineProvider);
    final scheme = context.colors;

    return Scaffold(
      appBar: AppBar(
        title: Text(order == null ? 'Order' : 'Order ${order.orderNumber}'),
        actions: [
          IconButton(
            tooltip: 'Refresh',
            onPressed: online ? watcher.refresh : null,
            icon: const Icon(Icons.refresh_rounded),
          ),
        ],
      ),
      body: Stack(
        children: [
          if (order == null)
            orderAsync.isLoading
                ? const SkeletonList(itemCount: 4)
                : ErrorState(
                    title: 'Order not found',
                    message: 'It may not have synced yet.',
                    onRetry: online ? watcher.refresh : null,
                  )
          else
            RefreshIndicator(
              onRefresh: watcher.refresh,
              child: ListView(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: const EdgeInsets.fromLTRB(AppSpacing.lg, AppSpacing.sm, AppSpacing.lg, AppSpacing.xxxl),
                children: [
                  FadeSlideIn(child: _Header(order: order, subOrders: effectiveSubs)),
                  const SizedBox(height: AppSpacing.md),
                  if (orderPayable(order, effectiveSubs))
                    FadeSlideIn.staggered(
                      index: 1,
                      child: _Callout(
                        icon: Icons.payment_rounded,
                        tone: StatusTone.warning,
                        title: order.paymentStatus == PaymentStatus.failed ? 'Payment failed or expired' : 'Payment pending',
                        message: 'Complete the payment so vendors can start preparing your order.',
                        action: AppButton.primary(
                          label: 'Pay now',
                          size: AppButtonSize.small,
                          tooltip: online ? null : 'Paying needs an internet connection',
                          onPressed: online ? () => context.push(AppRoutes.payment(order.id)) : null,
                        ),
                      ),
                    ),
                  if (orderTrackable(order, effectiveSubs))
                    FadeSlideIn.staggered(
                      index: 1,
                      child: _Callout(
                        icon: Icons.delivery_dining_rounded,
                        tone: StatusTone.info,
                        title: 'Track your delivery',
                        message: 'See live rider positions on the map.',
                        action: AppButton.secondary(
                          label: 'Track',
                          size: AppButtonSize.small,
                          onPressed: () => context.push(AppRoutes.tracking(order.id)),
                        ),
                      ),
                    ),
                  const SizedBox(height: AppSpacing.md),
                  for (var i = 0; i < effectiveSubs.length; i++) ...[
                    FadeSlideIn.staggered(
                      index: i + 2,
                      child: _SubOrderCard(
                        subOrder: effectiveSubs[i],
                        vendorName: effectiveSubs[i].vendorName ?? vendors[effectiveSubs[i].vendorId]?.name,
                        otp: otps[effectiveSubs[i].id],
                      ),
                    ),
                    const SizedBox(height: AppSpacing.md),
                  ],
                  FadeSlideIn.staggered(index: effectiveSubs.length + 2, child: _Totals(order: order)),
                  const SizedBox(height: AppSpacing.lg),
                  if (orderCancellable(order, effectiveSubs))
                    AppButton.danger(
                      label: 'Cancel order',
                      expanded: true,
                      loading: _cancelling,
                      tooltip: online ? null : 'Cancelling needs an internet connection',
                      onPressed: online && !_cancelling ? _cancel : null,
                    ),
                  const SizedBox(height: AppSpacing.sm),
                  Center(
                    child: Text(
                      'Placed ${formatDateTime(order.placedAt ?? order.createdAt)}',
                      style: context.text.bodySmall?.copyWith(color: scheme.onSurfaceVariant),
                    ),
                  ),
                ],
              ),
            ),
          if (_celebrating) SuccessOverlay(onDone: () => setState(() => _celebrating = false)),
        ],
      ),
    );
  }
}

class _Header extends StatelessWidget {
  const _Header({required this.order, required this.subOrders});
  final Order order;
  final List<SubOrder> subOrders;

  @override
  Widget build(BuildContext context) {
    final scheme = context.colors;
    final headline = headlineStatus(subOrders);
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              if (headline != null) StatusChip.subOrder(headline),
              const SizedBox(width: AppSpacing.sm),
              StatusChip.payment(order.paymentStatus, dense: true),
              const Spacer(),
              MoneyText.kobo(order.totalKobo, emphasize: true, style: context.text.titleMedium),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(Icons.location_on_outlined, size: 18, color: scheme.onSurfaceVariant),
              const SizedBox(width: AppSpacing.sm),
              Expanded(
                child: Text(
                  order.addressSnapshot?.oneLine ?? 'No address',
                  style: context.text.bodyMedium?.copyWith(color: scheme.onSurfaceVariant),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _Callout extends StatelessWidget {
  const _Callout({
    required this.icon,
    required this.tone,
    required this.title,
    required this.message,
    required this.action,
  });
  final IconData icon;
  final StatusTone tone;
  final String title;
  final String message;
  final Widget action;

  @override
  Widget build(BuildContext context) {
    final semantic = context.semanticColors;
    final (bg, fg) = switch (tone) {
      StatusTone.warning => (semantic.warningContainer, semantic.onWarningContainer),
      StatusTone.info => (semantic.infoContainer, semantic.onInfoContainer),
      _ => (context.colors.primaryContainer, context.colors.onPrimaryContainer),
    };
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.sm),
      child: AppCard(
        color: bg,
        outlined: false,
        child: Row(
          children: [
            Icon(icon, color: fg),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: context.text.titleSmall?.copyWith(color: fg)),
                  Text(message, style: context.text.bodySmall?.copyWith(color: fg)),
                ],
              ),
            ),
            const SizedBox(width: AppSpacing.sm),
            action,
          ],
        ),
      ),
    );
  }
}

class _SubOrderCard extends StatelessWidget {
  const _SubOrderCard({required this.subOrder, required this.vendorName, required this.otp});
  final SubOrder subOrder;
  final String? vendorName;
  final String? otp;

  @override
  Widget build(BuildContext context) {
    final scheme = context.colors;
    final showOtp = otp != null &&
        (subOrder.status == SubOrderStatus.outForDelivery || subOrder.status == SubOrderStatus.ready);
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.storefront_outlined, size: 18, color: scheme.onSurfaceVariant),
              const SizedBox(width: AppSpacing.sm),
              Expanded(child: Text(vendorName ?? 'Vendor', style: context.text.titleSmall)),
              StatusChip.subOrder(subOrder.status, dense: true),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          for (final item in subOrder.items)
            Padding(
              padding: const EdgeInsets.only(bottom: AppSpacing.xs),
              child: Row(
                children: [
                  Text('${item.qty}×', style: context.text.bodyMedium?.copyWith(color: scheme.onSurfaceVariant)),
                  const SizedBox(width: AppSpacing.sm),
                  Expanded(child: Text(item.nameSnapshot, maxLines: 2, overflow: TextOverflow.ellipsis)),
                  MoneyText.kobo(item.lineTotalKobo),
                ],
              ),
            ),
          const Divider(height: AppSpacing.lg),
          Row(
            children: [
              Expanded(child: Text('Delivery fee', style: context.text.bodyMedium)),
              MoneyText.kobo(subOrder.deliveryFeeKobo),
            ],
          ),
          if (showOtp) ...[
            const SizedBox(height: AppSpacing.md),
            Container(
              padding: const EdgeInsets.all(AppSpacing.md),
              decoration: BoxDecoration(color: scheme.primaryContainer, borderRadius: AppRadius.smAll),
              child: Row(
                children: [
                  Icon(Icons.pin_outlined, color: scheme.onPrimaryContainer),
                  const SizedBox(width: AppSpacing.md),
                  Expanded(
                    child: Text('Give this code to the rider',
                        style: context.text.bodySmall?.copyWith(color: scheme.onPrimaryContainer)),
                  ),
                  Text(
                    otp!,
                    style: context.text.headlineSmall?.copyWith(
                      color: scheme.onPrimaryContainer,
                      letterSpacing: 4,
                      fontFeatures: AppTypography.tabularFigures,
                    ),
                  ),
                ],
              ),
            ),
          ],
          const SizedBox(height: AppSpacing.lg),
          SubOrderTimeline(subOrder: subOrder),
        ],
      ),
    );
  }
}

class _Totals extends StatelessWidget {
  const _Totals({required this.order});
  final Order order;

  @override
  Widget build(BuildContext context) {
    Widget line(String label, int kobo, {bool emphasize = false}) {
      final style = emphasize ? context.text.titleMedium : context.text.bodyMedium;
      return Row(children: [Expanded(child: Text(label, style: style)), MoneyText.kobo(kobo, style: style, emphasize: emphasize)]);
    }

    return AppCard(
      child: Column(
        children: [
          line('Subtotal', order.subtotalKobo),
          const SizedBox(height: AppSpacing.xs),
          line('Delivery', order.deliveryTotalKobo),
          const Divider(height: AppSpacing.lg),
          line('Total', order.totalKobo, emphasize: true),
        ],
      ),
    );
  }
}
