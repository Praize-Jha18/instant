# instant_vendor

Vendor + platform-admin Flutter app for the Instant platform (Android, iOS, Web).
See `docs/ARCHITECTURE.md` for the contract and `docs/PACKAGES_API.md` for the shared packages.

## Run

From the repository root (pub workspace):

```sh
flutter pub get
```

Web (online-only: `LocalStore.open()` returns an in-memory store on web):

```sh
cd apps/vendor
flutter run -d chrome \
  --dart-define=API_BASE_URL=http://localhost:3000/api/v1 \
  --dart-define=WS_URL=http://localhost:3000
```

Android / iOS (offline-capable through ObjectBox + the outbox):

```sh
cd apps/vendor
flutter run -d <device-id> \
  --dart-define=API_BASE_URL=http://10.0.2.2:3000/api/v1 \
  --dart-define=WS_URL=http://10.0.2.2:3000
```

(`10.0.2.2` is the Android emulator alias for the host; use your machine's LAN IP for a physical device.)

Google Maps: replace `GOOGLE_MAPS_API_KEY` in `android/app/src/main/AndroidManifest.xml`,
`ios/Runner/AppDelegate.swift` and `web/index.html`.

## Verify

```sh
cd apps/vendor
flutter analyze
flutter test
flutter build web --release --dart-define=API_BASE_URL=http://localhost:3000/api/v1
```

## Layout

- `lib/app` bootstrap (providers, session, router, responsive shell, theme)
- `lib/core` token store, session cache, vendor JSON normalisation, utils, shared widgets
- `lib/features/<feature>/{data,domain,presentation}`: auth, vendor, dashboard, orders, products, riders, finance, settings, admin
