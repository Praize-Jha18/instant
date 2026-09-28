import 'package:api_client/api_client.dart';
import 'package:core_models/core_models.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:local_db/local_db.dart';

import '../../../app/providers.dart';
import 'rider_locations.dart';

/// Rider management. `GET /vendor/riders` returns the profile plus a nested
/// `user { fullName, phone }` and `lastLocation`; the model only knows flat
/// `fullName`/`phone`, so the raw response is flattened before storing and the
/// positions are pushed into [RiderLocations].
class RidersRepository {
  RidersRepository(this._ref, this._api, this._store);

  final Ref _ref;
  final ApiClient _api;
  final LocalStore _store;

  Future<List<RiderProfile>> refresh() async {
    final body = await _api.get('/vendor/riders');
    final raw = body is Map ? body['items'] : body;
    if (raw is! List) return const [];
    final docs = <Map<String, dynamic>>[];
    final positions = <RiderPosition>[];
    for (final e in raw) {
      if (e is! Map) continue;
      final doc = Map<String, dynamic>.from(e);
      final user = doc['user'];
      if (user is Map) {
        doc['fullName'] ??= user['fullName'];
        doc['phone'] ??= user['phone'];
      }
      final id = readId(doc, 'id')?.toString();
      final loc = doc['lastLocation'];
      if (id != null && loc is Map && loc['lat'] != null && loc['lng'] != null) {
        positions.add(RiderPosition(
          riderId: id,
          lat: (loc['lat'] as num).toDouble(),
          lng: (loc['lng'] as num).toDouble(),
          heading: (loc['heading'] as num?)?.toDouble(),
          at: loc['at'] == null ? DateTime.now().toUtc() : const DateTimeConverter().fromJson(loc['at'] as Object),
        ));
      }
      doc.remove('user');
      doc.remove('lastLocation');
      docs.add(doc);
    }
    await _store.upsertAllJson(Collections.riderProfiles, docs);
    _ref.read(riderLocationsProvider.notifier).seedAll(positions);
    return docs.map(RiderProfile.fromJson).toList();
  }

  Future<RiderProfile> approve(String riderProfileId) async {
    final r = await _api.vendor.approveRider(riderProfileId);
    await _mergeStore(r);
    return r;
  }

  Future<RiderProfile> suspend(String riderProfileId) async {
    final r = await _api.vendor.suspendRider(riderProfileId);
    await _mergeStore(r);
    return r;
  }

  /// Keeps the flattened name/phone the list call gave us.
  Future<void> _mergeStore(RiderProfile r) async {
    final existing = await _store.getById<RiderProfile>(Collections.riderProfiles, r.id);
    await _store.upsert(
      Collections.riderProfiles,
      r.copyWith(fullName: r.fullName ?? existing?.fullName, phone: r.phone ?? existing?.phone),
    );
  }
}

final ridersRepositoryProvider = Provider<RidersRepository>(
  (ref) => RidersRepository(ref, ref.watch(apiClientProvider), ref.watch(localStoreProvider)),
);
