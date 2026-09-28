import 'package:freezed_annotation/freezed_annotation.dart';

import '../converters/converters.dart';
import '../enums/enums.dart';

part 'inventory_movement.freezed.dart';
part 'inventory_movement.g.dart';

/// A stock change (`inventoryMovements` collection).
@freezed
abstract class InventoryMovement with _$InventoryMovement {
  const factory InventoryMovement({
    @JsonKey(readValue: readId) required String id,
    required String vendorId,
    required String productId,
    String? variantId,
    required int delta,
    required InventoryReason reason,
    String? orderId,
    String? byUserId,
    String? note,
    @NullableDateTimeConverter() DateTime? createdAt,
    @NullableDateTimeConverter() DateTime? updatedAt,
    @NullableDateTimeConverter() DateTime? deletedAt,
    @Default(0) int version,
  }) = _InventoryMovement;

  factory InventoryMovement.fromJson(Map<String, dynamic> json) =>
      _$InventoryMovementFromJson(json);
}
