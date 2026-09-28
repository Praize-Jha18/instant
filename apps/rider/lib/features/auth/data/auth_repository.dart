import 'package:api_client/api_client.dart';
import 'package:core_models/core_models.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:local_db/local_db.dart';

import '../../../app/providers.dart';
import '../../../core/errors.dart';

/// Auth + rider-profile access. Screens never see the mechanism (§3).
class AuthRepository {
  AuthRepository({required this.api, required this.store});

  final ApiClient api;
  final LocalStore store;

  /// Whether a refresh token is stored.
  Future<bool> get hasSession => api.tokenStore.hasSession;

  Future<AuthUser> login({required String email, required String password}) async {
    final res = await api.auth.login(LoginRequest(email: email.trim().toLowerCase(), password: password));
    final user = res.user ?? await api.auth.me();
    await _cacheUser(user);
    return AuthUser.fromUser(user);
  }

  /// Registers a rider for [vendorId]. Vehicle details are not part of the
  /// register contract, so they are applied with a follow-up PATCH; a failure
  /// there is non-fatal (the rider can edit them from Profile).
  Future<AuthUser> registerRider({
    required String email,
    required String password,
    required String fullName,
    String? phone,
    required String vendorId,
    String? vehicleType,
    String? plateNumber,
  }) async {
    final res = await api.auth.register(RegisterRequest(
      email: email.trim().toLowerCase(),
      password: password,
      fullName: fullName.trim(),
      phone: (phone ?? '').trim().isEmpty ? null : phone!.trim(),
      role: UserRole.rider,
      vendorId: vendorId,
    ));
    final user = res.user ?? await api.auth.me();
    await _cacheUser(user);
    if ((vehicleType ?? '').isNotEmpty || (plateNumber ?? '').isNotEmpty) {
      try {
        final profile = await api.rider.updateProfile(UpdateRiderProfileRequest(
          vehicleType: vehicleType,
          plateNumber: plateNumber,
        ));
        await store.upsert(Collections.riderProfiles, profile);
      } catch (_) {
        // Non-fatal: editable later from Profile.
      }
    }
    return AuthUser.fromUser(user);
  }

  /// Current user from the server, falling back to the cached copy offline.
  Future<AuthUser?> restoreUser() async {
    try {
      final user = await api.auth.me();
      await _cacheUser(user);
      return AuthUser.fromUser(user);
    } on ApiException catch (e) {
      if (e.isUnauthorized) return null;
      if (!isOfflineError(e)) rethrow;
      final cached = await store.getAll<User>(Collections.users);
      if (cached.isEmpty) return null;
      return AuthUser.fromUser(cached.first);
    }
  }

  /// Fetches the rider profile and caches it; offline, returns the cached one.
  Future<RiderProfile?> loadProfile({required String userId}) async {
    try {
      final profile = await api.rider.profile();
      await store.upsert(Collections.riderProfiles, profile);
      return profile;
    } on ApiException catch (e) {
      if (!isOfflineError(e)) rethrow;
      return cachedProfile(userId: userId);
    }
  }

  Future<RiderProfile?> cachedProfile({required String userId}) async {
    final all = await store.getAll<RiderProfile>(Collections.riderProfiles);
    for (final p in all) {
      if (p.userId == userId) return p;
    }
    return all.isEmpty ? null : all.first;
  }

  Future<void> logout() => api.auth.logout();

  Future<void> _cacheUser(User user) async {
    await store.clearCollection(Collections.users);
    await store.upsert(Collections.users, user);
  }
}

final authRepositoryProvider = Provider<AuthRepository>(
  (ref) => AuthRepository(api: ref.watch(apiClientProvider), store: ref.watch(localStoreProvider)),
);
