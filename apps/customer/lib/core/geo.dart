import 'dart:math' as math;

import 'package:core_models/core_models.dart';

/// Great-circle distance in kilometres (haversine).
double distanceKm(double lat1, double lng1, double lat2, double lng2) {
  const r = 6371.0;
  final dLat = _rad(lat2 - lat1);
  final dLng = _rad(lng2 - lng1);
  final a = math.sin(dLat / 2) * math.sin(dLat / 2) +
      math.cos(_rad(lat1)) * math.cos(_rad(lat2)) * math.sin(dLng / 2) * math.sin(dLng / 2);
  return 2 * r * math.atan2(math.sqrt(a), math.sqrt(1 - a));
}

double _rad(double deg) => deg * math.pi / 180;

extension GeoPointDistance on GeoPoint {
  double kmTo(GeoPoint other) => distanceKm(lat, lng, other.lat, other.lng);
}

/// Lagos, used when the user has no location and no address yet.
const GeoPoint kDefaultMapCenter = GeoPoint(lat: 6.5244, lng: 3.3792);

String formatDistance(double km) => km < 1 ? '${(km * 1000).round()} m' : '${km.toStringAsFixed(1)} km';
