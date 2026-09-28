import 'dart:async';

import 'package:dio/dio.dart';

import 'api_exception.dart';
import 'auth_interceptor.dart';
import 'surfaces/admin_api.dart';
import 'surfaces/auth_api.dart';
import 'surfaces/catalog_api.dart';
import 'surfaces/customer_api.dart';
import 'surfaces/notifications_api.dart';
import 'surfaces/payments_api.dart';
import 'surfaces/rider_api.dart';
import 'surfaces/sync_api.dart';
import 'surfaces/vendor_api.dart';
import 'token_store.dart';

/// HTTP method names accepted by [ApiClient.request].
enum HttpMethod { get, post, put, patch, delete }

/// Dio-based REST client for the Instant backend (`/api/v1`).
///
/// - Every call returns decoded JSON and throws [ApiException] on failure.
/// - [AuthInterceptor] adds the Bearer token and refreshes it on 401.
/// - Typed route surfaces hang off this client: [auth], [catalog], [customer],
///   [vendor], [rider], [admin], [payments], [sync].
///
/// ```dart
/// final client = ApiClient(baseUrl: apiBaseUrl, tokenStore: store,
///     onSessionExpired: () => router.go('/login'));
/// final products = await client.catalog.products(vendorId: 'v1');
/// ```
class ApiClient {
  ApiClient({
    required this.baseUrl,
    required this.tokenStore,
    FutureOr<void> Function()? onSessionExpired,
    String? deviceId,
    Duration connectTimeout = const Duration(seconds: 15),
    Duration receiveTimeout = const Duration(seconds: 30),
    Duration sendTimeout = const Duration(seconds: 30),
    Map<String, Object?> defaultHeaders = const {},
    List<Interceptor> interceptors = const [],
    Dio? dio,
  }) : dio = dio ?? Dio() {
    this.dio.options
      ..baseUrl = baseUrl
      ..connectTimeout = connectTimeout
      ..receiveTimeout = receiveTimeout
      ..sendTimeout = sendTimeout
      ..responseType = ResponseType.json
      ..headers = {
        'Accept': 'application/json',
        'X-Device-Id': ?deviceId,
        ...defaultHeaders,
      }
      ..validateStatus = (s) => s != null && s >= 200 && s < 300;
    authInterceptor = AuthInterceptor(
      dio: this.dio,
      tokenStore: tokenStore,
      onSessionExpired: onSessionExpired,
      deviceId: deviceId,
    );
    this.dio.interceptors
      ..add(authInterceptor)
      ..addAll(interceptors);
  }

  /// `API_BASE_URL`, e.g. `http://localhost:3000/api/v1`.
  final String baseUrl;

  /// Where tokens live.
  final TokenStore tokenStore;

  /// The underlying Dio instance (exposed for advanced use and tests).
  final Dio dio;

  /// The auth interceptor installed on [dio].
  late final AuthInterceptor authInterceptor;

  late final AuthApi auth = AuthApi(this);
  late final CatalogApi catalog = CatalogApi(this);
  late final CustomerApi customer = CustomerApi(this);
  late final VendorApi vendor = VendorApi(this);
  late final RiderApi rider = RiderApi(this);
  late final AdminApi admin = AdminApi(this);
  late final PaymentsApi payments = PaymentsApi(this);
  late final NotificationsApi notifications = NotificationsApi(this);
  late final SyncApi sync = SyncApi(this);

  /// Base URL without the `/api/v1` suffix, used for absolute asset links.
  String get originUrl {
    final uri = Uri.parse(baseUrl);
    return uri.replace(path: '', query: null, fragment: null).toString().replaceAll(RegExp(r'/$'), '');
  }

  /// Absolute URL for a relative API path (e.g. image URLs).
  String absoluteUrl(String path) {
    final base = baseUrl.endsWith('/') ? baseUrl.substring(0, baseUrl.length - 1) : baseUrl;
    return path.startsWith('/') ? '$base$path' : '$base/$path';
  }

  /// Sends a request and returns the decoded body. Throws [ApiException].
  ///
  /// [auth] false skips the Bearer header and 401 handling (login, register,
  /// public catalogue when signed out).
  Future<Object?> request(
    HttpMethod method,
    String path, {
    Object? data,
    Map<String, Object?>? query,
    Map<String, Object?>? headers,
    bool auth = true,
    CancelToken? cancelToken,
    ProgressCallback? onSendProgress,
    Duration? receiveTimeout,
  }) async {
    try {
      final response = await dio.request<Object?>(
        path,
        data: data,
        queryParameters: _cleanQuery(query),
        cancelToken: cancelToken,
        onSendProgress: onSendProgress,
        options: Options(
          method: method.name.toUpperCase(),
          headers: headers,
          receiveTimeout: receiveTimeout,
          extra: {if (!auth) kNoAuthExtra: true},
        ),
      );
      return response.data;
    } catch (e) {
      throw ApiException.from(e);
    }
  }

  Future<Object?> get(String path, {Map<String, Object?>? query, bool auth = true, CancelToken? cancelToken}) =>
      request(HttpMethod.get, path, query: query, auth: auth, cancelToken: cancelToken);

  Future<Object?> post(String path, {Object? data, Map<String, Object?>? query, bool auth = true, CancelToken? cancelToken}) =>
      request(HttpMethod.post, path, data: data, query: query, auth: auth, cancelToken: cancelToken);

  Future<Object?> put(String path, {Object? data, bool auth = true}) =>
      request(HttpMethod.put, path, data: data, auth: auth);

  Future<Object?> patch(String path, {Object? data, bool auth = true}) =>
      request(HttpMethod.patch, path, data: data, auth: auth);

  Future<Object?> delete(String path, {Object? data, bool auth = true}) =>
      request(HttpMethod.delete, path, data: data, auth: auth);

  /// Uploads a multipart form (image uploads). [fields] are extra text fields.
  Future<Object?> upload(
    String path, {
    required List<int> bytes,
    required String filename,
    String field = 'file',
    String? contentType,
    Map<String, Object?> fields = const {},
    ProgressCallback? onProgress,
    CancelToken? cancelToken,
  }) {
    final form = FormData.fromMap({
      ...fields,
      field: MultipartFile.fromBytes(
        bytes,
        filename: filename,
        contentType: contentType == null ? null : DioMediaType.parse(contentType),
      ),
    });
    return request(
      HttpMethod.post,
      path,
      data: form,
      onSendProgress: onProgress,
      cancelToken: cancelToken,
      receiveTimeout: const Duration(minutes: 2),
    );
  }

  /// Forgets the local session (does not call the server; see `auth.logout`).
  Future<void> clearSession() => tokenStore.clear();

  /// Releases the HTTP client.
  void close({bool force = false}) => dio.close(force: force);

  static Map<String, Object?>? _cleanQuery(Map<String, Object?>? query) {
    if (query == null) return null;
    final out = <String, Object?>{};
    query.forEach((k, v) {
      if (v == null) return;
      if (v is String && v.isEmpty) return;
      if (v is Enum) {
        out[k] = _enumJson(v);
      } else if (v is DateTime) {
        out[k] = v.toUtc().toIso8601String();
      } else if (v is List) {
        out[k] = v.join(',');
      } else {
        out[k] = v;
      }
    });
    return out.isEmpty ? null : out;
  }

  static Object _enumJson(Enum e) {
    final dyn = e as dynamic;
    try {
      return dyn.json as Object;
    } catch (_) {
      return e.name;
    }
  }
}
