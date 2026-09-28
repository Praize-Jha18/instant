/// Dio REST client, auth interceptor with single-flight refresh, typed route
/// surfaces and the Socket.IO realtime client for the Instant platform.
library;

export 'package:dio/dio.dart' show CancelToken, Interceptor, LogInterceptor;

export 'src/api_client.dart';
export 'src/api_exception.dart';
export 'src/auth_interceptor.dart' show AuthInterceptor, kNoAuthExtra;
export 'src/realtime/realtime_client.dart';
export 'src/realtime/realtime_events.dart';
export 'src/surfaces/admin_api.dart';
export 'src/surfaces/auth_api.dart';
export 'src/surfaces/base_api.dart';
export 'src/surfaces/catalog_api.dart';
export 'src/surfaces/customer_api.dart';
export 'src/surfaces/notifications_api.dart';
export 'src/surfaces/payments_api.dart';
export 'src/surfaces/rider_api.dart';
export 'src/surfaces/sync_api.dart';
export 'src/surfaces/vendor_api.dart';
export 'src/token_store.dart';
