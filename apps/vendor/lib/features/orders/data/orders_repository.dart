import 'package:api_client/api_client.dart';
import 'package:core_models/core_models.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:local_db/local_db.dart';

import '../../../app/providers.dart';

/// Order and delivery actions. All online-only (server-authoritative
/// statuses, §7); the returned document is written to the store so screens
/// update immediately without waiting for the realtime echo.
class OrdersRepository {
  OrdersRepository(this._api, this._store);

  final ApiClient _api;
  final LocalStore _store;

  Future<SubOrder> updateStatus(String subOrderId, SubOrderStatus status, {String? note}) async {
    final updated = await _api.vendor.updateOrderStatus(subOrderId, status, note: note);
    await _store.upsert(Collections.subOrders, updated);
    return updated;
  }

  Future<Delivery> assign(String deliveryId, String riderId) async {
    final d = await _api.vendor.assignDelivery(deliveryId, riderId);
    await _store.upsert(Collections.deliveries, d);
    return d;
  }

  Future<Delivery> autoAssign(String deliveryId) async {
    final d = await _api.vendor.autoAssignDelivery(deliveryId);
    await _store.upsert(Collections.deliveries, d);
    return d;
  }
}

final ordersRepositoryProvider = Provider<OrdersRepository>(
  (ref) => OrdersRepository(ref.watch(apiClientProvider), ref.watch(localStoreProvider)),
);
