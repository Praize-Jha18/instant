// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'timeline_entry.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_TimelineEntry _$TimelineEntryFromJson(Map<String, dynamic> json) =>
    _TimelineEntry(
      status: json['status'] as String,
      at: const DateTimeConverter().fromJson(json['at'] as Object),
      byUserId: json['byUserId'] as String?,
      note: json['note'] as String?,
    );

Map<String, dynamic> _$TimelineEntryToJson(_TimelineEntry instance) =>
    <String, dynamic>{
      'status': instance.status,
      'at': const DateTimeConverter().toJson(instance.at),
      'byUserId': ?instance.byUserId,
      'note': ?instance.note,
    };
