import 'dart:convert';

import 'package:core_models/core_models.dart';
import 'package:test/test.dart';

void main() {
  group('JSON round trips', () {
    test('Product from backend JSON with _id and ISO dates', () {
      final json = jsonDecode('''
      {
        "_id": "64f0c0ffee0000000000001",
        "vendorId": "v1",
        "name": "Jollof Rice",
        "slug": "jollof-rice",
        "categoryIds": ["c1"],
        "images": [{"imageId": "img1", "sortOrder": 1}, {"imageId": "img0", "sortOrder": 0}],
        "basePriceKobo": 250000,
        "variants": [
          {"_id": "var1", "name": "Small", "sku": "JR-S", "priceKobo": 200000, "stock": 3, "attributes": {"size": "S"}},
          {"_id": "var2", "name": "Large", "priceKobo": 300000, "stock": 0}
        ],
        "hasVariants": true,
        "stock": 0,
        "status": "active",
        "tags": ["rice"],
        "rating": {"avg": 4.5, "count": 12},
        "createdAt": "2026-01-01T10:00:00.000Z",
        "updatedAt": "2026-01-02T10:00:00.000Z",
        "deletedAt": null,
        "version": 3
      }
      ''') as Map<String, dynamic>;

      final product = Product.fromJson(json);
      expect(product.id, '64f0c0ffee0000000000001');
      expect(product.variants.first.id, 'var1');
      expect(product.status, ProductStatus.active);
      expect(product.updatedAt, DateTime.utc(2026, 1, 2, 10));
      expect(product.primaryImage?.imageId, 'img0');
      expect(product.totalStock, 3);
      expect(product.minPriceKobo, 200000);
      expect(product.variantById('var2')?.name, 'Large');

      final out = product.toJson();
      expect(out['id'], '64f0c0ffee0000000000001');
      expect(out.containsKey('_id'), isFalse);
      expect(out['status'], 'active');
      expect(out['updatedAt'], '2026-01-02T10:00:00.000Z');
      expect(out.containsKey('deletedAt'), isFalse, reason: 'nulls omitted');
      expect(Product.fromJson(out), product);
    });

    test('id is preferred over _id when both exist', () {
      final c = Category.fromJson({'id': 'a', '_id': 'b', 'name': 'x', 'slug': 'x'});
      expect(c.id, 'a');
    });

    test('SubOrder, Order and Delivery round trip', () {
      final sub = SubOrder(
        id: 's1',
        orderId: 'o1',
        vendorId: 'v1',
        customerId: 'u1',
        items: const [
          CartItem(productId: 'p1', vendorId: 'v1', qty: 2, priceKoboSnapshot: 1000, nameSnapshot: 'A'),
        ],
        subtotalKobo: 2000,
        deliveryFeeKobo: 500,
        status: SubOrderStatus.placed,
        timeline: [TimelineEntry(status: 'placed', at: DateTime.utc(2026, 1, 1))],
        updatedAt: DateTime.utc(2026, 1, 1),
      );
      final subJson = jsonDecode(jsonEncode(sub.toJson())) as Map<String, dynamic>;
      expect(subJson['status'], 'placed');
      expect(SubOrder.fromJson(subJson), sub);
      expect(sub.totalKobo, 2500);
      expect(sub.canMoveTo(SubOrderStatus.accepted), isTrue);

      final order = Order(
        id: 'o1',
        customerId: 'u1',
        orderNumber: 'INS-0001',
        subOrderIds: const ['s1'],
        addressSnapshot: const AddressSnapshot(line1: '1 Road', city: 'Lagos', state: 'Lagos', lat: 6.5, lng: 3.3),
        totalKobo: 2500,
        paymentStatus: PaymentStatus.paid,
        placedAt: DateTime.utc(2026, 1, 1, 12),
      );
      final orderJson = jsonDecode(jsonEncode(order.toJson())) as Map<String, dynamic>;
      expect(orderJson['paymentStatus'], 'paid');
      expect(Order.fromJson(orderJson), order);

      final delivery = Delivery(
        id: 'd1',
        subOrderId: 's1',
        vendorId: 'v1',
        status: DeliveryStatus.offered,
        pickup: const PickupPoint(lat: 1, lng: 2),
        dropoff: const DropoffPoint(lat: 3, lng: 4),
        offeredTo: [DeliveryOffer(riderId: 'r1', at: DateTime.utc(2026, 1, 1))],
        proof: const DeliveryProof(otp: '1234'),
      );
      final dJson = jsonDecode(jsonEncode(delivery.toJson())) as Map<String, dynamic>;
      expect(dJson['status'], 'offered');
      expect(Delivery.fromJson(dJson), delivery);
      expect(delivery.pendingOfferFor('r1'), isNotNull);
    });

    test('User roles and AuthResponse', () {
      final res = AuthResponse.fromJson({
        'accessToken': 'a',
        'refreshToken': 'r',
        'user': {
          '_id': 'u1',
          'email': 'x@y.z',
          'fullName': 'X',
          'roles': ['vendor_owner', 'customer'],
          'vendorId': 'v1',
          'status': 'active',
        },
      });
      expect(res.tokens, const AuthTokens(accessToken: 'a', refreshToken: 'r'));
      expect(res.user!.roles, [UserRole.vendorOwner, UserRole.customer]);
      expect(res.user!.isVendor, isTrue);
      expect(AuthUser.fromUser(res.user!).vendorId, 'v1');
      expect(res.user!.toJson()['roles'], ['vendor_owner', 'customer']);
    });

    test('Cart helpers', () {
      const cart = Cart(userId: 'u1');
      final withItem = cart.addItem(const CartItem(
          productId: 'p1', vendorId: 'v1', qty: 1, priceKoboSnapshot: 500, nameSnapshot: 'A'));
      final twice = withItem.addItem(const CartItem(
          productId: 'p1', vendorId: 'v1', qty: 2, priceKoboSnapshot: 500, nameSnapshot: 'A'));
      expect(twice.items.single.qty, 3);
      expect(twice.subtotalKobo, 1500);
      expect(twice.setQty('p1', 0).isEmpty, isTrue);
      expect(Cart.fromJson(twice.toJson()), twice);
    });

    test('Sync DTOs', () {
      final pull = SyncPullResponse.fromJson({
        'changes': {
          'products': [
            {'_id': 'p1', 'vendorId': 'v1', 'name': 'A', 'slug': 'a'}
          ]
        },
        'tombstones': {
          'products': ['p2']
        },
        'serverTime': '2026-01-01T00:00:00.000Z',
      });
      expect(pull.changeCount, 1);
      expect(pull.tombstoneCount, 1);
      expect(pull.hasMore, isFalse);
      expect(ModelRegistry.decode(Collections.products, pull.changes['products']!.first), isA<Product>());

      final op = SyncOp(
        opId: '11111111-1111-4111-8111-111111111111',
        entity: Collections.addresses,
        action: SyncOpAction.upsert,
        payload: const {'id': 'a1', 'line1': 'x'},
        clientAt: DateTime.utc(2026, 1, 1),
      );
      final req = SyncPushRequest(ops: [op]);
      final json = jsonDecode(jsonEncode(req.toJson())) as Map<String, dynamic>;
      expect((json['ops'] as List).first['action'], 'upsert');
      expect(SyncPushRequest.fromJson(json), req);
      expect(op.docId, 'a1');

      final push = SyncPushResponse.fromJson({
        'results': [
          {'opId': op.opId, 'status': 'rejected', 'code': 'STALE'},
          {'opId': 'x', 'status': 'duplicate'},
        ]
      });
      expect(push.results.first.isRejected, isTrue);
      expect(push.results.last.isSettled, isTrue);
    });

    test('Paginated', () {
      final page = Paginated<Category>.fromJson(
        {
          'items': [
            {'id': 'c1', 'name': 'A', 'slug': 'a'}
          ],
          'nextCursor': 'abc',
        },
        (e) => Category.fromJson(e as Map<String, dynamic>),
      );
      expect(page.items.single.id, 'c1');
      expect(page.hasMore, isTrue);
      final bare = Paginated.parse([
        {'id': 'c2', 'name': 'B', 'slug': 'b'}
      ], Category.fromJson);
      expect(bare.items.single.id, 'c2');
      expect(bare.hasMore, isFalse);
    });

    test('Registry covers all synced collections', () {
      for (final c in [
        ...Collections.customerSync,
        ...Collections.vendorSync,
        ...Collections.riderSync,
      ]) {
        expect(ModelRegistry.forCollection(c), isNotNull, reason: c);
      }
      expect(ModelRegistry.collectionOf<Product>(), Collections.products);
    });

    test('DateTimeConverter accepts ints and strings', () {
      const conv = DateTimeConverter();
      expect(conv.fromJson(0), DateTime.utc(1970));
      expect(conv.fromJson('2026-01-01T00:00:00+01:00'), DateTime.utc(2025, 12, 31, 23));
      expect(const NullableDateTimeConverter().fromJson(null), isNull);
    });
  });
}
