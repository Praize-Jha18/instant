import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:instant_customer/app/app.dart';
import 'package:instant_customer/app/router.dart';
import 'package:instant_customer/app/routes.dart';
import 'package:instant_customer/features/auth/domain/session_state.dart';
import 'package:instant_customer/features/auth/presentation/session_controller.dart';
import 'package:instant_customer/features/auth/presentation/splash_screen.dart';

import '../helpers/fakes.dart';
import '../helpers/test_app.dart';

void main() {
  group('sessionRedirect', () {
    test('unknown session always lands on splash', () {
      expect(sessionRedirect(session: const SessionUnknown(), location: AppRoutes.home), AppRoutes.splash);
      expect(sessionRedirect(session: const SessionUnknown(), location: AppRoutes.splash), isNull);
    });

    test('signed out is confined to the auth screens', () {
      expect(sessionRedirect(session: const SignedOut(), location: AppRoutes.home), AppRoutes.login);
      expect(sessionRedirect(session: const SignedOut(), location: AppRoutes.cart), AppRoutes.login);
      expect(sessionRedirect(session: const SignedOut(), location: '/orders/abc'), AppRoutes.login);
      expect(sessionRedirect(session: const SignedOut(), location: AppRoutes.login), isNull);
      expect(sessionRedirect(session: const SignedOut(), location: AppRoutes.register), isNull);
      expect(sessionRedirect(session: const SignedOut(), location: AppRoutes.forgotPassword), isNull);
    });

    test('signed in bounces off splash and auth screens', () {
      const s = SignedIn(testUser);
      expect(sessionRedirect(session: s, location: AppRoutes.splash), AppRoutes.home);
      expect(sessionRedirect(session: s, location: AppRoutes.login), AppRoutes.home);
      expect(sessionRedirect(session: s, location: AppRoutes.cart), isNull);
      expect(sessionRedirect(session: s, location: '/products/p1'), isNull);
    });
  });

  testWidgets('GoRouter follows the session through splash → login → home', (tester) async {
    final h = await TestHarness.create();
    addTearDown(h.dispose);
    tester.view.physicalSize = const Size(1080, 2200);
    tester.view.devicePixelRatio = 2;
    addTearDown(tester.view.reset);

    await tester.pumpWidget(
      ProviderScope(
        overrides: h.overrides(extra: [sessionControllerProvider.overrideWith(FakeSessionController.new)]),
        child: const InstantCustomerApp(),
      ),
    );
    await tester.pump();
    final context = tester.element(find.byType(SplashScreen));
    final container = ProviderScope.containerOf(context);
    final router = container.read(routerProvider);
    final session = container.read(sessionControllerProvider.notifier) as FakeSessionController;

    String location() => router.routerDelegate.currentConfiguration.uri.path;
    expect(location(), AppRoutes.splash);

    session.set(const SignedOut());
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 500));
    expect(location(), AppRoutes.login);

    router.go(AppRoutes.cart);
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 500));
    expect(location(), AppRoutes.login, reason: 'protected routes redirect to login while signed out');

    session.set(const SignedIn(testUser));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 500));
    expect(location(), AppRoutes.home);

    router.go(AppRoutes.cart);
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 500));
    expect(location(), AppRoutes.cart);

    session.set(const SignedOut(message: 'expired'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 500));
    expect(location(), AppRoutes.login);
  });
}
