import 'package:core_models/core_models.dart';

import '../token_store.dart';
import 'base_api.dart';

/// `/auth/*` routes (§3). Successful login/register/refresh persist tokens to
/// the client's [TokenStore]; logout clears them.
class AuthApi extends BaseApi {
  const AuthApi(super.client);

  /// `POST /auth/register`.
  Future<AuthResponse> register(RegisterRequest request) async {
    final body = await client.post('/auth/register', data: request.toJson(), auth: false);
    return _persist(AuthResponse.fromJson(unwrap(body)));
  }

  /// `POST /auth/login`.
  Future<AuthResponse> login(LoginRequest request) async {
    final body = await client.post('/auth/login', data: request.toJson(), auth: false);
    return _persist(AuthResponse.fromJson(unwrap(body)));
  }

  /// `POST /auth/refresh`. Normally done for you by the auth interceptor.
  Future<AuthResponse> refresh({String? refreshToken}) async {
    final token = refreshToken ?? await client.tokenStore.getRefreshToken();
    final body = await client.post(
      '/auth/refresh',
      data: RefreshTokenRequest(refreshToken: token ?? '').toJson(),
      auth: false,
    );
    return _persist(AuthResponse.fromJson(unwrap(body)));
  }

  /// `POST /auth/logout`. Always clears local tokens, even if the call fails.
  Future<void> logout() async {
    final token = await client.tokenStore.getRefreshToken();
    try {
      if (token != null) {
        await client.post('/auth/logout', data: RefreshTokenRequest(refreshToken: token).toJson());
      }
    } finally {
      await client.tokenStore.clear();
    }
  }

  /// `GET /auth/me`.
  Future<User> me() async => User.fromJson(unwrap(await client.get('/auth/me')));

  Future<AuthResponse> _persist(AuthResponse res) async {
    await client.tokenStore.write(res.tokens);
    return res;
  }
}
