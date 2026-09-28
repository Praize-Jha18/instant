import 'package:core_models/core_models.dart';
import 'package:dio/dio.dart';

/// Base of every error thrown by `api_client`.
///
/// Backend errors carry the contract shape `{ statusCode, code, message,
/// details? }` (§5); transport failures become [OfflineException] /
/// [TimeoutException] so the UI can treat them as "offline".
sealed class ApiException implements Exception {
  const ApiException({
    required this.code,
    required this.message,
    this.statusCode,
    this.details,
    this.cause,
  });

  /// No connectivity, DNS failure or connection refused.
  const factory ApiException.offline({String message, Object? cause}) =
      OfflineException;

  /// Maps any thrown object (usually a [DioException]) to an [ApiException].
  factory ApiException.from(Object error) {
    if (error is ApiException) return error;
    if (error is DioException) return _fromDio(error);
    if (_looksLikeSocketError(error)) {
      return OfflineException(message: error.toString(), cause: error);
    }
    return UnknownApiException(message: error.toString(), cause: error);
  }

  /// Builds the right subtype for an HTTP response with an error status.
  factory ApiException.fromResponse(int statusCode, Object? body, {Object? cause}) {
    final parsed = _parseBody(statusCode, body);
    final code = parsed.code;
    final message = parsed.message;
    final details = parsed.details;
    switch (statusCode) {
      case 400:
      case 422:
        return ValidationException(
            code: code, message: message, statusCode: statusCode, details: details, cause: cause);
      case 401:
        return UnauthorizedException(
            code: code, message: message, details: details, cause: cause);
      case 403:
        return ForbiddenException(code: code, message: message, details: details, cause: cause);
      case 404:
        return NotFoundException(code: code, message: message, details: details, cause: cause);
      case 409:
        return ConflictException(code: code, message: message, details: details, cause: cause);
      case 429:
        return RateLimitedException(code: code, message: message, details: details, cause: cause);
      default:
        if (statusCode >= 500) {
          return ServerException(
              code: code, message: message, statusCode: statusCode, details: details, cause: cause);
        }
        return HttpApiException(
            code: code, message: message, statusCode: statusCode, details: details, cause: cause);
    }
  }

  /// Machine-readable `SNAKE_CASE` code from the backend, or a client code
  /// such as `OFFLINE`, `TIMEOUT`, `CANCELLED`, `UNKNOWN`.
  final String code;

  /// Human-readable message.
  final String message;

  /// HTTP status when the error came from a response.
  final int? statusCode;

  /// Optional backend `details` (validation errors etc.).
  final Object? details;

  /// The underlying error, if any.
  final Object? cause;

  /// True for errors caused by lack of connectivity rather than the server.
  bool get isOffline => this is OfflineException || this is TimeoutException;

  /// True when the session is no longer valid and the user must sign in.
  bool get isUnauthorized => this is UnauthorizedException;

  @override
  String toString() => '$runtimeType($code${statusCode != null ? ' $statusCode' : ''}): $message';

  static ApiException _fromDio(DioException e) {
    switch (e.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
      case DioExceptionType.transformTimeout:
        return TimeoutException(cause: e);
      case DioExceptionType.connectionError:
        return OfflineException(message: e.message ?? 'No connection', cause: e);
      case DioExceptionType.cancel:
        return CancelledException(cause: e);
      case DioExceptionType.badCertificate:
        return UnknownApiException(code: 'BAD_CERTIFICATE', message: 'Bad certificate', cause: e);
      case DioExceptionType.badResponse:
        final res = e.response;
        return ApiException.fromResponse(res?.statusCode ?? 0, res?.data, cause: e);
      case DioExceptionType.unknown:
        final inner = e.error;
        if (inner is ApiException) return inner;
        if (inner != null && _looksLikeSocketError(inner)) {
          return OfflineException(message: inner.toString(), cause: e);
        }
        return UnknownApiException(message: e.message ?? inner.toString(), cause: e);
    }
  }

  // `dart:io` is not imported so this package stays web-safe.
  static bool _looksLikeSocketError(Object error) {
    final name = error.runtimeType.toString();
    return name == 'SocketException' ||
        name == 'HandshakeException' ||
        name == 'HttpException' ||
        name == 'ClientException';
  }

  static ApiErrorBody _parseBody(int statusCode, Object? body) {
    if (body is Map) {
      try {
        final map = Map<String, dynamic>.from(body);
        map['statusCode'] ??= statusCode;
        // NestJS default errors use `message` (string | string[]) and `error`.
        final msg = map['message'];
        if (msg is List) {
          map['details'] ??= msg;
          map['message'] = msg.join(', ');
        }
        map['code'] ??= _codeFromStatus(statusCode);
        return ApiErrorBody.fromJson(map);
      } catch (_) {
        // fall through
      }
    }
    return ApiErrorBody(
      statusCode: statusCode,
      code: _codeFromStatus(statusCode),
      message: body is String && body.isNotEmpty ? body : 'HTTP $statusCode',
    );
  }

  static String _codeFromStatus(int status) => switch (status) {
        400 => 'BAD_REQUEST',
        401 => 'UNAUTHORIZED',
        403 => 'FORBIDDEN',
        404 => 'NOT_FOUND',
        409 => 'CONFLICT',
        422 => 'VALIDATION_ERROR',
        429 => 'RATE_LIMITED',
        >= 500 => 'SERVER_ERROR',
        _ => 'HTTP_ERROR',
      };
}

/// No network / connection refused.
final class OfflineException extends ApiException {
  const OfflineException({super.message = 'You are offline', super.cause})
      : super(code: 'OFFLINE');
}

/// Connect/send/receive timeout.
final class TimeoutException extends ApiException {
  const TimeoutException({super.cause})
      : super(code: 'TIMEOUT', message: 'The request timed out');
}

/// Request cancelled via a [CancelToken].
final class CancelledException extends ApiException {
  const CancelledException({super.cause})
      : super(code: 'CANCELLED', message: 'Request cancelled');
}

/// 400 / 422.
final class ValidationException extends ApiException {
  const ValidationException({
    required super.code,
    required super.message,
    required int super.statusCode,
    super.details,
    super.cause,
  });
}

/// 401 after refresh was attempted (or not possible).
final class UnauthorizedException extends ApiException {
  const UnauthorizedException({
    required super.code,
    required super.message,
    super.details,
    super.cause,
  }) : super(statusCode: 401);
}

/// 403.
final class ForbiddenException extends ApiException {
  const ForbiddenException({
    required super.code,
    required super.message,
    super.details,
    super.cause,
  }) : super(statusCode: 403);
}

/// 404.
final class NotFoundException extends ApiException {
  const NotFoundException({
    required super.code,
    required super.message,
    super.details,
    super.cause,
  }) : super(statusCode: 404);
}

/// 409 (e.g. invalid state transition, out of stock, duplicate).
final class ConflictException extends ApiException {
  const ConflictException({
    required super.code,
    required super.message,
    super.details,
    super.cause,
  }) : super(statusCode: 409);
}

/// 429.
final class RateLimitedException extends ApiException {
  const RateLimitedException({
    required super.code,
    required super.message,
    super.details,
    super.cause,
  }) : super(statusCode: 429);
}

/// 5xx.
final class ServerException extends ApiException {
  const ServerException({
    required super.code,
    required super.message,
    required int super.statusCode,
    super.details,
    super.cause,
  });
}

/// Any other non-2xx status.
final class HttpApiException extends ApiException {
  const HttpApiException({
    required super.code,
    required super.message,
    required int super.statusCode,
    super.details,
    super.cause,
  });
}

/// Parsing failures and anything unexpected.
final class UnknownApiException extends ApiException {
  const UnknownApiException({
    super.code = 'UNKNOWN',
    required super.message,
    super.cause,
  });
}
