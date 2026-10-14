## Why

The app has a data layer (003) but the home screen is still a placeholder. The core requirement is a universities list with a ListView/GridView toggle and hand-written infinite scroll (20 items at a time). It needs a ViewModel that owns loading/error/empty/data states and pagination.

## What Changes

- Add `UniversitiesListViewModel` (`ChangeNotifier`) exposing an immutable state: status (loading, error, empty, data), visible universities, layout mode, and whether more items remain.
- Paginate client-side: the repository returns the full list once; the ViewModel reveals it 20 items at a time via `loadMore()`.
- Add a layout toggle (list <-> grid) held in the ViewModel.
- Replace the placeholder `UniversitiesListView` with a real screen: `ListenableBuilder` over the ViewModel, a scroll listener that calls `loadMore()` near the end (no external library), layout toggle action, retry button on error, tap navigates to the detail route.
- Wire `UniversityRepository` and the ViewModel with `provider` in the app shell.
- Unit tests for the ViewModel; widget tests for the list screen.

## Capabilities

### New Capabilities

- `universities-list`: list screen behavior: load states, paginated reveal, layout toggle, navigation to detail.

### Modified Capabilities

<!-- None: `universities-data` requirements are unchanged. -->

## Impact

- New: `lib/ui/features/universities/view_models/universities_list_view_model.dart`, list item widgets under `lib/ui/features/universities/views/`.
- Modified: `lib/ui/features/universities/views/universities_list_view.dart`, `lib/app/app.dart` (providers), `lib/main.dart` (composition root), existing placeholder widget test.
- No new dependencies.
- Non-goals: detail screen content, image upload, student count, search/sort, server-side pagination, persistence.
