import 'package:api_client/api_client.dart';
import 'package:core_models/core_models.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:local_db/local_db.dart';

import '../../../app/providers.dart';

/// Order + payment calls used by checkout, order detail and tracking. Every
/// successful read is written to the local store (network only fills it).
abstract interface class OrdersRepository {
  Future<CheckoutPayload> createOrder(CreateOrderRequest request);
  Future<CheckoutPayload> retryPayment(String orderId);
  Future<Order> fetchOrder(String id);
  Future<Order> cancelOrder(String id);
  Future<OrderTracking> tracking(String orderId);

  /// Delivery OTPs by subOrder id (shown to the customer at hand-over).
  ValueListenable<Map<String, String>> get deliveryOtps;
}

class ApiOrdersRepository implements OrdersRepository {
  ApiOrdersRepository(this._client, this._store);

  final ApiClient _client;
  final LocalStore _store;

  Future<void> _cache(Order order, [List<SubOrder> subOrders = const []]) async {
    await _store.upsert(Collections.orders, order);
    final subs = subOrders.isNotEmpty ? subOrders : order.subOrders;
    if (subs.isNotEmpty) await _store.upsertAll(Collections.subOrders, subs);
  }

  @override
  Future<CheckoutPayload> createOrder(CreateOrderRequest request) async {
    final payload = await _client.customer.createOrder(request);
    await _cache(payload.order, payload.subOrders);
    return payload;
  }

  @override
  Future<CheckoutPayload> retryPayment(String orderId) async {
    final payload = await _client.payments.retry(orderId);
    await _cache(payload.order, payload.subOrders);
    return payload;
  }

  @override
  Future<Order> fetchOrder(String id) async {
    // Raw read so we can also pick up `subOrders[].deliveryOtp` (contract §11),
    // which the typed SubOrder model does not carry.
    final body = _unwrap(await _client.get('/orders/$id'));
    final order = Order.fromJson(body);
    await _cache(order);
    final otps = <String, String>{};
    final subs = body['subOrders'];
    if (subs is List) {
      for (final raw in subs) {
        if (raw is! Map) continue;
        final subId = readId(Map<String, dynamic>.from(raw), 'id')?.toString();
        final otp = raw['deliveryOtp'];
        if (subId != null && otp is String && otp.isNotEmpty) otps[subId] = otp;
      }
    }
    if (otps.isNotEmpty) _otps.value = {..._otps.value, ...otps};
    return order;
  }

  /// Delivery OTPs by subOrder id, learned from `GET /orders/:id`.
  final ValueNotifier<Map<String, String>> _otps = ValueNotifier(const {});

  @override
  ValueListenable<Map<String, String>> get deliveryOtps => _otps;

  static Map<String, dynamic> _unwrap(Object? body) {
    final map = body is Map<String, dynamic> ? body : Map<String, dynamic>.from(body as Map);
    final data = map['data'];
    if (map.length == 1 && data is Map) return Map<String, dynamic>.from(data);
    return map;
  }

  @override
  Future<Order> cancelOrder(String id) async {
    final order = await _client.customer.cancelOrder(id);
    await _cache(order);
    return order;
  }

  @override
  Future<OrderTracking> tracking(String orderId) => _client.customer.tracking(orderId);
}

final ordersRepositoryProvider = Provider<OrdersRepository>(
  (ref) => ApiOrdersRepository(ref.watch(apiClientProvider), ref.watch(localStoreProvider)),
);
