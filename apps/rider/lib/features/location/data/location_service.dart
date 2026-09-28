import 'dart:async';
import 'dart:io' show Platform;

import 'package:api_client/api_client.dart';
import 'package:core_models/core_models.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';

import '../../../app/providers.dart';
import '../domain/location_queue.dart';
import 'location_permission.dart';

/// What the tracker should be doing, derived from profile + active delivery.
@immutable
class TrackingIntent {
  const TrackingIntent({required this.track, this.deliveryId});

  static const idle = TrackingIntent(track: false);

  final bool track;
  final String? deliveryId;

  @override
  bool operator ==(Object other) =>
      other is TrackingIntent && other.track == track && other.deliveryId == deliveryId;

  @override
  int get hashCode => Object.hash(track, deliveryId);
}

enum TrackingState { idle, tracking, permissionDenied, serviceDisabled, error }

/// Source of GPS fixes; swapped for a fake in tests.
typedef PositionSource = Stream<Position> Function(LocationSettings settings);

/// Dart-side background-ish location tracker.
///
/// While the rider is online or on an active delivery it streams positions
/// (best accuracy, 10 m filter) and sends each one over the socket
/// (`rider.location`). When the socket is not connected the ping goes to the
/// capped outbox queue instead, so nothing is lost offline.
///
/// On Android geolocator's foreground-notification config keeps the stream
/// alive in the background; on iOS the `location` background mode does. A
/// dedicated foreground-service plugin can later be plugged in by replacing
/// [positionSource] without touching the callers.
class RiderLocationService {
  RiderLocationService({
    required this.realtime,
    required this.queue,
    this.permissions = const LocationPermissionGate(),
    PositionSource? positionSource,
    this.distanceFilterMeters = 10,
  }) : _positionSource = positionSource ?? ((s) => Geolocator.getPositionStream(locationSettings: s));

  final RealtimeClient realtime;
  final LocationPingQueue queue;
  final LocationPermissionGate permissions;
  final PositionSource _positionSource;
  final int distanceFilterMeters;

  /// Latest fix sent (for the map's rider marker).
  final ValueNotifier<RiderLocationUpdate?> latest = ValueNotifier(null);

  /// Tracker state for UI hints.
  final ValueNotifier<TrackingState> state = ValueNotifier(TrackingState.idle);

  /// Number of pings queued offline since the tracker started.
  final ValueNotifier<int> queuedSinceStart = ValueNotifier(0);

  String? _riderId;
  String? _vendorId;
  TrackingIntent _intent = TrackingIntent.idle;
  StreamSubscription<TrackingIntent>? _intentSub;
  StreamSubscription<Position>? _positionSub;
  bool _running = false;

  bool get isRunning => _running;
  bool get isTracking => _positionSub != null;
  TrackingIntent get intent => _intent;

  /// Binds to [intents] for the signed-in rider.
  Future<void> start({
    required String riderId,
    String? vendorId,
    required Stream<TrackingIntent> intents,
  }) async {
    if (_running) await stop();
    _running = true;
    _riderId = riderId;
    _vendorId = vendorId;
    _intentSub = intents.distinct().listen(_onIntent);
  }

  Future<void> stop() async {
    _running = false;
    await _intentSub?.cancel();
    _intentSub = null;
    await _stopStream();
    _intent = TrackingIntent.idle;
    state.value = TrackingState.idle;
  }

  /// Re-checks permission and (re)starts the stream if tracking is wanted.
  Future<void> retry() => _onIntent(_intent, force: true);

  Future<void> _onIntent(TrackingIntent intent, {bool force = false}) async {
    final wasTracking = _intent.track;
    _intent = intent;
    if (!intent.track) {
      await _stopStream();
      state.value = TrackingState.idle;
      return;
    }
    if (isTracking && wasTracking && !force) return; // only deliveryId changed
    await _startStream();
  }

  Future<void> _startStream() async {
    await _stopStream();
    final access = await permissions.check();
    if (access == LocationAccess.serviceDisabled) {
      state.value = TrackingState.serviceDisabled;
      return;
    }
    if (!access.canTrack) {
      state.value = TrackingState.permissionDenied;
      return;
    }
    try {
      _positionSub = _positionSource(_settings()).listen(
        _onPosition,
        onError: (Object e, StackTrace st) {
          state.value = e is PermissionDeniedException
              ? TrackingState.permissionDenied
              : e is LocationServiceDisabledException
                  ? TrackingState.serviceDisabled
                  : TrackingState.error;
        },
      );
      state.value = TrackingState.tracking;
    } catch (_) {
      state.value = TrackingState.error;
    }
  }

  Future<void> _stopStream() async {
    await _positionSub?.cancel();
    _positionSub = null;
  }

  LocationSettings _settings() {
    if (kIsWeb) {
      return LocationSettings(accuracy: LocationAccuracy.best, distanceFilter: distanceFilterMeters);
    }
    if (Platform.isAndroid) {
      return AndroidSettings(
        accuracy: LocationAccuracy.best,
        distanceFilter: distanceFilterMeters,
        intervalDuration: const Duration(seconds: 5),
        foregroundNotificationConfig: const ForegroundNotificationConfig(
          notificationTitle: 'Instant Rider is online',
          notificationText: 'Sharing your location with your vendor while you deliver.',
          notificationChannelName: 'Delivery tracking',
          enableWakeLock: true,
          setOngoing: true,
        ),
      );
    }
    if (Platform.isIOS) {
      return AppleSettings(
        accuracy: LocationAccuracy.best,
        distanceFilter: distanceFilterMeters,
        activityType: ActivityType.automotiveNavigation,
        pauseLocationUpdatesAutomatically: false,
        showBackgroundLocationIndicator: true,
        allowBackgroundLocationUpdates: true,
      );
    }
    return LocationSettings(accuracy: LocationAccuracy.best, distanceFilter: distanceFilterMeters);
  }

  Future<void> _onPosition(Position p) async {
    final riderId = _riderId;
    if (riderId == null) return;
    final update = RiderLocationUpdate(
      lat: p.latitude,
      lng: p.longitude,
      heading: p.heading.isNaN || p.heading < 0 ? null : p.heading,
      speed: p.speed.isNaN || p.speed < 0 ? null : p.speed,
      at: p.timestamp.toUtc(),
      deliveryId: _intent.deliveryId,
    );
    latest.value = update;
    await send(update);
  }

  /// Socket first; outbox when the socket is down. Public for tests.
  Future<bool> send(RiderLocationUpdate update) async {
    final riderId = _riderId;
    if (riderId == null) return false;
    if (realtime.isConnected && realtime.sendRiderLocation(update)) return true;
    await queue.enqueue(RiderLocation(
      riderId: riderId,
      vendorId: _vendorId,
      deliveryId: update.deliveryId,
      lat: update.lat,
      lng: update.lng,
      heading: update.heading,
      speed: update.speed,
      at: update.at,
    ));
    queuedSinceStart.value++;
    return false;
  }

  void dispose() {
    unawaited(stop());
    latest.dispose();
    state.dispose();
    queuedSinceStart.dispose();
  }
}

final locationPingQueueProvider = Provider<LocationPingQueue>(
  (ref) => LocationPingQueue(engine: ref.watch(syncEngineProvider)),
);

final locationPermissionGateProvider = Provider<LocationPermissionGate>((ref) => const LocationPermissionGate());

final riderLocationServiceProvider = Provider<RiderLocationService>((ref) {
  final service = RiderLocationService(
    realtime: ref.watch(realtimeClientProvider),
    queue: ref.watch(locationPingQueueProvider),
    permissions: ref.watch(locationPermissionGateProvider),
  );
  ref.onDispose(service.dispose);
  return service;
});
