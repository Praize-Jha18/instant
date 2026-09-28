# Shared packages — public API quick reference

Generated from the packages agent report on 2026-09-28. Source of truth is the code under `packages/`; read it when in doubt.
Import: `package:core_models/core_models.dart`, `package:api_client/api_client.dart`, `package:local_db/local_db.dart`, `package:design_system/design_system.dart`.

## core_models (pure Dart)
- `readId(Map, String)` accepts `id` or `_id`. `DateTimeConverter`.
- `Money`: `Money.fromKobo(int)`, `Money.fromNaira(num)`, `kobo`, `naira`, `format({showDecimals, showSymbol})` → `₦12,500.00`, arithmetic, `percentBps`, `Money.sum`, `Money.zero`; `int.money` extension.
- Enums: UserRole, UserStatus, VendorStatus, ProductStatus, SubOrderStatus (incl. awaitingPayment), PaymentStatus, DeliveryStatus, RiderStatus, InventoryReason, LedgerEntryType, PayoutStatus, SyncOpAction, SyncOpStatus.
- Transitions: `canTransition(from,to)`, `nextSubOrderStatuses`, `vendorNextSubOrderStatuses`, `customerCanCancel` (placed or awaitingPayment), `canTransitionDelivery`.
- Models: User, Vendor(+VendorAddress, DeliveryFeeConfig.estimateKobo, OpeningHours{weekday 1–7 read from `weekday` or backend `day`; `day` getter; `toBackendJson()`}, PayoutAccount), Category, Product(+ProductImage, ProductVariant, ProductRating; `primaryImage`, `totalStock`, `minPriceKobo`, `variantById`), InventoryMovement, Address(+AddressSnapshot, `toSnapshot`), Cart+CartItem (`addItem`, `setQty`, `removeLine`, `subtotalKobo`, `itemsByVendor`), Order, CheckoutPayload{order, subOrders, paymentId?, clientSecret?, providerRef?, provider, publishableKey?}, SubOrder(+TimelineEntry; `deliveryOtp`, `orderNumber`, `vendorNameSnapshot`, `refundedKobo`), Payment, VendorLedgerEntry, Payout, RiderProfile(+RiderDocument, `user: RiderUserSummary?`, `lastLocation: RiderLastLocation?`, `displayName`, `displayPhone`), RiderLocation, Delivery(+DeliveryOffer, DeliveryProof, PickupPoint, DropoffPoint), AppNotification, AuthTokens, AuthUser, AuthResponse{accessToken, refreshToken, user?}, GeoPoint, OrderTracking/SubOrderTracking{subOrderId, vendorId, status, deliveryId?, deliveryStatus?, riderId?, riderLocation?}, AdminStats{counts: AdminCounts, revenue: AdminRevenue{today,last7d,last30d: RevenueWindow}, generatedAt}.
- Sync DTOs: SyncOp{opId, entity, action, customAction?, payload, clientAt}, SyncPushRequest/Result/Response, SyncPullResponse.
- API DTOs: RegisterRequest, LoginRequest, CreateOrderRequest, StockAdjustRequest, UpdateSubOrderStatusRequest, AssignDeliveryRequest, RiderLocationUpdate, UpdateRiderProfileRequest, RespondDeliveryRequest, DeliverRequest, RequestPayoutRequest, MarkPayoutPaidRequest, ProductInput, AddressInput, VendorInput, CategoryInput, CartInput, UploadedImage.
- `Paginated<T>{items, nextCursor, hasMore}`. `Collections` string constants + `customerSync/vendorSync/riderSync` lists. `ModelRegistry` (`forCollection`, `decode`).
- Nulls are omitted from toJson (`include_if_null: false`).

## api_client
```dart
ApiClient({required String baseUrl, required TokenStore tokenStore, FutureOr<void> Function()? onSessionExpired, String? deviceId, ...});
  auth, catalog, customer, vendor, rider, admin, payments, notifications, sync;  String absoluteUrl(String path);  Future<void> clearSession();
sealed class ApiException { code, message, statusCode, details, isOffline, isUnauthorized }  // OfflineException, TimeoutException, ValidationException, UnauthorizedException, ForbiddenException, NotFoundException, ConflictException, RateLimitedException, ServerException, ...
abstract interface class TokenStore { getAccessToken(); getRefreshToken(); setTokens({accessToken, refreshToken}); clear(); }  // MemoryTokenStore provided; apps implement a secure one
AuthApi: register(RegisterRequest), login(LoginRequest) → AuthResponse (persists tokens), refresh, logout(), me() → User
CatalogApi: vendors({lat,lng,q,cursor,limit}) → Paginated<Vendor>, vendorBySlug, categories(), products({vendorId,categoryId,q,cursor,limit}), product(id), imageUrl(id,{thumb})
CustomerApi: getCart, putCart(CartInput), addresses, createAddress, updateAddress, deleteAddress, createOrder(CreateOrderRequest) → CheckoutPayload, orders({cursor,limit}), order(id), cancelOrder(id), tracking(orderId) → OrderTracking
VendorApi: profile, updateProfile(VendorInput), uploadVendorImage({kind: 'logo'|'cover', bytes, filename, contentType, onProgress}) → Vendor, products({status,q,cursor,limit}), product, createProduct(ProductInput), updateProduct, deleteProduct, uploadProductImage(id,{bytes,filename,contentType,sortOrder,onProgress}) → Product, deleteProductImage, adjustStock(id, StockAdjustRequest), inventoryMovements, orders({status,cursor,limit}) → Paginated<SubOrder>, updateOrderStatus(subOrderId, SubOrderStatus,{note}), riders({status}), approveRider, suspendRider, deliveries({status,...}), assignDelivery(id, riderId), autoAssignDelivery(id), ledger, payouts, requestPayout
RiderApi: profile, updateProfile, setOnline(bool), sendLocation(RiderLocationUpdate), deliveries({status,...}), delivery(id), respond(id,{accept}), pickup(id), deliver(id,{otp, photoBytes, photoFilename, photoContentType})
AdminApi: vendors({status,q,...}), updateVendor, approveVendor, suspendVendor, orders, users({q,role,...}), payouts({status}), markPayoutPaid(id,{reference}), categories, createCategory, updateCategory, deleteCategory, stats() → AdminStats
PaymentsApi: retry(orderId) → CheckoutPayload
NotificationsApi: list({cursor,limit,unreadOnly}) → Paginated<AppNotification>, unreadCount() → int, markRead(id), markAllRead() → int
SyncApi implements SyncTransport: pull({collections, since, cursor, limit}), push(List<SyncOp>)
RealtimeClient({required wsUrl, required Future<String?> Function() tokenProvider, namespace='/rt'});
  changed: Stream<ChangedEvent{collection,id,doc,model}>, removed, riderLocations: Stream<RiderLocationEvent{deliveryId,riderId,lat,lng,heading,speed,at}>, connectionState, isConnected;
  connect(), disconnect(), subscribe(room), unsubscribe(room), bool sendRiderLocation(RiderLocationUpdate), dispose()
RealtimeRooms.user(id) / vendor(id) / order(id) / delivery(id)
```

## local_db
```dart
LocalStore.open({directory, name}) → MemoryStore on web, ObjectBoxStore otherwise
  upsert<T>(collection, model), upsertAll, upsertJson, delete(collection,id), getById<T>, getAll<T>,
  watchAll<T>(collection, {filter, sortBy}) → Stream<List<T>>, watchById<T>, query<T>(collection, predicate), count, clearCollection, clear() (sign-out), close()
  // T is the registered model for the collection, e.g. store.watchAll<Product>(Collections.products)
  cursors: getCursor/setCursor;  outbox: enqueue, watchPending, pending, rejected, markApplied, markRejected, retry, discard, pendingCount, watchPendingCount
SyncEngine({required store, required SyncTransport api, required List<String> collections, RealtimeClient? realtime, ConnectivityMonitor? connectivity, ...});
  status: Stream<SyncStatus{phase idle|syncing|offline|error, pendingCount, rejectedCount, lastSyncedAt, isOffline, isSyncing, hasPending}>, isOnline
  start(), stop(), dispose(), requestSync({immediate}), sync(), pull({only}), pushOutbox(),
  enqueueUpsert<T>(collection, model), enqueueDelete(collection,id), enqueueCustom(entity, customAction, payload), retryRejected, discardRejected
```

## design_system
- Tokens: `AppColors`, `AppSemanticColors` via `context.semanticColors / context.colors / context.text`, `AppSpacing` (xxs…xxxl, page, pageH, gapXs…gapXxl), `AppRadius` (sm 12, md 16, lg 24, smAll/mdAll/lgAll/pill), `AppMotion` (fast/normal/slow, curve), `AppTypography.configure({allowRuntimeFetching, useGoogleFonts})`.
- `AppTheme.light({seed})`, `AppTheme.dark({seed})`.
- Widgets: `AppButton.primary/.secondary/.ghost/.danger({loading, icon, expanded, size, haptic, tooltip})`, `AppTextField` (+ `.email()`, `.password()`), `AppCard`, `Skeleton`, `SkeletonList`, `SkeletonListTile`, `SkeletonCard`, `EmptyState`, `ErrorState({offline, onRetry})`, `StatusChip.subOrder/.delivery/.payment/.vendor/.rider/.payout`, `MoneyText(.kobo)`, `ConnectivityBanner.stream(stream:, offline:, pendingCount:, syncing:, error:)`, `AppImage({heroTag, aspectRatio})`, `QuantityStepper`, `AppBottomSheet.show/.confirm`, `SectionHeader`, `AppListTile`, `FadeSlideIn(.staggered(index:))`, `AnimatedPressable`.

## Wiring sketch
```dart
final tokens = SecureTokenStore();                    // app implements TokenStore with flutter_secure_storage
final client = ApiClient(baseUrl: apiBaseUrl, tokenStore: tokens, onSessionExpired: goToLogin);
final realtime = RealtimeClient(wsUrl: wsUrl, tokenProvider: tokens.getAccessToken);
final store = await LocalStore.open();
final engine = SyncEngine(store: store, api: client.sync, realtime: realtime, collections: Collections.customerSync);
await engine.start(); realtime.connect(); realtime.subscribe(RealtimeRooms.user(userId));
```
