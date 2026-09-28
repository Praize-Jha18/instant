import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:local_db/local_db.dart';

import 'app/app.dart';
import 'app/providers.dart';
import 'core/vendor_codec.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  registerVendorCodec();
  AppTypography.configure();
  // MemoryStore on web (online-only dashboard), ObjectBox on mobile.
  final store = await LocalStore.open(name: 'instant_vendor');
  runApp(
    ProviderScope(
      overrides: [localStoreProvider.overrideWithValue(store)],
      child: const InstantVendorApp(),
    ),
  );
}
