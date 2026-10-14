## Context

See proposal.md. The data layer exposes `UniversityRepository.getUniversities()` (full list, sequential `id`, throws `Failure`). The home route renders a placeholder; `App` has no providers; `main()` builds `App()` directly. Layout is MVVM with `ChangeNotifier` + `provider`, per `CLAUDE.md`.

## Goals / Non-Goals

**Goals:**
- A ViewModel testable without Flutter widgets, with immutable exposed state.
- Hand-written near-end detection; same pagination for list and grid.

**Non-Goals:**
- Search, sort, caching, server-side paging, detail content.

## Decisions

- **Client-side pagination.** The source is one JSON file with no paging API; fetch once, reveal in pages of 20 (`pageSize` constant). Alternative: lazy requests, impossible with this source.
- **Single immutable state object** (`UniversitiesListState`: `status` enum, `visible` list, `layout` enum, `hasMore`) replaced on each change; the ViewModel calls `notifyListeners()`. Alternative: several mutable fields; rejected because it allows inconsistent combinations (e.g. loading + error).
- **Status is an enum** `loading | error | empty | data`. Error carries a message from `Failure`.
- **Full list kept private** in the ViewModel; `visible` is a `List.unmodifiable` sublist. Order and `id` are never altered.
- **Layout lives in the ViewModel** (`toggleLayout()`), so toggling is unit-testable and survives rebuilds.
- **Scroll detection:** one `ScrollController` owned by the view's `State`, listener calls `loadMore()` when `position.extentAfter < threshold` (e.g. 200 px). The same controller feeds `ListView.builder` or `GridView.builder`; `loadMore()` is a no-op when `!hasMore` or not in data status, so repeated events are safe.
- **Retry:** error state shows a button calling `load()`. Resolves the 003 open question minimally; no automatic retry.
- **DI:** `App` accepts an optional `UniversityRepository`; `main()` builds `UniversityRepositoryImpl(UniversitiesApiService(...))` and `App` provides a `ChangeNotifierProvider` that creates the ViewModel and calls `load()`. Tests inject a fake repository. Alternative: provide at the route; rejected so state survives navigation to detail and back.
- **Grid** uses `SliverGridDelegateWithMaxCrossAxisExtent` for responsive columns.

## Risks / Trade-offs

- [Scroll event fires before layout fills the viewport, leaving too little to scroll] → first page of 20 exceeds a typical viewport; `loadMore()` is also idempotent.
- [Switching layout swaps the scrollable widget and may reset scroll offset] → accepted; position preservation is out of scope.
- [Full list held in memory] → ~10k small objects at most; acceptable.

## Open Questions

- None blocking.
