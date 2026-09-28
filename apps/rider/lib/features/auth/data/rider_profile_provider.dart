import 'package:core_models/core_models.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../app/providers.dart';
import '../domain/session_state.dart';
import 'auth_controller.dart';

/// Live rider profile from the local store (fed by sync + realtime), falling
/// back to the snapshot captured at sign-in until the first emission.
final riderProfileProvider = StreamProvider<RiderProfile?>((ref) {
  final session = ref.watch(authControllerProvider);
  if (session is! SignedIn) return Stream.value(null);
  final store = ref.watch(localStoreProvider);
  final userId = session.user.id;
  return store
      .watchAll<RiderProfile>(
        Collections.riderProfiles,
        filter: (p) => p.userId == userId,
      )
      .map((list) => list.isEmpty ? session.profile : list.first);
});

/// Best-known profile right now (stream value, else sign-in snapshot).
final currentRiderProfileProvider = Provider<RiderProfile?>((ref) {
  final session = ref.watch(authControllerProvider);
  if (session is! SignedIn) return null;
  final live = ref.watch(riderProfileProvider);
  return live.value ?? session.profile;
});

/// Whether [id] refers to this rider. `deliveries.riderId` / `offeredTo[].riderId`
/// may carry the rider profile id or the user id depending on the backend, so
/// both are accepted.
final riderIdMatcherProvider = Provider<bool Function(String? id)>((ref) {
  final user = ref.watch(currentUserProvider);
  final profile = ref.watch(currentRiderProfileProvider);
  final ids = <String>{if (user != null) user.id, if (profile != null) profile.id};
  return (id) => id != null && ids.contains(id);
});
