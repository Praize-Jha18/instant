import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../features/active_delivery/presentation/active_delivery_screen.dart';
import '../features/auth/data/auth_controller.dart';
import '../features/auth/data/rider_profile_provider.dart';
import '../features/auth/domain/session_state.dart';
import '../features/auth/presentation/login_screen.dart';
import '../features/auth/presentation/pending_approval_screen.dart';
import '../features/auth/presentation/register_screen.dart';
import '../features/auth/presentation/splash_screen.dart';
import '../features/auth/presentation/suspended_screen.dart';
import '../features/deliveries/presentation/deliveries_screen.dart';
import '../features/deliveries/presentation/delivery_detail_screen.dart';
import '../features/home/presentation/home_screen.dart';
import '../features/location/presentation/location_rationale_screen.dart';
import '../features/profile/presentation/profile_screen.dart';
import 'redirect.dart';
import 'shell.dart';

/// Notifies GoRouter whenever session or rider status changes.
class RouterNotifier extends ChangeNotifier {
  RouterNotifier(Ref ref) {
    ref.listen(authControllerProvider, (_, _) => notifyListeners());
    ref.listen(currentRiderProfileProvider, (prev, next) {
      if (prev?.status != next?.status) notifyListeners();
    });
  }
}

final routerNotifierProvider = Provider<RouterNotifier>((ref) {
  final n = RouterNotifier(ref);
  ref.onDispose(n.dispose);
  return n;
});

final rootNavigatorKey = GlobalKey<NavigatorState>(debugLabel: 'root');

final routerProvider = Provider<GoRouter>((ref) {
  final notifier = ref.watch(routerNotifierProvider);
  final router = GoRouter(
    navigatorKey: rootNavigatorKey,
    initialLocation: Routes.splash,
    refreshListenable: notifier,
    debugLogDiagnostics: false,
    redirect: (context, state) => computeRedirect(
      auth: ref.read(authControllerProvider).phase,
      riderStatus: ref.read(currentRiderProfileProvider)?.status,
      location: state.matchedLocation,
    ),
    routes: [
      GoRoute(path: Routes.splash, builder: (_, _) => const SplashScreen()),
      GoRoute(path: Routes.login, builder: (_, _) => const LoginScreen()),
      GoRoute(path: Routes.register, builder: (_, _) => const RegisterScreen()),
      GoRoute(path: Routes.pending, builder: (_, _) => const PendingApprovalScreen()),
      GoRoute(path: Routes.suspended, builder: (_, _) => const SuspendedScreen()),
      GoRoute(
        path: Routes.locationPermission,
        parentNavigatorKey: rootNavigatorKey,
        builder: (_, _) => const LocationRationaleScreen(),
      ),
      GoRoute(
        path: '/active/:id',
        parentNavigatorKey: rootNavigatorKey,
        builder: (_, state) => ActiveDeliveryScreen(deliveryId: state.pathParameters['id']!),
      ),
      StatefulShellRoute.indexedStack(
        builder: (context, state, shell) => RiderShell(navigationShell: shell),
        branches: [
          StatefulShellBranch(routes: [
            GoRoute(path: Routes.home, builder: (_, _) => const HomeScreen()),
          ]),
          StatefulShellBranch(routes: [
            GoRoute(
              path: Routes.deliveries,
              builder: (_, _) => const DeliveriesScreen(),
              routes: [
                GoRoute(
                  path: ':id',
                  builder: (_, state) => DeliveryDetailScreen(deliveryId: state.pathParameters['id']!),
                ),
              ],
            ),
          ]),
          StatefulShellBranch(routes: [
            GoRoute(path: Routes.profile, builder: (_, _) => const ProfileScreen()),
          ]),
        ],
      ),
    ],
  );
  ref.onDispose(router.dispose);
  return router;
});
