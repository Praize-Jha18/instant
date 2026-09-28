import 'package:api_client/api_client.dart';
import 'package:core_models/core_models.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:instant_customer/features/auth/domain/session_state.dart';
import 'package:instant_customer/features/auth/presentation/session_controller.dart';

import '../../helpers/fakes.dart';
import '../../helpers/test_app.dart';

void main() {
  late TestHarness h;
  setUp(() async => h = await TestHarness.create());
  tearDown(() => h.dispose());

  test('restore without tokens signs out', () async {
    h.auth.session = false;
    final c = h.container();
    await c.read(sessionControllerProvider.notifier).restore();
    expect(c.read(sessionControllerProvider), isA<SignedOut>());
    expect(h.lifecycle.starts, 0);
  });

  test('restore validates with /auth/me and starts the session', () async {
    h.auth.session = true;
    final c = h.container();
    await c.read(sessionControllerProvider.notifier).restore();
    final s = c.read(sessionControllerProvider);
    expect(s, isA<SignedIn>());
    expect((s as SignedIn).offline, isFalse);
    expect(h.lifecycle.lastUserId, 'u1');
    expect(await h.store.getAll<User>(Collections.users), hasLength(1));
  });

  test('restore offline falls back to the cached user', () async {
    h.auth
      ..session = true
      ..meError = const OfflineException();
    await h.store.upsert(Collections.users, testUser);
    final c = h.container();
    await c.read(sessionControllerProvider.notifier).restore();
    final s = c.read(sessionControllerProvider);
    expect(s, isA<SignedIn>());
    expect((s as SignedIn).offline, isTrue);
    expect(s.user.id, 'u1');
    expect(h.lifecycle.starts, 1);
  });

  test('restore offline with no cache signs out with a message', () async {
    h.auth
      ..session = true
      ..meError = const OfflineException();
    final c = h.container();
    await c.read(sessionControllerProvider.notifier).restore();
    final s = c.read(sessionControllerProvider);
    expect(s, isA<SignedOut>());
    expect((s as SignedOut).message, kOfflineSignInMessage);
  });

  test('restore with a revoked session clears everything', () async {
    h.auth
      ..session = true
      ..meError = const UnauthorizedException(code: 'UNAUTHORIZED', message: 'nope');
    await h.store.upsert(Collections.products, const Product(id: 'p', vendorId: 'v', name: 'x', slug: 'x'));
    final c = h.container();
    await c.read(sessionControllerProvider.notifier).restore();
    expect(c.read(sessionControllerProvider), isA<SignedOut>());
    expect(h.auth.calls, contains('clearTokens'));
    expect(await h.store.count(Collections.products), 0);
  });

  test('logout stops services and wipes the store', () async {
    h.auth.session = true;
    await h.store.upsert(Collections.products, const Product(id: 'p', vendorId: 'v', name: 'x', slug: 'x'));
    final c = h.container();
    final ctrl = c.read(sessionControllerProvider.notifier);
    await ctrl.login(email: 'a@b.co', password: 'password1');
    expect(c.read(sessionControllerProvider), isA<SignedIn>());
    await ctrl.logout();
    expect(c.read(sessionControllerProvider), isA<SignedOut>());
    expect(h.lifecycle.stops, 1);
    expect(await h.store.count(Collections.products), 0);
    expect(h.auth.calls, contains('logout'));
  });
}
