// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'notification.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_AppNotification _$AppNotificationFromJson(Map<String, dynamic> json) =>
    _AppNotification(
      id: readId(json, 'id') as String,
      userId: json['userId'] as String,
      type: json['type'] as String,
      title: json['title'] as String,
      body: json['body'] as String? ?? '',
      data: json['data'] as Map<String, dynamic>? ?? const <String, Object?>{},
      readAt: const NullableDateTimeConverter().fromJson(json['readAt']),
      createdAt: const NullableDateTimeConverter().fromJson(json['createdAt']),
      updatedAt: const NullableDateTimeConverter().fromJson(json['updatedAt']),
      deletedAt: const NullableDateTimeConverter().fromJson(json['deletedAt']),
      version: (json['version'] as num?)?.toInt() ?? 0,
    );

Map<String, dynamic> _$AppNotificationToJson(
  _AppNotification instance,
) => <String, dynamic>{
  'id': instance.id,
  'userId': instance.userId,
  'type': instance.type,
  'title': instance.title,
  'body': instance.body,
  'data': instance.data,
  'readAt': ?const NullableDateTimeConverter().toJson(instance.readAt),
  'createdAt': ?const NullableDateTimeConverter().toJson(instance.createdAt),
  'updatedAt': ?const NullableDateTimeConverter().toJson(instance.updatedAt),
  'deletedAt': ?const NullableDateTimeConverter().toJson(instance.deletedAt),
  'version': instance.version,
};
