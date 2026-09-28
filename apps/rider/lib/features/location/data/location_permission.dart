import 'package:geolocator/geolocator.dart';

/// Outcome of a permission check/request.
enum LocationAccess {
  /// Background ("always") access granted.
  always,

  /// Foreground-only access granted; tracking stops when the app is hidden.
  whileInUse,

  /// Denied; may ask again.
  denied,

  /// Denied permanently; only Settings can fix it.
  deniedForever,

  /// Location services are switched off on the device.
  serviceDisabled;

  bool get canTrack => this == always || this == whileInUse;
}

/// Thin wrapper over geolocator's permission API (mockable in tests).
class LocationPermissionGate {
  const LocationPermissionGate();

  Future<LocationAccess> check() async {
    if (!await Geolocator.isLocationServiceEnabled()) return LocationAccess.serviceDisabled;
    return _map(await Geolocator.checkPermission());
  }

  /// Requests foreground permission, then upgrades to background where the OS
  /// allows an in-app prompt (iOS; Android 10 shows the "all the time" option,
  /// Android 11+ requires the user to pick it in Settings).
  Future<LocationAccess> request() async {
    if (!await Geolocator.isLocationServiceEnabled()) return LocationAccess.serviceDisabled;
    var permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }
    if (permission == LocationPermission.whileInUse) {
      // Second prompt escalates to "always" where supported; harmless otherwise.
      final upgraded = await Geolocator.requestPermission();
      if (upgraded == LocationPermission.always) permission = upgraded;
    }
    return _map(permission);
  }

  Future<bool> openAppSettings() => Geolocator.openAppSettings();
  Future<bool> openLocationSettings() => Geolocator.openLocationSettings();

  static LocationAccess _map(LocationPermission p) => switch (p) {
        LocationPermission.always => LocationAccess.always,
        LocationPermission.whileInUse => LocationAccess.whileInUse,
        LocationPermission.denied => LocationAccess.denied,
        LocationPermission.deniedForever => LocationAccess.deniedForever,
        LocationPermission.unableToDetermine => LocationAccess.denied,
      };
}
