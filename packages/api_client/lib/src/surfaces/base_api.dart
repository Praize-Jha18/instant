import 'package:core_models/core_models.dart';

import '../api_client.dart';
import '../api_exception.dart';

/// Shared decoding helpers for typed route surfaces.
abstract class BaseApi {
  const BaseApi(this.client);

  /// The client this surface sends through.
  final ApiClient client;

  /// Asserts [body] is a JSON object.
  Map<String, dynamic> asMap(Object? body) {
    if (body is Map<String, dynamic>) return body;
    if (body is Map) return Map<String, dynamic>.from(body);
    throw UnknownApiException(
      code: 'BAD_BODY',
      message: 'Expected a JSON object but got ${body.runtimeType}',
    );
  }

  /// Decodes a list body, accepting either a bare array or `{ items: [] }`.
  List<T> asList<T>(Object? body, T Function(Map<String, dynamic>) fromJson) {
    final raw = body is Map ? body['items'] : body;
    if (raw is! List) {
      throw UnknownApiException(
        code: 'BAD_BODY',
        message: 'Expected a JSON array but got ${body.runtimeType}',
      );
    }
    return raw.map((e) => fromJson(asMap(e))).toList();
  }

  /// Decodes a paginated body (or bare array) into [Paginated].
  Paginated<T> asPage<T>(Object? body, T Function(Map<String, dynamic>) fromJson) {
    if (body is List) {
      return Paginated<T>(items: body.map((e) => fromJson(asMap(e))).toList());
    }
    final map = asMap(body);
    final items = map['items'];
    return Paginated<T>(
      items: items is List ? items.map((e) => fromJson(asMap(e))).toList() : const [],
      nextCursor: map['nextCursor'] as String?,
    );
  }

  /// Unwraps `{ data: {...} }` envelopes when present.
  Map<String, dynamic> unwrap(Object? body) {
    final map = asMap(body);
    final data = map['data'];
    if (map.length == 1 && data is Map) return asMap(data);
    return map;
  }
}
