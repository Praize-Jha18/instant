import 'dart:async';

import 'package:api_client/api_client.dart';
import 'package:core_models/core_models.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:local_db/local_db.dart';

import '../core/session_cache.dart';
import '../features/vendor/data/vendor_repository.dart';
import 'providers.dart';

enum SessionStatus { unknown, signedOut, signedIn }

/// Collections the admin area keeps in the local store.
const List<String> adminSyncCollections = [
  Collections.vendors,
  Collections.categories,
  Collections.orders,
  Collections.subOrders,
  Collections.payouts,
  Collections.riderProfiles,
  Collections.deliveries,
];

@immutable
class SessionState {
  const SessionState({
    this.status = SessionStatus.unknown,
    this.user,
    this.vendor,
    this.engine,
    this.vendorLoading = false,
    this.expired = false,
    this.restoreError,
  });

  final SessionStatus status;
  final User? user;

  /// Own vendor (vendor roles only). Null while loading or when unavailable
  /// offline on first launch.
  final Vendor? vendor;

  /// Session-scoped sync engine.
  final SyncEngine? engine;
  final bool vendorLoading;

  /// True when the last session ended because the refresh token was rejected.
  final bool expired;
  final Object? restoreError;

  bool get isSignedIn => status == SessionStatus.signedIn;
  bool get isAdmin => user?.isAdmin ?? false;
  bool get isVendor => user?.isVendor ?? false;
  bool get isOwner => user?.hasRole(UserRole.vendorOwner) ?? false;
  VendorStatus? get vendorStatus => vendor?.status;

  /// Where a signed-in user lands.
  String get homeLocation {
    if (isAdmin) return '/admin';
    if (isVendor) {
      return switch (vendorStatus) {
        VendorStatus.pending => '/pending',
        VendorStatus.suspended => '/suspended',
        _ => '/dashboard',
      };
    }
    return '/no-access';
  }

  SessionState copyWith({
    SessionStatus? status,
    User? user,
    Vendor? vendor,
    SyncEngine? engine,
    bool? vendorLoading,
    bool? expired,
    Object? restoreError,
  }) =>
      SessionState(
        status: status ?? this.status,
        user: user ?? this.user,
        vendor: vendor ?? this.vendor,
        engine: engine ?? this.engine,
        vendorLoading: vendorLoading ?? this.vendorLoading,
        expired: expired ?? this.expired,
        restoreError: restoreError ?? this.restoreError,
      );
}

/// Owns the signed-in session: tokens, user, vendor, sync engine and realtime
/// rooms. Widgets read [SessionState]; screens call the methods.
class SessionNotifier extends Notifier<SessionState> {
  StreamSubscription<Vendor?>? _vendorSub;
  bool _stopping = false;

  @override
  SessionState build() {
    ref.onDispose(() => _vendorSub?.cancel());
    return const SessionState();
  }

  ApiClient get _api => ref.read(apiClientProvider);
  LocalStore get _store => ref.read(localStoreProvider);
  RealtimeClient get _realtime => ref.read(realtimeClientProvider);
  SessionCache get _cache => ref.read(sessionCacheProvider);

  /// Splash: restores a persisted session if any.
  Future<void> restore() async {
    if (state.status != SessionStatus.unknown) return;
    final tokens = ref.read(tokenStoreProvider);
    if (!await tokens.hasSession) {
      state = const SessionState(status: SessionStatus.signedOut);
      return;
    }
    User? user;
    try {
      user = await _api.auth.me();
      await _cache.writeUser(user);
    } on ApiException catch (e) {
      if (e.isUnauthorized) {
        await tokens.clear();
        await _cache.clearUser();
        state = const SessionState(status: SessionStatus.signedOut, expired: true);
        return;
      }
      // Offline or server down: fall back to the cached user.
      user = await _cache.readUser();
      if (user == null) {
        state = SessionState(status: SessionStatus.signedOut, restoreError: e);
        return;
      }
    } catch (e) {
      user = await _cache.readUser();
      if (user == null) {
        state = SessionState(status: SessionStatus.signedOut, restoreError: e);
        return;
      }
    }
    await _startSession(user);
  }

  Future<void> login({required String email, required String password}) async {
    final res = await _api.auth.login(
      LoginRequest(email: email.trim(), password: password, deviceId: ref.read(deviceIdProvider)),
    );
    final user = res.user ?? await _api.auth.me();
    await _cache.writeUser(user);
    await _startSession(user);
  }

  /// Registers a vendor owner and completes the pending vendor profile.
  /// Returns an error message when the profile step failed (the account
  /// itself was created and the session started).
  Future<String?> registerVendor({
    required String email,
    required String password,
    required String fullName,
    String? phone,
    required String businessName,
    required VendorInput profile,
  }) async {
    final res = await _api.auth.register(RegisterRequest(
      email: email.trim(),
      password: password,
      fullName: fullName.trim(),
      phone: phone?.trim().isEmpty ?? true ? null : phone!.trim(),
      role: UserRole.vendorOwner,
      vendorName: businessName.trim(),
      deviceId: ref.read(deviceIdProvider),
    ));
    final user = res.user ?? await _api.auth.me();
    await _cache.writeUser(user);
    String? profileError;
    try {
      await ref.read(vendorRepositoryProvider).updateProfile(profile);
    } on ApiException catch (e) {
      profileError = e.message;
    }
    await _startSession(user);
    return profileError;
  }

  Future<void> _startSession(User user) async {
    final collections = user.isAdmin ? adminSyncCollections : Collections.vendorSync;
    final engine = SyncEngine(
      store: _store,
      api: _api.sync,
      realtime: _realtime,
      collections: collections,
      periodicInterval: const Duration(minutes: 2),
    );
    state = SessionState(
      status: SessionStatus.signedIn,
      user: user,
      engine: engine,
      vendorLoading: user.isVendor,
    );
    _realtime.subscribe(RealtimeRooms.user(user.id));
    final vendorId = user.vendorId;
    if (vendorId != null) _realtime.subscribe(RealtimeRooms.vendor(vendorId));
    _realtime.connect();
    await engine.start();

    if (user.isVendor && vendorId != null) {
      Vendor? vendor;
      try {
        vendor = await ref.read(vendorRepositoryProvider).fetchProfile();
      } catch (_) {
        try {
          vendor = await _store.getById<Vendor>(Collections.vendors, vendorId);
        } catch (_) {}
      }
      if (state.status != SessionStatus.signedIn) return;
      state = state.copyWith(vendor: vendor, vendorLoading: false);
      _vendorSub = _store.watchById<Vendor>(Collections.vendors, vendorId).listen((v) {
        if (v != null && state.status == SessionStatus.signedIn) state = state.copyWith(vendor: v);
      });
    }
  }

  /// Re-fetches the vendor profile (e.g. after editing settings).
  Future<void> refreshVendor() async {
    if (!state.isVendor) return;
    try {
      final vendor = await ref.read(vendorRepositoryProvider).fetchProfile();
      state = state.copyWith(vendor: vendor);
    } catch (_) {}
  }

  void setVendor(Vendor vendor) => state = state.copyWith(vendor: vendor);

  Future<void> logout() async {
    if (_stopping) return;
    _stopping = true;
    try {
      await _api.auth.logout();
    } catch (_) {
      // Tokens are cleared locally by `logout()` even on failure.
    }
    await _stopSession();
    state = const SessionState(status: SessionStatus.signedOut);
    _stopping = false;
  }

  /// Called by the API client when the refresh token is rejected.
  Future<void> onSessionExpired() async {
    if (_stopping || state.status != SessionStatus.signedIn) return;
    _stopping = true;
    await _stopSession();
    state = const SessionState(status: SessionStatus.signedOut, expired: true);
    _stopping = false;
  }

  Future<void> _stopSession() async {
    await _vendorSub?.cancel();
    _vendorSub = null;
    final engine = state.engine;
    for (final room in _realtime.rooms.toList()) {
      _realtime.unsubscribe(room);
    }
    _realtime.disconnect();
    await engine?.dispose();
    try {
      await _store.clear();
    } catch (_) {}
    await _cache.clearUser();
  }
}

final sessionProvider = NotifierProvider<SessionNotifier, SessionState>(SessionNotifier.new);
