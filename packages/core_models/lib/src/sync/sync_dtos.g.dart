// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sync_dtos.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_SyncOp _$SyncOpFromJson(Map<String, dynamic> json) => _SyncOp(
  opId: json['opId'] as String,
  entity: json['entity'] as String,
  action: $enumDecode(_$SyncOpActionEnumMap, json['action']),
  customAction: json['customAction'] as String?,
  payload:
      json['payload'] as Map<String, dynamic>? ?? const <String, Object?>{},
  clientAt: const DateTimeConverter().fromJson(json['clientAt'] as Object),
);

Map<String, dynamic> _$SyncOpToJson(_SyncOp instance) => <String, dynamic>{
  'opId': instance.opId,
  'entity': instance.entity,
  'action': _$SyncOpActionEnumMap[instance.action]!,
  'customAction': ?instance.customAction,
  'payload': instance.payload,
  'clientAt': const DateTimeConverter().toJson(instance.clientAt),
};

const _$SyncOpActionEnumMap = {
  SyncOpAction.upsert: 'upsert',
  SyncOpAction.delete: 'delete',
  SyncOpAction.custom: 'custom',
};

_SyncPushRequest _$SyncPushRequestFromJson(Map<String, dynamic> json) =>
    _SyncPushRequest(
      ops: (json['ops'] as List<dynamic>)
          .map((e) => SyncOp.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$SyncPushRequestToJson(_SyncPushRequest instance) =>
    <String, dynamic>{'ops': instance.ops.map((e) => e.toJson()).toList()};

_SyncPushResult _$SyncPushResultFromJson(Map<String, dynamic> json) =>
    _SyncPushResult(
      opId: json['opId'] as String,
      status: $enumDecode(_$SyncOpStatusEnumMap, json['status']),
      code: json['code'] as String?,
      message: json['message'] as String?,
      doc: json['doc'] as Map<String, dynamic>?,
    );

Map<String, dynamic> _$SyncPushResultToJson(_SyncPushResult instance) =>
    <String, dynamic>{
      'opId': instance.opId,
      'status': _$SyncOpStatusEnumMap[instance.status]!,
      'code': ?instance.code,
      'message': ?instance.message,
      'doc': ?instance.doc,
    };

const _$SyncOpStatusEnumMap = {
  SyncOpStatus.applied: 'applied',
  SyncOpStatus.duplicate: 'duplicate',
  SyncOpStatus.rejected: 'rejected',
};

_SyncPushResponse _$SyncPushResponseFromJson(Map<String, dynamic> json) =>
    _SyncPushResponse(
      results:
          (json['results'] as List<dynamic>?)
              ?.map((e) => SyncPushResult.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const <SyncPushResult>[],
    );

Map<String, dynamic> _$SyncPushResponseToJson(_SyncPushResponse instance) =>
    <String, dynamic>{
      'results': instance.results.map((e) => e.toJson()).toList(),
    };

_SyncPullResponse _$SyncPullResponseFromJson(
  Map<String, dynamic> json,
) => _SyncPullResponse(
  changes:
      (json['changes'] as Map<String, dynamic>?)?.map(
        (k, e) => MapEntry(
          k,
          (e as List<dynamic>).map((e) => e as Map<String, dynamic>).toList(),
        ),
      ) ??
      const <String, List<Map<String, Object?>>>{},
  tombstones:
      (json['tombstones'] as Map<String, dynamic>?)?.map(
        (k, e) =>
            MapEntry(k, (e as List<dynamic>).map((e) => e as String).toList()),
      ) ??
      const <String, List<String>>{},
  serverTime: const DateTimeConverter().fromJson(json['serverTime'] as Object),
  nextCursor: json['nextCursor'] as String?,
);

Map<String, dynamic> _$SyncPullResponseToJson(_SyncPullResponse instance) =>
    <String, dynamic>{
      'changes': instance.changes,
      'tombstones': instance.tombstones,
      'serverTime': const DateTimeConverter().toJson(instance.serverTime),
      'nextCursor': ?instance.nextCursor,
    };
