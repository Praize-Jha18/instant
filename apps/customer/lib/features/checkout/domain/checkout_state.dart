import 'package:core_models/core_models.dart';

/// Checkout / payment state machine.
sealed class CheckoutState {
  const CheckoutState();
}

final class CheckoutIdle extends CheckoutState {
  const CheckoutIdle();
}

/// `POST /orders` in flight.
final class CheckoutPlacing extends CheckoutState {
  const CheckoutPlacing();
}

/// Order exists; the payment sheet is (about to be) shown.
final class CheckoutPaying extends CheckoutState {
  const CheckoutPaying(this.order);
  final Order order;
}

/// Sheet completed; waiting for the webhook to flip `paymentStatus`.
final class CheckoutConfirming extends CheckoutState {
  const CheckoutConfirming(this.order, {this.timedOut = false});
  final Order order;

  /// We stopped polling; the order will update via sync.
  final bool timedOut;
}

/// Order created but no Stripe publishable key is available.
final class CheckoutNotConfigured extends CheckoutState {
  const CheckoutNotConfigured(this.order);
  final Order order;
}

final class CheckoutFailed extends CheckoutState {
  const CheckoutFailed({this.order, required this.message, this.cancelled = false});

  /// Null when order creation itself failed.
  final Order? order;
  final String message;

  /// True when the user dismissed the payment sheet.
  final bool cancelled;

  bool get canRetryPayment => order != null;
}

final class CheckoutSucceeded extends CheckoutState {
  const CheckoutSucceeded(this.order);
  final Order order;
}

extension CheckoutStateX on CheckoutState {
  Order? get order => switch (this) {
        CheckoutPaying(:final order) => order,
        CheckoutConfirming(:final order) => order,
        CheckoutNotConfigured(:final order) => order,
        CheckoutFailed(:final order) => order,
        CheckoutSucceeded(:final order) => order,
        CheckoutIdle() || CheckoutPlacing() => null,
      };

  bool get isBusy => this is CheckoutPlacing || this is CheckoutPaying || this is CheckoutConfirming;
}
