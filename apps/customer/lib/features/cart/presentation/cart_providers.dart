import 'package:core_models/core_models.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../app/providers.dart';
import '../../addresses/data/address_providers.dart';
import '../../auth/presentation/session_controller.dart';
import '../../catalog/data/catalog_providers.dart';
import '../domain/cart_totals.dart';

/// The signed-in user's cart from the local store (keyed by userId, see
/// `ModelRegistry`). Always emits a cart, empty when none is stored.
final cartProvider = StreamProvider<Cart>((ref) {
  final userId = ref.watch(currentUserIdProvider);
  final store = ref.watch(localStoreProvider);
  if (userId.isEmpty) return Stream.value(const Cart(userId: ''));
  return store
      .watchById<Cart>(Collections.carts, userId)
      .map((c) => c ?? Cart(userId: userId));
});

final cartCountProvider = Provider<int>((ref) => ref.watch(cartProvider).value?.itemCount ?? 0);

/// Totals grouped by vendor with delivery estimates from the selected address.
final cartTotalsProvider = Provider<CartTotals>((ref) {
  final cart = ref.watch(cartProvider).value;
  if (cart == null) return CartTotals.empty;
  final vendors = ref.watch(vendorsByIdProvider);
  final address = ref.watch(selectedAddressProvider);
  return computeCartTotals(
    cart: cart,
    vendors: vendors,
    dropoff: address == null ? null : GeoPoint(lat: address.lat, lng: address.lng),
  );
});

/// Mutations: write locally and queue an upsert (offline-safe, LWW).
class CartActions {
  CartActions(this._ref);
  final Ref _ref;

  Future<Cart> _current() async {
    final userId = _ref.read(currentUserIdProvider);
    final store = _ref.read(localStoreProvider);
    return await store.getById<Cart>(Collections.carts, userId) ?? Cart(userId: userId);
  }

  Future<void> _save(Cart cart) => _ref
      .read(syncEngineProvider)
      .enqueueUpsert(Collections.carts, cart.copyWith(updatedAt: DateTime.now().toUtc()));

  Future<void> add(Product product, {ProductVariant? variant, int qty = 1}) async {
    final cart = await _current();
    await _save(cart.addItem(CartItem(
      productId: product.id,
      variantId: variant?.id,
      vendorId: product.vendorId,
      qty: qty,
      priceKoboSnapshot: variant?.priceKobo ?? product.basePriceKobo,
      nameSnapshot: variant == null ? product.name : '${product.name} · ${variant.name}',
      imageId: product.primaryImage?.imageId,
    )));
  }

  Future<void> setQty(String lineKey, int qty) async => _save((await _current()).setQty(lineKey, qty));

  Future<void> remove(String lineKey) async => _save((await _current()).removeLine(lineKey));

  /// Undo of a swipe-to-remove: re-inserts the exact line.
  Future<void> restore(CartItem item) async => _save((await _current()).addItem(item));

  Future<void> clear() async => _save((await _current()).copyWith(items: const []));
}

final cartActionsProvider = Provider<CartActions>(CartActions.new);
