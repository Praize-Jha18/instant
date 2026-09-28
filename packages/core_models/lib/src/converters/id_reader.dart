/// Reads a document id from JSON, accepting either `id` or Mongo's `_id`.
///
/// Use as `@JsonKey(readValue: readId)` on `id` fields. The backend
/// serialises `_id` to `id`, but raw documents (for example inside sync
/// payloads or realtime events) may still carry `_id`.
Object? readId(Map<dynamic, dynamic> json, String key) {
  final value = json[key] ?? json['_id'];
  if (value == null) return null;
  if (value is Map && value[r'$oid'] != null) return value[r'$oid'].toString();
  return value.toString();
}
