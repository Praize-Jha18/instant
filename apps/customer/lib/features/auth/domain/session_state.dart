import 'package:core_models/core_models.dart';

/// Where the app is in its authentication lifecycle.
sealed class SessionState {
  const SessionState();
}

/// Session not yet checked (splash).
final class SessionUnknown extends SessionState {
  const SessionUnknown();
}

final class SignedOut extends SessionState {
  const SignedOut({this.message});

  /// Shown on the login screen, e.g. "Your session expired".
  final String? message;
}

final class SignedIn extends SessionState {
  const SignedIn(this.user, {this.offline = false});

  final User user;

  /// True when the user came from the local cache because `GET /auth/me`
  /// could not be reached.
  final bool offline;
}
