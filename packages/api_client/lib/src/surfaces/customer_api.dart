import 'package:core_models/core_models.dart';

import 'base_api.dart';

/// Customer routes (§5): cart, addresses, orders, tracking.
class CustomerApi extends BaseApi {
  const CustomerApi(super.client);

  /// `GET /me/cart`.
  Future<Cart> getCart() async => Cart.fromJson(unwrap(await client.get('/me/cart')));

  /// `PUT /me/cart` — full replace; the client is the source of truth.
  Future<Cart> putCart(CartInput cart) async =>
      Cart.fromJson(unwrap(await client.put('/me/cart', data: cart.toJson())));

  /// `GET /me/addresses`.
  Future<List<Address>> addresses() async =>
      asList(await client.get('/me/addresses'), Address.fromJson);

  /// `POST /me/addresses`.
  Future<Address> createAddress(AddressInput input) async =>
      Address.fromJson(unwrap(await client.post('/me/addresses', data: input.toJson())));

  /// `PATCH /me/addresses/:id`.
  Future<Address> updateAddress(String id, AddressInput input) async =>
      Address.fromJson(unwrap(await client.patch('/me/addresses/$id', data: input.toJson())));

  /// `DELETE /me/addresses/:id`.
  Future<void> deleteAddress(String id) => client.delete('/me/addresses/$id');

  /// `POST /orders` — creates order + subOrders from the cart; returns the
  /// checkout payload (order + payment client secret). Online only.
  Future<CheckoutPayload> createOrder(CreateOrderRequest request) async {
    final body = unwrap(await client.post('/orders', data: request.toJson()));
    // Tolerate a bare order response.
    if (!body.containsKey('order') && body.containsKey('orderNumber')) {
      return CheckoutPayload(order: Order.fromJson(body));
    }
    return CheckoutPayload.fromJson(body);
  }

  /// `GET /orders?cursor=`.
  Future<Paginated<Order>> orders({String? cursor, int? limit}) async =>
      asPage(await client.get('/orders', query: {'cursor': cursor, 'limit': limit}), Order.fromJson);

  /// `GET /orders/:id`.
  Future<Order> order(String id) async => Order.fromJson(unwrap(await client.get('/orders/$id')));

  /// `POST /orders/:id/cancel` — only while every subOrder is `placed`.
  Future<Order> cancelOrder(String id) async =>
      Order.fromJson(unwrap(await client.post('/orders/$id/cancel')));

  /// `GET /orders/:id/tracking` — rider location + status per subOrder.
  Future<OrderTracking> tracking(String orderId) async {
    final body = unwrap(await client.get('/orders/$orderId/tracking'));
    body.putIfAbsent('orderId', () => orderId);
    return OrderTracking.fromJson(body);
  }
}
