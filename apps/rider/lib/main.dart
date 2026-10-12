import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:local_db/local_db.dart';

import 'app/app.dart';
import 'app/config.dart';
import 'app/providers.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const RiderAppEntry());
}

/// Embeddable entry point for the rider experience in the unified app.
class RiderAppEntry extends StatelessWidget {
  const RiderAppEntry({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<LocalStore>(
      future: _initialize(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const MaterialApp(home: Scaffold(body: Center(child: CircularProgressIndicator())));
        }
        return ProviderScope(
          overrides: [localStoreProvider.overrideWithValue(snapshot.data!)],
          child: const RiderApp(),
        );
      },
    );
  }

  Future<LocalStore> _initialize() async {
    AppTypography.configure(allowRuntimeFetching: true);
    return LocalStore.open(name: AppConfig.storeName);
  }
}
