# Tasks

## 1. Domain

- [x] 1.1 Create `lib/domain/models/university.dart` (`id`, `name`, `country`, `alphaTwoCode`, `stateProvince?`, `domains`, `webPages`) and `lib/domain/failures/failure.dart` (value-equal `Failure(message)` implementing `Exception`); verify `flutter analyze` is clean
- [x] 1.2 Create `lib/domain/repositories/university_repository.dart` (abstract `getUniversities()` documented to throw `Failure`); verify `flutter analyze` is clean

- [x] 1.3 Update the layout line and "Current State" in `CLAUDE.md` to include `lib/domain/failures/`; verify with `rg -n 'failures' CLAUDE.md`

## 2. Data

- [x] 2.1 Create `lib/data/models/university_api_model.dart` (`fromJson`, `toDomain(int id)`); verify through the service tests that a `null` `state-province` parses
- [x] 2.2 Create `lib/data/services/universities_api_service.dart` (GET with injected `http.Client`, 200 check, UTF-8 decode); verify with `MockClient` tests in `test/data/services/` for success, non-200 and malformed payload
- [x] 2.3 Create `lib/data/repositories/university_repository_impl.dart` (assign `id` = source index, keep order, map any error to `Failure`); verify with tests in `test/data/repositories/` for source order and ids, duplicate names with distinct ids, and non-200, network error and malformed payload all throwing `Failure`

## 3. Integration check

- [x] 3.1 Verify `flutter analyze` is clean and `flutter test` passes
