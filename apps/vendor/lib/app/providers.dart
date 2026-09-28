import 'dart:async';

import 'package:api_client/api_client.dart';
import 'package:core_models/core_models.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:local_db/local_db.dart';

import '../core/secure_token_store.dart';
import '../core/session_cache.dart';
import 'config.dart';
import 'session.dart';

/// Where tokens live. Tests override with `MemoryTokenStore`.
final tokenStoreProvider = Provider<TokenStore>((ref) => SecureTokenStore());

/// Session metadata cache (user JSON for offline restore, theme).
final sessionCacheProvider = Provider<SessionCache>((ref) => SecureSessionCache());

/// The local database. Opened in `main()` and injected with an override so
/// widgets never await it; tests inject a `MemoryStore`.
final localStoreProvider = Provider<LocalStore>(
  (ref) => throw UnimplementedError('localStoreProvider must be overridden'),
);

/// Device id sent as `X-Device-Id` and used for refresh-token families.
final deviceIdProvider = Provider<String>((ref) => 'vendor-app');

final apiClientProvider = Provider<ApiClient>((ref) {
  final client = ApiClient(
    baseUrl: AppConfig.apiBaseUrl,
    tokenStore: ref.watch(tokenStoreProvider),
    deviceId: ref.watch(deviceIdProvider),
    onSessionExpired: () => ref.read(sessionProvider.notifier).onSessionExpired(),
  );
  ref.onDispose(client.close);
  return client;
});

final realtimeClientProvider = Provider<RealtimeClient>((ref) {
  final tokens = ref.watch(tokenStoreProvider);
  final client = RealtimeClient(wsUrl: AppConfig.wsUrl, tokenProvider: tokens.getAccessToken);
  ref.onDispose(client.dispose);
  return client;
});

/// The session-scoped sync engine (null while signed out).
final syncEngineProvider = Provider<SyncEngine?>((ref) => ref.watch(sessionProvider.select((s) => s.engine)));

/// Live sync status; idle when there is no engine.
final syncStatusProvider = StreamProvider<SyncStatus>((ref) {
  final engine = ref.watch(syncEngineProvider);
  if (engine == null) return Stream.value(const SyncStatus());
  return _withInitial(engine.status, engine.currentStatus);
});

/// True unless the engine reports offline. Online-only actions gate on this.
final isOnlineProvider = Provider<bool>((ref) {
  final status = ref.watch(syncStatusProvider).value;
  return !(status?.isOffline ?? false);
});

/// Realtime connection state for the header indicator.
final realtimeStateProvider = StreamProvider<RealtimeConnectionState>((ref) {
  final rt = ref.watch(realtimeClientProvider);
  return _withInitial(rt.connectionState, rt.currentState);
});

Stream<T> _withInitial<T>(Stream<T> stream, T initial) async* {
  yield initial;
  yield* stream;
}

// ---- Theme ------------------------------------------------------------------

class ThemeModeNotifier extends Notifier<ThemeMode> {
  @override
  ThemeMode build() {
    _load();
    return ThemeMode.system;
  }

  Future<void> _load() async {
    final raw = await ref.read(sessionCacheProvider).read(SessionCacheKeys.themeMode);
    final mode = ThemeMode.values.where((m) => m.name == raw).firstOrNull;
    if (mode != null) state = mode;
  }

  Future<void> set(ThemeMode mode) async {
    state = mode;
    await ref.read(sessionCacheProvider).write(SessionCacheKeys.themeMode, mode.name);
  }
}

final themeModeProvider = NotifierProvider<ThemeModeNotifier, ThemeMode>(ThemeModeNotifier.new);

// ---- Local store streams ----------------------------------------------------
//
// Every list screen renders from these (§9). The sync engine and realtime
// events fill the store; pull-to-refresh calls `engine.pull()`.

int _newestFirst(DateTime? a, DateTime? b) {
  if (a == null && b == null) return 0;
  if (a == null) return 1;
  if (b == null) return -1;
  return b.compareTo(a);
}

final vendorStreamProvider = StreamProvider<Vendor?>((ref) {
  final vendorId = ref.watch(sessionProvider.select((s) => s.user?.vendorId));
  if (vendorId == null) return Stream.value(null);
  return ref.watch(localStoreProvider).watchById<Vendor>(Collections.vendors, vendorId);
});

final categoriesStreamProvider = StreamProvider<List<Category>>((ref) => ref
    .watch(localStoreProvider)
    .watchAll<Category>(Collections.categories, sortBy: (a, b) => a.sortOrder.compareTo(b.sortOrder)));

final productsStreamProvider = StreamProvider<List<Product>>((ref) => ref
    .watch(localStoreProvider)
    .watchAll<Product>(Collections.products, sortBy: (a, b) => _newestFirst(a.updatedAt, b.updatedAt)));

final productStreamProvider = StreamProvider.family<Product?, String>(
    (ref, id) => ref.watch(localStoreProvider).watchById<Product>(Collections.products, id));

final subOrdersStreamProvider = StreamProvider<List<SubOrder>>((ref) => ref.watch(localStoreProvider).watchAll<SubOrder>(
      Collections.subOrders,
      filter: (s) => s.status != SubOrderStatus.awaitingPayment,
      sortBy: (a, b) => _newestFirst(a.createdAt, b.createdAt),
    ));

final subOrderStreamProvider = StreamProvider.family<SubOrder?, String>(
    (ref, id) => ref.watch(localStoreProvider).watchById<SubOrder>(Collections.subOrders, id));

final deliveriesStreamProvider = StreamProvider<List<Delivery>>((ref) => ref
    .watch(localStoreProvider)
    .watchAll<Delivery>(Collections.deliveries, sortBy: (a, b) => _newestFirst(a.createdAt, b.createdAt)));

final deliveryStreamProvider = StreamProvider.family<Delivery?, String>(
    (ref, id) => ref.watch(localStoreProvider).watchById<Delivery>(Collections.deliveries, id));

final ridersStreamProvider = StreamProvider<List<RiderProfile>>((ref) => ref.watch(localStoreProvider).watchAll<RiderProfile>(
      Collections.riderProfiles,
      sortBy: (a, b) => (a.fullName ?? '').compareTo(b.fullName ?? ''),
    ));

final riderStreamProvider = StreamProvider.family<RiderProfile?, String>(
    (ref, id) => ref.watch(localStoreProvider).watchById<RiderProfile>(Collections.riderProfiles, id));

final ledgerStreamProvider = StreamProvider<List<VendorLedgerEntry>>((ref) => ref
    .watch(localStoreProvider)
    .watchAll<VendorLedgerEntry>(Collections.vendorLedger, sortBy: (a, b) => _newestFirst(a.createdAt, b.createdAt)));

final payoutsStreamProvider = StreamProvider<List<Payout>>((ref) => ref
    .watch(localStoreProvider)
    .watchAll<Payout>(Collections.payouts, sortBy: (a, b) => _newestFirst(a.createdAt, b.createdAt)));

final movementsStreamProvider = StreamProvider.family<List<InventoryMovement>, String>(
    (ref, productId) => ref.watch(localStoreProvider).watchAll<InventoryMovement>(
          Collections.inventoryMovements,
          filter: (m) => m.productId == productId,
          sortBy: (a, b) => _newestFirst(a.createdAt, b.createdAt),
        ));

final ordersStreamProvider = StreamProvider<List<Order>>((ref) => ref
    .watch(localStoreProvider)
    .watchAll<Order>(Collections.orders, sortBy: (a, b) => _newestFirst(a.createdAt, b.createdAt)));

final vendorsStreamProvider = StreamProvider<List<Vendor>>((ref) => ref
    .watch(localStoreProvider)
    .watchAll<Vendor>(Collections.vendors, sortBy: (a, b) => _newestFirst(a.createdAt, b.createdAt)));

/// Pull-to-refresh helper: pulls the given collections (or all) and swallows
/// transport errors (the banner already shows them).
Future<void> refreshCollections(WidgetRef ref, [List<String>? only]) async {
  final engine = ref.read(syncEngineProvider);
  if (engine == null) return;
  try {
    await engine.pull(only: only);
  } catch (_) {}
}
