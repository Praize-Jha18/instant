import 'dart:async';

import 'package:api_client/api_client.dart';
import 'package:core_models/core_models.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../app/providers.dart';
import '../../../app/session.dart';

/// Last known position of one rider.
@immutable
class RiderPosition {
  const RiderPosition({required this.riderId, required this.lat, required this.lng, this.heading, required this.at, this.deliveryId});

  final String riderId;
  final double lat;
  final double lng;
  final double? heading;
  final DateTime at;
  final String? deliveryId;
}

/// Live rider positions keyed by rider profile id. Fed by realtime
/// `rider.location` events (subscribed delivery rooms) and seeded from the
/// `lastLocation` returned by `GET /vendor/riders`.
class RiderLocations extends Notifier<Map<String, RiderPosition>> {
  StreamSubscription<RiderLocationEvent>? _sub;

  @override
  Map<String, RiderPosition> build() {
    ref.watch(sessionProvider.select((s) => s.user?.id));
    final realtime = ref.watch(realtimeClientProvider);
    _sub?.cancel();
    _sub = realtime.riderLocations.listen(_onEvent);
    ref.onDispose(() => _sub?.cancel());
    return const {};
  }

  Future<void> _onEvent(RiderLocationEvent e) async {
    var riderId = e.riderId;
    if (riderId == null && e.deliveryId.isNotEmpty) {
      final d = await ref.read(localStoreProvider).getById<Delivery>(Collections.deliveries, e.deliveryId);
      riderId = d?.riderId;
    }
    if (riderId == null) return;
    seed(RiderPosition(riderId: riderId, lat: e.lat, lng: e.lng, heading: e.heading, at: e.at, deliveryId: e.deliveryId));
  }

  /// Merges a position, keeping the newest per rider.
  void seed(RiderPosition p) {
    final current = state[p.riderId];
    if (current != null && current.at.isAfter(p.at)) return;
    state = {...state, p.riderId: p};
  }

  void seedAll(Iterable<RiderPosition> positions) {
    final next = Map<String, RiderPosition>.from(state);
    for (final p in positions) {
      final current = next[p.riderId];
      if (current == null || !current.at.isAfter(p.at)) next[p.riderId] = p;
    }
    state = next;
  }
}

final riderLocationsProvider = NotifierProvider<RiderLocations, Map<String, RiderPosition>>(RiderLocations.new);

/// Keeps a `delivery:{id}` room subscription for every active delivery so
/// rider.location events reach the vendor app. Terminal deliveries are left.
class DeliveryRooms extends Notifier<Set<String>> {
  StreamSubscription<List<Delivery>>? _sub;

  @override
  Set<String> build() {
    ref.watch(sessionProvider.select((s) => s.user?.id));
    final store = ref.watch(localStoreProvider);
    final realtime = ref.watch(realtimeClientProvider);
    _sub?.cancel();
    _sub = store.watchAll<Delivery>(Collections.deliveries, filter: (d) => !d.status.isTerminal).listen((active) {
      final wanted = active.map((d) => d.id).toSet();
      for (final id in wanted.difference(state)) {
        realtime.subscribe(RealtimeRooms.delivery(id));
      }
      for (final id in state.difference(wanted)) {
        realtime.unsubscribe(RealtimeRooms.delivery(id));
      }
      state = wanted;
    });
    ref.onDispose(() {
      _sub?.cancel();
      for (final id in state) {
        realtime.unsubscribe(RealtimeRooms.delivery(id));
      }
    });
    return const {};
  }
}

final deliveryRoomsProvider = NotifierProvider<DeliveryRooms, Set<String>>(DeliveryRooms.new);
