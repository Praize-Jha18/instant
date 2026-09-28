# Instant backend

NestJS 12 + Mongoose 9 implementation of [`docs/ARCHITECTURE.md`](../docs/ARCHITECTURE.md): REST under `/api/v1`, Socket.IO on `/rt`, Stripe payments, offline sync. Single deployable.

## Run

Requirements: Node 22, pnpm 10, MongoDB 6+ (local `mongod` or Atlas).

```bash
cd backend
pnpm install
cp .env.example .env        # then set JWT_SECRET, MONGODB_URI, Stripe keys, ADMIN_EMAIL/ADMIN_PASSWORD
pnpm start:dev              # http://localhost:3000/api/v1 — Swagger at http://localhost:3000/docs
```

- **Local mongod**: `MONGODB_URI=mongodb://localhost:27017/instant`. Change streams need a replica set; without one the server logs a warning and realtime events are emitted directly from services (functionally identical for clients). To enable change streams locally: `mongod --replSet rs0` then `mongosh --eval 'rs.initiate()'`, and use `mongodb://localhost:27017/instant?replicaSet=rs0`.
- **Atlas**: paste the `mongodb+srv://` URI. Change streams work out of the box. Optionally create an Atlas Search index on `products` and set `ATLAS_SEARCH_INDEX=<name>`; otherwise `GET /products?q=` falls back to a case-insensitive regex over `searchText`.

All environment variables are validated at boot (`src/config/env.validation.ts`); the process refuses to start with a bad configuration.

| Variable | Default | Notes |
|---|---|---|
| `MONGODB_URI` | `mongodb://localhost:27017/instant` | |
| `JWT_SECRET` | required (min 16 chars) | HS256 access tokens, 15 min |
| `JWT_ACCESS_TTL` | `15m` | |
| `REFRESH_TTL_DAYS` | `30` | |
| `STRIPE_SECRET_KEY` | empty | Payments return 503 `PAYMENT_PROVIDER_UNAVAILABLE` until set |
| `STRIPE_WEBHOOK_SECRET` | empty | From `stripe listen` (below) or the dashboard |
| `PAYMENTS_PROVIDER` | `stripe` | `mock` is accepted outside production for local development |
| `PORT` | `3000` | |
| `CORS_ORIGINS` | `*` | Comma-separated allow-list, e.g. `http://localhost:8080,https://vendor.example.com` |
| `ADMIN_EMAIL`, `ADMIN_PASSWORD` | empty | Used by `pnpm seed` only |
| `ATLAS_SEARCH_INDEX` | empty | Name of the Atlas Search index on `products` |

## Seed

```bash
pnpm seed
```

Idempotent. Creates the admin from `ADMIN_EMAIL`/`ADMIN_PASSWORD`, 3 categories, 2 active vendors (Lagos) with owners, 10 products with generated placeholder images, 1 approved rider per vendor and 1 customer with a default address. Password for every non-admin seeded account is `Password123!`:

| Role | Email |
|---|---|
| vendor owner | `owner1@instant.local`, `owner2@instant.local` |
| rider | `rider1@instant.local` (Mama Put Kitchen), `rider2@instant.local` (FreshMart) |
| customer | `customer@instant.local` |

## Stripe webhooks locally

```bash
stripe listen --forward-to localhost:3000/api/v1/payments/webhook/stripe
# copy the printed whsec_... into STRIPE_WEBHOOK_SECRET and restart
stripe trigger payment_intent.succeeded   # or pay a real intent from the app with a test card
```

The webhook reads the raw body (`rawBody: true` in `main.ts`), verifies the signature, and is idempotent on the Stripe event id (recorded on the `payments` document). `payment_intent.succeeded` marks the order paid and flips its sub-orders `awaiting_payment → placed`; failures release stock. A cron job (`OrderExpiryJob`, every minute) expires unpaid orders after 30 minutes and releases their stock.

With `PAYMENTS_PROVIDER=mock` you can confirm an order by posting to the same webhook route without a signature:

```bash
curl -X POST localhost:3000/api/v1/payments/webhook/stripe -H 'content-type: application/json' \
  -d '{"id":"evt_1","type":"payment_intent.succeeded","providerRef":"<payment.providerRef from checkout>"}'
```

## Scripts

| Command | What it does |
|---|---|
| `pnpm start:dev` | Watch mode |
| `pnpm build` | `nest build` → `dist/` |
| `pnpm start:prod` | `node dist/main` |
| `pnpm test` | Unit tests (vitest, no database needed) |
| `pnpm test:e2e` | Boots the app against `MONGODB_URI` |
| `pnpm lint` | oxlint, type-aware |
| `pnpm seed` | Build + seed |
| `pnpm smoke` | Build, then run `test/smoke.mjs`: boots seed + server against an in-memory replica set (downloads a mongod binary on first run) and drives the full customer → payment → vendor → rider → ledger → sync flow with the mock payment provider |

## Layout

```
src/
  config/          env validation (Joi) + typed AppConfig
  common/          AppError, exception filter, guards (JWT, Roles, VendorScope), decorators,
                   timestampsVersionPlugin, cursor pagination, geo/slug/money utils
  database/        MongooseModule root (plugin applied to every schema)
  modules/
    auth           AuthProvider interface, LocalPasswordProvider, rotating refresh tokens, JWT strategy
    users vendors categories products(+stock, inventoryMovements) images addresses cart
    orders         Order/SubOrder schemas, state machine, checkout, vendor transitions
    deliveries riders ledger(+payouts) payments(provider, Stripe, mock, webhook, expiry job)
    notifications admin sync realtime(gateway, change streams, RealtimeService)
  seed/            pnpm seed
```

Conventions: money is integer kobo; every write bumps `updatedAt`/`version`; deletes are soft (`deletedAt`); errors are `{ statusCode, code, message, details? }`; lists are `{ items, nextCursor }`; JSON documents expose `id` (Mongo `_id` is mapped by the schema plugin; sync payloads and realtime events use the same shape).

## Routes (`/api/v1`)

Public: `POST /auth/register|login|refresh|logout`, `GET /vendors?near=lat,lng&q=`, `GET /vendors/:slug`, `GET /categories`, `GET /products?vendorId=&categoryId=&q=&cursor=`, `GET /products/:id`, `GET /images/:id[?size=thumb]`, `POST /payments/webhook/stripe`.

Authenticated (Bearer): `GET /auth/me`, `GET|POST /notifications[/:id/read|/read-all|/unread-count]`, `GET /sync/pull?since=&collections=&cursor=`, `POST /sync/push`.

Customer: `GET|PUT /me/cart`, `GET|POST /me/addresses`, `GET|PATCH|DELETE /me/addresses/:id`, `POST /orders`, `GET /orders`, `GET /orders/:id`, `GET /orders/:id/checkout`, `POST /orders/:id/cancel`, `GET /orders/:id/tracking`, `POST /payments/:orderId/retry`.

Vendor (`vendor_owner|vendor_staff`, scoped to own `vendorId`): `GET|PATCH /vendor`, `GET|POST /vendor/products`, `GET|PATCH|DELETE /vendor/products/:id`, `POST /vendor/products/:id/images` (multipart `file`), `DELETE /vendor/products/:id/images/:imageId`, `POST /vendor/products/:id/stock`, `GET /vendor/inventory/movements`, `GET /vendor/orders?status=`, `GET /vendor/orders/:subOrderId`, `POST /vendor/orders/:subOrderId/status`, `GET /vendor/riders`, `POST /vendor/riders/:id/approve|suspend`, `GET /vendor/deliveries`, `GET /vendor/deliveries/:id`, `POST /vendor/deliveries/:id/assign`, `POST /vendor/deliveries/:id/auto-assign`, `GET /vendor/ledger`, `GET|POST /vendor/payouts`.

Rider: `GET|PATCH /rider/profile`, `POST /rider/location`, `GET /rider/deliveries?status=`, `GET /rider/deliveries/:id`, `POST /rider/deliveries/:id/respond`, `POST /rider/deliveries/:id/pickup`, `POST /rider/deliveries/:id/deliver` (JSON `{ otp }` or multipart `photo`).

Admin: `GET /admin/vendors`, `GET|PATCH /admin/vendors/:id`, `POST /admin/vendors/:id/approve|suspend`, `GET /admin/orders`, `GET /admin/orders/:id`, `GET /admin/sub-orders`, `GET /admin/users`, `GET /admin/users/:id`, `PATCH /admin/users/:id/status`, `GET /admin/payouts`, `POST /admin/payouts/:id/mark-paid|mark-failed`, `GET|POST /admin/categories`, `GET|PATCH|DELETE /admin/categories/:id`, `GET /admin/stats`.

## Realtime (`/rt`)

Connect with `io(WS_URL + '/rt', { auth: { token: accessToken } })`. The socket auto-joins `user:{id}` and, for vendor users, `vendor:{id}`. Emit `subscribe { room }` for `order:{id}` / `delivery:{id}` (ownership is checked; ack `{ ok, room, error? }`). Server events: `changed { collection, id, doc }`, `removed { collection, id }`, `rider.location { deliveryId, riderId, lat, lng, heading, at }`. Riders emit `rider.location { lat, lng, heading?, speed?, at }` (persisted at most once per 3 s per rider).

## Sync

`GET /sync/pull?since=<iso>&collections=products,vendors,categories,orders,subOrders,deliveries[&cursor=]` returns `{ changes, tombstones, serverTime, nextCursor? }` scoped by role, with a 2 s overlap on `since`. When any collection has more than `limit` (default 200) rows the response carries `nextCursor`; repeat the call with the same `since` and that cursor until it is absent, then store `serverTime`.

`POST /sync/push { ops: [{ opId, entity, action, payload, clientAt }] }` is idempotent per `opId` (30-day `syncOps` log). Supported operations:

| entity | action | payload |
|---|---|---|
| `cart` | `upsert` | `{ items: CartItem[] }` (LWW by `clientAt`) |
| `addresses` | `upsert` / `delete` | address fields (+ client-generated `id`) / `{ id }` |
| `riderProfile` | `upsert` | `{ isOnline }` only |
| `riderLocation` | `upsert` | one point or `{ points: [...] }` |
| `product` | `upsert` | `{ id, name?, description?, tags? }` text fields only (LWW) |
| `stock` | `custom` | `{ name: 'stock.adjust', productId, variantId?, delta, reason?, note? }` (delta, replay-safe) |
