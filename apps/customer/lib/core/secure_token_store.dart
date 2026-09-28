import 'package:api_client/api_client.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

/// [TokenStore] backed by the platform keychain / keystore.
///
/// Values are cached in memory after the first read so the auth interceptor
/// does not hit the platform channel on every request.
class SecureTokenStore implements TokenStore {
  SecureTokenStore({FlutterSecureStorage? storage})
      : _storage = storage ?? const FlutterSecureStorage();

  static const String _accessKey = 'instant.customer.accessToken';
  static const String _refreshKey = 'instant.customer.refreshToken';

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
      // Corrupted keystore entries: treat as signed out.
      _access = null;
      _refresh = null;
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
    _access = accessToken;
    _refresh = refreshToken;
    _loaded = true;
    await _storage.write(key: _accessKey, value: accessToken);
    await _storage.write(key: _refreshKey, value: refreshToken);
  }

  @override
  Future<void> clear() async {
    _access = null;
    _refresh = null;
    _loaded = true;
    await _storage.delete(key: _accessKey);
    await _storage.delete(key: _refreshKey);
  }
}
