import 'package:api_client/api_client.dart';
import 'package:core_models/core_models.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:local_db/local_db.dart';

import '../../../app/providers.dart';
import '../data/auth_gateway.dart';
import '../domain/session_state.dart';

/// Owns the session: restores it at launch, signs in/out and starts/stops
/// the sync engine + realtime connection around it.
class SessionController extends Notifier<SessionState> {
  @override
  SessionState build() => const SessionUnknown();

  AuthGateway get _gateway => ref.read(authGatewayProvider);

  /// Splash: validate the stored session with `GET /auth/me`, falling back to
  /// the cached user when offline.
  Future<void> restore() async {
    final store = ref.read(localStoreProvider);
    if (!await _gateway.hasSession()) {
      await store.clear();
      state = const SignedOut();
      return;
    }
    try {
      final user = await _gateway.me();
      await _enter(user);
    } on ApiException catch (e) {
      if (e.isUnauthorized) {
        await _leave();
        state = const SignedOut(message: 'Your session expired. Please sign in again.');
        return;
      }
      await _enterCachedOrSignOut(store);
    } catch (_) {
      await _enterCachedOrSignOut(store);
    }
  }

  Future<void> _enterCachedOrSignOut(LocalStore store) async {
    final cached = await store.getAll<User>(Collections.users);
    if (cached.isNotEmpty) {
      await _enter(cached.first, offline: true);
    } else {
      await _leave();
      state = const SignedOut(message: kOfflineSignInMessage);
    }
  }

  /// Throws [ApiException] for the form to display.
  Future<void> login({required String email, required String password}) async {
    final user = await _gateway.login(email: email, password: password);
    await _enter(user);
  }

  Future<void> register({
    required String email,
    required String password,
    required String fullName,
    String? phone,
  }) async {
    final user = await _gateway.register(
      email: email,
      password: password,
      fullName: fullName,
      phone: phone,
    );
    await _enter(user);
  }

  Future<void> logout() async {
    try {
      await _gateway.logout();
    } catch (_) {
      // Tokens are cleared locally regardless.
    }
    await _leave();
    state = const SignedOut();
  }

  /// Called by the API client when a refresh fails.
  Future<void> onSessionExpired() async {
    if (state is! SignedIn) return;
    await _leave();
    state = const SignedOut(message: 'Your session expired. Please sign in again.');
  }

  /// Re-validates an offline session once the network is back.
  Future<void> refreshUser() async {
    final current = state;
    if (current is! SignedIn) return;
    try {
      final user = await _gateway.me();
      await ref.read(localStoreProvider).upsert(Collections.users, user);
      state = SignedIn(user);
    } on ApiException catch (e) {
      if (e.isUnauthorized) await onSessionExpired();
    } catch (_) {}
  }

  Future<void> _enter(User user, {bool offline = false}) async {
    final store = ref.read(localStoreProvider);
    // Only ever keep the signed-in user locally.
    await store.clearCollection(Collections.users);
    await store.upsert(Collections.users, user);
    state = SignedIn(user, offline: offline);
    await ref.read(sessionLifecycleProvider).start(user.id);
  }

  Future<void> _leave() async {
    await ref.read(sessionLifecycleProvider).stop();
    await _gateway.clearTokens();
    await ref.read(localStoreProvider).clear();
  }
}

const String kOfflineSignInMessage = 'You are offline. Connect to the internet to sign in.';

final sessionControllerProvider =
    NotifierProvider<SessionController, SessionState>(SessionController.new);

/// The signed-in user or null.
final currentUserProvider = Provider<User?>((ref) {
  final s = ref.watch(sessionControllerProvider);
  return s is SignedIn ? s.user : null;
});

/// The signed-in user's id, or an empty string when signed out (so
/// store watchers can be created unconditionally).
final currentUserIdProvider = Provider<String>((ref) => ref.watch(currentUserProvider)?.id ?? '');
