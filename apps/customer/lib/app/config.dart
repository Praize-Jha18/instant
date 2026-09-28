import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Build-time configuration supplied with `--dart-define`.
///
/// ```
/// flutter run --dart-define=API_BASE_URL=http://10.0.2.2:3000/api/v1 \
///             --dart-define=WS_URL=http://10.0.2.2:3000 \
///             --dart-define=STRIPE_PUBLISHABLE_KEY=pk_test_...
/// ```
class AppConfig {
  const AppConfig({
    required this.apiBaseUrl,
    required this.wsUrl,
    required this.stripePublishableKey,
  });

  static const AppConfig fromEnvironment = AppConfig(
    apiBaseUrl: String.fromEnvironment(
      'API_BASE_URL',
      defaultValue: 'http://localhost:3000/api/v1',
    ),
    wsUrl: String.fromEnvironment('WS_URL', defaultValue: 'http://localhost:3000'),
    stripePublishableKey: String.fromEnvironment('STRIPE_PUBLISHABLE_KEY'),
  );

  final String apiBaseUrl;
  final String wsUrl;

  /// Empty when Stripe is not configured; the pay screen then shows a
  /// "not configured" state instead of crashing.
  final String stripePublishableKey;

  bool get hasStripeKey => stripePublishableKey.isNotEmpty;
}

final appConfigProvider = Provider<AppConfig>((_) => AppConfig.fromEnvironment);
