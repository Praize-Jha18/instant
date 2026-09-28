import 'package:core_models/core_models.dart';
import 'package:test/test.dart';

void main() {
  group('canTransition', () {
    test('happy path follows §6', () {
      const path = [
        SubOrderStatus.awaitingPayment,
        SubOrderStatus.placed,
        SubOrderStatus.accepted,
        SubOrderStatus.preparing,
        SubOrderStatus.ready,
        SubOrderStatus.outForDelivery,
        SubOrderStatus.delivered,
      ];
      for (var i = 0; i < path.length - 1; i++) {
        expect(canTransition(path[i], path[i + 1]), isTrue, reason: '${path[i]} → ${path[i + 1]}');
      }
    });

    test('cancellation only from awaiting_payment, placed, accepted, preparing', () {
      expect(canTransition(SubOrderStatus.awaitingPayment, SubOrderStatus.cancelled), isTrue);
      expect(canTransition(SubOrderStatus.placed, SubOrderStatus.cancelled), isTrue);
      expect(canTransition(SubOrderStatus.accepted, SubOrderStatus.cancelled), isTrue);
      expect(canTransition(SubOrderStatus.preparing, SubOrderStatus.cancelled), isTrue);
      expect(canTransition(SubOrderStatus.ready, SubOrderStatus.cancelled), isFalse);
      expect(canTransition(SubOrderStatus.outForDelivery, SubOrderStatus.cancelled), isFalse);
      expect(canTransition(SubOrderStatus.delivered, SubOrderStatus.cancelled), isFalse);
    });

    test('no skipping or going backwards', () {
      expect(canTransition(SubOrderStatus.placed, SubOrderStatus.preparing), isFalse);
      expect(canTransition(SubOrderStatus.placed, SubOrderStatus.delivered), isFalse);
      expect(canTransition(SubOrderStatus.ready, SubOrderStatus.preparing), isFalse);
      expect(canTransition(SubOrderStatus.delivered, SubOrderStatus.placed), isFalse);
      expect(canTransition(SubOrderStatus.cancelled, SubOrderStatus.placed), isFalse);
    });

    test('vendor cannot trigger delivery-driven statuses', () {
      expect(vendorNextSubOrderStatuses(SubOrderStatus.ready), isEmpty);
      expect(vendorNextSubOrderStatuses(SubOrderStatus.placed),
          {SubOrderStatus.accepted, SubOrderStatus.cancelled});
      expect(customerCanCancel(SubOrderStatus.placed), isTrue);
      expect(customerCanCancel(SubOrderStatus.accepted), isFalse);
    });

    test('delivery transitions', () {
      expect(canTransitionDelivery(DeliveryStatus.unassigned, DeliveryStatus.offered), isTrue);
      expect(canTransitionDelivery(DeliveryStatus.offered, DeliveryStatus.accepted), isTrue);
      expect(canTransitionDelivery(DeliveryStatus.accepted, DeliveryStatus.pickedUp), isTrue);
      expect(canTransitionDelivery(DeliveryStatus.pickedUp, DeliveryStatus.delivered), isTrue);
      expect(canTransitionDelivery(DeliveryStatus.delivered, DeliveryStatus.pickedUp), isFalse);
    });
  });
}
