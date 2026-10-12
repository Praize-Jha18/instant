import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:local_db/local_db.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'app/app.dart';
import 'app/providers.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const CustomerAppEntry());
}

/// Embeddable entry point for the customer experience.
///
/// This allows the unified Instant app to present the customer UI without
/// duplicating its session, router, or offline-store setup.
class CustomerAppEntry extends StatelessWidget {
  const CustomerAppEntry({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<(SharedPreferences, LocalStore)>(
      future: _initialize(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const MaterialApp(home: Scaffold(body: Center(child: CircularProgressIndicator())));
        }
        final (prefs, store) = snapshot.data!;
        return ProviderScope(
          overrides: [
            sharedPreferencesProvider.overrideWithValue(prefs),
            localStoreProvider.overrideWithValue(store),
          ],
          child: const InstantCustomerApp(),
        );
      },
    );
  }

  Future<(SharedPreferences, LocalStore)> _initialize() async {
    AppTypography.configure();
    return (await SharedPreferences.getInstance(), await LocalStore.open(name: 'instant_customer'));
  }
}
