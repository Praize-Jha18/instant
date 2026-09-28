import 'dart:async';

import 'package:api_client/api_client.dart';
import 'package:core_models/core_models.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../app/providers.dart';
import '../data/orders_repository.dart';
import 'order_providers.dart';

/// Latest known rider position for one delivery.
class RiderPoint {
  const RiderPoint({required this.deliveryId, required this.lat, required this.lng, this.heading, required this.at});
  final String deliveryId;
  final double lat;
  final double lng;
  final double? heading;
  final DateTime at;
}

class TrackingState {
  const TrackingState({this.tracking, this.riders = const {}, this.error, this.loading = true});

  /// Last `GET /orders/:id/tracking` response.
  final OrderTracking? tracking;

  /// Rider positions by delivery id (realtime first, polling as fallback).
  final Map<String, RiderPoint> riders;
  final String? error;
  final bool loading;

  TrackingState copyWith({OrderTracking? tracking, Map<String, RiderPoint>? riders, String? error, bool? loading}) =>
      TrackingState(
        tracking: tracking ?? this.tracking,
        riders: riders ?? this.riders,
        error: error,
        loading: loading ?? this.loading,
      );
}

/// Subscribes to the delivery rooms of an order for `rider.location` events
/// and polls the tracking endpoint every [pollInterval] as a fallback.
class TrackingController extends Notifier<TrackingState> {
  TrackingController(this.orderId);

  final String orderId;
  static const Duration pollInterval = Duration(seconds: 15);

  Timer? _timer;
  StreamSubscription<RiderLocationEvent>? _sub;
  final Set<String> _rooms = {};

  @override
  TrackingState build() {
    final realtime = ref.watch(realtimeClientProvider);
    _sub = realtime.riderLocations.listen(_onRiderLocation);
    _timer = Timer.periodic(pollInterval, (_) => poll());

    // Join delivery rooms as deliveries become known locally.
    ref.listen<AsyncValue<List<SubOrder>>>(subOrdersProvider(orderId), (_, next) {
      _joinRooms(realtime, (next.value ?? const []).map((s) => s.deliveryId).nonNulls);
    }, fireImmediately: true);
    ref.listen<AsyncValue<List<Delivery>>>(deliveriesForOrderProvider(orderId), (_, next) {
      _joinRooms(realtime, (next.value ?? const []).map((d) => d.id));
    }, fireImmediately: true);

    ref.onDispose(() {
      _timer?.cancel();
      _sub?.cancel();
      for (final room in _rooms) {
        realtime.unsubscribe(room);
      }
    });
    Future.microtask(poll);
    return const TrackingState();
  }

  void _joinRooms(RealtimeClient realtime, Iterable<String> deliveryIds) {
    for (final id in deliveryIds) {
      final room = RealtimeRooms.delivery(id);
      if (_rooms.add(room)) realtime.subscribe(room);
    }
  }

  void _onRiderLocation(RiderLocationEvent e) {
    if (!_rooms.contains(RealtimeRooms.delivery(e.deliveryId))) return;
    state = state.copyWith(riders: {
      ...state.riders,
      e.deliveryId: RiderPoint(deliveryId: e.deliveryId, lat: e.lat, lng: e.lng, heading: e.heading, at: e.at),
    });
  }

  Future<void> poll() async {
    if (!ref.read(isOnlineProvider)) {
      state = state.copyWith(loading: false, error: state.tracking == null ? 'offline' : null);
      return;
    }
    try {
      final tracking = await ref.read(ordersRepositoryProvider).tracking(orderId);
      final riders = {...state.riders};
      for (final s in tracking.subOrders) {
        final loc = s.riderLocation;
        final deliveryId = s.deliveryId;
        if (loc == null || deliveryId == null) continue;
        final existing = riders[deliveryId];
        if (existing == null || !existing.at.isAfter(loc.at)) {
          riders[deliveryId] =
              RiderPoint(deliveryId: deliveryId, lat: loc.lat, lng: loc.lng, heading: loc.heading, at: loc.at);
        }
        _joinRooms(ref.read(realtimeClientProvider), [deliveryId]);
      }
      state = state.copyWith(tracking: tracking, riders: riders, loading: false);
    } catch (e) {
      state = state.copyWith(loading: false, error: e.toString());
    }
  }
}

final trackingControllerProvider = NotifierProvider.autoDispose
    .family<TrackingController, TrackingState, String>(TrackingController.new);
