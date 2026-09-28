import 'package:freezed_annotation/freezed_annotation.dart';

import '../converters/converters.dart';

part 'category.freezed.dart';
part 'category.g.dart';

/// A product category (`categories` collection).
@freezed
abstract class Category with _$Category {
  const factory Category({
    @JsonKey(readValue: readId) required String id,
    required String name,
    required String slug,
    String? parentId,
    @Default(0) int sortOrder,
    String? imageId,
    @NullableDateTimeConverter() DateTime? createdAt,
    @NullableDateTimeConverter() DateTime? updatedAt,
    @NullableDateTimeConverter() DateTime? deletedAt,
    @Default(0) int version,
  }) = _Category;

  factory Category.fromJson(Map<String, dynamic> json) => _$CategoryFromJson(json);
}
