## 1. ViewModel

- [x] 1.1 Create `UniversitiesListViewModel` and immutable `UniversitiesListState` (status, visible, layout, hasMore) in `lib/ui/features/universities/view_models/`; `load()` handles loading/data/empty/error (`Failure` message). Verify: unit tests in `test/ui/features/universities/view_models/` with a fake repository cover all four states.
- [x] 1.2 Add `loadMore()` (pages of 20, no-op when no more or not in data status) and `toggleLayout()`. Verify: unit tests for first page = 20, next page appends in order, last partial page, `hasMore` false at end, no-op at end, toggle both ways, retry after error.

## 2. View and wiring

- [x] 2.1 Replace the placeholder `UniversitiesListView` with a `ListenableBuilder` screen: progress, error + retry, empty message, list/grid via `ListView.builder`/`GridView.builder`, AppBar layout toggle. Verify: widget tests for each state and the toggle.
- [x] 2.2 Add scroll controller near-end detection calling `loadMore()`; tapping an item calls `context.go(AppRoutes.detailFor(id))`. Verify: widget tests that scrolling to the end shows more than 20 items in list and grid, and that tapping navigates to the detail route.
- [x] 2.3 Provide the repository and ViewModel with `provider` in `App`/`main()`; allow injecting a repository in `App` for tests. Verify: update `app_test.dart`/`placeholder_views_test.dart` to the new wiring; `flutter analyze` and `flutter test` pass.

## 3. Roadmap

- [x] 3.1 Move the "List ViewModel" item of `ROADMAP.md` to Done as `004-universities-list-viewmodel`. Verify: file reflects it.
