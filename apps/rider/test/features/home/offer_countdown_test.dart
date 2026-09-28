import 'package:core_models/core_models.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:instant_rider/app/config.dart';
import 'package:instant_rider/features/home/domain/offer_countdown.dart';

void main() {
  final offeredAt = DateTime.utc(2026, 9, 28, 10, 0, 0);
  const window = Duration(seconds: 60);

  group('OfferCountdown.remaining', () {
    test('is the full window at the moment of the offer', () {
      expect(OfferCountdown.remaining(offeredAt: offeredAt, now: offeredAt, window: window), window);
    });

    test('counts down linearly', () {
      final now = offeredAt.add(const Duration(seconds: 25));
      expect(OfferCountdown.remaining(offeredAt: offeredAt, now: now, window: window), const Duration(seconds: 35));
    });

    test('clamps to zero once the window has passed', () {
      final now = offeredAt.add(const Duration(minutes: 5));
      expect(OfferCountdown.remaining(offeredAt: offeredAt, now: now, window: window), Duration.zero);
      expect(OfferCountdown.isExpired(offeredAt: offeredAt, now: now, window: window), isTrue);
    });

    test('clamps to the window when the clock is skewed (offer in the future)', () {
      final now = offeredAt.subtract(const Duration(seconds: 10));
      expect(OfferCountdown.remaining(offeredAt: offeredAt, now: now, window: window), window);
    });

    test('uses the app default window when none is given', () {
      expect(OfferCountdown.remaining(offeredAt: offeredAt, now: offeredAt), AppConfig.offerWindow);
    });
  });

  group('OfferCountdown.progress', () {
    test('goes from 1.0 to 0.0', () {
      expect(OfferCountdown.progress(offeredAt: offeredAt, now: offeredAt, window: window), 1.0);
      expect(
        OfferCountdown.progress(offeredAt: offeredAt, now: offeredAt.add(const Duration(seconds: 30)), window: window),
        closeTo(0.5, 1e-9),
      );
      expect(OfferCountdown.progress(offeredAt: offeredAt, now: offeredAt.add(window), window: window), 0.0);
    });

    test('is 0 for a degenerate window', () {
      expect(OfferCountdown.progress(offeredAt: offeredAt, now: offeredAt, window: Duration.zero), 0);
    });
  });

  group('OfferCountdown.offeredAt', () {
    bool isMe(String? id) => id == 'me' || id == 'me-user';

    test('picks the latest pending offer addressed to this rider', () {
      final d = Delivery(
        id: 'd1',
        subOrderId: 's1',
        vendorId: 'v1',
        status: DeliveryStatus.offered,
        offeredTo: [
          DeliveryOffer(riderId: 'someone-else', at: offeredAt.add(const Duration(minutes: 1))),
          DeliveryOffer(riderId: 'me', at: offeredAt.subtract(const Duration(minutes: 1)), response: 'declined'),
          DeliveryOffer(riderId: 'me', at: offeredAt),
          DeliveryOffer(riderId: 'me-user', at: offeredAt.add(const Duration(seconds: 5))),
        ],
      );
      expect(OfferCountdown.offeredAt(d, isMe), offeredAt.add(const Duration(seconds: 5)));
    });

    test('is null when there is no pending offer for this rider', () {
      final d = Delivery(
        id: 'd1',
        subOrderId: 's1',
        vendorId: 'v1',
        offeredTo: [DeliveryOffer(riderId: 'me', at: offeredAt, response: 'accepted')],
      );
      expect(OfferCountdown.offeredAt(d, isMe), isNull);
    });
  });
}
