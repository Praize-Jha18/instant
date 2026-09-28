import 'package:core_models/core_models.dart';

/// Server event `changed { collection, id, doc }` (§7).
class ChangedEvent {
  const ChangedEvent({required this.collection, required this.id, required this.doc});

  factory ChangedEvent.fromJson(Map<String, dynamic> json) => ChangedEvent(
        collection: json['collection'] as String,
        id: (json['id'] ?? json['_id'] ?? (json['doc'] as Map?)?['id'] ?? (json['doc'] as Map?)?['_id'])
            .toString(),
        doc: Map<String, dynamic>.from(json['doc'] as Map? ?? const {}),
      );

  final String collection;
  final String id;
  final Map<String, dynamic> doc;

  /// The typed model for [collection], or null when unknown to the registry.
  Object? get model {
    final codec = ModelRegistry.forCollection(collection);
    if (codec == null || doc.isEmpty) return null;
    return codec.decodeDynamic(doc);
  }

  @override
  String toString() => 'ChangedEvent($collection/$id)';
}

/// Server event `removed { collection, id }`.
class RemovedEvent {
  const RemovedEvent({required this.collection, required this.id});

  factory RemovedEvent.fromJson(Map<String, dynamic> json) => RemovedEvent(
        collection: json['collection'] as String,
        id: (json['id'] ?? json['_id']).toString(),
      );

  final String collection;
  final String id;

  @override
  String toString() => 'RemovedEvent($collection/$id)';
}

/// Server event `rider.location { deliveryId, lat, lng, heading, at }`.
class RiderLocationEvent {
  const RiderLocationEvent({
    required this.deliveryId,
    this.riderId,
    required this.lat,
    required this.lng,
    this.heading,
    this.speed,
    required this.at,
  });

  factory RiderLocationEvent.fromJson(Map<String, dynamic> json) => RiderLocationEvent(
        deliveryId: json['deliveryId']?.toString() ?? '',
        riderId: json['riderId']?.toString(),
        lat: (json['lat'] as num).toDouble(),
        lng: (json['lng'] as num).toDouble(),
        heading: (json['heading'] as num?)?.toDouble(),
        speed: (json['speed'] as num?)?.toDouble(),
        at: json['at'] == null
            ? DateTime.now().toUtc()
            : const DateTimeConverter().fromJson(json['at'] as Object),
      );

  final String deliveryId;
  final String? riderId;
  final double lat;
  final double lng;
  final double? heading;
  final double? speed;
  final DateTime at;

  GeoPoint get point => GeoPoint(lat: lat, lng: lng);

  @override
  String toString() => 'RiderLocationEvent($deliveryId @ $lat,$lng)';
}

/// Connection lifecycle of [RealtimeClient].
enum RealtimeConnectionState { disconnected, connecting, connected, reconnecting }

/// Realtime room helpers (§7).
abstract final class RealtimeRooms {
  static String user(String id) => 'user:$id';
  static String vendor(String id) => 'vendor:$id';
  static String order(String id) => 'order:$id';
  static String delivery(String id) => 'delivery:$id';
}
