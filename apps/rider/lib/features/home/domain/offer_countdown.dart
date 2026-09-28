import 'package:core_models/core_models.dart';

import '../../../app/config.dart';

/// Pure countdown maths for delivery offers.
abstract final class OfferCountdown {
  /// Time left before the offer lapses, clamped to `0 … window`.
  static Duration remaining({
    required DateTime offeredAt,
    required DateTime now,
    Duration window = AppConfig.offerWindow,
  }) {
    final left = window - now.difference(offeredAt);
    if (left.isNegative) return Duration.zero;
    if (left > window) return window;
    return left;
  }

  /// 1.0 when fresh, 0.0 when expired.
  static double progress({
    required DateTime offeredAt,
    required DateTime now,
    Duration window = AppConfig.offerWindow,
  }) {
    if (window.inMicroseconds <= 0) return 0;
    return remaining(offeredAt: offeredAt, now: now, window: window).inMicroseconds / window.inMicroseconds;
  }

  static bool isExpired({
    required DateTime offeredAt,
    required DateTime now,
    Duration window = AppConfig.offerWindow,
  }) =>
      remaining(offeredAt: offeredAt, now: now, window: window) == Duration.zero;

  /// When this rider's pending offer on [delivery] was made, or null.
  static DateTime? offeredAt(Delivery delivery, bool Function(String? riderId) isMe) {
    DateTime? latest;
    for (final o in delivery.offeredTo) {
      if (!isMe(o.riderId) || !o.isPending) continue;
      if (latest == null || o.at.isAfter(latest)) latest = o.at;
    }
    return latest;
  }
}
