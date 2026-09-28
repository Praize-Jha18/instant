import 'package:core_models/core_models.dart';

/// Where the app is in its sign-in lifecycle.
sealed class SessionState {
  const SessionState();
}

/// Restoring a previous session (splash).
final class SessionLoading extends SessionState {
  const SessionLoading();
}

/// No valid session.
final class SignedOut extends SessionState {
  const SignedOut();
}

/// A rider is signed in. [profile] is the snapshot loaded at sign-in; live
/// updates come from the local store (see `riderProfileProvider`).
final class SignedIn extends SessionState {
  const SignedIn({required this.user, this.profile});

  final AuthUser user;
  final RiderProfile? profile;

  SignedIn copyWith({AuthUser? user, RiderProfile? profile}) =>
      SignedIn(user: user ?? this.user, profile: profile ?? this.profile);
}

/// Coarse phase used by the router.
enum AuthPhase { loading, signedOut, signedIn }

extension SessionStateX on SessionState {
  AuthPhase get phase => switch (this) {
        SessionLoading() => AuthPhase.loading,
        SignedOut() => AuthPhase.signedOut,
        SignedIn() => AuthPhase.signedIn,
      };

  AuthUser? get userOrNull => switch (this) {
        SignedIn(:final user) => user,
        _ => null,
      };
}
