import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:instant_customer/main.dart' show CustomerAppEntry;
import 'package:instant_rider/main.dart' show RiderAppEntry;
import 'package:local_db/local_db.dart';

import 'app/app.dart';
import 'app/providers.dart';
import 'core/vendor_codec.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const InstantApp());
}

/// The single app users install. They choose their workspace before signing in.
class InstantApp extends StatefulWidget {
  const InstantApp({super.key});

  @override
  State<InstantApp> createState() => _InstantAppState();
}

class _InstantAppState extends State<InstantApp> {
  _Workspace? _workspace;

  @override
  Widget build(BuildContext context) {
    return switch (_workspace) {
      _Workspace.customer => const CustomerAppEntry(),
      _Workspace.rider => const RiderAppEntry(),
      _Workspace.vendor => const VendorAppEntry(),
      null => MaterialApp(
          title: 'Instant',
          debugShowCheckedModeBanner: false,
          theme: AppTheme.light(),
          darkTheme: AppTheme.dark(),
          home: _WorkspacePicker(onSelected: (workspace) => setState(() => _workspace = workspace)),
        ),
    };
  }
}

/// The vendor/admin experience, with its existing isolated store and session.
class VendorAppEntry extends StatelessWidget {
  const VendorAppEntry({super.key});

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
          child: const InstantVendorApp(),
        );
      },
    );
  }

  Future<LocalStore> _initialize() async {
    registerVendorCodec();
    AppTypography.configure();
    return LocalStore.open(name: 'instant_vendor');
  }
}

enum _Workspace { customer, rider, vendor }

class _WorkspacePicker extends StatelessWidget {
  const _WorkspacePicker({required this.onSelected});

  final ValueChanged<_Workspace> onSelected;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 520),
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text('Welcome to Instant', style: Theme.of(context).textTheme.headlineMedium, textAlign: TextAlign.center),
                  const SizedBox(height: 12),
                  Text('Choose how you use Instant. You will sign in on the next screen.', style: Theme.of(context).textTheme.bodyLarge, textAlign: TextAlign.center),
                  const SizedBox(height: 32),
                  _WorkspaceCard(icon: Icons.shopping_bag_outlined, title: 'Customer', subtitle: 'Shop, pay and track your orders', onTap: () => onSelected(_Workspace.customer)),
                  const SizedBox(height: 12),
                  _WorkspaceCard(icon: Icons.two_wheeler_outlined, title: 'Rider', subtitle: 'Accept and complete deliveries', onTap: () => onSelected(_Workspace.rider)),
                  const SizedBox(height: 12),
                  _WorkspaceCard(icon: Icons.storefront_outlined, title: 'Vendor or Admin', subtitle: 'Manage your store, orders and riders', onTap: () => onSelected(_Workspace.vendor)),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _WorkspaceCard extends StatelessWidget {
  const _WorkspaceCard({required this.icon, required this.title, required this.subtitle, required this.onTap});

  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        onTap: onTap,
        contentPadding: const EdgeInsets.all(20),
        leading: Icon(icon, size: 32),
        title: Text(title),
        subtitle: Text(subtitle),
        trailing: const Icon(Icons.arrow_forward),
      ),
    );
  }
}
