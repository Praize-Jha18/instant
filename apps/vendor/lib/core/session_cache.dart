import 'dart:convert';

import 'package:core_models/core_models.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

/// Small key/value cache for session metadata (the signed-in user for offline
/// restore, theme preference). Not for tokens: see `SecureTokenStore`.
abstract interface class SessionCache {
  Future<String?> read(String key);
  Future<void> write(String key, String value);
  Future<void> delete(String key);
}

/// Keys used by the app.
abstract final class SessionCacheKeys {
  static const user = 'instant.vendor.user';
  static const themeMode = 'instant.vendor.themeMode';
}

extension SessionCacheUser on SessionCache {
  Future<User?> readUser() async {
    final raw = await read(SessionCacheKeys.user);
    if (raw == null) return null;
    try {
      return User.fromJson(jsonDecode(raw) as Map<String, dynamic>);
    } catch (_) {
      return null;
    }
  }

  Future<void> writeUser(User user) =>
      write(SessionCacheKeys.user, jsonEncode(user.toJson()));

  Future<void> clearUser() => delete(SessionCacheKeys.user);
}

class SecureSessionCache implements SessionCache {
  SecureSessionCache({FlutterSecureStorage? storage})
      : _storage = storage ?? const FlutterSecureStorage();

  final FlutterSecureStorage _storage;

  @override
  Future<String?> read(String key) async {
    try {
      return await _storage.read(key: key);
    } catch (_) {
      return null;
    }
  }

  @override
  Future<void> write(String key, String value) async {
    try {
      await _storage.write(key: key, value: value);
    } catch (_) {}
  }

  @override
  Future<void> delete(String key) async {
    try {
      await _storage.delete(key: key);
    } catch (_) {}
  }
}

/// In-memory cache for tests.
class MemorySessionCache implements SessionCache {
  final Map<String, String> _values = {};

  @override
  Future<String?> read(String key) async => _values[key];

  @override
  Future<void> write(String key, String value) async => _values[key] = value;

  @override
  Future<void> delete(String key) async => _values.remove(key);
}
