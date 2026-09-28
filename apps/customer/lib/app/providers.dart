import 'package:api_client/api_client.dart';
import 'package:core_models/core_models.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:local_db/local_db.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';

import '../core/secure_token_store.dart';
import '../features/auth/presentation/session_controller.dart';
import 'config.dart';

/// Overridden in `main` (and in tests) with a ready instance.
final sharedPreferencesProvider = Provider<SharedPreferences>(
  (_) => throw UnimplementedError('sharedPreferencesProvider must be overridden'),
);

/// Overridden in `main` with `await LocalStore.open()`; tests use MemoryStore.
final localStoreProvider = Provider<LocalStore>(
  (_) => throw UnimplementedError('localStoreProvider must be overridden'),
);

final tokenStoreProvider = Provider<TokenStore>((_) => SecureTokenStore());

/// Stable per-install id sent as `X-Device-Id` and used for refresh-token families.
final deviceIdProvider = Provider<String>((ref) {
  const key = 'instant.deviceId';
  final prefs = ref.watch(sharedPreferencesProvider);
  final existing = prefs.getString(key);
  if (existing != null && existing.isNotEmpty) return existing;
  final id = const Uuid().v4();
  prefs.setString(key, id);
  return id;
});

final apiClientProvider = Provider<ApiClient>((ref) {
  final config = ref.watch(appConfigProvider);
  final client = ApiClient(
    baseUrl: config.apiBaseUrl,
    tokenStore: ref.watch(tokenStoreProvider),
    deviceId: ref.watch(deviceIdProvider),
    onSessionExpired: () => ref.read(sessionControllerProvider.notifier).onSessionExpired(),
  );
  ref.onDispose(client.close);
  return client;
});

final realtimeClientProvider = Provider<RealtimeClient>((ref) {
  final config = ref.watch(appConfigProvider);
  final tokens = ref.watch(tokenStoreProvider);
  final realtime = RealtimeClient(wsUrl: config.wsUrl, tokenProvider: tokens.getAccessToken);
  ref.onDispose(realtime.dispose);
  return realtime;
});

final syncEngineProvider = Provider<SyncEngine>((ref) {
  final engine = SyncEngine(
    store: ref.watch(localStoreProvider),
    api: ref.watch(apiClientProvider).sync,
    realtime: ref.watch(realtimeClientProvider),
    collections: Collections.customerSync,
    periodicInterval: const Duration(minutes: 2),
  );
  ref.onDispose(engine.dispose);
  return engine;
});

/// Current sync status; seeded with the engine's snapshot so the UI never
/// waits for the first event.
final syncStatusProvider = StreamProvider<SyncStatus>((ref) async* {
  final engine = ref.watch(syncEngineProvider);
  yield engine.currentStatus;
  yield* engine.status;
});

/// False only when the engine knows we are offline.
final isOnlineProvider = Provider<bool>((ref) {
  final status = ref.watch(syncStatusProvider).value;
  return !(status?.isOffline ?? false);
});

/// Starts/stops the sync engine and realtime connection around a session.
abstract interface class SessionLifecycle {
  Future<void> start(String userId);
  Future<void> stop();
}

class DefaultSessionLifecycle implements SessionLifecycle {
  DefaultSessionLifecycle({required this.engine, required this.realtime});

  final SyncEngine engine;
  final RealtimeClient realtime;
  String? _userId;

  @override
  Future<void> start(String userId) async {
    _userId = userId;
    realtime.subscribe(RealtimeRooms.user(userId));
    realtime.connect();
    await engine.start();
  }

  @override
  Future<void> stop() async {
    final id = _userId;
    _userId = null;
    if (id != null) realtime.unsubscribe(RealtimeRooms.user(id));
    realtime.disconnect();
    await engine.stop();
  }
}

final sessionLifecycleProvider = Provider<SessionLifecycle>(
  (ref) => DefaultSessionLifecycle(
    engine: ref.watch(syncEngineProvider),
    realtime: ref.watch(realtimeClientProvider),
  ),
);

final imageUrlProvider = Provider<String? Function(String? imageId, {bool thumb})>((ref) {
  final catalog = ref.watch(apiClientProvider).catalog;
  return (String? imageId, {bool thumb = false}) {
    if (imageId == null || imageId.isEmpty) return null;
    return catalog.imageUrl(imageId, thumb: thumb);
  };
});
