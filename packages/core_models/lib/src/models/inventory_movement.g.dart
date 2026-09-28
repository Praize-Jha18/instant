// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'inventory_movement.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_InventoryMovement _$InventoryMovementFromJson(Map<String, dynamic> json) =>
    _InventoryMovement(
      id: readId(json, 'id') as String,
      vendorId: json['vendorId'] as String,
      productId: json['productId'] as String,
      variantId: json['variantId'] as String?,
      delta: (json['delta'] as num).toInt(),
      reason: $enumDecode(_$InventoryReasonEnumMap, json['reason']),
      orderId: json['orderId'] as String?,
      byUserId: json['byUserId'] as String?,
      note: json['note'] as String?,
      createdAt: const NullableDateTimeConverter().fromJson(json['createdAt']),
      updatedAt: const NullableDateTimeConverter().fromJson(json['updatedAt']),
      deletedAt: const NullableDateTimeConverter().fromJson(json['deletedAt']),
      version: (json['version'] as num?)?.toInt() ?? 0,
    );

Map<String, dynamic> _$InventoryMovementToJson(
  _InventoryMovement instance,
) => <String, dynamic>{
  'id': instance.id,
  'vendorId': instance.vendorId,
  'productId': instance.productId,
  'variantId': ?instance.variantId,
  'delta': instance.delta,
  'reason': _$InventoryReasonEnumMap[instance.reason]!,
  'orderId': ?instance.orderId,
  'byUserId': ?instance.byUserId,
  'note': ?instance.note,
  'createdAt': ?const NullableDateTimeConverter().toJson(instance.createdAt),
  'updatedAt': ?const NullableDateTimeConverter().toJson(instance.updatedAt),
  'deletedAt': ?const NullableDateTimeConverter().toJson(instance.deletedAt),
  'version': instance.version,
};

const _$InventoryReasonEnumMap = {
  InventoryReason.sale: 'sale',
  InventoryReason.restock: 'restock',
  InventoryReason.adjustment: 'adjustment',
  InventoryReason.returned: 'return',
  InventoryReason.cancel: 'cancel',
};
