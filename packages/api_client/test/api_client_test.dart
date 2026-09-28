import 'dart:async';

import 'package:api_client/api_client.dart';
import 'package:core_models/core_models.dart';
import 'package:test/test.dart';

import 'fake_adapter.dart';

ApiClient _client(FakeAdapter adapter, TokenStore store, {FutureOr<void> Function()? onExpired}) {
  final client = ApiClient(
    baseUrl: 'http://localhost:3000/api/v1',
    tokenStore: store,
    onSessionExpired: onExpired,
  );
  client.dio.httpClientAdapter = adapter;
  return client;
}

void main() {
  group('error mapping', () {
    test('backend error shape → typed ApiException with code', () async {
      final adapter = FakeAdapter((r) => FakeReply.json(404, {
            'statusCode': 404,
            'code': 'PRODUCT_NOT_FOUND',
            'message': 'No such product',
            'details': {'id': 'x'},
          }));
      final client = _client(adapter, MemoryTokenStore());
      try {
        await client.catalog.product('x');
        fail('should throw');
      } on ApiException catch (e) {
        expect(e, isA<NotFoundException>());
        expect(e.code, 'PRODUCT_NOT_FOUND');
        expect(e.message, 'No such product');
        expect(e.statusCode, 404);
        expect(e.details, {'id': 'x'});
        expect(e.isOffline, isFalse);
      }
    });

    test('NestJS validation array and 5xx', () async {
      final adapter = FakeAdapter((r) => r.path.contains('orders')
          ? FakeReply.json(400, {'statusCode': 400, 'message': ['email must be an email', 'x'], 'error': 'Bad Request'})
          : FakeReply(503, 'down'));
      final client = _client(adapter, MemoryTokenStore(accessToken: 'a', refreshToken: 'r'));
      await expectLater(
        client.customer.createOrder(const CreateOrderRequest(addressId: 'a')),
        throwsA(isA<ValidationException>()
            .having((e) => e.code, 'code', 'BAD_REQUEST')
            .having((e) => e.message, 'message', contains('email must be an email'))
            .having((e) => e.details, 'details', isA<List<Object?>>())),
      );
      await expectLater(
        client.vendor.profile(),
        throwsA(isA<ServerException>().having((e) => e.statusCode, 'status', 503)),
      );
    });

    test('network failure → ApiException.offline', () async {
      final adapter = FakeAdapter((r) => FakeReply.offline());
      final client = _client(adapter, MemoryTokenStore());
      await expectLater(
        client.catalog.categories(),
        throwsA(isA<OfflineException>().having((e) => e.isOffline, 'isOffline', isTrue)),
      );
    });

    test('isOffline is false for a plain 409', () async {
      final adapter = FakeAdapter((r) => FakeReply.json(409, {'statusCode': 409, 'code': 'OUT_OF_STOCK', 'message': 'x'}));
      final client = _client(adapter, MemoryTokenStore(accessToken: 'a', refreshToken: 'r'));
      await expectLater(
        client.vendor.updateOrderStatus('s1', SubOrderStatus.accepted),
        throwsA(isA<ConflictException>().having((e) => e.code, 'code', 'OUT_OF_STOCK')),
      );
    });
  });

  group('auth interceptor', () {
    test('attaches Bearer and skips it for public/no-auth calls', () async {
      final adapter = FakeAdapter((r) => FakeReply.json(200, {'items': []}));
      final client = _client(adapter, MemoryTokenStore(accessToken: 'tok', refreshToken: 'ref'));
      await client.vendor.orders();
      expect(adapter.requests.last.authorization, 'Bearer tok');
      await client.catalog.products();
      expect(adapter.requests.last.authorization, isNull);
    });

    test('401 → single refresh → retry once with new token', () async {
      var refreshes = 0;
      final adapter = FakeAdapter((r) {
        if (r.path.endsWith('/auth/refresh')) {
          refreshes++;
          expect(r.json['refreshToken'], 'ref1');
          return FakeReply.json(200, {'accessToken': 'new', 'refreshToken': 'ref2'});
        }
        if (r.authorization == 'Bearer new') {
          return FakeReply.json(200, {'id': 'u1', 'email': 'a@b.c', 'fullName': 'A'});
        }
        return FakeReply.json(401, {'statusCode': 401, 'code': 'TOKEN_EXPIRED', 'message': 'expired'});
      });
      final store = MemoryTokenStore(accessToken: 'old', refreshToken: 'ref1');
      final client = _client(adapter, store);

      final user = await client.auth.me();
      expect(user.id, 'u1');
      expect(refreshes, 1);
      expect(await store.getAccessToken(), 'new');
      expect(await store.getRefreshToken(), 'ref2');
      expect(adapter.requests.map((r) => r.path).toList(),
          ['/auth/me', '/auth/refresh', '/auth/me']);
    });

    test('concurrent 401s share one refresh (single-flight)', () async {
      var refreshes = 0;
      final refreshGate = Completer<void>();
      final adapter = FakeAdapter((r) async {
        if (r.path.endsWith('/auth/refresh')) {
          refreshes++;
          await refreshGate.future;
          return FakeReply.json(200, {'accessToken': 'new', 'refreshToken': 'ref2'});
        }
        if (r.authorization == 'Bearer new') return FakeReply.json(200, {'items': []});
        return FakeReply.json(401, {'statusCode': 401, 'code': 'UNAUTHORIZED', 'message': 'x'});
      });
      final client = _client(adapter, MemoryTokenStore(accessToken: 'old', refreshToken: 'ref1'));

      final futures = [
        client.vendor.orders(),
        client.vendor.products(),
        client.vendor.riders(),
      ];
      await Future<void>.delayed(const Duration(milliseconds: 50));
      refreshGate.complete();
      await Future.wait(futures);

      expect(refreshes, 1);
      expect(client.authInterceptor.refreshCount, 1);
      final retried = adapter.requests.where((r) => r.authorization == 'Bearer new');
      expect(retried.length, 3);
      // Each original request is retried exactly once.
      expect(adapter.requests.where((r) => r.path == '/vendor/orders').length, 2);
    });

    test('refresh rejected → tokens cleared, onSessionExpired, 401 surfaces', () async {
      var expired = 0;
      final adapter = FakeAdapter((r) {
        if (r.path.endsWith('/auth/refresh')) {
          return FakeReply.json(401, {'statusCode': 401, 'code': 'REFRESH_REVOKED', 'message': 'revoked'});
        }
        return FakeReply.json(401, {'statusCode': 401, 'code': 'UNAUTHORIZED', 'message': 'x'});
      });
      final store = MemoryTokenStore(accessToken: 'old', refreshToken: 'ref1');
      final client = _client(adapter, store, onExpired: () => expired++);

      await expectLater(
        client.auth.me(),
        throwsA(isA<UnauthorizedException>().having((e) => e.code, 'code', 'UNAUTHORIZED')),
      );
      expect(expired, 1);
      expect(await store.getAccessToken(), isNull);
      expect(await store.getRefreshToken(), isNull);
      // No infinite loop: me, refresh, and nothing else.
      expect(adapter.requests.map((r) => r.path).toList(), ['/auth/me', '/auth/refresh']);
    });

    test('refresh transport error does not end the session', () async {
      var expired = 0;
      final adapter = FakeAdapter((r) {
        if (r.path.endsWith('/auth/refresh')) return FakeReply.offline();
        return FakeReply.json(401, {'statusCode': 401, 'code': 'UNAUTHORIZED', 'message': 'x'});
      });
      final store = MemoryTokenStore(accessToken: 'old', refreshToken: 'ref1');
      final client = _client(adapter, store, onExpired: () => expired++);
      await expectLater(client.auth.me(), throwsA(isA<UnauthorizedException>()));
      expect(expired, 0);
      expect(await store.getRefreshToken(), 'ref1');
    });

    test('no refresh token → session expired without a refresh call', () async {
      var expired = 0;
      final adapter = FakeAdapter(
          (r) => FakeReply.json(401, {'statusCode': 401, 'code': 'UNAUTHORIZED', 'message': 'x'}));
      final client = _client(adapter, MemoryTokenStore(), onExpired: () => expired++);
      await expectLater(client.auth.me(), throwsA(isA<UnauthorizedException>()));
      expect(expired, 1);
      expect(adapter.requests.length, 1);
    });

    test('login persists tokens; logout clears them', () async {
      final adapter = FakeAdapter((r) => r.path.endsWith('/auth/login')
          ? FakeReply.json(200, {
              'accessToken': 'a1',
              'refreshToken': 'r1',
              'user': {'_id': 'u1', 'email': 'x@y.z', 'fullName': 'X', 'roles': ['customer']},
            })
          : FakeReply(204));
      final store = MemoryTokenStore();
      final client = _client(adapter, store);
      final res = await client.auth.login(const LoginRequest(email: 'x@y.z', password: 'pw'));
      expect(res.user?.roles, [UserRole.customer]);
      expect(await store.getAccessToken(), 'a1');
      expect(adapter.requests.last.authorization, isNull, reason: 'login is unauthenticated');
      await client.auth.logout();
      expect(adapter.requests.last.json['refreshToken'], 'r1');
      expect(await store.getRefreshToken(), isNull);
    });
  });

  group('surfaces', () {
    test('imageUrl and query building', () async {
      final adapter = FakeAdapter((r) => r.path == '/sync/pull'
          ? FakeReply.json(200, {'changes': {}, 'tombstones': {}, 'serverTime': '2026-01-01T00:00:00.000Z'})
          : FakeReply.json(200, {'items': [], 'nextCursor': null}));
      final client = _client(adapter, MemoryTokenStore());
      expect(client.catalog.imageUrl('img1'), 'http://localhost:3000/api/v1/images/img1');
      expect(client.catalog.imageUrl('img1', thumb: true), 'http://localhost:3000/api/v1/images/img1?size=thumb');

      await client.catalog.vendors(lat: 6.5, lng: 3.3, q: '');
      final uri = adapter.requests.last.options.uri;
      expect(uri.queryParameters['near'], '6.5,3.3');
      expect(uri.queryParameters.containsKey('q'), isFalse, reason: 'empty strings dropped');

      await client.sync.pull(collections: ['products', 'orders'], since: DateTime.utc(2026));
      final pull = adapter.requests.last.options.uri;
      expect(pull.queryParameters['collections'], 'products,orders');
      expect(pull.queryParameters['since'], '2026-01-01T00:00:00.000Z');

      await client.vendor.orders(status: SubOrderStatus.outForDelivery);
      expect(adapter.requests.last.options.uri.queryParameters['status'], 'out_for_delivery');
    });

    test('paginated and bare-list bodies both decode', () async {
      final adapter = FakeAdapter((r) => r.path == '/categories'
          ? FakeReply.json(200, [
              {'_id': 'c1', 'name': 'A', 'slug': 'a'}
            ])
          : FakeReply.json(200, {
              'items': [
                {'_id': 'p1', 'vendorId': 'v', 'name': 'P', 'slug': 'p'}
              ],
              'nextCursor': 'n1',
            }));
      final client = _client(adapter, MemoryTokenStore());
      final cats = await client.catalog.categories();
      expect(cats.single.id, 'c1');
      final page = await client.catalog.products(vendorId: 'v');
      expect(page.items.single.id, 'p1');
      expect(page.nextCursor, 'n1');
    });

    test('sync push serialises ops and decodes results', () async {
      final adapter = FakeAdapter((r) {
        final ops = r.json['ops'] as List;
        return FakeReply.json(200, {
          'results': [
            {'opId': (ops.first as Map)['opId'], 'status': 'applied', 'doc': {'id': 'a1'}},
          ]
        });
      });
      final client = _client(adapter, MemoryTokenStore(accessToken: 't', refreshToken: 'r'));
      final res = await client.sync.push([
        SyncOp(
          opId: 'op-1',
          entity: Collections.addresses,
          action: SyncOpAction.upsert,
          payload: const {'id': 'a1'},
          clientAt: DateTime.utc(2026),
        ),
      ]);
      expect(res.results.single.status, SyncOpStatus.applied);
      expect(res.results.single.doc, {'id': 'a1'});
      expect(adapter.requests.single.json['ops'], hasLength(1));
      expect(((adapter.requests.single.json['ops'] as List).first as Map)['clientAt'], '2026-01-01T00:00:00.000Z');
    });

    test('multipart upload sends a file field', () async {
      final adapter = FakeAdapter((r) => FakeReply.json(200, {'_id': 'p1', 'vendorId': 'v', 'name': 'P', 'slug': 'p'}));
      final client = _client(adapter, MemoryTokenStore(accessToken: 't', refreshToken: 'r'));
      final product = await client.vendor.uploadProductImage('p1', bytes: [1, 2, 3], filename: 'a.jpg');
      expect(product.id, 'p1');
      final req = adapter.requests.single;
      expect(req.options.contentType, startsWith('multipart/form-data'));
      expect(req.body, contains('filename="a.jpg"'));
      expect(req.body, contains('name="file"'));
    });
  });

  group('realtime events', () {
    test('parse server payloads', () {
      final changed = ChangedEvent.fromJson({
        'collection': 'products',
        'id': 'p1',
        'doc': {'_id': 'p1', 'vendorId': 'v', 'name': 'P', 'slug': 'p'},
      });
      expect(changed.model, isA<Product>());
      expect(RemovedEvent.fromJson({'collection': 'products', 'id': 'p1'}).id, 'p1');
      final loc = RiderLocationEvent.fromJson({
        'deliveryId': 'd1',
        'lat': 6.5,
        'lng': 3,
        'heading': 90,
        'at': '2026-01-01T00:00:00.000Z',
      });
      expect(loc.lng, 3.0);
      expect(loc.at, DateTime.utc(2026));
      expect(RealtimeRooms.delivery('d1'), 'delivery:d1');
    });

    test('client state machine without a server', () async {
      final rt = RealtimeClient(wsUrl: 'http://127.0.0.1:1', tokenProvider: () async => 't');
      expect(rt.currentState, RealtimeConnectionState.disconnected);
      rt.subscribe('vendor:v1');
      expect(rt.rooms, {'vendor:v1'});
      expect(rt.sendRiderLocation(RiderLocationUpdate(lat: 1, lng: 2, at: DateTime.now())), isFalse);
      await rt.dispose();
    });
  });
}
