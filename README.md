# Instant

Multi-vendor commerce and delivery platform. Vendors list products, customers order and pay,
vendors dispatch their own riders. Works offline and syncs when back online.

Read [docs/ARCHITECTURE.md](docs/ARCHITECTURE.md) first. It is the contract between backend and apps.

## Layout

| Path | What |
|---|---|
| `backend/` | NestJS + MongoDB + Socket.IO API |
| `apps/customer/` | Flutter customer app (Android, iOS) |
| `apps/rider/` | Flutter rider app (Android, iOS) |
| `apps/vendor/` | Flutter vendor + platform admin app (Android, iOS, Web) |
| `packages/core_models/` | Shared Dart models, enums, DTOs |
| `packages/api_client/` | REST + realtime client |
| `packages/local_db/` | ObjectBox local store, outbox, sync engine |
| `packages/design_system/` | Theme tokens and shared widgets |

## Prerequisites

- Flutter 3.44+, Dart 3.12+
- Node 22, pnpm 10
- MongoDB 7+ as a replica set (needed for Change Streams). Either a free MongoDB Atlas cluster
  or `docker compose up -d` using the included `docker-compose.yml`.
- Stripe account + Stripe CLI for webhook forwarding

## Run

```bash
# backend
cp backend/.env.example backend/.env   # fill MONGODB_URI, JWT_SECRET, STRIPE_*
pnpm install
pnpm --dir backend seed                 # admin, vendors, products, rider, customer
pnpm backend:dev                        # http://localhost:3000/api/v1 , Swagger at /docs

# stripe webhooks (separate terminal)
stripe listen --forward-to localhost:3000/api/v1/payments/webhook/stripe

# flutter
flutter pub get                         # from repo root, resolves the whole workspace
cd apps/customer && flutter run --dart-define=API_BASE_URL=http://localhost:3000/api/v1 --dart-define=WS_URL=http://localhost:3000
```

On the Android emulator use `10.0.2.2` instead of `localhost`.

## Regenerating code

```bash
cd packages/core_models && dart run build_runner build --delete-conflicting-outputs
cd packages/local_db    && dart run build_runner build --delete-conflicting-outputs
```

## Decisions

- Email + password auth now, Firebase Auth later behind the same `AuthProvider` interface.
- Images are stored in MongoDB for now and served from `/images/:id`. Move to blob storage by changing only `ImagesService`.
- Stripe for card payments in NGN. Stripe Connect is not available for Nigerian businesses, so vendor
  earnings accrue in a ledger and payouts are marked paid by admin. A Paystack provider can be added later.
- Custom offline sync: ObjectBox locally, outbox for writes, pull with cursors, Socket.IO for realtime.
