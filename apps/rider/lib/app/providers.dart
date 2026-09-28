import 'package:api_client/api_client.dart';
import 'package:core_models/core_models.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:local_db/local_db.dart';

import '../core/secure_token_store.dart';
import '../features/auth/data/auth_controller.dart';
import 'config.dart';

/// Token persistence. Overridden with [MemoryTokenStore] in tests.
final tokenStoreProvider = Provider<TokenStore>((ref) => SecureTokenStore());

/// The opened [LocalStore]. `main()` opens it before `runApp` and overrides
/// this provider with the instance, so reading it is synchronous everywhere.
final localStoreProvider = Provider<LocalStore>(
  (ref) => throw UnimplementedError('localStoreProvider must be overridden in main()'),
);

/// REST client. `onSessionExpired` is wired to the auth controller lazily so
/// there is no provider cycle.
final apiClientProvider = Provider<ApiClient>((ref) {
  final client = ApiClient(
    baseUrl: AppConfig.apiBaseUrl,
    tokenStore: ref.watch(tokenStoreProvider),
    onSessionExpired: () => ref.read(authControllerProvider.notifier).handleSessionExpired(),
  );
  ref.onDispose(client.close);
  return client;
});

/// Socket.IO client for `/rt`.
final realtimeClientProvider = Provider<RealtimeClient>((ref) {
  final tokens = ref.watch(tokenStoreProvider);
  final client = RealtimeClient(wsUrl: AppConfig.wsUrl, tokenProvider: tokens.getAccessToken);
  ref.onDispose(client.dispose);
  return client;
});

/// Connectivity source for the engine (overridable in tests).
final connectivityMonitorProvider = Provider<ConnectivityMonitor>((ref) => ConnectivityPlusMonitor());

/// The sync engine for the rider collections (§7).
final syncEngineProvider = Provider<SyncEngine>((ref) {
  final engine = SyncEngine(
    store: ref.watch(localStoreProvider),
    api: ref.watch(apiClientProvider).sync,
    realtime: ref.watch(realtimeClientProvider),
    connectivity: ref.watch(connectivityMonitorProvider),
    collections: Collections.riderSync,
    periodicInterval: const Duration(minutes: 2),
  );
  ref.onDispose(engine.dispose);
  return engine;
});

/// Live sync status, seeded with the engine's current snapshot.
final syncStatusProvider = StreamProvider<SyncStatus>((ref) async* {
  final engine = ref.watch(syncEngineProvider);
  yield engine.currentStatus;
  yield* engine.status;
});

/// True when the engine believes we can reach the server.
final isOnlineProvider = Provider<bool>((ref) {
  final status = ref.watch(syncStatusProvider).value;
  if (status == null) return ref.watch(syncEngineProvider).isOnline;
  return !status.isOffline;
});
