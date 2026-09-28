import 'package:api_client/api_client.dart';
import 'package:core_models/core_models.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../app/providers.dart';
import '../../auth/data/rider_profile_provider.dart';

/// How an online/offline change was applied.
enum OnlineChange { applied, queued }

/// Toggles `isOnline`. Online it PATCHes `/rider/profile`; offline (or when the
/// PATCH fails on transport) it writes the profile locally and queues an
/// `upsert riderProfiles` op, which is in the offline-safe tier (§7).
class OnlineController extends Notifier<bool> {
  @override
  bool build() => false; // busy flag

  Future<OnlineChange> setOnline(bool value) async {
    final profile = ref.read(currentRiderProfileProvider);
    if (profile == null) throw StateError('No rider profile loaded');
    final engine = ref.read(syncEngineProvider);
    final api = ref.read(apiClientProvider);
    final store = ref.read(localStoreProvider);
    state = true;
    try {
      if (engine.isOnline) {
        try {
          final updated = await api.rider.setOnline(value);
          await store.upsert(Collections.riderProfiles, updated);
          return OnlineChange.applied;
        } on ApiException catch (e) {
          if (!e.isOffline) rethrow;
        }
      }
      await engine.enqueueUpsert(
        Collections.riderProfiles,
        profile.copyWith(isOnline: value, lastSeenAt: DateTime.now().toUtc()),
      );
      return OnlineChange.queued;
    } finally {
      state = false;
    }
  }
}

final onlineControllerProvider = NotifierProvider<OnlineController, bool>(OnlineController.new);
