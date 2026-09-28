import 'package:api_client/api_client.dart';
import 'package:core_models/core_models.dart';
import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/misc.dart' show Override;
import 'package:flutter_test/flutter_test.dart';
import 'package:instant_customer/app/providers.dart';
import 'package:instant_customer/features/auth/data/auth_gateway.dart';
import 'package:instant_customer/features/auth/domain/session_state.dart';
import 'package:instant_customer/features/auth/presentation/session_controller.dart';
import 'package:instant_customer/features/catalog/data/location_controller.dart';
import 'package:local_db/local_db.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'fakes.dart';

/// Everything a test needs to run app code against in-memory fakes.
class TestHarness {
  TestHarness._({
    required this.store,
    required this.prefs,
    required this.engine,
    required this.transport,
    required this.auth,
    required this.lifecycle,
  });

  static Future<TestHarness> create({FakeAuthGateway? auth}) async {
    AppTypography.configure(useGoogleFonts: false, allowRuntimeFetching: false);
    SharedPreferences.setMockInitialValues({});
    final prefs = await SharedPreferences.getInstance();
    final store = MemoryStore();
    final transport = FakeSyncTransport();
    final engine = SyncEngine(
      store: store,
      api: transport,
      collections: Collections.customerSync,
      connectivity: ManualConnectivityMonitor(),
    );
    return TestHarness._(
      store: store,
      prefs: prefs,
      engine: engine,
      transport: transport,
      auth: auth ?? FakeAuthGateway(),
      lifecycle: NoopLifecycle(),
    );
  }

  final MemoryStore store;
  final SharedPreferences prefs;
  final SyncEngine engine;
  final FakeSyncTransport transport;
  final FakeAuthGateway auth;
  final NoopLifecycle lifecycle;

  List<Override> overrides({List<Override> extra = const []}) => [
        sharedPreferencesProvider.overrideWithValue(prefs),
        localStoreProvider.overrideWithValue(store),
        tokenStoreProvider.overrideWithValue(MemoryTokenStore()),
        syncEngineProvider.overrideWithValue(engine),
        sessionLifecycleProvider.overrideWithValue(lifecycle),
        authGatewayProvider.overrideWithValue(auth),
        locationServiceProvider.overrideWithValue(FakeLocationService()),
        ...extra,
      ];

  ProviderContainer container({List<Override> extra = const []}) {
    final c = ProviderContainer(overrides: overrides(extra: extra));
    addTearDown(c.dispose);
    return c;
  }

  /// Signed-in overrides for widget tests.
  List<Override> signedInOverrides({List<Override> extra = const []}) => overrides(extra: [
        sessionControllerProvider.overrideWith(() => FakeSessionController(const SignedIn(testUser))),
        ...extra,
      ]);

  Future<void> dispose() => engine.dispose();
}

/// Pumps [child] inside a ProviderScope + MaterialApp with the app theme.
Future<void> pumpApp(WidgetTester tester, Widget child, {required List<Override> overrides}) async {
  await tester.pumpWidget(
    ProviderScope(
      overrides: overrides,
      child: MaterialApp(theme: AppTheme.light(), home: child),
    ),
  );
  await tester.pump();
}
