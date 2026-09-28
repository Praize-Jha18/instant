import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_stripe/flutter_stripe.dart';

/// The user dismissed the payment sheet.
class PaymentCancelled implements Exception {
  const PaymentCancelled();
}

/// The provider declined or errored.
class PaymentFailed implements Exception {
  const PaymentFailed(this.message);
  final String message;

  @override
  String toString() => 'PaymentFailed: $message';
}

/// Presents a card payment sheet for a PaymentIntent client secret.
abstract interface class PaymentSheetService {
  Future<void> pay({
    required String publishableKey,
    required String clientSecret,
    ThemeMode style = ThemeMode.system,
  });
}

/// flutter_stripe PaymentSheet.
class StripePaymentSheetService implements PaymentSheetService {
  const StripePaymentSheetService();

  @override
  Future<void> pay({
    required String publishableKey,
    required String clientSecret,
    ThemeMode style = ThemeMode.system,
  }) async {
    try {
      if (Stripe.publishableKey != publishableKey) {
        Stripe.publishableKey = publishableKey;
        await Stripe.instance.applySettings();
      }
      await Stripe.instance.initPaymentSheet(
        paymentSheetParameters: SetupPaymentSheetParameters(
          paymentIntentClientSecret: clientSecret,
          merchantDisplayName: 'Instant',
          style: style,
        ),
      );
      await Stripe.instance.presentPaymentSheet();
    } on StripeException catch (e) {
      if (e.error.code == FailureCode.Canceled) throw const PaymentCancelled();
      throw PaymentFailed(e.error.localizedMessage ?? e.error.message ?? 'Payment failed');
    } on StripeConfigException catch (e) {
      throw PaymentFailed(e.message);
    }
  }
}

final paymentSheetServiceProvider = Provider<PaymentSheetService>((_) => const StripePaymentSheetService());
