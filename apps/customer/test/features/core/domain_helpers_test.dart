import 'package:core_models/core_models.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:instant_customer/core/geo.dart';
import 'package:instant_customer/core/widgets/list_phase.dart';
import 'package:instant_customer/features/catalog/domain/vendor_helpers.dart';
import 'package:instant_customer/features/orders/domain/order_rules.dart';
import 'package:instant_customer/features/search/domain/product_filter.dart';
import 'package:local_db/local_db.dart';

void main() {
  group('resolveListPhase', () {
    test('cached data always shows', () {
      expect(resolveListPhase(count: 3, status: const SyncStatus(phase: SyncPhase.offline)), ListPhase.ready);
    });
    test('empty before first sync is loading, offline/error when it cannot sync', () {
      expect(resolveListPhase(count: 0, status: null), ListPhase.loading);
      expect(resolveListPhase(count: 0, status: const SyncStatus()), ListPhase.loading);
      expect(resolveListPhase(count: 0, status: const SyncStatus(phase: SyncPhase.syncing)), ListPhase.loading);
      expect(resolveListPhase(count: 0, status: const SyncStatus(phase: SyncPhase.offline)), ListPhase.offline);
      expect(resolveListPhase(count: 0, status: const SyncStatus(phase: SyncPhase.error)), ListPhase.error);
    });
    test('empty after a completed sync is empty', () {
      expect(resolveListPhase(count: 0, status: SyncStatus(lastSyncedAt: DateTime.now())), ListPhase.empty);
    });
  });

  group('filterProducts', () {
    const products = [
      Product(id: '1', vendorId: 'v', name: 'Jollof Rice', slug: 'j', tags: ['spicy'], categoryIds: ['food']),
      Product(id: '2', vendorId: 'v', name: 'Fried Rice', slug: 'f', description: 'with chicken', categoryIds: ['food']),
      Product(id: '3', vendorId: 'v', name: 'Chocolate Cake', slug: 'c', categoryIds: ['dessert']),
    ];
    test('matches every term across name, description and tags', () {
      expect(filterProducts(products, query: 'rice').map((p) => p.id), ['2', '1']);
      expect(filterProducts(products, query: 'rice chicken').map((p) => p.id), ['2']);
      expect(filterProducts(products, query: 'SPICY').map((p) => p.id), ['1']);
      expect(filterProducts(products, query: 'pizza'), isEmpty);
    });
    test('filters by category and ranks name matches first', () {
      expect(filterProducts(products, categoryId: 'dessert').map((p) => p.id), ['3']);
      expect(filterProducts(products, query: 'chicken', categoryId: 'dessert'), isEmpty);
      expect(filterProducts(products, query: 'cake').first.id, '3');
    });
  });

  group('vendor helpers', () {
    test('haversine distance Lagos → Ibadan is ~128 km', () {
      expect(distanceKm(6.5244, 3.3792, 7.3775, 3.9470), closeTo(112, 5));
    });
    test('isOpenAt respects opening hours including past-midnight closes', () {
      const v = Vendor(id: 'v', name: 'v', slug: 'v', ownerUserId: 'o', openingHours: [
        OpeningHours(weekday: 1, open: '09:00', close: '18:00'),
        OpeningHours(weekday: 2, closed: true),
        OpeningHours(weekday: 5, open: '20:00', close: '02:00'),
      ]);
      expect(v.isOpenAt(DateTime(2026, 9, 28, 10)), isTrue); // Monday
      expect(v.isOpenAt(DateTime(2026, 9, 28, 19)), isFalse);
      expect(v.isOpenAt(DateTime(2026, 9, 29, 12)), isFalse); // Tuesday closed
      expect(v.isOpenAt(DateTime(2026, 10, 2, 23)), isTrue); // Friday late
      expect(v.isOpenAt(DateTime(2026, 10, 2, 1)), isTrue);
      expect(v.isOpenAt(DateTime(2026, 9, 30, 12)), isFalse); // Wednesday: no entry
    });
  });

  group('order rules', () {
    const order = Order(id: 'o', customerId: 'c', orderNumber: '1', paymentStatus: PaymentStatus.paid);
    SubOrder sub(SubOrderStatus s) => SubOrder(id: s.name, orderId: 'o', vendorId: 'v', customerId: 'c', status: s);

    test('customer may cancel while placed or awaiting payment', () {
      expect(orderCancellable(order, [sub(SubOrderStatus.placed), sub(SubOrderStatus.awaitingPayment)]), isTrue);
      expect(orderCancellable(order, [sub(SubOrderStatus.placed), sub(SubOrderStatus.accepted)]), isFalse);
      expect(orderCancellable(order.copyWith(paymentStatus: PaymentStatus.refunded), [sub(SubOrderStatus.placed)]), isFalse);
    });
    test('payable when pending or failed and not fully cancelled', () {
      expect(orderPayable(order.copyWith(paymentStatus: PaymentStatus.pending), []), isTrue);
      expect(orderPayable(order.copyWith(paymentStatus: PaymentStatus.failed), [sub(SubOrderStatus.awaitingPayment)]), isTrue);
      expect(orderPayable(order.copyWith(paymentStatus: PaymentStatus.failed), [sub(SubOrderStatus.cancelled)]), isFalse);
      expect(orderPayable(order, []), isFalse);
    });
    test('headline status is the least advanced active sub-order', () {
      expect(headlineStatus([sub(SubOrderStatus.delivered), sub(SubOrderStatus.preparing)]), SubOrderStatus.preparing);
      expect(headlineStatus([sub(SubOrderStatus.cancelled), sub(SubOrderStatus.ready)]), SubOrderStatus.ready);
      expect(headlineStatus([sub(SubOrderStatus.cancelled)]), SubOrderStatus.cancelled);
      expect(headlineStatus([]), isNull);
    });
  });
}
