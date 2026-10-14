# Design

## Context

After `001-setup-project-structure` the tree is empty folders plus the template `main.dart` (counter app) and its widget test. No dependencies beyond Flutter. See proposal.md for motivation and scope.

## Goals / Non-Goals

**Goals:**
- A bootable shell: `main.dart` -> `App` (`MaterialApp.router`) -> `go_router` -> placeholder views.
- Establish where app-level wiring lives (`lib/app/`) and how views are reached (`go_router` paths).
- Cover boot and routing with widget tests.

**Non-Goals:**
- Data layer, domain models, ViewModels, real UI, validators.
- Registering any `provider` objects (nothing to register yet).

## Decisions

**Files and responsibilities.**

```
lib/main.dart                  runApp(const App())
lib/app/app.dart               App: MaterialApp.router(routerConfig, theme)
lib/app/router.dart            AppRoutes (path constants) + buildRouter()
lib/app/theme.dart             buildAppTheme()
lib/ui/features/universities/views/
  universities_list_view.dart  placeholder for `/`
  university_detail_view.dart  placeholder for `/university/:id`, takes `int id`
```

**Router as a factory, not a global.** `buildRouter()` returns a new `GoRouter` each call so tests can build an isolated router and it can later be placed in the `provider` tree if needed. Alternative: a top-level `final router`, rejected because shared state leaks between tests.

**Route constants.** `AppRoutes.list = '/'`, `AppRoutes.detail = '/university/:id'` plus a `detailFor(int id)` helper, so views never hardcode paths. The id is parsed as `int` to match the sequential id defined in `001`; an invalid id falls through to go_router's error page.

**Placeholders live in `ui/`, not `app/`.** `app/` only wires; screens belong to the UI layer and will be replaced in place by later changes. Naming follows the skill (`*_view.dart`).

**Theme.** Material 3 with a seed color; one function, no extension classes yet.

**Dependencies.** `provider` and `http` are added now (as requested) but unused until later changes; `flutter analyze` does not flag unused dependencies. Versions are whatever `flutter pub add` resolves.

**`App` is a `StatelessWidget`** holding the router in a field created once in the constructor path (`App` takes an optional `GoRouter` for tests, defaulting to `buildRouter()`), avoiding router recreation on rebuild.

## Risks / Trade-offs

- [Unused dependencies until later changes] -> Accepted; they are consumed by `003+`.
- [Placeholders get replaced, tests with them too] -> Tests assert routing (which view is shown per path), not placeholder text styling.
- [Router recreated on rebuild] -> Built once and injected into `App`.

## Open Questions

None.
