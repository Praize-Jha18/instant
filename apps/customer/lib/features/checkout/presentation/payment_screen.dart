import 'package:core_models/core_models.dart';
import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../app/config.dart';
import '../../../app/providers.dart';
import '../../../app/routes.dart';
import '../../orders/presentation/order_providers.dart';
import '../domain/checkout_state.dart';
import 'checkout_controller.dart';

/// Shows payment progress for an order and handles retry / not-configured.
/// Reached from checkout (order just created) or from an unpaid order's
/// "Pay now" button (starts a retry).
class PaymentScreen extends ConsumerStatefulWidget {
  const PaymentScreen({super.key, required this.orderId});

  final String orderId;

  @override
  ConsumerState<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends ConsumerState<PaymentScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      final state = ref.read(checkoutControllerProvider);
      // Opened directly from an order: start a fresh PaymentIntent.
      if (state.order?.id != widget.orderId) _retry();
    });
  }

  ThemeMode get _style => Theme.of(context).brightness == Brightness.dark ? ThemeMode.dark : ThemeMode.light;

  void _retry() => ref.read(checkoutControllerProvider.notifier).retry(widget.orderId, style: _style);

  void _goToOrder({bool celebrate = false}) {
    ref.read(checkoutControllerProvider.notifier).reset();
    context.go(AppRoutes.orders);
    context.push(AppRoutes.order(widget.orderId, celebrate: celebrate));
  }

  @override
  Widget build(BuildContext context) {
    ref.listen<CheckoutState>(checkoutControllerProvider, (prev, next) {
      if (next is CheckoutSucceeded && prev is! CheckoutSucceeded) {
        HapticFeedback.heavyImpact();
        _goToOrder(celebrate: true);
      }
    });
    final state = ref.watch(checkoutControllerProvider);
    final online = ref.watch(isOnlineProvider);
    final localOrder = ref.watch(orderProvider(widget.orderId)).value;
    final order = state.order ?? localOrder;
    final hasKey = ref.watch(appConfigProvider).hasStripeKey;

    return PopScope(
      canPop: !state.isBusy,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Payment'),
          automaticallyImplyLeading: !state.isBusy,
        ),
        body: SafeArea(
          child: Padding(
            padding: AppSpacing.page,
            child: Column(
              children: [
                if (order != null) _OrderHeader(order: order),
                const Spacer(),
                AnimatedSwitcher(
                  duration: AppMotion.normal,
                  switchInCurve: AppMotion.curve,
                  child: switch (state) {
                    CheckoutIdle() || CheckoutPlacing() || CheckoutPaying() => const _Progress(
                        key: ValueKey('paying'),
                        title: 'Opening secure payment…',
                        message: 'Complete the payment in the Stripe sheet.',
                      ),
                    CheckoutConfirming(:final timedOut) => timedOut
                        ? _Result(
                            key: const ValueKey('timeout'),
                            icon: Icons.hourglass_bottom_rounded,
                            title: 'Confirming your payment',
                            message:
                                'Your payment was submitted. We will update the order as soon as the bank confirms it.',
                            primaryLabel: 'View order',
                            onPrimary: () => _goToOrder(),
                          )
                        : const _Progress(
                            key: ValueKey('confirming'),
                            title: 'Confirming payment…',
                            message: 'Waiting for the payment provider. This usually takes a few seconds.',
                          ),
                    CheckoutNotConfigured() => _Result(
                        key: const ValueKey('not-configured'),
                        icon: Icons.key_off_outlined,
                        tone: StatusTone.warning,
                        title: 'Stripe key not configured',
                        message: hasKey
                            ? 'The server did not return a payment secret for this order.'
                            : 'This build has no STRIPE_PUBLISHABLE_KEY. Run with '
                                '--dart-define=STRIPE_PUBLISHABLE_KEY=pk_test_… to pay. Your order is saved as unpaid.',
                        primaryLabel: 'View order',
                        onPrimary: () => _goToOrder(),
                        secondaryLabel: online ? 'Try again' : null,
                        onSecondary: online ? _retry : null,
                      ),
                    CheckoutFailed(:final message, :final cancelled, :final canRetryPayment) => _Result(
                        key: const ValueKey('failed'),
                        icon: cancelled ? Icons.pause_circle_outline_rounded : Icons.error_outline_rounded,
                        tone: cancelled ? StatusTone.neutral : StatusTone.danger,
                        title: cancelled ? 'Payment not completed' : 'Payment failed',
                        message: message,
                        primaryLabel: canRetryPayment && online ? 'Try again' : 'View order',
                        onPrimary: canRetryPayment && online ? _retry : () => _goToOrder(),
                        secondaryLabel: canRetryPayment ? 'Pay later' : null,
                        onSecondary: canRetryPayment ? () => _goToOrder() : null,
                      ),
                    CheckoutSucceeded() => const _Progress(
                        key: ValueKey('done'),
                        title: 'Paid!',
                        message: 'Taking you to your order…',
                      ),
                  },
                ),
                const Spacer(flex: 2),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _OrderHeader extends StatelessWidget {
  const _OrderHeader({required this.order});
  final Order order;

  @override
  Widget build(BuildContext context) {
    final scheme = context.colors;
    return AppCard(
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(order.orderNumber.isEmpty ? 'Order' : 'Order ${order.orderNumber}', style: context.text.titleSmall),
                const SizedBox(height: AppSpacing.xxs),
                Text(order.addressSnapshot?.oneLine ?? '',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: context.text.bodySmall?.copyWith(color: scheme.onSurfaceVariant)),
              ],
            ),
          ),
          const SizedBox(width: AppSpacing.md),
          MoneyText.kobo(order.totalKobo, emphasize: true, style: context.text.titleMedium),
        ],
      ),
    );
  }
}

class _Progress extends StatelessWidget {
  const _Progress({super.key, required this.title, required this.message});
  final String title;
  final String message;

  @override
  Widget build(BuildContext context) {
    final scheme = context.colors;
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const SizedBox.square(dimension: 48, child: CircularProgressIndicator(strokeWidth: 3)),
        const SizedBox(height: AppSpacing.xl),
        Text(title, style: context.text.titleLarge, textAlign: TextAlign.center),
        const SizedBox(height: AppSpacing.sm),
        Text(message,
            textAlign: TextAlign.center, style: context.text.bodyMedium?.copyWith(color: scheme.onSurfaceVariant)),
      ],
    );
  }
}

class _Result extends StatelessWidget {
  const _Result({
    super.key,
    required this.icon,
    required this.title,
    required this.message,
    required this.primaryLabel,
    required this.onPrimary,
    this.secondaryLabel,
    this.onSecondary,
    this.tone = StatusTone.primary,
  });

  final IconData icon;
  final String title;
  final String message;
  final String primaryLabel;
  final VoidCallback onPrimary;
  final String? secondaryLabel;
  final VoidCallback? onSecondary;
  final StatusTone tone;

  @override
  Widget build(BuildContext context) {
    final scheme = context.colors;
    final semantic = context.semanticColors;
    final (bg, fg) = switch (tone) {
      StatusTone.danger => (semantic.dangerContainer, semantic.onDangerContainer),
      StatusTone.warning => (semantic.warningContainer, semantic.onWarningContainer),
      StatusTone.success => (semantic.successContainer, semantic.onSuccessContainer),
      _ => (scheme.primaryContainer, scheme.onPrimaryContainer),
    };
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 72,
          height: 72,
          decoration: BoxDecoration(color: bg, borderRadius: AppRadius.lgAll),
          child: Icon(icon, size: 36, color: fg),
        ),
        const SizedBox(height: AppSpacing.xl),
        Text(title, style: context.text.titleLarge, textAlign: TextAlign.center),
        const SizedBox(height: AppSpacing.sm),
        Text(message,
            textAlign: TextAlign.center, style: context.text.bodyMedium?.copyWith(color: scheme.onSurfaceVariant)),
        const SizedBox(height: AppSpacing.xl),
        AppButton.primary(label: primaryLabel, expanded: true, size: AppButtonSize.large, onPressed: onPrimary),
        if (secondaryLabel != null) ...[
          const SizedBox(height: AppSpacing.sm),
          AppButton.ghost(label: secondaryLabel!, expanded: true, onPressed: onSecondary),
        ],
      ],
    );
  }
}
