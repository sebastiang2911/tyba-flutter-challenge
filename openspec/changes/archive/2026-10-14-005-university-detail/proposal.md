# Proposal

## Why

The detail screen is a placeholder. The test requires opening a university, assigning it an image (gallery or camera) and entering a validated number of students. Both are session-only (no persistence required).

## What Changes

- Replace the `UniversityDetailView` placeholder with a real detail: name, country, state/province, domains, web pages, assigned image and student count.
- Add a `UniversityDetailViewModel` (`ChangeNotifier`) with loading / error / data states.
- Add a pure `StudentCountValidator` (non-empty, integer, > 0, upper bound).
- Add an in-memory `UniversityProfileRepository` holding image path and student count per university `id`, so values survive list <-> detail navigation within a session.
- Add an image picker service wrapping `image_picker` (gallery and camera).
- Add `UniversityRepository.getUniversityById(int id)`.
- Configure camera/photo-library permissions in `ios/Runner/Info.plist` and `android/app/src/main/AndroidManifest.xml`.
- New dependency: `image_picker`.

## Capabilities

### New Capabilities
- `university-detail`: detail view of one university, image assignment and validated student count.

### Modified Capabilities
- `universities-data`: a single university can be fetched by its sequential `id`.

## Impact

- Code: `lib/domain/{models,repositories,validators}`, `lib/data/{repositories,services}`, `lib/ui/features/universities/{view_models,views}`, `lib/app/{app,router}.dart`.
- Platform config: `Info.plist`, `AndroidManifest.xml`.
- Dependencies: `image_picker`.
- Developed in parallel with change 004 (list ViewModel); expect small merge conflicts in `lib/app/app.dart` (providers) when rebasing.
