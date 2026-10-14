# Tyba Technical Test: Universities

Flutter app that lists universities from a remote JSON, lets the user switch between list and grid, and open a detail screen where an image and a student count can be assigned to a university.

## Features

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

On a real device or emulator, the gallery and camera need the platform setup described in [Platform setup](#platform-setup).

## Architecture

Layered architecture following the Flutter recommendations: UI (MVVM), Data, and a small Domain layer that both depend on. Dependencies point inwards: `ui` and `data` know `domain`; `domain` knows nothing about Flutter widgets or HTTP.

```
lib/
├── main.dart                 # composition root: builds services and repositories
├── app/                      # App widget, go_router config, theme
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
        ├── view_models/      # UniversitiesListViewModel, UniversityDetailViewModel
        └── views/            # UniversitiesListView, UniversityDetailView
test/                         # mirrors lib/, plus test/support/ fakes
```

| Layer | Responsibility |
| --- | --- |
| Services | Stateless wrappers over external APIs (HTTP, image picker). |
| Repositories | Use services, map API models to domain models, translate errors into `Failure`. |
| ViewModels | Extend `ChangeNotifier`, receive repositories by constructor, expose an immutable state snapshot. |
| Views | Render the state with `ListenableBuilder` and forward user events. No business logic. |

### Data flow

```
View  ->  ViewModel  ->  Repository (interface)  ->  Service  ->  HTTP / image picker
 ^            |
 +-- state ---+   (notifyListeners)
```

### Dependency injection and navigation

- `main.dart` creates the concrete repositories and passes them to `App`.
- `App` exposes them with `provider` (`Provider.value`) and creates the list ViewModel.
- `go_router` defines two routes: `/` (list) and `/university/:id` (detail). The detail route creates its own ViewModel scoped to the screen. The list opens it with `push`, so back returns to the list; if the detail was opened directly (no history), back navigates to `/`. The list opens it with `push`, so back returns to the list; if the detail was opened directly (no history), back navigates to `/`.
- Views and ViewModels depend on the repository interfaces, so tests inject fakes (`test/support/`).

## Key decisions

- **Sequential `id` in source order.** The JSON has no id and names repeat, so the repository assigns the index of each item before any sort or filter. The detail route uses it as its path parameter.
- **Immutable state snapshots.** Each ViewModel keeps a single state object (`status`, data, errors) and replaces it on every change, which makes states explicit (`loading`, `error`, `empty`, `data`) and easy to assert in tests.
- **Hand-written infinite scroll.** The list ViewModel pages the already loaded list in chunks of 20 (`pageSize`). The view listens to its `ScrollController` and asks for more when less than 200 px remain.
- **Validation in the domain.** `StudentCountValidator` returns an error enum, not text, so the rule is testable without Flutter and the view decides the wording. It parses with `BigInt` so very long digit strings count as out of range instead of crashing.
- **In-memory profile repository.** The test does not require persistence, so image path and student count are stored in a map behind `UniversityProfileRepository`. Swapping it for a persistent implementation does not touch the UI.
- **Failures instead of raw exceptions.** Repositories throw `Failure` with a message safe to show; ViewModels catch only `Failure`.
- **No use cases layer.** ViewModels call repositories directly; the logic is thin enough that an extra layer would add ceremony without value.

## Platform setup

- **iOS:** `ios/Runner/Info.plist` declares `NSPhotoLibraryUsageDescription` and `NSCameraUsageDescription`.
- **Android:** `AndroidManifest.xml` declares the camera feature as optional. The `CAMERA` permission is intentionally absent: `image_picker` opens the system camera app, and declaring the permission would force a runtime request.

## Testing

`test/` mirrors `lib/`:

- **Unit:** validator, failure, API service, repository implementations, image picker service.
- **ViewModel:** state transitions for loading, error, empty, pagination, layout toggle, image pick and student count.
- **Widget:** list and detail views, `App` wiring and router.

Fakes live in `test/support/`. Run everything with `flutter test`.

## Limitations and next steps

- No persistence between sessions (by design of the test).
- `getUniversityById` reloads the full list from the network; caching the list in the repository would avoid repeated downloads.
- The error state offers a plain Retry button; richer retry UX is undecided.
- Pagination is client-side: the whole JSON is downloaded once and revealed in pages.
