import 'dart:async';

import 'package:core_models/core_models.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';

import '../../../app/config.dart';
import '../../../app/providers.dart';
import '../../../core/errors.dart';
import '../../cart/presentation/cart_providers.dart';
import '../../orders/data/orders_repository.dart';
import '../data/payment_sheet.dart';
import '../domain/checkout_state.dart';

/// Drives place-order → pay → confirm. One instance per app session; the
/// payment screen can also resume an unpaid order via [retry].
class CheckoutController extends Notifier<CheckoutState> {
  static const Duration pollInterval = Duration(seconds: 2);
  static const Duration confirmTimeout = Duration(seconds: 60);

  String? _idempotencyKey;

  @override
  CheckoutState build() => const CheckoutIdle();

  OrdersRepository get _repo => ref.read(ordersRepositoryProvider);

  void reset() {
    _idempotencyKey = null;
    state = const CheckoutIdle();
  }

  /// Creates the order from the server-side cart, then pays.
  Future<void> placeOrder({required String addressId, String? note, ThemeMode style = ThemeMode.system}) async {
    if (state.isBusy) return;
    state = const CheckoutPlacing();
    _idempotencyKey ??= const Uuid().v4();
    final CheckoutPayload payload;
    try {
      payload = await _repo.createOrder(CreateOrderRequest(
        addressId: addressId,
        note: (note ?? '').trim().isEmpty ? null : note!.trim(),
        idempotencyKey: _idempotencyKey,
      ));
    } catch (e) {
      state = CheckoutFailed(message: describeError(e, fallback: 'Could not place your order.'));
      return;
    }
    _idempotencyKey = null;
    // The cart was consumed server-side; mirror that locally.
    unawaited(ref.read(cartActionsProvider).clear());
    await _pay(payload, style: style);
  }

  /// New PaymentIntent for an existing unpaid order (`POST /payments/:id/retry`).
  Future<void> retry(String orderId, {ThemeMode style = ThemeMode.system}) async {
    if (state.isBusy) return;
    final previous = state.order;
    state = CheckoutPaying(previous ?? Order(id: orderId, customerId: '', orderNumber: ''));
    final CheckoutPayload payload;
    try {
      payload = await _repo.retryPayment(orderId);
    } catch (e) {
      state = CheckoutFailed(order: previous, message: describeError(e, fallback: 'Could not restart the payment.'));
      return;
    }
    await _pay(payload, style: style);
  }

  Future<void> _pay(CheckoutPayload payload, {required ThemeMode style}) async {
    final order = payload.order;
    if (order.isPaid) {
      state = CheckoutSucceeded(order);
      return;
    }
    final key = _publishableKey(payload);
    final secret = payload.clientSecret;
    if (key == null || secret == null || secret.isEmpty) {
      state = CheckoutNotConfigured(order);
      return;
    }
    state = CheckoutPaying(order);
    try {
      await ref.read(paymentSheetServiceProvider).pay(publishableKey: key, clientSecret: secret, style: style);
    } on PaymentCancelled {
      state = CheckoutFailed(order: order, message: 'Payment cancelled. You can try again.', cancelled: true);
      return;
    } on PaymentFailed catch (e) {
      state = CheckoutFailed(order: order, message: e.message);
      return;
    } catch (e) {
      state = CheckoutFailed(order: order, message: describeError(e, fallback: 'Payment failed.'));
      return;
    }
    await _confirm(order);
  }

  String? _publishableKey(CheckoutPayload payload) {
    final fromEnv = ref.read(appConfigProvider).stripePublishableKey;
    if (fromEnv.isNotEmpty) return fromEnv;
    final fromServer = payload.publishableKey;
    if (fromServer != null && fromServer.isNotEmpty) return fromServer;
    return null;
  }

  /// Polls `GET /orders/:id` until the webhook marks it paid; the local store
  /// (fed by realtime) is checked as well so a `changed` event ends it early.
  Future<void> _confirm(Order order) async {
    state = CheckoutConfirming(order);
    final store = ref.read(localStoreProvider);
    final deadline = DateTime.now().add(confirmTimeout);
    var latest = order;
    while (DateTime.now().isBefore(deadline)) {
      final local = await store.getById<Order>(Collections.orders, order.id);
      if (local != null) latest = local;
      if (_settle(latest)) return;
      try {
        latest = await _repo.fetchOrder(order.id);
      } catch (_) {
        // Transient: keep polling until the deadline.
      }
      if (_settle(latest)) return;
      await Future<void>.delayed(pollInterval);
    }
    state = CheckoutConfirming(latest, timedOut: true);
  }

  bool _settle(Order order) {
    switch (order.paymentStatus) {
      case PaymentStatus.paid:
        state = CheckoutSucceeded(order);
        return true;
      case PaymentStatus.failed:
        state = CheckoutFailed(order: order, message: 'The payment was declined.');
        return true;
      case PaymentStatus.pending:
      case PaymentStatus.refunded:
      case PaymentStatus.partiallyRefunded:
        return false;
    }
  }
}

final checkoutControllerProvider =
    NotifierProvider<CheckoutController, CheckoutState>(CheckoutController.new);
