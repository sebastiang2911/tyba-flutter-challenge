## 1. Domain

- [x] 1.1 Add `UniversityProfile` model and `PhotoSource` enum (`gallery`, `camera`)
- [x] 1.2 Add `StudentCountValidator` and `StudentCountError`
- [x] 1.3 Add `UniversityProfileRepository` interface
- [x] 1.4 Add `getUniversityById` to `UniversityRepository`

## 2. Data

- [x] 2.1 Add `image_picker` dependency (`flutter pub add image_picker`)
- [x] 2.2 Add `ImagePickerService`
- [x] 2.3 Implement `getUniversityById` in `UniversityRepositoryImpl`
- [x] 2.4 Add `InMemoryUniversityProfileRepository`

## 3. UI

- [x] 3.1 Add `UniversityDetailViewModel` (loading/error/data, pick image, submit count)
- [x] 3.2 Replace `UniversityDetailView` placeholder (info, image, count form, error state)
- [x] 3.3 Wire providers in `app.dart` and the detail route in `router.dart`

## 4. Platform

- [x] 4.1 Add usage descriptions to `ios/Runner/Info.plist`
- [x] 4.2 Add camera feature and `IMAGE_CAPTURE` query to `AndroidManifest.xml`

## 5. Tests and verification

- [x] 5.1 Unit: validator, in-memory profile repository, `getUniversityById`, ViewModel
- [x] 5.2 Widget: detail states, validation messages, image shown after pick
- [x] 5.3 Update existing router/placeholder tests broken by the new view
- [x] 5.4 `flutter analyze` and `flutter test` pass
