# Tyba Technical Test: Universities

Flutter app that lists universities from a remote JSON, lets the user switch between list and grid, and open a detail screen where an image and a student count can be assigned to a university.

## Features

- Branded startup: native launch screen, then an animated splash that prefetches the universities.
- Universities list loaded from `https://tyba-assets.s3.amazonaws.com/FE-Engineer-test/universities.json`.
- Toggle between `ListView` and `GridView`.
- Infinite scroll: 20 items at a time, hand-written (no external library).
- Detail screen per university.
- Assign an image from the gallery or the camera.
- Enter the number of students, validated (required, integer, between 1 and 10,000,000).
- Loading, error, empty and data states.
- No persistence: image and student count live only for the current session.

## Getting started

Requirements: Flutter with Dart SDK `^3.13.5`.

```bash
flutter pub get
flutter run          # pick a device or emulator
flutter analyze
flutter test
```

To run locally, keep the code generator running in a separate terminal before `flutter run`:

```bash
dart run build_runner watch -d
```

On a real device or emulator, the gallery and camera need the platform setup described in [Platform setup](#platform-setup).

## Architecture

Layered architecture following the Flutter recommendations: UI (MVVM), Data, and a small Domain layer that both depend on. Dependencies point inwards: `ui` and `data` know `domain`; `domain` knows nothing about Flutter widgets or HTTP.

```
lib/
├── main.dart                 # entry point: ProviderScope around App
├── app/                      # App widget, appRouter provider, theme, infrastructure providers
├── domain/
│   ├── models/               # University, UniversityProfile
│   ├── repositories/         # abstract contracts
│   ├── failures/             # Failure (user-facing error message)
│   └── validators/           # StudentCountValidator
├── data/
│   ├── models/               # UniversityApiModel (JSON shape)
│   ├── services/             # UniversitiesApiService, ImagePickerService
│   └── repositories/         # implementations of the domain contracts
└── ui/
    └── features/universities/
        ├── providers/        # list and detail Riverpod providers (+ generated *.g.dart)
        └── views/            # UniversitiesListView, UniversityDetailView
test/                         # mirrors lib/, plus test/support/ fakes
```

| Layer | Responsibility |
| --- | --- |
| Services | Stateless wrappers over external APIs (HTTP, image picker). |
| Repositories | Use services, map API models to domain models, translate errors into `Failure`. |
| Providers | Code-generated Riverpod providers (`@riverpod`): small `Future` providers for data, notifiers for UI state, derived providers for what the view shows. They read repositories through providers. |
| Views | Render with `ref.watch` and `AsyncValue.when` (Consumer widgets) and forward user events with `ref.read`. No business logic. |

### Data flow

```
View  ->  Provider  ->  Repository (interface)  ->  Service  ->  HTTP / image picker
 ^           |
 +-- state --+   (ref.watch rebuilds)
```

### Dependency injection and navigation

- `main.dart` runs `ProviderScope(child: App())`. `lib/app/providers.dart` builds the concrete http client, services and repositories as keepAlive providers; tests override them with fakes.
- `App` is a `ConsumerWidget` that watches the `appRouter` provider.
- List state is split into small providers: `universities` (Future), `universitiesLayout`, `visibleCount` and the derived `visibleUniversities`. Detail uses the `university(id)` family Future and the `universityProfileNotifier(id)` family notifier (both auto-dispose).
- `go_router` defines three routes: `/splash` (initial), `/` (list) and `/university/:id` (detail). The splash replaces itself with the list (`go`), so back never returns to it. The list opens the detail with `push`, so back returns to the list; if the detail was opened directly (no history), back navigates to `/`.
- Views and providers depend on the repository interfaces, so tests inject fakes (`test/support/`).
- Providers are code-generated. After changing one, run `dart run build_runner build -d`; the generated `*.g.dart` files are committed.

## Key decisions

- **Sequential `id` in source order.** The JSON has no id and names repeat, so the repository assigns the index of each item before any sort or filter. The detail route uses it as its path parameter.
- **Riverpod with code generation.** `AsyncValue` models loading, error and data explicitly (empty is a data case with an empty list), and state classes are immutable, so states are easy to assert in tests. Riverpod's automatic retry is disabled (`noRetry`): failures surface at once and the user retries with the button.
- **Hand-written infinite scroll.** The list providers page the already loaded list in chunks of 20 (`pageSize`). The view listens to its `ScrollController` and asks for more when less than 200 px remain.
- **Validation in the domain.** `StudentCountValidator` returns an error enum, not text, so the rule is testable without Flutter and the view decides the wording. It parses with `BigInt` so very long digit strings count as out of range instead of crashing.
- **In-memory profile repository.** The test does not require persistence, so image path and student count are stored in a map behind `UniversityProfileRepository`. Swapping it for a persistent implementation does not touch the UI.
- **Failures instead of raw exceptions.** Repositories throw `Failure` with a message safe to show; providers translate only `Failure`.
- **No use cases layer.** Providers call repositories directly; the logic is thin enough that an extra layer would add ceremony without value.

## Platform setup

- **iOS:** `ios/Runner/Info.plist` declares `NSPhotoLibraryUsageDescription` and `NSCameraUsageDescription`.
- **Android:** `AndroidManifest.xml` declares the camera feature as optional. The `CAMERA` permission is intentionally absent: `image_picker` opens the system camera app, and declaring the permission would force a runtime request.

## App icon

The launcher icon is the triangular mark of `assets/tyba.svg`. Sources live in `assets/icon/` (`tyba_mark.svg`, plus the 1024 px `app_icon.png` and `app_icon_foreground.png` rendered from it). iOS and Android icons (including the Android adaptive icon) are generated with `flutter_launcher_icons`, configured in `pubspec.yaml`:

```sh
dart run flutter_launcher_icons
git checkout ios/Runner.xcodeproj/project.pbxproj
```

The second command discards a `project.pbxproj` edit the generator makes, which breaks `ASSETCATALOG_COMPILER_GENERATE_SWIFT_ASSET_SYMBOL_EXTENSIONS`.

## Splash screen

Startup has two layers. The native launch screen (triangular mark on white, Android 12+ included) is generated with `flutter_native_splash`, configured in `pubspec.yaml`:

```sh
dart run flutter_native_splash:create
```

Then the Flutter `/splash` route fades in the wordmark (`assets/images/tyba_wordmark.png`, exported from `assets/tyba.svg`). The `splashReady` provider waits for the universities prefetch and a minimum of 800 ms (`splashMinDuration`), whichever is later. A failed prefetch does not block: the list opens and shows its own error with retry.

## Testing

`test/` mirrors `lib/`:

- **Unit:** validator, failure, API service, repository implementations, image picker service.
- **Providers:** `ProviderContainer` tests for state transitions for loading, error, empty, pagination, layout toggle, image pick and student count.
- **Widget:** list and detail views, `App` wiring and router (`ProviderScope` overrides).

Fakes live in `test/support/`. Run everything with `flutter test`.

## Limitations and next steps

- No persistence between sessions (by design of the test).
- `getUniversityById` reloads the full list from the network; caching the list in the repository would avoid repeated downloads.
- The error state offers a plain Retry button; richer retry UX is undecided.
- Pagination is client-side: the whole JSON is downloaded once and revealed in pages.
