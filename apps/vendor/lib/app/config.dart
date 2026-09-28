/// Build-time configuration supplied through `--dart-define`.
///
/// ```
/// flutter run -d chrome \
///   --dart-define=API_BASE_URL=http://localhost:3000/api/v1 \
///   --dart-define=WS_URL=http://localhost:3000
/// ```
abstract final class AppConfig {
  static const String apiBaseUrl = String.fromEnvironment(
    'API_BASE_URL',
    defaultValue: 'http://localhost:3000/api/v1',
  );

  static const String wsUrl = String.fromEnvironment(
    'WS_URL',
    defaultValue: 'http://localhost:3000',
  );

  /// Maximum width of page content on wide screens.
  static const double maxContentWidth = 1200;
}
