import 'package:api_client/api_client.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

/// [TokenStore] backed by `flutter_secure_storage` (Keychain / Keystore /
/// WebCrypto). Values are cached in memory so the interceptor does not hit the
/// platform channel on every request.
class SecureTokenStore implements TokenStore {
  SecureTokenStore({FlutterSecureStorage? storage})
      : _storage = storage ??
            const FlutterSecureStorage(
              aOptions: AndroidOptions(),
              iOptions: IOSOptions(accessibility: KeychainAccessibility.first_unlock),
            );

  static const _accessKey = 'instant.vendor.accessToken';
  static const _refreshKey = 'instant.vendor.refreshToken';

  final FlutterSecureStorage _storage;
  String? _access;
  String? _refresh;
  bool _loaded = false;

  Future<void> _load() async {
    if (_loaded) return;
    try {
      _access = await _storage.read(key: _accessKey);
      _refresh = await _storage.read(key: _refreshKey);
    } catch (_) {
      // Storage unavailable (e.g. private browsing): behave as signed out.
    }
    _loaded = true;
  }

  @override
  Future<String?> getAccessToken() async {
    await _load();
    return _access;
  }

  @override
  Future<String?> getRefreshToken() async {
    await _load();
    return _refresh;
  }

  @override
  Future<void> setTokens({required String accessToken, required String refreshToken}) async {
    _loaded = true;
    _access = accessToken;
    _refresh = refreshToken;
    try {
      await _storage.write(key: _accessKey, value: accessToken);
      await _storage.write(key: _refreshKey, value: refreshToken);
    } catch (_) {
      // Keep the in-memory copy; the session simply will not survive a restart.
    }
  }

  @override
  Future<void> clear() async {
    _loaded = true;
    _access = null;
    _refresh = null;
    try {
      await _storage.delete(key: _accessKey);
      await _storage.delete(key: _refreshKey);
    } catch (_) {}
  }
}
