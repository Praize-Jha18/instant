import 'package:freezed_annotation/freezed_annotation.dart';

import '../converters/converters.dart';
import '../enums/enums.dart';

part 'product.freezed.dart';
part 'product.g.dart';

/// A product image reference (`products.images[]`).
@freezed
abstract class ProductImage with _$ProductImage {
  const factory ProductImage({
    required String imageId,
    @Default(0) int sortOrder,
  }) = _ProductImage;

  factory ProductImage.fromJson(Map<String, dynamic> json) =>
      _$ProductImageFromJson(json);
}

/// A purchasable variant of a product (`products.variants[]`).
@freezed
abstract class ProductVariant with _$ProductVariant {
  const ProductVariant._();

  const factory ProductVariant({
    @JsonKey(readValue: readId) required String id,
    required String name,
    String? sku,
    required int priceKobo,
    @Default(0) int stock,
    @Default(<String, Object?>{}) Map<String, Object?> attributes,
  }) = _ProductVariant;

  factory ProductVariant.fromJson(Map<String, dynamic> json) =>
      _$ProductVariantFromJson(json);

  bool get inStock => stock > 0;
}

/// Aggregate rating (`products.rating`).
@freezed
abstract class ProductRating with _$ProductRating {
  const factory ProductRating({
    @Default(0) double avg,
    @Default(0) int count,
  }) = _ProductRating;

  factory ProductRating.fromJson(Map<String, dynamic> json) =>
      _$ProductRatingFromJson(json);
}

/// A product (`products` collection).
@freezed
abstract class Product with _$Product {
  const Product._();

  const factory Product({
    @JsonKey(readValue: readId) required String id,
    required String vendorId,
    required String name,
    required String slug,
    String? description,
    @Default(<String>[]) List<String> categoryIds,
    @Default(<ProductImage>[]) List<ProductImage> images,
    @Default(0) int basePriceKobo,
    @Default(<ProductVariant>[]) List<ProductVariant> variants,
    @Default(false) bool hasVariants,
    @Default(0) int stock,
    @Default(ProductStatus.draft) ProductStatus status,
    @Default(<String>[]) List<String> tags,
    @Default(ProductRating()) ProductRating rating,
    @NullableDateTimeConverter() DateTime? createdAt,
    @NullableDateTimeConverter() DateTime? updatedAt,
    @NullableDateTimeConverter() DateTime? deletedAt,
    @Default(0) int version,
  }) = _Product;

  factory Product.fromJson(Map<String, dynamic> json) => _$ProductFromJson(json);

  /// First image by [ProductImage.sortOrder], if any.
  ProductImage? get primaryImage {
    if (images.isEmpty) return null;
    final sorted = [...images]..sort((a, b) => a.sortOrder.compareTo(b.sortOrder));
    return sorted.first;
  }

  /// Total available stock across variants, or [stock] when no variants.
  int get totalStock => hasVariants
      ? variants.fold(0, (acc, v) => acc + v.stock)
      : stock;

  bool get inStock => totalStock > 0;

  /// Lowest price across variants, or [basePriceKobo].
  int get minPriceKobo {
    if (!hasVariants || variants.isEmpty) return basePriceKobo;
    return variants.map((v) => v.priceKobo).reduce((a, b) => a < b ? a : b);
  }

  ProductVariant? variantById(String? variantId) {
    if (variantId == null) return null;
    for (final v in variants) {
      if (v.id == variantId) return v;
    }
    return null;
  }
}
