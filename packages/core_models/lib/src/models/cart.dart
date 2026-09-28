import 'package:freezed_annotation/freezed_annotation.dart';

import '../converters/converters.dart';

part 'cart.freezed.dart';
part 'cart.g.dart';

/// A line in a cart or order (`carts.items[]`, `subOrders.items[]`).
@freezed
abstract class CartItem with _$CartItem {
  const CartItem._();

  const factory CartItem({
    required String productId,
    String? variantId,
    required String vendorId,
    required int qty,
    required int priceKoboSnapshot,
    required String nameSnapshot,
    String? imageId,
  }) = _CartItem;

  factory CartItem.fromJson(Map<String, dynamic> json) => _$CartItemFromJson(json);

  int get lineTotalKobo => qty * priceKoboSnapshot;

  /// Identity of the line: product + variant.
  String get lineKey => variantId == null ? productId : '$productId:$variantId';
}

/// Same snapshot shape is used for order lines.
typedef OrderItem = CartItem;

/// A customer's cart (`carts` collection, one per user). Client is the source
/// of truth; `PUT /me/cart` replaces it entirely.
@freezed
abstract class Cart with _$Cart {
  const Cart._();

  const factory Cart({
    @JsonKey(readValue: readId) String? id,
    required String userId,
    @Default(<CartItem>[]) List<CartItem> items,
    @NullableDateTimeConverter() DateTime? createdAt,
    @NullableDateTimeConverter() DateTime? updatedAt,
    @NullableDateTimeConverter() DateTime? deletedAt,
    @Default(0) int version,
  }) = _Cart;

  factory Cart.fromJson(Map<String, dynamic> json) => _$CartFromJson(json);

  int get subtotalKobo => items.fold(0, (acc, i) => acc + i.lineTotalKobo);
  int get itemCount => items.fold(0, (acc, i) => acc + i.qty);
  bool get isEmpty => items.isEmpty;

  /// Distinct vendor ids in this cart (one SubOrder per vendor at checkout).
  Set<String> get vendorIds => items.map((i) => i.vendorId).toSet();

  /// Items grouped by vendor.
  Map<String, List<CartItem>> get itemsByVendor {
    final out = <String, List<CartItem>>{};
    for (final item in items) {
      out.putIfAbsent(item.vendorId, () => []).add(item);
    }
    return out;
  }

  /// Returns a copy with [item] merged in (qty added when the line exists).
  Cart addItem(CartItem item) {
    final existing = items.indexWhere((i) => i.lineKey == item.lineKey);
    if (existing == -1) return copyWith(items: [...items, item]);
    final merged = [...items];
    merged[existing] = merged[existing].copyWith(qty: merged[existing].qty + item.qty);
    return copyWith(items: merged);
  }

  /// Returns a copy with the line's quantity set (removing it when ≤ 0).
  Cart setQty(String lineKey, int qty) {
    if (qty <= 0) return copyWith(items: items.where((i) => i.lineKey != lineKey).toList());
    return copyWith(
      items: [for (final i in items) i.lineKey == lineKey ? i.copyWith(qty: qty) : i],
    );
  }

  Cart removeLine(String lineKey) =>
      copyWith(items: items.where((i) => i.lineKey != lineKey).toList());
}
