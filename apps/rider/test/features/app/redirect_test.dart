import 'package:core_models/core_models.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:instant_rider/app/redirect.dart';
import 'package:instant_rider/features/auth/domain/session_state.dart';

void main() {
  String? go(AuthPhase auth, RiderStatus? status, String location) =>
      computeRedirect(auth: auth, riderStatus: status, location: location);

  group('computeRedirect', () {
    test('while restoring the session everything goes to splash', () {
      expect(go(AuthPhase.loading, null, Routes.home), Routes.splash);
      expect(go(AuthPhase.loading, null, Routes.login), Routes.splash);
      expect(go(AuthPhase.loading, null, Routes.splash), isNull);
    });

    test('signed out users only see login and register', () {
      expect(go(AuthPhase.signedOut, null, Routes.login), isNull);
      expect(go(AuthPhase.signedOut, null, Routes.register), isNull);
      expect(go(AuthPhase.signedOut, null, Routes.home), Routes.login);
      expect(go(AuthPhase.signedOut, null, Routes.splash), Routes.login);
      expect(go(AuthPhase.signedOut, null, '/active/abc'), Routes.login);
    });

    test('pending riders are parked on the approval screen', () {
      expect(go(AuthPhase.signedIn, RiderStatus.pending, Routes.home), Routes.pending);
      expect(go(AuthPhase.signedIn, RiderStatus.pending, Routes.splash), Routes.pending);
      expect(go(AuthPhase.signedIn, RiderStatus.pending, Routes.pending), isNull);
    });

    test('an unknown profile status is treated as pending', () {
      expect(go(AuthPhase.signedIn, null, Routes.home), Routes.pending);
    });

    test('suspended riders are blocked', () {
      expect(go(AuthPhase.signedIn, RiderStatus.suspended, Routes.home), Routes.suspended);
      expect(go(AuthPhase.signedIn, RiderStatus.suspended, Routes.suspended), isNull);
    });

    test('active riders leave the gate screens and can use the app', () {
      expect(go(AuthPhase.signedIn, RiderStatus.active, Routes.splash), Routes.home);
      expect(go(AuthPhase.signedIn, RiderStatus.active, Routes.login), Routes.home);
      expect(go(AuthPhase.signedIn, RiderStatus.active, Routes.pending), Routes.home);
      expect(go(AuthPhase.signedIn, RiderStatus.active, Routes.suspended), Routes.home);
      expect(go(AuthPhase.signedIn, RiderStatus.active, Routes.home), isNull);
      expect(go(AuthPhase.signedIn, RiderStatus.active, Routes.deliveries), isNull);
      expect(go(AuthPhase.signedIn, RiderStatus.active, '/deliveries/d1'), isNull);
      expect(go(AuthPhase.signedIn, RiderStatus.active, '/active/d1'), isNull);
      expect(go(AuthPhase.signedIn, RiderStatus.active, Routes.locationPermission), isNull);
    });

    test('ignores query strings when matching', () {
      expect(go(AuthPhase.signedOut, null, '/login?next=%2Fhome'), isNull);
      expect(go(AuthPhase.signedIn, RiderStatus.active, '/splash?x=1'), Routes.home);
    });

    test('approval flips the redirect from pending to home', () {
      // Simulates the realtime `changed` event on riderProfiles.
      expect(go(AuthPhase.signedIn, RiderStatus.pending, Routes.pending), isNull);
      expect(go(AuthPhase.signedIn, RiderStatus.active, Routes.pending), Routes.home);
    });
  });
}
