/// Build-time configuration supplied through `--dart-define`.
///
/// ```sh
/// flutter run --dart-define=API_BASE_URL=http://10.0.2.2:3000/api/v1 \
///             --dart-define=WS_URL=http://10.0.2.2:3000
/// ```
abstract final class AppConfig {
  /// REST base URL including the `/api/v1` prefix.
  static const String apiBaseUrl = String.fromEnvironment(
    'API_BASE_URL',
    defaultValue: 'http://localhost:3000/api/v1',
  );

  /// Socket.IO origin (namespace `/rt` is appended by the client).
  static const String wsUrl = String.fromEnvironment(
    'WS_URL',
    defaultValue: 'http://localhost:3000',
  );

  /// Informational only: the native Maps SDKs read their key from
  /// `AndroidManifest.xml` / `AppDelegate.swift` (see the TODOs there).
  static const String googleMapsApiKey = String.fromEnvironment(
    'GOOGLE_MAPS_API_KEY',
    defaultValue: '',
  );

  /// How long a delivery offer stays actionable after `offeredTo[].at`.
  /// The backend does not publish a TTL yet, so the app assumes this window.
  static const Duration offerWindow = Duration(seconds: 60);

  /// Upper bound on queued offline location pings (oldest are dropped).
  static const int maxQueuedLocationPings = 200;

  /// Local store name (ObjectBox directory).
  static const String storeName = 'instant_rider';
}
