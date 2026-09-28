import 'package:core_models/core_models.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:instant_customer/features/addresses/data/address_providers.dart';
import 'package:instant_customer/features/cart/domain/cart_totals.dart';
import 'package:instant_customer/features/cart/presentation/cart_providers.dart';
import 'package:instant_customer/features/cart/presentation/cart_screen.dart';
import 'package:design_system/design_system.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../helpers/test_app.dart';

const _lagos = GeoPoint(lat: 6.5244, lng: 3.3792);

Vendor _vendor(String id, {required double lat, required double lng, DeliveryFeeConfig? fee}) => Vendor(
      id: id,
      name: 'Vendor $id',
      slug: id,
      ownerUserId: 'o',
      status: VendorStatus.active,
      address: VendorAddress(line1: 'x', city: 'Lagos', state: 'Lagos', lat: lat, lng: lng),
      deliveryFee: fee,
    );

void main() {
  group('computeCartTotals', () {
    test('groups by vendor and estimates delivery from the dropoff distance', () {
      // Vendor A ~1.1 km north of the dropoff; base 500 + 100/km.
      final a = _vendor('a', lat: 6.5344, lng: 3.3792, fee: const DeliveryFeeConfig(baseKobo: 50000, perKmKobo: 10000));
      // Vendor B at the dropoff, free above 5000.
      final b = _vendor('b', lat: 6.5244, lng: 3.3792, fee: const DeliveryFeeConfig(baseKobo: 30000, perKmKobo: 5000, freeAboveKobo: 500000));
      const cart = Cart(userId: 'u1', items: [
        CartItem(productId: 'p1', vendorId: 'a', qty: 2, priceKoboSnapshot: 150000, nameSnapshot: 'Jollof'),
        CartItem(productId: 'p2', vendorId: 'a', qty: 1, priceKoboSnapshot: 50000, nameSnapshot: 'Plantain'),
        CartItem(productId: 'p3', vendorId: 'b', qty: 1, priceKoboSnapshot: 600000, nameSnapshot: 'Cake'),
      ]);

      final totals = computeCartTotals(cart: cart, vendors: {'a': a, 'b': b}, dropoff: _lagos);

      expect(totals.groups, hasLength(2));
      final ga = totals.groups.firstWhere((g) => g.vendorId == 'a');
      final gb = totals.groups.firstWhere((g) => g.vendorId == 'b');
      expect(ga.subtotalKobo, 350000);
      expect(ga.distanceKm, closeTo(1.11, 0.02));
      expect(ga.deliveryFeeKobo, 50000 + (10000 * ga.distanceKm!).round());
      expect(gb.subtotalKobo, 600000);
      expect(gb.deliveryFeeKobo, 0, reason: 'free above threshold');
      expect(totals.subtotalKobo, 950000);
      expect(totals.deliveryTotalKobo, ga.deliveryFeeKobo);
      expect(totals.totalKobo, 950000 + ga.deliveryFeeKobo!);
      expect(totals.hasUnknownDelivery, isFalse);
      expect(totals.hasDropoff, isTrue);
      expect(totals.itemCount, 4);
    });

    test('unknown vendor yields an unknown delivery fee, not a crash', () {
      const cart = Cart(userId: 'u1', items: [
        CartItem(productId: 'p1', vendorId: 'ghost', qty: 1, priceKoboSnapshot: 1000, nameSnapshot: 'x'),
      ]);
      final totals = computeCartTotals(cart: cart, vendors: const {}, dropoff: _lagos);
      expect(totals.groups.single.deliveryFeeKobo, isNull);
      expect(totals.hasUnknownDelivery, isTrue);
      expect(totals.totalKobo, 1000);
    });

    test('without a dropoff the estimate assumes 0 km', () {
      final a = _vendor('a', lat: 7, lng: 4, fee: const DeliveryFeeConfig(baseKobo: 20000, perKmKobo: 99999));
      const cart = Cart(userId: 'u1', items: [
        CartItem(productId: 'p1', vendorId: 'a', qty: 1, priceKoboSnapshot: 1000, nameSnapshot: 'x'),
      ]);
      final totals = computeCartTotals(cart: cart, vendors: {'a': a});
      expect(totals.hasDropoff, isFalse);
      expect(totals.groups.single.distanceKm, isNull);
      expect(totals.groups.single.deliveryFeeKobo, 20000);
    });

    test('empty cart is empty totals', () {
      expect(computeCartTotals(cart: const Cart(userId: 'u1'), vendors: const {}).isEmpty, isTrue);
    });
  });

  group('CartScreen', () {
    late TestHarness h;
    setUp(() async => h = await TestHarness.create());
    tearDown(() => h.dispose());

    testWidgets('renders per-vendor subtotals, delivery estimate and total from the store', (tester) async {
      tester.view.physicalSize = const Size(1080, 2400);
      tester.view.devicePixelRatio = 2;
      addTearDown(tester.view.reset);

      final a = _vendor('a', lat: 6.5244, lng: 3.3792, fee: const DeliveryFeeConfig(baseKobo: 50000));
      await h.store.upsert(Collections.vendors, a);
      await h.store.upsert(
        Collections.addresses,
        const Address(id: 'ad1', userId: 'u1', label: 'Home', line1: '1 Marina', city: 'Lagos', state: 'Lagos', lat: 6.5244, lng: 3.3792, isDefault: true),
      );
      await h.store.upsert(
        Collections.carts,
        const Cart(userId: 'u1', items: [
          CartItem(productId: 'p1', vendorId: 'a', qty: 2, priceKoboSnapshot: 150000, nameSnapshot: 'Jollof rice'),
        ]),
      );

      await pumpApp(tester, const CartScreen(), overrides: h.signedInOverrides());
      await tester.pump(const Duration(seconds: 1));

      expect(find.text('Vendor a'), findsOneWidget);
      expect(find.text('Jollof rice'), findsOneWidget);
      expect(find.text('₦3,000.00'), findsWidgets); // line total + subtotal
      expect(find.text('Delivery ₦500.00'), findsOneWidget);
      expect(find.text('₦3,500.00'), findsOneWidget); // grand total
      final checkout = tester.widget<AppButton>(find.byKey(const ValueKey('checkout-button')));
      expect(checkout.onPressed, isNotNull, reason: 'online with an address selected');

      // Changing quantity goes through the outbox and re-renders totals.
      final container = ProviderScope.containerOf(tester.element(find.byType(CartScreen)));
      await container.read(cartActionsProvider).setQty('p1', 3);
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 300));
      expect(find.text('₦5,000.00'), findsOneWidget);
      expect(container.read(cartTotalsProvider).totalKobo, 500000);
      expect(await h.store.pendingCount(), 1);
      expect(container.read(selectedAddressProvider)?.id, 'ad1');
    });

    testWidgets('shows the empty state when the cart is empty', (tester) async {
      await pumpApp(tester, const CartScreen(), overrides: h.signedInOverrides());
      await tester.pump(const Duration(milliseconds: 500));
      expect(find.text('Your cart is empty'), findsOneWidget);
    });
  });
}
