# Proposal

## Why

The app shell from `002-app-shell` has placeholder views and no data. Every later change (list, pagination, detail) depends on a single, trustworthy source of universities. The source JSON has no `id` and 10 repeated names, so identity and ordering must be fixed in the data layer before any UI consumes it.

## What Changes

- Add the domain model `University` (with a sequential `id`) and the abstract `UniversityRepository`.
- Add a `Failure` type so the UI layer sees a domain error instead of HTTP or parsing exceptions.
- Add the API model `UniversityApiModel` (JSON parsing) and `UniversitiesApiService` (one HTTP GET to the universities JSON).
- Add `UniversityRepositoryImpl`: maps API models to domain models, assigns `id` by position in the source array, returns source order, and converts any failure into `Failure`.
- Add unit tests for the service and the repository using `http` mock clients.

Out of scope: ViewModels, `provider` registrations, UI, pagination, filtering/sorting, caching, retry, image and student-count state.

## Capabilities

### New Capabilities

- `universities-data`: loading the list of universities with stable identity and ordering, and reporting load failures.

### Modified Capabilities

None.

## Impact

- Code: new files under `lib/domain/` (`models`, `repositories`, `failures`), `lib/data/` (`models`, `services`, `repositories`) and mirrored tests under `test/data/`.
- Dependencies: none new (`http` was added in `002`).
- Network: first real use of the universities JSON endpoint (tests use mock clients only).
