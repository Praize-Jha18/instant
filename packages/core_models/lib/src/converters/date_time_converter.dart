import 'package:json_annotation/json_annotation.dart';

/// Converts ISO-8601 strings (or epoch milliseconds) to UTC [DateTime]s and
/// back to ISO-8601 strings, matching what the backend emits.
class DateTimeConverter implements JsonConverter<DateTime, Object> {
  const DateTimeConverter();

  @override
  DateTime fromJson(Object json) {
    if (json is DateTime) return json.toUtc();
    if (json is int) return DateTime.fromMillisecondsSinceEpoch(json, isUtc: true);
    if (json is String) return DateTime.parse(json).toUtc();
    if (json is Map && json[r'$date'] != null) return fromJson(json[r'$date'] as Object);
    throw FormatException('Cannot parse DateTime from ${json.runtimeType}');
  }

  @override
  Object toJson(DateTime object) => object.toUtc().toIso8601String();
}

/// Nullable variant of [DateTimeConverter].
class NullableDateTimeConverter implements JsonConverter<DateTime?, Object?> {
  const NullableDateTimeConverter();

  @override
  DateTime? fromJson(Object? json) =>
      json == null ? null : const DateTimeConverter().fromJson(json);

  @override
  Object? toJson(DateTime? object) =>
      object == null ? null : const DateTimeConverter().toJson(object);
}
