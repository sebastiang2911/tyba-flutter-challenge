# Design

## Context

- Detail route `/university/:id` exists with a placeholder view (`lib/ui/features/universities/views/university_detail_view.dart`).
- `UniversityRepository` only exposes `getUniversities()`; `id` is the source index. There is no cache.
- No persistence between sessions is required, but image and count must survive list <-> detail navigation.
- Change 004 (list ViewModel) is developed in parallel and also edits `lib/app/app.dart`.

## Decisions

1. **`getUniversityById(int id)` on `UniversityRepository`.** Implemented over `getUniversities()` and `id` match; throws `Failure` if missing. Simple and keeps `id` stable. Cost: one download per detail open; an in-memory cache is a later optimization.
2. **`UniversityProfile` domain model** (`imagePath`, `studentCount`, both nullable) plus **`UniversityProfileRepository`** (domain interface, `InMemoryUniversityProfileRepository` in data). Map keyed by university `id`, app-scoped singleton so values outlive the detail screen. Exposes `getProfile(id)`, `saveStudentCount(id, count)`, `assignImage(id, path)`.
3. **`ImagePickerService`** (`lib/data/services`) wraps `image_picker`, returns a file path or `null` on cancel. Stateless. Injected into the in-memory profile repository via constructor through a `pickImage(id, PhotoSource)` method, so the ViewModel talks only to repositories.
4. **`StudentCountValidator`** in `lib/domain/validators`: pure function `StudentCountError? validate(String?)` plus parsed value helper. Errors: `empty`, `notInteger`, `outOfRange` (1..10,000,000). UI maps the enum to messages.
5. **`UniversityDetailViewModel`** (`ChangeNotifier`): constructor takes both repositories and the `id`; state = sealed/enum status (`loading`, `error`, `data`), `university`, `profile`, `studentCountError`. Methods `load()`, `pickImage(PhotoSource)`, `submitStudentCount(String)`. The view uses `ListenableBuilder`; no logic in the view.
6. **Wiring.** Repositories provided with `provider` in `app.dart`; the detail route creates the ViewModel (`ChangeNotifierProvider`) per navigation using `state.pathParameters`. Profile repository is created once in `App` so state persists.
7. **Android permissions.** `image_picker` needs no runtime permission on Android. Declaring `android.permission.CAMERA` would force a runtime request and crash the camera intent without it, so we declare only `<uses-feature android.hardware.camera required="false"/>` and a `<queries>` intent for `IMAGE_CAPTURE`. This deviates from a literal "add permissions" reading on purpose. iOS gets `NSCameraUsageDescription` and `NSPhotoLibraryUsageDescription`.
8. **Testing.** Fakes for both repositories and the picker; unit tests for validator, in-memory repository, `getUniversityById` and ViewModel; widget tests for detail states and validation messages.

## Risks / Trade-offs

- Merge conflicts in `app.dart` with change 004: resolved by rebasing; provider list is additive.
- Camera cannot be exercised in widget tests; covered by a faked service. Manual check on device/simulator.
- Re-downloading JSON per detail open is accepted for scope.

## Open Questions

- None blocking.
