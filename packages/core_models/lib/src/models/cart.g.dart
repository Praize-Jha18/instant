// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'cart.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_CartItem _$CartItemFromJson(Map<String, dynamic> json) => _CartItem(
  productId: json['productId'] as String,
  variantId: json['variantId'] as String?,
  vendorId: json['vendorId'] as String,
  qty: (json['qty'] as num).toInt(),
  priceKoboSnapshot: (json['priceKoboSnapshot'] as num).toInt(),
  nameSnapshot: json['nameSnapshot'] as String,
  imageId: json['imageId'] as String?,
);

Map<String, dynamic> _$CartItemToJson(_CartItem instance) => <String, dynamic>{
  'productId': instance.productId,
  'variantId': ?instance.variantId,
  'vendorId': instance.vendorId,
  'qty': instance.qty,
  'priceKoboSnapshot': instance.priceKoboSnapshot,
  'nameSnapshot': instance.nameSnapshot,
  'imageId': ?instance.imageId,
};

_Cart _$CartFromJson(Map<String, dynamic> json) => _Cart(
  id: readId(json, 'id') as String?,
  userId: json['userId'] as String,
  items:
      (json['items'] as List<dynamic>?)
          ?.map((e) => CartItem.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const <CartItem>[],
  createdAt: const NullableDateTimeConverter().fromJson(json['createdAt']),
  updatedAt: const NullableDateTimeConverter().fromJson(json['updatedAt']),
  deletedAt: const NullableDateTimeConverter().fromJson(json['deletedAt']),
  version: (json['version'] as num?)?.toInt() ?? 0,
);

Map<String, dynamic> _$CartToJson(_Cart instance) => <String, dynamic>{
  'id': ?instance.id,
  'userId': instance.userId,
  'items': instance.items.map((e) => e.toJson()).toList(),
  'createdAt': ?const NullableDateTimeConverter().toJson(instance.createdAt),
  'updatedAt': ?const NullableDateTimeConverter().toJson(instance.updatedAt),
  'deletedAt': ?const NullableDateTimeConverter().toJson(instance.deletedAt),
  'version': instance.version,
};
