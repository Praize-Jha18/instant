# Instant — customer app

Flutter (Android + iOS) customer app: browse vendors, order, pay with Stripe, track deliveries.
Built on the shared workspace packages `core_models`, `api_client`, `local_db`, `design_system`.

## Run

From the repo root:

```sh
flutter pub get
cd apps/customer
flutter run \
  --dart-define=API_BASE_URL=http://localhost:3000/api/v1 \
  --dart-define=WS_URL=http://localhost:3000 \
  --dart-define=STRIPE_PUBLISHABLE_KEY=pk_test_xxx
```

- Android emulator: use `http://10.0.2.2:3000` instead of `localhost`.
- `STRIPE_PUBLISHABLE_KEY` may be omitted; the pay screen then shows a "Stripe key not configured" state
  (the server-provided `publishableKey` in the checkout payload is used when present).
- Google Maps: set a real key via `-PGOOGLE_MAPS_API_KEY=...` / `GOOGLE_MAPS_API_KEY` env (Android) and
  in `ios/Runner/AppDelegate.swift` (iOS). See the `TODO(maps)` comments.

## Verify

```sh
flutter analyze
flutter test
```

## Layout

```
lib/app        bootstrap providers, router, shell, theme mode, config
lib/core       secure token store, errors, geo, formatters, validators, list-phase helper
lib/features   auth, catalog, home, search, vendor, product, cart, addresses, checkout, orders, profile
```

State is Riverpod 3 with hand-written providers (no code generation: `riverpod_generator` cannot resolve
alongside `objectbox_generator` in this workspace, see the report).
