// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'address.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Address _$AddressFromJson(Map<String, dynamic> json) => _Address(
  id: readId(json, 'id') as String,
  userId: json['userId'] as String,
  label: json['label'] as String? ?? 'Home',
  line1: json['line1'] as String,
  line2: json['line2'] as String?,
  city: json['city'] as String,
  state: json['state'] as String,
  lat: (json['lat'] as num).toDouble(),
  lng: (json['lng'] as num).toDouble(),
  phone: json['phone'] as String?,
  isDefault: json['isDefault'] as bool? ?? false,
  createdAt: const NullableDateTimeConverter().fromJson(json['createdAt']),
  updatedAt: const NullableDateTimeConverter().fromJson(json['updatedAt']),
  deletedAt: const NullableDateTimeConverter().fromJson(json['deletedAt']),
  version: (json['version'] as num?)?.toInt() ?? 0,
);

Map<String, dynamic> _$AddressToJson(_Address instance) => <String, dynamic>{
  'id': instance.id,
  'userId': instance.userId,
  'label': instance.label,
  'line1': instance.line1,
  'line2': ?instance.line2,
  'city': instance.city,
  'state': instance.state,
  'lat': instance.lat,
  'lng': instance.lng,
  'phone': ?instance.phone,
  'isDefault': instance.isDefault,
  'createdAt': ?const NullableDateTimeConverter().toJson(instance.createdAt),
  'updatedAt': ?const NullableDateTimeConverter().toJson(instance.updatedAt),
  'deletedAt': ?const NullableDateTimeConverter().toJson(instance.deletedAt),
  'version': instance.version,
};

_AddressSnapshot _$AddressSnapshotFromJson(Map<String, dynamic> json) =>
    _AddressSnapshot(
      label: json['label'] as String?,
      line1: json['line1'] as String,
      line2: json['line2'] as String?,
      city: json['city'] as String,
      state: json['state'] as String,
      lat: (json['lat'] as num).toDouble(),
      lng: (json['lng'] as num).toDouble(),
      phone: json['phone'] as String?,
    );

Map<String, dynamic> _$AddressSnapshotToJson(_AddressSnapshot instance) =>
    <String, dynamic>{
      'label': ?instance.label,
      'line1': instance.line1,
      'line2': ?instance.line2,
      'city': instance.city,
      'state': instance.state,
      'lat': instance.lat,
      'lng': instance.lng,
      'phone': ?instance.phone,
    };
