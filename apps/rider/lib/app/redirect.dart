import 'package:core_models/core_models.dart';

import '../features/auth/domain/session_state.dart';

/// Route paths (single source of truth for router + redirect).
abstract final class Routes {
  static const splash = '/splash';
  static const login = '/login';
  static const register = '/register';
  static const pending = '/pending';
  static const suspended = '/suspended';
  static const locationPermission = '/location-permission';
  static const home = '/home';
  static const deliveries = '/deliveries';
  static const profile = '/profile';

  static String delivery(String id) => '/deliveries/$id';
  static String active(String id) => '/active/$id';

  static const Set<String> _public = {login, register};
  static const Set<String> _gates = {splash, login, register, pending, suspended};

  static bool isPublic(String location) => _public.contains(_path(location));
  static bool isGate(String location) => _gates.contains(_path(location));
  static String _path(String location) => Uri.parse(location).path;
}

/// Pure redirect rule used by the router (and unit-tested directly).
///
/// Returns the path to go to, or null to stay on [location].
String? computeRedirect({
  required AuthPhase auth,
  required RiderStatus? riderStatus,
  required String location,
}) {
  final path = Uri.parse(location).path;
  switch (auth) {
    case AuthPhase.loading:
      return path == Routes.splash ? null : Routes.splash;
    case AuthPhase.signedOut:
      return Routes.isPublic(path) ? null : Routes.login;
    case AuthPhase.signedIn:
      switch (riderStatus) {
        case null:
        case RiderStatus.pending:
          return path == Routes.pending ? null : Routes.pending;
        case RiderStatus.suspended:
          return path == Routes.suspended ? null : Routes.suspended;
        case RiderStatus.active:
          return Routes.isGate(path) ? Routes.home : null;
      }
  }
}
