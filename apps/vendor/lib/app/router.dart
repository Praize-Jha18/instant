import 'package:core_models/core_models.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../features/admin/presentation/admin_categories_screen.dart';
import '../features/admin/presentation/admin_dashboard_screen.dart';
import '../features/admin/presentation/admin_more_screen.dart';
import '../features/admin/presentation/admin_orders_screen.dart';
import '../features/admin/presentation/admin_payouts_screen.dart';
import '../features/admin/presentation/admin_users_screen.dart';
import '../features/admin/presentation/admin_vendors_screen.dart';
import '../features/auth/presentation/awaiting_approval_screen.dart';
import '../features/auth/presentation/blocked_screens.dart';
import '../features/auth/presentation/login_screen.dart';
import '../features/auth/presentation/register_screen.dart';
import '../features/auth/presentation/splash_screen.dart';
import '../features/dashboard/presentation/dashboard_screen.dart';
import '../features/finance/presentation/finance_screen.dart';
import '../features/orders/presentation/order_detail_screen.dart';
import '../features/orders/presentation/orders_board_screen.dart';
import '../features/products/presentation/inventory_movements_screen.dart';
import '../features/products/presentation/product_form_screen.dart';
import '../features/products/presentation/products_screen.dart';
import '../features/riders/presentation/deliveries_board_screen.dart';
import '../features/riders/presentation/rider_detail_screen.dart';
import '../features/riders/presentation/riders_screen.dart';
import '../features/settings/presentation/more_screen.dart';
import '../features/settings/presentation/settings_screen.dart';
import 'session.dart';
import 'shell/shell_scaffolds.dart';

class _RouterRefresh extends ChangeNotifier {
  void refresh() => notifyListeners();
}

final _rootKey = GlobalKey<NavigatorState>(debugLabel: 'root');

final routerProvider = Provider<GoRouter>((ref) {
  final refresh = _RouterRefresh();
  ref.listen(sessionProvider, (_, _) => refresh.refresh());
  ref.onDispose(refresh.dispose);

  String? redirect(BuildContext context, GoRouterState state) {
    final session = ref.read(sessionProvider);
    final loc = state.matchedLocation;
    final isAuthRoute = loc == '/login' || loc == '/register';

    switch (session.status) {
      case SessionStatus.unknown:
        return loc == '/splash' ? null : '/splash';
      case SessionStatus.signedOut:
        return isAuthRoute ? null : '/login';
      case SessionStatus.signedIn:
        break;
    }

    if (loc == '/splash' || isAuthRoute) return session.homeLocation;

    if (session.isAdmin) {
      return loc.startsWith('/admin') ? null : '/admin';
    }

    if (session.isVendor) {
      if (loc.startsWith('/admin') || loc == '/no-access') return session.homeLocation;
      switch (session.vendorStatus) {
        case VendorStatus.suspended:
          return loc == '/suspended' ? null : '/suspended';
        case VendorStatus.pending:
          final allowed = loc == '/approval' || loc.startsWith('/products') || loc.startsWith('/settings');
          return allowed ? null : '/approval';
        case VendorStatus.active:
        case null:
          return (loc == '/approval' || loc == '/suspended') ? '/dashboard' : null;
      }
    }

    return loc == '/no-access' ? null : '/no-access';
  }

  return GoRouter(
    navigatorKey: _rootKey,
    initialLocation: '/splash',
    debugLogDiagnostics: kDebugMode,
    refreshListenable: refresh,
    redirect: redirect,
    routes: [
      GoRoute(path: '/splash', builder: (_, _) => const SplashScreen()),
      GoRoute(path: '/login', builder: (_, _) => const LoginScreen()),
      GoRoute(path: '/register', builder: (_, _) => const RegisterScreen()),
      GoRoute(path: '/suspended', builder: (_, _) => const SuspendedScreen()),
      GoRoute(path: '/no-access', builder: (_, _) => const NoAccessScreen()),

      // ---- Vendor area ----------------------------------------------------
      StatefulShellRoute.indexedStack(
        builder: (context, state, shell) => VendorShellScaffold(navigationShell: shell),
        branches: [
          StatefulShellBranch(routes: [GoRoute(path: '/dashboard', builder: (_, _) => const DashboardScreen())]),
          StatefulShellBranch(routes: [
            GoRoute(
              path: '/orders',
              builder: (_, _) => const OrdersBoardScreen(),
              routes: [
                GoRoute(path: ':id', builder: (_, s) => OrderDetailScreen(subOrderId: s.pathParameters['id']!)),
              ],
            ),
          ]),
          StatefulShellBranch(routes: [
            GoRoute(
              path: '/products',
              builder: (_, _) => const ProductsScreen(),
              routes: [
                GoRoute(path: 'new', builder: (_, _) => const ProductFormScreen()),
                GoRoute(
                  path: ':id',
                  builder: (_, s) => ProductFormScreen(productId: s.pathParameters['id']),
                  routes: [
                    GoRoute(
                      path: 'movements',
                      builder: (_, s) => InventoryMovementsScreen(productId: s.pathParameters['id']!),
                    ),
                  ],
                ),
              ],
            ),
          ]),
          StatefulShellBranch(routes: [
            GoRoute(
              path: '/riders',
              builder: (_, _) => const RidersScreen(),
              routes: [
                GoRoute(path: ':id', builder: (_, s) => RiderDetailScreen(riderId: s.pathParameters['id']!)),
              ],
            ),
          ]),
          StatefulShellBranch(routes: [GoRoute(path: '/deliveries', builder: (_, _) => const DeliveriesBoardScreen())]),
          StatefulShellBranch(routes: [GoRoute(path: '/finance', builder: (_, _) => const FinanceScreen())]),
          StatefulShellBranch(routes: [GoRoute(path: '/settings', builder: (_, _) => const SettingsScreen())]),
          StatefulShellBranch(routes: [GoRoute(path: '/more', builder: (_, _) => const MoreScreen())]),
          StatefulShellBranch(routes: [GoRoute(path: '/approval', builder: (_, _) => const AwaitingApprovalScreen())]),
        ],
      ),

      // ---- Admin area -----------------------------------------------------
      StatefulShellRoute.indexedStack(
        builder: (context, state, shell) => AdminShellScaffold(navigationShell: shell),
        branches: [
          StatefulShellBranch(routes: [GoRoute(path: '/admin', builder: (_, _) => const AdminDashboardScreen())]),
          StatefulShellBranch(routes: [GoRoute(path: '/admin/vendors', builder: (_, _) => const AdminVendorsScreen())]),
          StatefulShellBranch(routes: [GoRoute(path: '/admin/orders', builder: (_, _) => const AdminOrdersScreen())]),
          StatefulShellBranch(routes: [GoRoute(path: '/admin/users', builder: (_, _) => const AdminUsersScreen())]),
          StatefulShellBranch(routes: [GoRoute(path: '/admin/payouts', builder: (_, _) => const AdminPayoutsScreen())]),
          StatefulShellBranch(routes: [GoRoute(path: '/admin/categories', builder: (_, _) => const AdminCategoriesScreen())]),
          StatefulShellBranch(routes: [GoRoute(path: '/admin/more', builder: (_, _) => const AdminMoreScreen())]),
        ],
      ),
    ],
  );
});

/// Branch indices of the vendor shell (kept in one place for badges etc.).
abstract final class VendorBranch {
  static const dashboard = 0;
  static const orders = 1;
  static const products = 2;
  static const riders = 3;
  static const deliveries = 4;
  static const finance = 5;
  static const settings = 6;
  static const more = 7;
  static const approval = 8;
}

abstract final class AdminBranch {
  static const dashboard = 0;
  static const vendors = 1;
  static const orders = 2;
  static const users = 3;
  static const payouts = 4;
  static const categories = 5;
  static const more = 6;
}
