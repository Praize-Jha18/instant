import 'package:api_client/api_client.dart';

/// A user-facing failure raised by app code (as opposed to the API).
class AppFailure implements Exception {
  const AppFailure(this.message);
  final String message;

  @override
  String toString() => 'AppFailure: $message';
}

const String kOfflineMessage = 'You are offline. Check your connection and try again.';

/// Human-readable message for any error surfaced to the UI.
String describeError(Object? error, {String fallback = 'Something went wrong. Please try again.'}) {
  if (error is ApiException) {
    if (error.isOffline) return kOfflineMessage;
    return error.message.isNotEmpty ? error.message : fallback;
  }
  if (error is AppFailure) return error.message;
  return fallback;
}

bool isOfflineError(Object? error) => error is ApiException && error.isOffline;
