import 'package:core_models/core_models.dart';

import '../../../core/geo.dart';

extension VendorX on Vendor {
  GeoPoint? get location {
    final a = address;
    return a == null ? null : GeoPoint(lat: a.lat, lng: a.lng);
  }

  /// Distance from [from] in km, or the server-provided [distanceKm].
  double? distanceFrom(GeoPoint? from) {
    final loc = location;
    if (from != null && loc != null) return from.kmTo(loc);
    return this.distanceKm;
  }

  OpeningHours? hoursFor(DateTime now) {
    for (final h in openingHours) {
      if (h.weekday == now.weekday) return h;
    }
    return null;
  }

  /// Open right now according to [openingHours]; true when no hours are set.
  bool isOpenAt(DateTime now) {
    if (openingHours.isEmpty) return true;
    final h = hoursFor(now);
    if (h == null || h.closed) return false;
    final open = _minutes(h.open);
    final close = _minutes(h.close);
    final cur = now.hour * 60 + now.minute;
    if (open == null || close == null) return true;
    if (close < open) return cur >= open || cur < close; // past midnight
    return cur >= open && cur < close;
  }

  /// Delivery-fee estimate for [subtotalKobo] at [distance] km, or null when
  /// the vendor has no fee configuration.
  int? estimateDeliveryKobo({required double distance, required int subtotalKobo}) =>
      deliveryFee?.estimateKobo(distanceKm: distance, subtotalKobo: subtotalKobo);
}

int? _minutes(String hhmm) {
  final parts = hhmm.split(':');
  if (parts.length != 2) return null;
  final h = int.tryParse(parts[0]);
  final m = int.tryParse(parts[1]);
  if (h == null || m == null) return null;
  return h * 60 + m;
}

/// Sorts vendors by distance from [from] (unknown distances last).
List<Vendor> sortVendorsByDistance(List<Vendor> vendors, GeoPoint? from) {
  final list = [...vendors];
  list.sort((a, b) {
    final da = a.distanceFrom(from);
    final db = b.distanceFrom(from);
    if (da == null && db == null) return a.name.compareTo(b.name);
    if (da == null) return 1;
    if (db == null) return -1;
    return da.compareTo(db);
  });
  return list;
}
