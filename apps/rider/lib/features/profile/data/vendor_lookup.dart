import 'package:core_models/core_models.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../app/providers.dart';

/// Resolves the rider's vendor.
///
/// The contract has no `GET /vendors/:id` and `vendors` is not in
/// `Collections.riderSync`, so we look in the local cache first (seeded when
/// the rider picked a vendor at registration), then in delivery pickup
/// snapshots, and finally page through the public vendor list.
final vendorByIdProvider = FutureProvider.family<Vendor?, String?>((ref, vendorId) async {
  if (vendorId == null || vendorId.isEmpty) return null;
  final store = ref.watch(localStoreProvider);
  final cached = await store.getById<Vendor>(Collections.vendors, vendorId);
  if (cached != null) return cached;

  final api = ref.watch(apiClientProvider);
  String? cursor;
  for (var page = 0; page < 5; page++) {
    final res = await api.catalog.vendors(cursor: cursor, limit: 100);
    for (final v in res.items) {
      if (v.id == vendorId) {
        await store.upsert(Collections.vendors, v);
        return v;
      }
    }
    if (!res.hasMore) break;
    cursor = res.nextCursor;
  }
  return null;
});

/// Display name for the vendor (falls back to a delivery's pickup snapshot).
final vendorNameProvider = FutureProvider.family<String?, String?>((ref, vendorId) async {
  if (vendorId == null) return null;
  final store = ref.watch(localStoreProvider);
  try {
    final vendor = await ref.watch(vendorByIdProvider(vendorId).future);
    if (vendor != null) return vendor.name;
  } catch (_) {
    // offline: fall through to snapshots
  }
  final deliveries = await store.query<Delivery>(
    Collections.deliveries,
    (d) => d.vendorId == vendorId && (d.pickup?.vendorName?.isNotEmpty ?? false),
  );
  return deliveries.isEmpty ? null : deliveries.first.pickup!.vendorName;
});
