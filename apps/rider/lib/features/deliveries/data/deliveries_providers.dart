import 'package:core_models/core_models.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../app/providers.dart';
import '../../../core/formatters.dart';
import '../../auth/data/rider_profile_provider.dart';

/// Every delivery that concerns this rider (assigned or offered), newest first.
final myDeliveriesProvider = StreamProvider<List<Delivery>>((ref) {
  final store = ref.watch(localStoreProvider);
  final isMe = ref.watch(riderIdMatcherProvider);
  return store.watchAll<Delivery>(
    Collections.deliveries,
    filter: (d) => d.deletedAt == null && (isMe(d.riderId) || d.offeredTo.any((o) => isMe(o.riderId))),
    sortBy: (a, b) => _ts(b).compareTo(_ts(a)),
  );
});

/// Offers still awaiting this rider's answer.
final offeredDeliveriesProvider = Provider<List<Delivery>>((ref) {
  final isMe = ref.watch(riderIdMatcherProvider);
  final all = ref.watch(myDeliveriesProvider).value ?? const [];
  return all
      .where((d) => d.status == DeliveryStatus.offered && d.offeredTo.any((o) => isMe(o.riderId) && o.isPending))
      .toList();
});

/// The delivery in progress (accepted or picked up), if any.
final activeDeliveryProvider = Provider<Delivery?>((ref) {
  final isMe = ref.watch(riderIdMatcherProvider);
  final all = ref.watch(myDeliveriesProvider).value ?? const [];
  for (final d in all) {
    if (isMe(d.riderId) && (d.status == DeliveryStatus.accepted || d.status == DeliveryStatus.pickedUp)) {
      return d;
    }
  }
  return null;
});

/// One delivery, live.
final deliveryByIdProvider = StreamProvider.family<Delivery?, String>(
  (ref, id) => ref.watch(localStoreProvider).watchById<Delivery>(Collections.deliveries, id),
);

/// Today's numbers for the dashboard. Earnings are not exposed to riders by
/// the API (the ledger is vendor-scoped), so the summary is count-based.
class TodaySummary {
  const TodaySummary({required this.delivered, required this.failed, required this.inProgress});

  final int delivered;
  final int failed;
  final int inProgress;
}

final todaySummaryProvider = Provider<TodaySummary>((ref) {
  final isMe = ref.watch(riderIdMatcherProvider);
  final all = ref.watch(myDeliveriesProvider).value ?? const [];
  final now = DateTime.now();
  var delivered = 0, failed = 0, inProgress = 0;
  for (final d in all) {
    if (!isMe(d.riderId)) continue;
    switch (d.status) {
      case DeliveryStatus.delivered:
        if (Fmt.isSameDay(_settledAt(d, 'delivered'), now)) delivered++;
      case DeliveryStatus.failed:
        if (Fmt.isSameDay(_settledAt(d, 'failed'), now)) failed++;
      case DeliveryStatus.accepted:
      case DeliveryStatus.pickedUp:
        inProgress++;
      case DeliveryStatus.unassigned:
      case DeliveryStatus.offered:
        break;
    }
  }
  return TodaySummary(delivered: delivered, failed: failed, inProgress: inProgress);
});

DateTime _ts(Delivery d) => d.updatedAt ?? d.createdAt ?? DateTime.fromMillisecondsSinceEpoch(0);

DateTime _settledAt(Delivery d, String status) {
  for (final t in d.timeline.reversed) {
    if (t.status == status) return t.at;
  }
  return _ts(d);
}
