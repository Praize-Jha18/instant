import 'package:api_client/api_client.dart';
import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:instant_vendor/app/providers.dart';
import 'package:instant_vendor/core/session_cache.dart';
import 'package:instant_vendor/core/vendor_codec.dart';
import 'package:local_db/local_db.dart';

/// Wraps [child] in a `ProviderScope` with in-memory fakes and the app theme.
Widget testApp(Widget child, {MemoryStore? store}) {
  registerVendorCodec();
  AppTypography.configure(useGoogleFonts: false, allowRuntimeFetching: false);
  return ProviderScope(
    overrides: [
      localStoreProvider.overrideWithValue(store ?? MemoryStore()),
      tokenStoreProvider.overrideWithValue(MemoryTokenStore()),
      sessionCacheProvider.overrideWithValue(MemorySessionCache()),
    ],
    child: MaterialApp(theme: AppTheme.light(), home: child),
  );
}

/// Sets the logical test surface size (restored automatically after the test).
void setSurface(WidgetTester tester, Size size) {
  tester.view.physicalSize = size;
  tester.view.devicePixelRatio = 1;
  addTearDown(tester.view.resetPhysicalSize);
  addTearDown(tester.view.resetDevicePixelRatio);
}
