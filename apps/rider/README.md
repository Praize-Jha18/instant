# instant_rider

Rider app of the Instant platform (Android + iOS). Riders belong to one vendor,
go online, accept offers and deliver orders. See `docs/ARCHITECTURE.md` at the
repo root for the contract.

## Run

From the repo root (pub workspace):

```sh
flutter pub get
cd apps/rider
flutter run \
  --dart-define=API_BASE_URL=http://localhost:3000/api/v1 \
  --dart-define=WS_URL=http://localhost:3000
```

Android emulator: use `http://10.0.2.2:3000` for both. Physical device: your
machine's LAN IP.

Google Maps keys are placeholders: replace `YOUR_GOOGLE_MAPS_API_KEY` in
`android/app/src/main/AndroidManifest.xml` and `ios/Runner/AppDelegate.swift`.

## Verify

```sh
flutter analyze
flutter test
```

## Layout

- `lib/app` bootstrap, providers, router (+ pure redirect rule), shell, theme
- `lib/core` token store, formatters, launchers, small utilities
- `lib/features/<feature>/{data,domain,presentation}` auth, home, location,
  deliveries, active_delivery, profile
