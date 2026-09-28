// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'rider.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_RiderDocument _$RiderDocumentFromJson(Map<String, dynamic> json) =>
    _RiderDocument(
      type: json['type'] as String,
      imageId: json['imageId'] as String,
    );

Map<String, dynamic> _$RiderDocumentToJson(_RiderDocument instance) =>
    <String, dynamic>{'type': instance.type, 'imageId': instance.imageId};

_RiderUserSummary _$RiderUserSummaryFromJson(Map<String, dynamic> json) =>
    _RiderUserSummary(
      id: readId(json, 'id') as String,
      fullName: json['fullName'] as String,
      phone: json['phone'] as String?,
      email: json['email'] as String?,
    );

Map<String, dynamic> _$RiderUserSummaryToJson(_RiderUserSummary instance) =>
    <String, dynamic>{
      'id': instance.id,
      'fullName': instance.fullName,
      'phone': ?instance.phone,
      'email': ?instance.email,
    };

_RiderLastLocation _$RiderLastLocationFromJson(Map<String, dynamic> json) =>
    _RiderLastLocation(
      lat: (json['lat'] as num).toDouble(),
      lng: (json['lng'] as num).toDouble(),
      heading: (json['heading'] as num?)?.toDouble(),
      speed: (json['speed'] as num?)?.toDouble(),
      at: const DateTimeConverter().fromJson(json['at'] as Object),
    );

Map<String, dynamic> _$RiderLastLocationToJson(_RiderLastLocation instance) =>
    <String, dynamic>{
      'lat': instance.lat,
      'lng': instance.lng,
      'heading': ?instance.heading,
      'speed': ?instance.speed,
      'at': const DateTimeConverter().toJson(instance.at),
    };

_RiderProfile _$RiderProfileFromJson(Map<String, dynamic> json) =>
    _RiderProfile(
      id: readId(json, 'id') as String,
      userId: json['userId'] as String,
      vendorId: json['vendorId'] as String,
      status:
          $enumDecodeNullable(_$RiderStatusEnumMap, json['status']) ??
          RiderStatus.pending,
      vehicleType: json['vehicleType'] as String?,
      plateNumber: json['plateNumber'] as String?,
      documents:
          (json['documents'] as List<dynamic>?)
              ?.map((e) => RiderDocument.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const <RiderDocument>[],
      isOnline: json['isOnline'] as bool? ?? false,
      lastSeenAt: const NullableDateTimeConverter().fromJson(
        json['lastSeenAt'],
      ),
      currentDeliveryId: json['currentDeliveryId'] as String?,
      fullName: json['fullName'] as String?,
      phone: json['phone'] as String?,
      avatarImageId: json['avatarImageId'] as String?,
      user: json['user'] == null
          ? null
          : RiderUserSummary.fromJson(json['user'] as Map<String, dynamic>),
      lastLocation: json['lastLocation'] == null
          ? null
          : RiderLastLocation.fromJson(
              json['lastLocation'] as Map<String, dynamic>,
            ),
      createdAt: const NullableDateTimeConverter().fromJson(json['createdAt']),
      updatedAt: const NullableDateTimeConverter().fromJson(json['updatedAt']),
      deletedAt: const NullableDateTimeConverter().fromJson(json['deletedAt']),
      version: (json['version'] as num?)?.toInt() ?? 0,
    );

Map<String, dynamic> _$RiderProfileToJson(
  _RiderProfile instance,
) => <String, dynamic>{
  'id': instance.id,
  'userId': instance.userId,
  'vendorId': instance.vendorId,
  'status': _$RiderStatusEnumMap[instance.status]!,
  'vehicleType': ?instance.vehicleType,
  'plateNumber': ?instance.plateNumber,
  'documents': instance.documents.map((e) => e.toJson()).toList(),
  'isOnline': instance.isOnline,
  'lastSeenAt': ?const NullableDateTimeConverter().toJson(instance.lastSeenAt),
  'currentDeliveryId': ?instance.currentDeliveryId,
  'fullName': ?instance.fullName,
  'phone': ?instance.phone,
  'avatarImageId': ?instance.avatarImageId,
  'user': ?instance.user?.toJson(),
  'lastLocation': ?instance.lastLocation?.toJson(),
  'createdAt': ?const NullableDateTimeConverter().toJson(instance.createdAt),
  'updatedAt': ?const NullableDateTimeConverter().toJson(instance.updatedAt),
  'deletedAt': ?const NullableDateTimeConverter().toJson(instance.deletedAt),
  'version': instance.version,
};

const _$RiderStatusEnumMap = {
  RiderStatus.pending: 'pending',
  RiderStatus.active: 'active',
  RiderStatus.suspended: 'suspended',
};

_RiderLocation _$RiderLocationFromJson(Map<String, dynamic> json) =>
    _RiderLocation(
      id: readId(json, 'id') as String?,
      riderId: json['riderId'] as String,
      vendorId: json['vendorId'] as String?,
      deliveryId: json['deliveryId'] as String?,
      lat: (json['lat'] as num).toDouble(),
      lng: (json['lng'] as num).toDouble(),
      heading: (json['heading'] as num?)?.toDouble(),
      speed: (json['speed'] as num?)?.toDouble(),
      at: const DateTimeConverter().fromJson(json['at'] as Object),
    );

Map<String, dynamic> _$RiderLocationToJson(_RiderLocation instance) =>
    <String, dynamic>{
      'id': ?instance.id,
      'riderId': instance.riderId,
      'vendorId': ?instance.vendorId,
      'deliveryId': ?instance.deliveryId,
      'lat': instance.lat,
      'lng': instance.lng,
      'heading': ?instance.heading,
      'speed': ?instance.speed,
      'at': const DateTimeConverter().toJson(instance.at),
    };
