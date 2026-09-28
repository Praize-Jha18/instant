import 'package:api_client/api_client.dart';
import 'package:core_models/core_models.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../app/providers.dart';

/// The auth mechanism as the app sees it (ARCHITECTURE §3: apps never know
/// whether it is passwords or Firebase). Tests provide a fake.
abstract interface class AuthGateway {
  Future<bool> hasSession();
  Future<User> login({required String email, required String password});
  Future<User> register({
    required String email,
    required String password,
    required String fullName,
    String? phone,
  });
  Future<User> me();
  Future<void> logout();
  Future<void> clearTokens();
}

class ApiAuthGateway implements AuthGateway {
  ApiAuthGateway(this._client, {this.deviceId});

  final ApiClient _client;
  final String? deviceId;

  @override
  Future<bool> hasSession() => _client.tokenStore.hasSession;

  @override
  Future<User> login({required String email, required String password}) async {
    final res = await _client.auth.login(
      LoginRequest(email: email.trim().toLowerCase(), password: password, deviceId: deviceId),
    );
    return res.user ?? await _client.auth.me();
  }

  @override
  Future<User> register({
    required String email,
    required String password,
    required String fullName,
    String? phone,
  }) async {
    final res = await _client.auth.register(
      RegisterRequest(
        email: email.trim().toLowerCase(),
        password: password,
        fullName: fullName.trim(),
        phone: (phone ?? '').trim().isEmpty ? null : phone!.trim(),
        role: UserRole.customer,
        deviceId: deviceId,
      ),
    );
    return res.user ?? await _client.auth.me();
  }

  @override
  Future<User> me() => _client.auth.me();

  @override
  Future<void> logout() => _client.auth.logout();

  @override
  Future<void> clearTokens() => _client.clearSession();
}

final authGatewayProvider = Provider<AuthGateway>(
  (ref) => ApiAuthGateway(ref.watch(apiClientProvider), deviceId: ref.watch(deviceIdProvider)),
);
