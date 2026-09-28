import 'dart:async';

import 'package:api_client/api_client.dart';
import 'package:core_models/core_models.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../core/streams.dart';
import '../features/active_delivery/data/pending_proof_queue.dart';
import '../features/location/data/location_service.dart';
import 'providers.dart';

/// Starts and stops everything that lives for the duration of a sign-in:
/// sync engine, realtime rooms, location tracking and the proof queue.
class SessionServices {
  SessionServices(this._ref);

  final Ref _ref;
  final Set<String> _rooms = {};
  bool _running = false;

  bool get isRunning => _running;

  Future<void> start(AuthUser user) async {
    if (_running) return;
    _running = true;
    final engine = _ref.read(syncEngineProvider);
    final realtime = _ref.read(realtimeClientProvider);
    final store = _ref.read(localStoreProvider);

    await engine.start();

    // Vendor id may live only on the profile when the JWT omits it.
    final profiles = await store.getAll<RiderProfile>(Collections.riderProfiles);
    final profile = profiles.where((p) => p.userId == user.id).firstOrNull ?? profiles.firstOrNull;
    final vendorId = user.vendorId ?? profile?.vendorId;

    _subscribe(realtime, RealtimeRooms.user(user.id));
    if (vendorId != null) _subscribe(realtime, RealtimeRooms.vendor(vendorId));
    realtime.connect();

    _ref.read(pendingProofQueueProvider).bind(engine: engine, realtime: realtime);

    final riderId = profile?.id ?? user.id;
    final myIds = <String>{user.id, if (profile != null) profile.id};
    final onlineStream = store
        .watchAll<RiderProfile>(Collections.riderProfiles, filter: (p) => p.userId == user.id)
        .map((l) => l.isNotEmpty && l.first.isOnline);
    final activeStream = store
        .watchAll<Delivery>(
          Collections.deliveries,
          filter: (d) =>
              myIds.contains(d.riderId) &&
              (d.status == DeliveryStatus.accepted || d.status == DeliveryStatus.pickedUp),
        )
        .map((l) => l.isEmpty ? null : l.first.id);
    final intents = combineLatest2<bool, String?, TrackingIntent>(
      onlineStream,
      activeStream,
      (online, deliveryId) => TrackingIntent(track: online || deliveryId != null, deliveryId: deliveryId),
    );
    await _ref.read(riderLocationServiceProvider).start(riderId: riderId, vendorId: vendorId, intents: intents);
  }

  Future<void> stop({required bool clearStore}) async {
    final engine = _ref.read(syncEngineProvider);
    final realtime = _ref.read(realtimeClientProvider);
    final store = _ref.read(localStoreProvider);

    await _ref.read(riderLocationServiceProvider).stop();
    _ref.read(pendingProofQueueProvider).unbind();
    for (final room in _rooms) {
      realtime.unsubscribe(room);
    }
    _rooms.clear();
    realtime.disconnect();
    await engine.stop();
    if (clearStore) await store.clear();
    _running = false;
  }

  void _subscribe(RealtimeClient realtime, String room) {
    _rooms.add(room);
    realtime.subscribe(room);
  }
}

final sessionServicesProvider = Provider<SessionServices>((ref) => SessionServices(ref));
