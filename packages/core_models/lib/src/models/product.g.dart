// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'product.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_ProductImage _$ProductImageFromJson(Map<String, dynamic> json) =>
    _ProductImage(
      imageId: json['imageId'] as String,
      sortOrder: (json['sortOrder'] as num?)?.toInt() ?? 0,
    );

Map<String, dynamic> _$ProductImageToJson(_ProductImage instance) =>
    <String, dynamic>{
      'imageId': instance.imageId,
      'sortOrder': instance.sortOrder,
    };

_ProductVariant _$ProductVariantFromJson(Map<String, dynamic> json) =>
    _ProductVariant(
      id: readId(json, 'id') as String,
      name: json['name'] as String,
      sku: json['sku'] as String?,
      priceKobo: (json['priceKobo'] as num).toInt(),
      stock: (json['stock'] as num?)?.toInt() ?? 0,
      attributes:
          json['attributes'] as Map<String, dynamic>? ??
          const <String, Object?>{},
    );

Map<String, dynamic> _$ProductVariantToJson(_ProductVariant instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'sku': ?instance.sku,
      'priceKobo': instance.priceKobo,
      'stock': instance.stock,
      'attributes': instance.attributes,
    };

_ProductRating _$ProductRatingFromJson(Map<String, dynamic> json) =>
    _ProductRating(
      avg: (json['avg'] as num?)?.toDouble() ?? 0,
      count: (json['count'] as num?)?.toInt() ?? 0,
    );

Map<String, dynamic> _$ProductRatingToJson(_ProductRating instance) =>
    <String, dynamic>{'avg': instance.avg, 'count': instance.count};

_Product _$ProductFromJson(Map<String, dynamic> json) => _Product(
  id: readId(json, 'id') as String,
  vendorId: json['vendorId'] as String,
  name: json['name'] as String,
  slug: json['slug'] as String,
  description: json['description'] as String?,
  categoryIds:
      (json['categoryIds'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList() ??
      const <String>[],
  images:
      (json['images'] as List<dynamic>?)
          ?.map((e) => ProductImage.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const <ProductImage>[],
  basePriceKobo: (json['basePriceKobo'] as num?)?.toInt() ?? 0,
  variants:
      (json['variants'] as List<dynamic>?)
          ?.map((e) => ProductVariant.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const <ProductVariant>[],
  hasVariants: json['hasVariants'] as bool? ?? false,
  stock: (json['stock'] as num?)?.toInt() ?? 0,
  status:
      $enumDecodeNullable(_$ProductStatusEnumMap, json['status']) ??
      ProductStatus.draft,
  tags:
      (json['tags'] as List<dynamic>?)?.map((e) => e as String).toList() ??
      const <String>[],
  rating: json['rating'] == null
      ? const ProductRating()
      : ProductRating.fromJson(json['rating'] as Map<String, dynamic>),
  createdAt: const NullableDateTimeConverter().fromJson(json['createdAt']),
  updatedAt: const NullableDateTimeConverter().fromJson(json['updatedAt']),
  deletedAt: const NullableDateTimeConverter().fromJson(json['deletedAt']),
  version: (json['version'] as num?)?.toInt() ?? 0,
);

Map<String, dynamic> _$ProductToJson(_Product instance) => <String, dynamic>{
  'id': instance.id,
  'vendorId': instance.vendorId,
  'name': instance.name,
  'slug': instance.slug,
  'description': ?instance.description,
  'categoryIds': instance.categoryIds,
  'images': instance.images.map((e) => e.toJson()).toList(),
  'basePriceKobo': instance.basePriceKobo,
  'variants': instance.variants.map((e) => e.toJson()).toList(),
  'hasVariants': instance.hasVariants,
  'stock': instance.stock,
  'status': _$ProductStatusEnumMap[instance.status]!,
  'tags': instance.tags,
  'rating': instance.rating.toJson(),
  'createdAt': ?const NullableDateTimeConverter().toJson(instance.createdAt),
  'updatedAt': ?const NullableDateTimeConverter().toJson(instance.updatedAt),
  'deletedAt': ?const NullableDateTimeConverter().toJson(instance.deletedAt),
  'version': instance.version,
};

const _$ProductStatusEnumMap = {
  ProductStatus.draft: 'draft',
  ProductStatus.active: 'active',
  ProductStatus.archived: 'archived',
};
