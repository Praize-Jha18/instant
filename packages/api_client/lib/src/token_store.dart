import 'package:core_models/core_models.dart';

/// Persists the access/refresh token pair. Apps provide a
/// `flutter_secure_storage` implementation; [MemoryTokenStore] is for tests
/// and web fallbacks.
abstract interface class TokenStore {
  Future<String?> getAccessToken();
  Future<String?> getRefreshToken();
  Future<void> setTokens({required String accessToken, required String refreshToken});
  Future<void> clear();
}

/// Convenience helpers shared by all [TokenStore]s.
extension TokenStoreX on TokenStore {
  Future<AuthTokens?> read() async {
    final access = await getAccessToken();
    final refresh = await getRefreshToken();
    if (access == null || refresh == null) return null;
    return AuthTokens(accessToken: access, refreshToken: refresh);
  }

  Future<void> write(AuthTokens tokens) =>
      setTokens(accessToken: tokens.accessToken, refreshToken: tokens.refreshToken);

  Future<bool> get hasSession async => (await getRefreshToken()) != null;
}

/// In-memory [TokenStore].
class MemoryTokenStore implements TokenStore {
  MemoryTokenStore({String? accessToken, String? refreshToken})
      : _access = accessToken,
        _refresh = refreshToken;

  String? _access;
  String? _refresh;

  @override
  Future<String?> getAccessToken() async => _access;

  @override
  Future<String?> getRefreshToken() async => _refresh;

  @override
  Future<void> setTokens({required String accessToken, required String refreshToken}) async {
    _access = accessToken;
    _refresh = refreshToken;
  }

  @override
  Future<void> clear() async {
    _access = null;
    _refresh = null;
  }
}
