import 'package:core_models/core_models.dart';

/// A document ready to be persisted.
typedef EncodedDoc = ({String id, Map<String, dynamic> json, DateTime updatedAt});

/// Encodes/decodes documents for a collection through [ModelRegistry],
/// falling back to raw maps for unregistered collections.
abstract final class DocCodec {
  static EncodedDoc encode(String collection, Object model) {
    if (model is Map) {
      final json = Map<String, dynamic>.from(model);
      final id = readId(json, 'id')?.toString();
      if (id == null || id.isEmpty) {
        throw ArgumentError('Raw document for "$collection" has no id/_id');
      }
      json.remove('_id');
      json['id'] = id;
      return (id: id, json: json, updatedAt: _updatedAt(json));
    }
    final codec = ModelRegistry.forCollection(collection);
    if (codec == null) {
      throw ArgumentError.value(collection, 'collection',
          'No codec registered; pass a Map<String, dynamic> instead of ${model.runtimeType}');
    }
    final json = codec.encodeDynamic(model);
    final id = codec.idOfDynamic(model);
    final updatedAt = codec.updatedAtOfDynamic(model) ?? _updatedAt(json);
    return (id: id, json: json, updatedAt: updatedAt);
  }

  /// Decodes into the registered model type or returns [json] unchanged.
  static Object decode(String collection, Map<String, dynamic> json) {
    final codec = ModelRegistry.forCollection(collection);
    if (codec == null) return json;
    return codec.decodeDynamic(json);
  }

  /// Casts [decoded] to [T], raising a clear error on mismatch.
  static T cast<T extends Object>(String collection, Object decoded) {
    if (decoded is T) return decoded;
    throw StateError(
        'Collection "$collection" decodes to ${decoded.runtimeType}, not $T');
  }

  static DateTime _updatedAt(Map<String, dynamic> json) {
    final raw = json['updatedAt'];
    if (raw != null) {
      try {
        return const DateTimeConverter().fromJson(raw as Object);
      } catch (_) {
        // fall through
      }
    }
    return DateTime.now().toUtc();
  }
}

/// Element-wise equality used to suppress duplicate stream emissions.
bool listEquals<T>(List<T> a, List<T> b) {
  if (identical(a, b)) return true;
  if (a.length != b.length) return false;
  for (var i = 0; i < a.length; i++) {
    if (a[i] != b[i]) return false;
  }
  return true;
}
