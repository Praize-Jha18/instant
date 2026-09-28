import 'dart:async';

import 'package:core_models/core_models.dart';
import 'package:dio/dio.dart';

import 'token_store.dart';

/// Marker in `RequestOptions.extra` that disables auth handling for a request.
const String kNoAuthExtra = 'noAuth';

/// Marker in `RequestOptions.extra` set on the retried request after refresh.
const String kRetriedExtra = 'authRetried';

/// Attaches `Authorization: Bearer <access>` and transparently refreshes the
/// session on 401 (§3).
///
/// - Refresh is single-flight: concurrent 401s share one `POST /auth/refresh`
///   (sent through a bare Dio so it never re-enters this interceptor).
/// - The failed request is retried exactly once with the new token.
/// - If refresh is rejected (4xx) the tokens are cleared, [onSessionExpired]
///   fires and the original 401 is propagated. Transport errors during refresh
///   keep the session so the next request can try again.
class AuthInterceptor extends Interceptor {
  AuthInterceptor({
    required this.dio,
    required this.tokenStore,
    this.onSessionExpired,
    this.refreshPath = '/auth/refresh',
    this.deviceId,
  });

  /// The Dio instance requests are retried (and refreshed) through.
  final Dio dio;

  /// Token persistence.
  final TokenStore tokenStore;

  /// Optional device id sent with refresh calls.
  final String? deviceId;

  /// Path (relative to the Dio base URL) of the refresh endpoint.
  final String refreshPath;

  /// Called once when the refresh token is rejected and the user must sign in.
  final FutureOr<void> Function()? onSessionExpired;

  Future<AuthTokens?>? _inFlightRefresh;
  Dio? _refreshDio;

  /// Number of refresh calls performed (useful in tests/telemetry).
  int refreshCount = 0;

  @override
  Future<void> onRequest(RequestOptions options, RequestInterceptorHandler handler) async {
    if (options.extra[kNoAuthExtra] == true) return handler.next(options);
    final access = await tokenStore.getAccessToken();
    if (access != null && access.isNotEmpty) {
      options.headers['Authorization'] = 'Bearer $access';
    }
    handler.next(options);
  }

  @override
  Future<void> onError(DioException err, ErrorInterceptorHandler handler) async {
    final options = err.requestOptions;
    final status = err.response?.statusCode;
    final skip = status != 401 ||
        options.extra[kNoAuthExtra] == true ||
        options.extra[kRetriedExtra] == true ||
        options.path.endsWith(refreshPath);
    if (skip) return handler.next(err);

    final usedToken = _bearerOf(options.headers['Authorization']);
    var current = await tokenStore.getAccessToken();

    // Another request already refreshed while this one was in flight.
    if (current == null || current == usedToken) {
      final refreshed = await refresh();
      current = refreshed?.accessToken;
    }

    if (current == null) return handler.next(err);

    try {
      final response = await _retry(options, current);
      handler.resolve(response);
    } on DioException catch (e) {
      handler.next(e);
    }
  }

  /// Performs (or joins) a refresh. Returns null when the session is gone.
  Future<AuthTokens?> refresh() {
    final inFlight = _inFlightRefresh;
    if (inFlight != null) return inFlight;
    final future = _doRefresh();
    _inFlightRefresh = future;
    future.whenComplete(() => _inFlightRefresh = null);
    return future;
  }

  Future<AuthTokens?> _doRefresh() async {
    final refreshToken = await tokenStore.getRefreshToken();
    if (refreshToken == null || refreshToken.isEmpty) {
      await _expire();
      return null;
    }
    refreshCount++;
    try {
      final res = await _bareDio().post<Object?>(
        refreshPath,
        data: {'refreshToken': refreshToken, 'deviceId': ?deviceId},
        options: Options(extra: {kNoAuthExtra: true}),
      );
      final body = res.data;
      if (body is! Map) {
        await _expire();
        return null;
      }
      final tokens = AuthTokens.fromJson(Map<String, dynamic>.from(body));
      await tokenStore.write(tokens);
      return tokens;
    } on DioException catch (e) {
      final status = e.response?.statusCode;
      // Only a definitive rejection ends the session; transport errors do not.
      if (status != null && status >= 400 && status < 500) {
        await _expire();
      }
      return null;
    }
  }

  /// A Dio sharing base options and adapter with [dio] but no interceptors.
  Dio _bareDio() {
    final cached = _refreshDio;
    if (cached != null && identical(cached.httpClientAdapter, dio.httpClientAdapter)) {
      return cached;
    }
    final bare = Dio(dio.options)
      ..httpClientAdapter = dio.httpClientAdapter
      ..transformer = dio.transformer;
    _refreshDio = bare;
    return bare;
  }

  Future<void> _expire() async {
    await tokenStore.clear();
    await onSessionExpired?.call();
  }

  Future<Response<Object?>> _retry(RequestOptions options, String accessToken) {
    final headers = Map<String, Object?>.from(options.headers)
      ..['Authorization'] = 'Bearer $accessToken';
    final extra = Map<String, Object?>.from(options.extra)..[kRetriedExtra] = true;
    return dio.fetch<Object?>(options.copyWith(headers: headers, extra: extra));
  }

  static String? _bearerOf(Object? header) {
    if (header is! String) return null;
    const prefix = 'Bearer ';
    return header.startsWith(prefix) ? header.substring(prefix.length) : null;
  }
}
