import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../features/addresses/presentation/address_form_screen.dart';
import '../features/addresses/presentation/addresses_screen.dart';
import '../features/auth/domain/session_state.dart';
import '../features/auth/presentation/forgot_password_screen.dart';
import '../features/auth/presentation/login_screen.dart';
import '../features/auth/presentation/register_screen.dart';
import '../features/auth/presentation/session_controller.dart';
import '../features/auth/presentation/splash_screen.dart';
import '../features/cart/presentation/cart_screen.dart';
import '../features/checkout/presentation/checkout_screen.dart';
import '../features/checkout/presentation/payment_screen.dart';
import '../features/home/presentation/home_screen.dart';
import '../features/orders/presentation/order_detail_screen.dart';
import '../features/orders/presentation/orders_screen.dart';
import '../features/orders/presentation/tracking_screen.dart';
import '../features/product/presentation/product_detail_screen.dart';
import '../features/profile/presentation/notifications_screen.dart';
import '../features/profile/presentation/profile_screen.dart';
import '../features/search/presentation/search_screen.dart';
import '../features/vendor/presentation/vendor_screen.dart';
import 'routes.dart';
import 'shell.dart';
import 'transitions.dart';

/// Pure redirect rule, unit-tested separately from GoRouter.
///
/// - Session unknown: stay on splash until it is resolved.
/// - Signed out: only the auth screens are reachable.
/// - Signed in: splash and auth screens bounce to home.
String? sessionRedirect({required SessionState session, required String location}) {
  final isAuth = AppRoutes.authRoutes.contains(location);
  final isSplash = location == AppRoutes.splash;
  return switch (session) {
    SessionUnknown() => isSplash ? null : AppRoutes.splash,
    SignedOut() => isAuth ? null : AppRoutes.login,
    SignedIn() => (isSplash || isAuth) ? AppRoutes.home : null,
  };
}

final rootNavigatorKey = GlobalKey<NavigatorState>(debugLabel: 'root');

/// Bumps a listenable whenever the session changes so GoRouter re-runs
/// [sessionRedirect].
final _routerRefreshProvider = Provider<ChangeNotifier>((ref) {
  final notifier = _Refresh();
  ref.listen(sessionControllerProvider, (_, _) => notifier.bump());
  ref.onDispose(notifier.dispose);
  return notifier;
});

class _Refresh extends ChangeNotifier {
  void bump() => notifyListeners();
}

final routerProvider = Provider<GoRouter>((ref) {
  final refresh = ref.watch(_routerRefreshProvider);
  final router = GoRouter(
    navigatorKey: rootNavigatorKey,
    initialLocation: AppRoutes.splash,
    refreshListenable: refresh,
    debugLogDiagnostics: false,
    redirect: (context, state) => sessionRedirect(
      session: ref.read(sessionControllerProvider),
      location: state.matchedLocation,
    ),
    routes: buildAppRoutes(),
  );
  ref.onDispose(router.dispose);
  return router;
});

/// The route table (exposed so tests can build a router around it).
List<RouteBase> buildAppRoutes() => [
      GoRoute(
        path: AppRoutes.splash,
        pageBuilder: (context, state) => fadePage(key: state.pageKey, child: const SplashScreen()),
      ),
      GoRoute(
        path: AppRoutes.login,
        pageBuilder: (context, state) => fadePage(key: state.pageKey, child: const LoginScreen()),
      ),
      GoRoute(
        path: AppRoutes.register,
        pageBuilder: (context, state) => fadeSlidePage(key: state.pageKey, child: const RegisterScreen()),
      ),
      GoRoute(
        path: AppRoutes.forgotPassword,
        pageBuilder: (context, state) => fadeSlidePage(key: state.pageKey, child: const ForgotPasswordScreen()),
      ),
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) => AppShell(navigationShell: navigationShell),
        branches: [
          StatefulShellBranch(routes: [
            GoRoute(
              path: AppRoutes.home,
              pageBuilder: (context, state) => NoTransitionPage(key: state.pageKey, child: const HomeScreen()),
            ),
          ]),
          StatefulShellBranch(routes: [
            GoRoute(
              path: AppRoutes.search,
              pageBuilder: (context, state) => NoTransitionPage(
                key: state.pageKey,
                child: SearchScreen(
                  initialQuery: state.uri.queryParameters['q'],
                  initialCategoryId: state.uri.queryParameters['categoryId'],
                ),
              ),
            ),
          ]),
          StatefulShellBranch(routes: [
            GoRoute(
              path: AppRoutes.cart,
              pageBuilder: (context, state) => NoTransitionPage(key: state.pageKey, child: const CartScreen()),
            ),
          ]),
          StatefulShellBranch(routes: [
            GoRoute(
              path: AppRoutes.orders,
              pageBuilder: (context, state) => NoTransitionPage(key: state.pageKey, child: const OrdersScreen()),
            ),
          ]),
          StatefulShellBranch(routes: [
            GoRoute(
              path: AppRoutes.profile,
              pageBuilder: (context, state) => NoTransitionPage(key: state.pageKey, child: const ProfileScreen()),
            ),
          ]),
        ],
      ),
      // Full-screen detail routes (cover the bottom navigation).
      GoRoute(
        path: '/vendors/:id',
        pageBuilder: (context, state) =>
            fadeSlidePage(key: state.pageKey, child: VendorScreen(vendorId: state.pathParameters['id']!)),
      ),
      GoRoute(
        path: '/products/:id',
        pageBuilder: (context, state) =>
            fadeSlidePage(key: state.pageKey, child: ProductDetailScreen(productId: state.pathParameters['id']!)),
      ),
      GoRoute(
        path: AppRoutes.checkout,
        pageBuilder: (context, state) => slideUpPage(key: state.pageKey, child: const CheckoutScreen()),
      ),
      GoRoute(
        path: '/checkout/pay/:orderId',
        pageBuilder: (context, state) =>
            slideUpPage(key: state.pageKey, child: PaymentScreen(orderId: state.pathParameters['orderId']!)),
      ),
      GoRoute(
        path: '/orders/:id',
        pageBuilder: (context, state) => fadeSlidePage(
          key: state.pageKey,
          child: OrderDetailScreen(
            orderId: state.pathParameters['id']!,
            celebrate: state.uri.queryParameters['celebrate'] == '1',
          ),
        ),
        routes: [
          GoRoute(
            path: 'tracking',
            pageBuilder: (context, state) =>
                fadeSlidePage(key: state.pageKey, child: TrackingScreen(orderId: state.pathParameters['id']!)),
          ),
        ],
      ),
      GoRoute(
        path: AppRoutes.addresses,
        pageBuilder: (context, state) => fadeSlidePage(key: state.pageKey, child: const AddressesScreen()),
        routes: [
          GoRoute(
            path: 'new',
            pageBuilder: (context, state) => slideUpPage(key: state.pageKey, child: const AddressFormScreen()),
          ),
          GoRoute(
            path: ':id/edit',
            pageBuilder: (context, state) => slideUpPage(
              key: state.pageKey,
              child: AddressFormScreen(addressId: state.pathParameters['id']),
            ),
          ),
        ],
      ),
      GoRoute(
        path: AppRoutes.notifications,
        pageBuilder: (context, state) => fadeSlidePage(key: state.pageKey, child: const NotificationsScreen()),
      ),
    ];
