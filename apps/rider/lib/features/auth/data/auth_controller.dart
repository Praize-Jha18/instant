import 'dart:async';

import 'package:core_models/core_models.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../app/session_services.dart';
import '../domain/session_state.dart';
import 'auth_repository.dart';

/// Owns the [SessionState]: restores it at launch, performs login/register/
/// logout and starts/stops the per-session services (sync, realtime,
/// location, proof queue).
class AuthController extends Notifier<SessionState> {
  Completer<void>? _restore;

  @override
  SessionState build() {
    // Kick off restoration once; the splash screen waits for it.
    Future<void>.microtask(restore);
    return const SessionLoading();
  }

  AuthRepository get _repo => ref.read(authRepositoryProvider);
  SessionServices get _services => ref.read(sessionServicesProvider);

  /// Restores a stored session (called once from [build]; safe to await).
  Future<void> restore() {
    final existing = _restore;
    if (existing != null) return existing.future;
    final completer = Completer<void>();
    _restore = completer;
    _doRestore().whenComplete(completer.complete);
    return completer.future;
  }

  Future<void> _doRestore() async {
    try {
      if (!await _repo.hasSession) {
        state = const SignedOut();
        return;
      }
      final user = await _repo.restoreUser();
      if (user == null || !user.isRider) {
        await _repo.logout();
        state = const SignedOut();
        return;
      }
      final profile = await _safeProfile(user.id);
      state = SignedIn(user: user, profile: profile);
      await _services.start(user);
    } catch (_) {
      state = const SignedOut();
    }
  }

  Future<void> login({required String email, required String password}) async {
    final user = await _repo.login(email: email, password: password);
    if (!user.isRider) {
      await _repo.logout();
      throw const NotARiderException();
    }
    final profile = await _safeProfile(user.id);
    state = SignedIn(user: user, profile: profile);
    await _services.start(user);
  }

  Future<void> register({
    required String email,
    required String password,
    required String fullName,
    String? phone,
    required String vendorId,
    String? vehicleType,
    String? plateNumber,
  }) async {
    final user = await _repo.registerRider(
      email: email,
      password: password,
      fullName: fullName,
      phone: phone,
      vendorId: vendorId,
      vehicleType: vehicleType,
      plateNumber: plateNumber,
    );
    final profile = await _safeProfile(user.id);
    state = SignedIn(user: user, profile: profile);
    await _services.start(user);
  }

  /// Re-fetches the rider profile (pending-approval pull-to-refresh).
  Future<RiderProfile?> refreshProfile() async {
    final current = state;
    if (current is! SignedIn) return null;
    final profile = await _repo.loadProfile(userId: current.user.id);
    if (profile != null) state = current.copyWith(profile: profile);
    return profile;
  }

  Future<void> logout() async {
    await _services.stop(clearStore: true);
    try {
      await _repo.logout();
    } catch (_) {
      // Tokens are cleared locally regardless.
    }
    state = const SignedOut();
  }

  /// Called by the API client when the refresh token is rejected.
  Future<void> handleSessionExpired() async {
    if (state is SignedOut) return;
    await _services.stop(clearStore: true);
    state = const SignedOut();
  }

  Future<RiderProfile?> _safeProfile(String userId) async {
    try {
      return await _repo.loadProfile(userId: userId);
    } catch (_) {
      return _repo.cachedProfile(userId: userId);
    }
  }
}

final authControllerProvider = NotifierProvider<AuthController, SessionState>(AuthController.new);

/// The signed-in user, or null.
final currentUserProvider = Provider<AuthUser?>((ref) => ref.watch(authControllerProvider).userOrNull);

/// Thrown when an account without the `rider` role signs in here.
class NotARiderException implements Exception {
  const NotARiderException();

  @override
  String toString() => 'This account is not a rider account.';
}
