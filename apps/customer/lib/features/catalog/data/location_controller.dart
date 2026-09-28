import 'package:core_models/core_models.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';

import '../../../app/providers.dart';

/// Whether the user has been asked for location on Home already (soft ask).
class LocationPromptDismissed extends Notifier<bool> {
  static const String _key = 'instant.locationPromptDismissed';

  @override
  bool build() => ref.watch(sharedPreferencesProvider).getBool(_key) ?? false;

  Future<void> dismiss() async {
    state = true;
    await ref.read(sharedPreferencesProvider).setBool(_key, true);
  }
}

final locationPromptDismissedProvider =
    NotifierProvider<LocationPromptDismissed, bool>(LocationPromptDismissed.new);

/// Abstraction over geolocator so tests can fake it.
abstract interface class LocationService {
  Future<bool> hasPermission();
  Future<bool> requestPermission();
  Future<GeoPoint?> currentPosition();
}

class GeolocatorLocationService implements LocationService {
  const GeolocatorLocationService();

  static bool _granted(LocationPermission p) =>
      p == LocationPermission.always || p == LocationPermission.whileInUse;

  @override
  Future<bool> hasPermission() async {
    try {
      return _granted(await Geolocator.checkPermission());
    } catch (_) {
      return false;
    }
  }

  @override
  Future<bool> requestPermission() async {
    try {
      if (!await Geolocator.isLocationServiceEnabled()) return false;
      var p = await Geolocator.checkPermission();
      if (p == LocationPermission.denied) p = await Geolocator.requestPermission();
      return _granted(p);
    } catch (_) {
      return false;
    }
  }

  @override
  Future<GeoPoint?> currentPosition() async {
    try {
      final last = await Geolocator.getLastKnownPosition();
      final pos = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(accuracy: LocationAccuracy.medium),
      ).timeout(const Duration(seconds: 8), onTimeout: () {
        if (last == null) throw Exception('timeout');
        return last;
      });
      return GeoPoint(lat: pos.latitude, lng: pos.longitude);
    } catch (_) {
      return null;
    }
  }
}

final locationServiceProvider = Provider<LocationService>((_) => const GeolocatorLocationService());

/// The user's current position when permission is already granted; never
/// prompts by itself (see [request]).
class LocationController extends AsyncNotifier<GeoPoint?> {
  @override
  Future<GeoPoint?> build() async {
    final service = ref.watch(locationServiceProvider);
    if (!await service.hasPermission()) return null;
    return service.currentPosition();
  }

  /// Soft ask from the Home card: returns true when a position was obtained.
  Future<bool> request() async {
    final service = ref.read(locationServiceProvider);
    state = const AsyncLoading<GeoPoint?>();
    final granted = await service.requestPermission();
    final point = granted ? await service.currentPosition() : null;
    state = AsyncData(point);
    return point != null;
  }

  Future<void> refresh() async {
    final service = ref.read(locationServiceProvider);
    if (!await service.hasPermission()) return;
    final point = await service.currentPosition();
    if (point != null) state = AsyncData(point);
  }
}

final locationProvider = AsyncNotifierProvider<LocationController, GeoPoint?>(LocationController.new);
