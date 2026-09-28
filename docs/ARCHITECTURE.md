# Instant — Architecture Contract

Multi-vendor commerce and delivery platform. Vendors list products, customers order and pay,
vendors dispatch their own riders. This document is the contract every package follows.
If code and this document disagree, fix one of them in the same change.

## 1. Repository layout

```
instant/
  backend/                NestJS 11 + Mongoose. REST + Socket.IO. Single deployable.
  apps/
    customer/             Flutter (Android, iOS). Browse, order, pay, track.
    rider/                Flutter (Android, iOS). Vendor riders. Background location.
    vendor/               Flutter (Android, iOS, Web). Vendor owner/staff + platform admin views.
  packages/
    core_models/          Pure Dart. Freezed models, enums, JSON. No Flutter imports.
    api_client/           Dart. Dio REST client, auth interceptor, token refresh, Socket.IO client.
    local_db/             Flutter. ObjectBox entities, outbox, SyncEngine. In-memory fallback on web.
    design_system/        Flutter. Theme tokens, typography, motion, shared widgets.
  docs/                   This file plus ADRs.
  pubspec.yaml            Dart pub workspace root.
```

Dart packages use `resolution: workspace`. Apps depend on packages by path via the workspace.

## 2. Roles

`customer`, `rider`, `vendor_owner`, `vendor_staff`, `admin`.

- A user has `roles: string[]`. One account may hold several roles.
- `rider`, `vendor_owner`, `vendor_staff` carry a `vendorId`. Riders belong to exactly one vendor.
- `admin` is the platform operator. Created via a seed script, never via public registration.
- Every REST route and every socket room checks role AND ownership (vendorId / userId).

## 3. Authentication (Phase 1: email + password, Firebase later)

- Register: `POST /auth/register { email, password, fullName, phone?, role: 'customer' | 'rider' | 'vendor_owner' }`
  - Password: min 8 chars. Hashed with bcrypt cost 12. Email lowercased and unique.
  - `vendor_owner` registration also creates a `vendors` doc with `status: 'pending'`.
  - `rider` registration requires `vendorId`; rider profile is created with `status: 'pending'` until the vendor approves.
- Login: `POST /auth/login { email, password }` → `{ accessToken, refreshToken, user }`
- Access token: JWT HS256, 15 min, payload `{ sub, roles, vendorId? }`.
- Refresh token: opaque 64-byte random, 30 days, stored as SHA-256 hash in `refreshTokens` with deviceId. Rotated on every use. Reuse of a rotated token revokes the whole family.
- `POST /auth/refresh { refreshToken }`, `POST /auth/logout { refreshToken }`, `GET /auth/me`.
- Auth provider is behind `AuthProvider` interface in backend (`LocalPasswordProvider` now, `FirebaseProvider` later). Flutter apps call `AuthRepository` only; they never know the mechanism.

## 4. Data model (MongoDB)

All documents carry: `_id: ObjectId`, `createdAt`, `updatedAt`, `deletedAt: Date | null`, `version: number`.
`updatedAt` and `version` are bumped on every write by a Mongoose plugin. Soft delete only, never hard delete
(the sync protocol needs tombstones). Indexes on `updatedAt` for every synced collection.

| Collection | Key fields |
|---|---|
| `users` | email (unique), passwordHash, fullName, phone, roles[], vendorId?, avatarImageId?, status: active/suspended |
| `refreshTokens` | userId, tokenHash, familyId, deviceId, expiresAt, revokedAt |
| `vendors` | name, slug (unique), description, logoImageId, coverImageId, ownerUserId, status: pending/active/suspended, address {line1, city, state, country:'NG', lat, lng}, deliveryFee {baseKobo, perKmKobo, freeAboveKobo?}, deliveryRadiusKm, openingHours[], commissionBps (platform take, default 1000 = 10%), payout {bankName, accountNumber, accountName} |
| `categories` | name, slug, parentId?, sortOrder, imageId? |
| `products` | vendorId, name, slug, description, categoryIds[], images: [{imageId, sortOrder}], basePriceKobo, variants: [{ _id, name, sku, priceKobo, stock, attributes{} }], hasVariants, stock (when no variants), status: draft/active/archived, tags[], rating {avg, count}, searchText |
| `inventoryMovements` | vendorId, productId, variantId?, delta, reason: sale/restock/adjustment/return/cancel, orderId?, byUserId, note |
| `images` | data: Buffer, thumb: Buffer, contentType, size, width, height, ownerType, ownerId, uploadedBy. Max 2 MB upload; server resizes to max 1200px and 200px thumb with sharp. Served at `GET /images/:id` and `GET /images/:id?size=thumb` with long cache headers. **Swap to blob storage later by changing only ImagesService.** |
| `addresses` | userId, label, line1, line2, city, state, lat, lng, phone, isDefault |
| `carts` | userId (unique), items: [{productId, variantId?, vendorId, qty, priceKoboSnapshot, nameSnapshot}], client-owned, synced via outbox |
| `orders` | customerId, orderNumber, subOrderIds[], addressSnapshot, subtotalKobo, deliveryTotalKobo, totalKobo, currency:'NGN', paymentStatus: pending/paid/failed/refunded/partially_refunded, paymentId?, placedAt |
| `subOrders` | orderId, vendorId, customerId, items[] (same snapshot as cart), subtotalKobo, deliveryFeeKobo, commissionKobo, vendorNetKobo, status (see §6), deliveryId?, timeline: [{status, at, byUserId?, note?}] |
| `payments` | orderId, provider: 'stripe', providerRef (PaymentIntent id), amountKobo, currency, status, rawEvents[] (last 20), idempotencyKey |
| `vendorLedger` | vendorId, subOrderId, type: sale/commission/refund/payout, amountKobo (signed), balanceAfterKobo |
| `payouts` | vendorId, amountKobo, status: requested/paid/failed, method: manual, reference, paidAt |
| `riderProfiles` | userId, vendorId, status: pending/active/suspended, vehicleType, plateNumber, documents: [{type, imageId}], isOnline, lastSeenAt, currentDeliveryId? |
| `riderLocations` | riderId, vendorId, lat, lng, heading, speed, at. Time-series-like, TTL index 24h. |
| `deliveries` | subOrderId, vendorId, riderId?, status: unassigned/offered/accepted/picked_up/delivered/failed, pickup {lat,lng}, dropoff {lat,lng,addressSnapshot}, offeredTo: [{riderId, at, response}], proof {photoImageId?, otp, otpVerifiedAt?}, timeline[] |
| `notifications` | userId, type, title, body, data{}, readAt |
| `syncOps` | opId (unique), userId, entity, action, result, processedAt. Idempotency log for push. TTL 30 days. |

Money is always integer kobo. Currency is NGN everywhere for now but stored on the order.

## 5. REST API (prefix `/api/v1`)

Auth described in §3. All others require Bearer token unless marked public.

```
Public catalogue
  GET  /vendors?near=lat,lng&q=                     active vendors
  GET  /vendors/:slug
  GET  /categories
  GET  /products?vendorId=&categoryId=&q=&cursor=   active products, Atlas Search when q present
  GET  /products/:id
  GET  /images/:id[?size=thumb]

Customer
  GET/PUT      /me/cart                              full replace, client is source of truth
  CRUD         /me/addresses
  POST         /orders                               from cart → creates order + subOrders, returns checkout payload
  GET          /orders, /orders/:id
  POST         /orders/:id/cancel                    only while subOrder status is 'placed'
  GET          /orders/:id/tracking                  rider location + status per subOrder

Vendor (role vendor_owner|vendor_staff, scoped to own vendorId)
  GET/PATCH    /vendor                               own vendor profile
  CRUD         /vendor/products, POST /vendor/products/:id/images (multipart), DELETE .../images/:imageId
  POST         /vendor/products/:id/stock            { variantId?, delta, reason, note }
  GET          /vendor/inventory/movements
  GET          /vendor/orders?status=                own subOrders
  POST         /vendor/orders/:subOrderId/status     { status } follows §6 transitions
  GET          /vendor/riders, POST /vendor/riders/:id/approve|suspend
  POST         /vendor/deliveries/:id/assign          { riderId }   manual assignment
  POST         /vendor/deliveries/:id/auto-assign                   nearest online rider of this vendor
  GET          /vendor/ledger, GET /vendor/payouts, POST /vendor/payouts (request)

Rider (role rider)
  GET/PATCH    /rider/profile                        { isOnline }
  POST         /rider/location                       { lat, lng, heading?, speed?, at }  (also via socket)
  GET          /rider/deliveries?status=
  POST         /rider/deliveries/:id/respond          { accept: boolean }
  POST         /rider/deliveries/:id/pickup
  POST         /rider/deliveries/:id/deliver          { otp } or multipart photo

Admin (role admin)
  GET/PATCH    /admin/vendors, POST /admin/vendors/:id/approve|suspend
  GET          /admin/orders, /admin/users, /admin/payouts, POST /admin/payouts/:id/mark-paid
  CRUD         /admin/categories
  GET          /admin/stats

Payments
  POST         /payments/webhook/stripe              raw body, signature verified
  POST         /payments/:orderId/retry

Sync (see §7)
  GET          /sync/pull?since=<iso>&collections=a,b
  POST         /sync/push
```

Errors: `{ statusCode, code: 'SNAKE_CASE', message, details? }`. Pagination: `{ items, nextCursor }`.

## 6. Order and delivery state machines

SubOrder status:
```
placed → accepted → preparing → ready → out_for_delivery → delivered
placed|accepted|preparing → cancelled   (by vendor, or by customer only while 'placed')
```
Delivery status: `unassigned → offered → accepted → picked_up → delivered | failed`.
Delivery is created when subOrder hits `ready`. `picked_up` moves subOrder to `out_for_delivery`; `delivered` moves it to `delivered` and writes vendorLedger sale + commission rows.

Payment gate: an order is `placed` for vendors only after the payment webhook confirms. Before that the
subOrders exist with status `awaiting_payment` and are hidden from vendors. Unpaid orders expire after 30 min and
release reserved stock.

Stock: reserved atomically (`$inc` with `stock >= qty` filter) when the order is created; on payment failure or
expiry it is released. Stock is never changed from the client.

## 7. Offline and sync protocol

Every Flutter screen reads from local_db. Network only fills local_db.

Tiers:
- Offline safe, queued in the outbox: cart, addresses, favourites, rider location, rider isOnline, proof of delivery, vendor stock adjustments, vendor product edits.
- Online only, the UI says so: register/login, place order, pay, respond to delivery offer.

Pull: `GET /sync/pull?since=2026-01-01T00:00:00.000Z&collections=products,vendors,categories,orders,subOrders,deliveries`
- Server returns docs where `updatedAt > since - 2s` (overlap for clock skew) scoped to what the caller may see.
- Response `{ changes: { products: [...], orders: [...] }, tombstones: { products: [ids] }, serverTime }`.
- Client upserts by id, deletes tombstones, stores `serverTime` as next cursor per collection.
- Products/vendors/categories are paged with `cursor` inside the same call when large.

Push: `POST /sync/push { ops: [{ opId (uuid v4), entity, action: 'upsert'|'delete'|'custom', payload, clientAt }] }`
- Server processes ops in order, idempotently by `opId` (via `syncOps`). Returns `{ results: [{ opId, status: 'applied'|'duplicate'|'rejected', code?, doc? }] }`.
- Client removes applied/duplicate ops from the outbox, surfaces rejected ones.
- Conflicts: last-write-wins by `clientAt` for client-owned entities (cart, addresses, product text fields). Server-authoritative for stock, prices in orders, statuses. Custom actions (e.g. `stock.adjust`) are applied as deltas, never absolute values, so replays are safe.

Realtime: Socket.IO namespace `/rt`, auth via access token in handshake. Rooms: `user:{id}`, `vendor:{id}`, `order:{id}`, `delivery:{id}`.
Events from server: `changed { collection, id, doc }`, `removed { collection, id }`, `rider.location { deliveryId, lat, lng, heading, at }`.
Events from client: `rider.location`, `subscribe { room }`. Backend fans out from MongoDB Change Streams.
On reconnect the client performs a pull, so realtime is an optimisation, never the source of truth.

Local DB: ObjectBox on Android/iOS/macOS. On web `local_db` provides an in-memory `LocalStore` (vendor web dashboard is online-only). All app code depends on the `LocalStore` interface, never on ObjectBox types.

## 8. Payments

`PaymentProvider` interface in backend: `createIntent(order) → { clientSecret, providerRef }`, `parseWebhook(rawBody, headers) → PaymentEvent`, `refund(payment, amountKobo)`.
- `StripeProvider` is the first implementation. Currency `ngn`, amounts in kobo.
- Vendor payouts are NOT via Stripe Connect (unavailable for Nigerian businesses). Earnings accrue in `vendorLedger`; payouts are requested by vendors and marked paid by admin (manual bank transfer). A `PaystackProvider` can be added later without touching order code.
- Webhook is idempotent on provider event id.

## 9. Flutter conventions

- State: Riverpod 3 (`riverpod_annotation`). Navigation: go_router. Models: freezed + json_serializable.
- Feature-first folders: `lib/features/<feature>/{data,domain,presentation}`.
- Every list screen renders from a `LocalStore` stream. Pull-to-refresh triggers `SyncEngine.pull()`.
- A global `ConnectivityBanner` shows offline state; online-only actions are disabled with a tooltip while offline.
- Design system: 4pt spacing scale, radius 12/16/24, motion 150/250/400 ms with `Curves.easeOutCubic`, hero transitions on product images, skeleton loaders, haptics on primary actions. Light and dark themes from the same tokens.
- Money formatting: `₦12,500.00` via `Money.fromKobo(...)`.

## 10. Environments

Backend `.env`: `MONGODB_URI`, `JWT_SECRET`, `JWT_ACCESS_TTL=15m`, `REFRESH_TTL_DAYS=30`, `STRIPE_SECRET_KEY`, `STRIPE_WEBHOOK_SECRET`, `PORT=3000`, `CORS_ORIGINS`, `ADMIN_EMAIL`, `ADMIN_PASSWORD` (seed).
Flutter: `--dart-define=API_BASE_URL=http://localhost:3000/api/v1` and `WS_URL`.

## 11. Contract addenda (from the Phase 1 backend implementation, 2026-09-28)

Additive details settled during implementation. Clients should rely on these.

- **Register** accepts optional `vendorName` for `vendor_owner` (defaults to `"<fullName>'s Store"`). Register and login return the same body `{ accessToken, refreshToken, refreshExpiresAt, user }`.
- **Delivery OTP**: `subOrders.deliveryOtp` (plaintext, visible to customer and vendor) is shown to the customer and typed by the rider at hand-over. `deliveries.proof.otp` stores only an HMAC.
- **Extra denormalised fields**: `deliveries.orderId/customerId/riderUserId/orderNumber`, `subOrders.orderNumber/vendorNameSnapshot/deliveryOtp/refundedKobo`, `orders.expiresAt/paidAt`, `carts|addresses|products.clientUpdatedAt`.
- **Customer cancel** is allowed while every sub-order is `placed` or still `awaiting_payment`. Paid sub-orders cancelled by a vendor are refunded per sub-order (`orders.paymentStatus` becomes `partially_refunded` or `refunded`). Expired unpaid orders get `paymentStatus: failed`; `POST /payments/:orderId/retry` re-reserves stock and reopens them.
- **Sync pull paging**: when any collection exceeds `limit` (default 200) the response carries a top-level `nextCursor`; repeat the call with the same `since` plus `cursor`.
- **Sync push custom ops**: `{ entity, action: 'custom', customAction: 'stock.adjust', payload: { productId, variantId?, delta, reason?, note? } }`. The name may also be given as `payload.name`. Entity names are accepted singular or plural.
- **List shapes**: `GET /categories` and `GET /me/addresses` also return `{ items, nextCursor: null }`.
- **Vendors near**: sorted by haversine in-process, max 50, vendors whose `deliveryRadiusKm` does not cover the point are omitted.
- **Local dev without Stripe**: `PAYMENTS_PROVIDER=mock` (refused in production) plus `GET /orders/:id/checkout`. Realtime works without a replica set through direct emission; change streams are used when available.
- **Additive routes**: `/notifications` (+ `/:id/read`, `/read-all`, `/unread-count`), `GET /vendor/orders/:subOrderId`, `GET /vendor/deliveries[/:id]`, `GET /rider/deliveries/:id`, `GET /admin/vendors/:id`, `GET /admin/orders/:id`, `GET /admin/sub-orders`, `GET /admin/users/:id`, `PATCH /admin/users/:id/status`, `POST /admin/payouts/:id/mark-failed`.
- **Rider identity**: `deliveries.riderId` and `offeredTo[].riderId` are `riderProfiles._id`; `deliveries.riderUserId` carries the `users._id`. Rider location pings use the profile id.
- **Offer window**: the backend does not expire offers yet. The rider app shows a 60 s countdown from `offeredTo[].at` and disables the buttons after it; the server stays authoritative. A server-side TTL is a Phase 4 follow-up.
- **`GET /vendors/:slugOrId`** accepts a slug or a vendor ObjectId.
- **Rider registration** sends `role: rider, vendorId` and then PATCHes vehicle details via `/rider/profile`; rider document uploads are not exposed yet (follow-up).
- **Tooling**: `riverpod_generator` cannot co-resolve with `objectbox_generator` and `json_serializable` in this workspace. Apps use hand-written Riverpod 3 providers.
- **Opening hours**: stored as `{ day: 0–6 (Sun=0), open, close, closed }`. The API accepts either `day` or `weekday` (1–7, Mon=1) on write; the Dart model reads either and exposes `toBackendJson()`.
- **Vendor images**: `POST /vendor/logo` and `POST /vendor/cover` (multipart `file`, vendor_owner only) set `logoImageId` / `coverImageId` and soft-delete the previous image.
- **Product image reorder**: `PATCH /vendor/products/:id { images: [{ imageId, sortOrder }] }` must list exactly the attached images; upload and delete stay on the image routes. Variant `id` may be omitted, `null` or `""` for new variants.
- **`GET /vendor/riders`** items are rider profiles plus `user { id, fullName, phone, email }` and `lastLocation { lat, lng, heading, speed, at }`.
- **`GET /admin/stats`** returns `{ counts: { users, customers, riders, vendors: { <status>: n }, products, activeProducts, orders, paidOrders, openSubOrders }, revenue: { today, last7d, last30d: { revenueKobo, orders, commissionKobo } }, generatedAt }`.
