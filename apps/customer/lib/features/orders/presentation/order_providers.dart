import 'dart:async';

import 'package:api_client/api_client.dart';
import 'package:core_models/core_models.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../app/providers.dart';
import '../../auth/presentation/session_controller.dart';
import '../data/orders_repository.dart';

/// All my orders, newest first.
final ordersProvider = StreamProvider<List<Order>>((ref) {
  final userId = ref.watch(currentUserIdProvider);
  final store = ref.watch(localStoreProvider);
  DateTime when(Order o) => o.placedAt ?? o.createdAt ?? DateTime.fromMillisecondsSinceEpoch(0);
  return store.watchAll<Order>(
    Collections.orders,
    filter: (o) => o.deletedAt == null && (userId.isEmpty || o.customerId == userId),
    sortBy: (a, b) => when(b).compareTo(when(a)),
  );
});

final orderProvider = StreamProvider.family<Order?, String>((ref, id) {
  final store = ref.watch(localStoreProvider);
  return store.watchById<Order>(Collections.orders, id);
});

/// Sub-orders of one order from the store, falling back to the ones embedded
/// in the order document.
final subOrdersProvider = StreamProvider.family<List<SubOrder>, String>((ref, orderId) {
  final store = ref.watch(localStoreProvider);
  return store.watchAll<SubOrder>(
    Collections.subOrders,
    filter: (s) => s.orderId == orderId && s.deletedAt == null,
    sortBy: (a, b) => (a.vendorName ?? a.vendorId).compareTo(b.vendorName ?? b.vendorId),
  );
});

/// All sub-orders keyed by order id (for the orders list badges).
final subOrdersByOrderProvider = StreamProvider<Map<String, List<SubOrder>>>((ref) {
  final store = ref.watch(localStoreProvider);
  return store.watchAll<SubOrder>(Collections.subOrders, filter: (s) => s.deletedAt == null).map((all) {
    final out = <String, List<SubOrder>>{};
    for (final s in all) {
      out.putIfAbsent(s.orderId, () => []).add(s);
    }
    return out;
  });
});

final deliveriesForOrderProvider = StreamProvider.family<List<Delivery>, String>((ref, orderId) {
  final store = ref.watch(localStoreProvider);
  final subIds = (ref.watch(subOrdersProvider(orderId)).value ?? const <SubOrder>[]).map((s) => s.id).toSet();
  return store.watchAll<Delivery>(
    Collections.deliveries,
    filter: (d) => d.orderId == orderId || subIds.contains(d.subOrderId),
  );
});

/// Delivery OTPs learned from the API (subOrderId → otp).
final deliveryOtpsProvider = Provider<Map<String, String>>((ref) {
  final listenable = ref.watch(ordersRepositoryProvider).deliveryOtps;
  void onChange() => ref.invalidateSelf();
  listenable.addListener(onChange);
  ref.onDispose(() => listenable.removeListener(onChange));
  return listenable.value;
});

/// Keeps an order fresh while its screen is open: joins the realtime room and
/// refreshes from the API once (and again on demand).
class OrderWatcher {
  OrderWatcher(this._ref, this.orderId);

  final Ref _ref;
  final String orderId;
  bool _active = false;

  Future<void> start() async {
    if (_active) return;
    _active = true;
    _ref.read(realtimeClientProvider).subscribe(RealtimeRooms.order(orderId));
    await refresh();
  }

  Future<void> stop() async {
    if (!_active) return;
    _active = false;
    _ref.read(realtimeClientProvider).unsubscribe(RealtimeRooms.order(orderId));
  }

  Future<void> refresh() async {
    if (!_ref.read(isOnlineProvider)) return;
    try {
      await _ref.read(ordersRepositoryProvider).fetchOrder(orderId);
    } catch (_) {
      // Local copy stays; sync will catch up.
    }
  }
}

final orderWatcherProvider = Provider.autoDispose.family<OrderWatcher, String>((ref, orderId) {
  final watcher = OrderWatcher(ref, orderId);
  unawaited(watcher.start());
  ref.onDispose(() => unawaited(watcher.stop()));
  return watcher;
});
