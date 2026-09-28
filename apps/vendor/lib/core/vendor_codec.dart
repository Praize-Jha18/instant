import 'package:core_models/core_models.dart';

/// The backend stores opening hours as `{ day (0 = Sunday … 6), open, close }`
/// while `core_models.OpeningHours` expects `{ weekday (1 = Monday … 7), open,
/// close, closed }`. `Vendor.fromJson` throws on the backend shape, so every
/// vendor document is normalised through these helpers before decoding and
/// mapped back before `PATCH /vendor`.
///
/// Registered once at bootstrap via [registerVendorCodec] so the local store
/// and sync engine decode vendors correctly too.
abstract final class VendorJson {
  static Map<String, dynamic> normalize(Map<String, dynamic> json) {
    final out = Map<String, dynamic>.from(json);
    out['name'] ??= '';
    out['slug'] ??= '';
    out['ownerUserId'] ??= '';

    final hours = out['openingHours'];
    if (hours is List) {
      out['openingHours'] = [
        for (final h in hours)
          if (h is Map) normalizeHours(Map<String, dynamic>.from(h)),
      ];
    }

    final address = out['address'];
    if (address is Map) {
      final a = Map<String, dynamic>.from(address);
      a['line1'] ??= '';
      a['city'] ??= '';
      a['state'] ??= '';
      a['country'] ??= 'NG';
      a['lat'] = (a['lat'] as num?)?.toDouble() ?? 0.0;
      a['lng'] = (a['lng'] as num?)?.toDouble() ?? 0.0;
      out['address'] = a;
    }

    final payout = out['payout'];
    if (payout is Map) {
      final p = Map<String, dynamic>.from(payout);
      p['bankName'] ??= '';
      p['accountNumber'] ??= '';
      p['accountName'] ??= '';
      out['payout'] = p;
    }
    return out;
  }

  static Map<String, dynamic> normalizeHours(Map<String, dynamic> h) {
    if (h.containsKey('weekday')) return h;
    final day = (h['day'] as num?)?.toInt() ?? 1;
    return {
      'weekday': day == 0 ? 7 : day,
      'open': h['open'] ?? '09:00',
      'close': h['close'] ?? '18:00',
      'closed': h['closed'] ?? false,
    };
  }

  /// `OpeningHours` → backend shape. Closed days are omitted.
  static List<Map<String, Object?>> hoursToApi(List<OpeningHours> hours) => [
        for (final h in hours)
          if (!h.closed) {'day': h.weekday % 7, 'open': h.open, 'close': h.close},
      ];

  /// `VendorInput` → `PATCH /vendor` body using the backend's opening-hours
  /// shape. Null fields are omitted.
  static Map<String, Object?> patchBody(VendorInput input) {
    final body = Map<String, Object?>.from(input.toJson());
    final hours = input.openingHours;
    if (hours != null) body['openingHours'] = hoursToApi(hours);
    // Not accepted by the backend's UpdateVendorDto (whitelisted away).
    body.remove('logoImageId');
    body.remove('coverImageId');
    return body;
  }

  static Vendor decode(Object? body) {
    final map = body is Map<String, dynamic> ? body : Map<String, dynamic>.from(body as Map);
    final data = map['data'];
    final doc = map.length == 1 && data is Map ? Map<String, dynamic>.from(data) : map;
    return Vendor.fromJson(normalize(doc));
  }
}

bool _registered = false;

/// Replaces the default `vendors` codec so raw documents from sync, realtime
/// and the local store decode with [VendorJson.normalize].
void registerVendorCodec() {
  if (_registered) return;
  _registered = true;
  ModelRegistry.register<Vendor>(
    CollectionCodec<Vendor>(
      collection: Collections.vendors,
      fromJson: (json) => Vendor.fromJson(VendorJson.normalize(json)),
      toJson: (m) => m.toJson(),
      idOf: (m) => m.id,
      updatedAtOf: (m) => m.updatedAt,
    ),
  );
}
