import 'package:api_client/api_client.dart';
import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:instant_rider/app/providers.dart';
import 'package:instant_rider/features/auth/data/auth_controller.dart';
import 'package:instant_rider/features/auth/domain/session_state.dart';
import 'package:instant_rider/features/auth/domain/validators.dart';
import 'package:instant_rider/features/auth/presentation/login_screen.dart';
import 'package:local_db/local_db.dart';

/// Records login attempts instead of hitting the network.
class FakeAuthController extends AuthController {
  final calls = <(String, String)>[];
  Object? failWith;

  @override
  SessionState build() => const SignedOut();

  @override
  Future<void> login({required String email, required String password}) async {
    calls.add((email, password));
    if (failWith != null) throw failWith!;
  }
}

void main() {
  late FakeAuthController fake;

  setUpAll(() => AppTypography.configure(allowRuntimeFetching: false, useGoogleFonts: false));

  Widget harness() {
    fake = FakeAuthController();
    return ProviderScope(
      overrides: [
        tokenStoreProvider.overrideWithValue(MemoryTokenStore()),
        localStoreProvider.overrideWithValue(MemoryStore()),
        connectivityMonitorProvider.overrideWithValue(ManualConnectivityMonitor()),
        authControllerProvider.overrideWith(() => fake),
      ],
      child: MaterialApp(theme: AppTheme.light(), home: const LoginScreen()),
    );
  }

  group('Validators', () {
    test('email', () {
      expect(Validators.email(''), 'Email is required');
      expect(Validators.email('nope'), 'Enter a valid email address');
      expect(Validators.email('  rider@example.com '), isNull);
    });

    test('password enforces the 8 character minimum from the contract', () {
      expect(Validators.password(''), 'Password is required');
      expect(Validators.password('1234567'), 'Password must be at least 8 characters');
      expect(Validators.password('12345678'), isNull);
    });

    test('otp accepts 4 to 8 digits only', () {
      expect(Validators.otp('123'), isNotNull);
      expect(Validators.otp('12ab'), isNotNull);
      expect(Validators.otp('4821'), isNull);
      expect(Validators.otp('12345678'), isNull);
    });
  });

  group('LoginScreen', () {
    testWidgets('shows validation errors and does not submit when empty', (tester) async {
      await tester.pumpWidget(harness());
      await tester.pumpAndSettle();

      await tester.tap(find.byKey(LoginKeys.submit));
      await tester.pumpAndSettle();

      expect(find.text('Email is required'), findsOneWidget);
      expect(find.text('Password is required'), findsOneWidget);
      expect(fake.calls, isEmpty);
    });

    testWidgets('rejects a malformed email and a short password', (tester) async {
      await tester.pumpWidget(harness());
      await tester.pumpAndSettle();

      await tester.enterText(find.byKey(LoginKeys.email), 'not-an-email');
      await tester.enterText(find.byKey(LoginKeys.password), 'short');
      await tester.tap(find.byKey(LoginKeys.submit));
      await tester.pumpAndSettle();

      expect(find.text('Enter a valid email address'), findsOneWidget);
      expect(find.text('Password must be at least 8 characters'), findsOneWidget);
      expect(fake.calls, isEmpty);
    });

    testWidgets('submits valid credentials to the auth controller', (tester) async {
      await tester.pumpWidget(harness());
      await tester.pumpAndSettle();

      await tester.enterText(find.byKey(LoginKeys.email), 'rider@example.com');
      await tester.enterText(find.byKey(LoginKeys.password), 'supersecret');
      await tester.tap(find.byKey(LoginKeys.submit));
      await tester.pumpAndSettle();

      expect(fake.calls, [('rider@example.com', 'supersecret')]);
      expect(find.byKey(LoginKeys.error), findsNothing);
    });

    testWidgets('surfaces API errors inline', (tester) async {
      await tester.pumpWidget(harness());
      await tester.pumpAndSettle();
      fake.failWith = const UnauthorizedException(code: 'INVALID_CREDENTIALS', message: 'Wrong email or password');

      await tester.enterText(find.byKey(LoginKeys.email), 'rider@example.com');
      await tester.enterText(find.byKey(LoginKeys.password), 'supersecret');
      await tester.tap(find.byKey(LoginKeys.submit));
      await tester.pumpAndSettle();

      expect(find.byKey(LoginKeys.error), findsOneWidget);
      expect(fake.calls, hasLength(1));
    });
  });
}
