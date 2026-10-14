# Design

## Context

Greenfield Flutter app (SDK ^3.13.5). Source data is a single JSON array of 2178 US universities (`name`, `country`, `alpha_two_code`, `domains[]`, `web_pages[]`, `state-province` nullable). There is no `id` field and 10 names repeat. See proposal.md for motivation.

## Goals / Non-Goals

**Goals:**
- Fix directory layout and layer boundaries before feature work, per `flutter-apply-architecture-best-practices`.
- Make the dependency direction explicit: `ui -> domain <- data`.
- Establish the identity and ordering rules later work will rely on.

**Non-Goals:**
- Writing any Dart code, adding dependencies, or implementing list/detail/pagination behavior.
- Persistence between sessions.

## Decisions

**Layout** (hybrid: Data/Domain grouped by type, UI grouped by feature):

```
lib/
  main.dart
  app/                         app, router, theme
  data/
    models/                    API models
    repositories/              repository implementations
    services/                  stateless API clients
  domain/
    models/                    clean domain models (University)
    repositories/              abstract repository contracts
    validators/                StudentCountValidator
  ui/
    core/                      shared widgets (loading, error, empty)
    features/universities/
      view_models/
      views/
test/                          mirrors lib/ (data, domain, ui/features/universities)
```

**MVVM in the UI layer.** ViewModels extend `ChangeNotifier`, take repositories through the constructor and expose immutable state; Views are lean and listen with `ListenableBuilder`. Alternative: Riverpod notifiers, rejected to follow the adopted skill and avoid an extra paradigm.

**DI with `provider`.** Services, repositories and ViewModels are registered at the app root. Alternative: `get_it`; `provider` keeps wiring inside the widget tree.

**Single `universities` UI feature.** List and detail share the entity and state; splitting would duplicate both.

**No use cases layer.** With two or three operations it adds indirection without value; ViewModels call the repository directly. The skill marks this layer optional.

**Local state in the ViewModel.** Assigned image and student count are session-only user input. They live in the ViewModel keyed by university `id`, merged with the domain model at read time; `domain` stays free of mutable UI state.

**Student count validation in `domain/validators`.** It is a business rule (non-empty, integer, > 0, upper bound), not generic UI code.

**`go_router`** with routes `/` (list) and `/university/:id`.

**Data source: direct HTTP request.** On failure the ViewModel exposes an error state; no local fallback. Alternative: bundled JSON fallback, rejected to avoid two sources of truth.

**Identity and order invariant.** The repository assigns a sequential `id` (index in the source array) while mapping API models to domain models, before any filter or sort, and returns items in source order. Later sorting or filtering lives in the ViewModel and never reassigns `id`. Alternative: composite key `name + domains.first`, rejected as collision-prone and fragile in URLs.

**Pagination in the ViewModel.** The full list is held in memory; the visible slice is `items.take(page * 20)`, extended by a hand-written scroll listener. No external library.

## Risks / Trade-offs

- [Empty directories are not tracked by git] -> `.gitkeep` in every leaf directory.
- [Index id breaks if a future sort/filter runs before id assignment] -> Assign ids only in the repository; later change covers it with a unit test.
- [Overrides keyed by id are lost on restart] -> Accepted; persistence is out of scope.

## Open Questions

- Retry UX in the error state (button vs pull-to-refresh); does not affect structure or tasks.
