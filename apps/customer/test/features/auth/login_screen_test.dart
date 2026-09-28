import 'package:api_client/api_client.dart';
import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:instant_customer/features/auth/domain/session_state.dart';
import 'package:instant_customer/features/auth/presentation/login_screen.dart';
import 'package:instant_customer/features/auth/presentation/session_controller.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/misc.dart' show Override;

import '../../helpers/fakes.dart';
import '../../helpers/test_app.dart';

void main() {
  late TestHarness h;

  setUp(() async => h = await TestHarness.create());
  tearDown(() => h.dispose());

  Future<void> pumpLogin(WidgetTester tester, {List<Override> extra = const []}) async {
    tester.view.physicalSize = const Size(1080, 2200);
    tester.view.devicePixelRatio = 2;
    addTearDown(tester.view.reset);
    await pumpApp(tester, const LoginScreen(), overrides: h.overrides(extra: extra));
    await tester.pump(const Duration(seconds: 1));
  }

  Finder signInButton() => find.widgetWithText(AppButton, 'Sign in');

  testWidgets('shows required errors when submitted empty', (tester) async {
    await pumpLogin(tester);
    await tester.tap(signInButton());
    await tester.pump();

    expect(find.text('Enter your email'), findsOneWidget);
    expect(find.text('Enter your password'), findsOneWidget);
    expect(h.auth.calls, isEmpty);
  });

  testWidgets('validates email format and password length', (tester) async {
    await pumpLogin(tester);
    await tester.enterText(find.byType(TextFormField).at(0), 'not-an-email');
    await tester.enterText(find.byType(TextFormField).at(1), 'short');
    await tester.tap(signInButton());
    await tester.pump();

    expect(find.text('Enter a valid email'), findsOneWidget);
    expect(find.text('Password must be at least 8 characters'), findsOneWidget);
    expect(h.auth.calls, isEmpty);
  });

  testWidgets('signs in with valid credentials and starts the session', (tester) async {
    await pumpLogin(tester);
    await tester.enterText(find.byType(TextFormField).at(0), 'Ada@Example.com');
    await tester.enterText(find.byType(TextFormField).at(1), 'correct horse');
    await tester.tap(signInButton());
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 100));

    expect(h.auth.calls, contains('login:Ada@Example.com'));
    final container = ProviderScope.containerOf(tester.element(find.byType(LoginScreen)));
    expect(container.read(sessionControllerProvider), isA<SignedIn>());
    expect(h.lifecycle.starts, 1);
    expect(h.lifecycle.lastUserId, testUser.id);
  });

  testWidgets('surfaces API errors inline', (tester) async {
    h.auth.loginError = const UnauthorizedException(code: 'INVALID_CREDENTIALS', message: 'Wrong email or password');
    await pumpLogin(tester);
    await tester.enterText(find.byType(TextFormField).at(0), 'ada@example.com');
    await tester.enterText(find.byType(TextFormField).at(1), 'wrong-password');
    await tester.tap(signInButton());
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 400));

    expect(find.text('Wrong email or password'), findsOneWidget);
  });
}
