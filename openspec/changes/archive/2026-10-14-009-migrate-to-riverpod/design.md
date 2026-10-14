# Design

## Context

Current code (already migrated once) uses plain `Notifier` ViewModels with hand-written `NotifierProvider`s, repository providers that throw `UnimplementedError` and are overridden in `App`, and a router built outside Riverpod. The reference style lives in `flutter-riverpod-app`: `riverpod_generator`, `Ref ref` function providers, `extends _$Name` notifiers, derived providers, `AsyncValue.when`, router as provider, `ProviderScope(child: MyApp())`. See proposal.md for motivation.

## Goals / Non-Goals

**Goals:**
- Same behavior, states and user flows; only the state/DI mechanism changes.
- Match the reference project's Riverpod style as closely as the architecture allows.
- Keep domain/data layers untouched; keep tests as the safety net with the same scenarios.

**Non-Goals:**
- No hooks, no `riverpod_lint`, no behavior or retry-UX change, no new features.

## Decisions

1. **Code generation** (`riverpod_annotation` + `riverpod_generator` + `build_runner`). Generated `*.g.dart` files are committed (as in the reference). Alternative (hand-written providers) rejected: diverges from the reference style.
2. **Infrastructure as keepAlive function providers** in `lib/app/providers.dart`: `httpClient`, `universitiesApiService`, `imagePickerService`, `universityRepository`, `universityProfileRepository`. Concrete instances are built inside providers (no overrides in `main`); tests override them with fakes. Alternative (override-only, throwing defaults) rejected: more wiring in `main`, unlike the reference.
3. **`main` and `App`**: `runApp(ProviderScope(child: App()))`; `App` is a `ConsumerWidget` that watches `appRouterProvider` and `buildAppTheme()`. The router is `@riverpod GoRouter appRouter(Ref ref)` in `lib/app/router.dart`. This changes `App`'s constructor (no repository params); app tests use `ProviderScope(overrides: [...])`.
4. **Universities list as small providers** (like `Todos` / `filteredTodos`):
   - `universities`: `@Riverpod(keepAlive: true) Future<List<University>>` calling the repository.
   - `UniversitiesLayoutNotifier` (`list` | `grid`) with `toggle()`.
   - `VisibleCount` notifier starting at the page size (20) with `loadMore()`, a no-op when nothing remains.
   - `visibleUniversities`: derived provider (first `VisibleCount` items; exposes `hasMore`).
   - Generated names drop the `Notifier` suffix (`universitiesLayoutProvider`).
   - Retry: `ref.invalidate(universitiesProvider)`. Views use `AsyncValue.when` for loading/error/data; the empty state is a data branch with an empty list. The `status`-enum state classes are removed.
5. **University detail**:
   - `university(Ref, int id)`: family `Future<University>` (autoDispose, default).
   - `UniversityProfileNotifier` family keyed by id (provider: `universityProfileProvider(id)`): holds the profile, `pickImage(source)`, `submitStudentCount(input)` and exposes image and student-count errors in a small immutable state. Views use `.when` on the university and watch the profile notifier.
6. **Views** are Consumer widgets; `UniversitiesListView` stays a `ConsumerStatefulWidget` for its `ScrollController`. Reads: `ref.watch`; actions: `ref.read(x.notifier)`.
7. **Folders**: `view_models/` becomes `providers/` per feature with a barrel `providers.dart`; tests mirror it under `test/ui/features/universities/providers/`.
8. **Versions**: `flutter_riverpod ^3.4.3`, `riverpod_annotation ^4.0.7`, `riverpod_generator ^4.0.9` (same as the reference); `build_runner` latest compatible via `flutter pub add`.

9. **No automatic retry**: Riverpod 3 retries failed providers with backoff, which keeps them in loading and delays the error. `noRetry` (in `lib/app/providers.dart`, returns `null`) is applied as `retry: noRetry` to `universities` and `university`, so errors show at once and the manual Retry (`ref.invalidate`) behaves as before. Alternative (default retry) rejected: changes behavior and hangs error-path tests.

## Risks / Trade-offs

- [Riverpod 3 automatic retry hides errors] → `noRetry` on the providers that do I/O.
- [Stale `*.g.dart` breaks the build] → Run `dart run build_runner build -d` in every task that touches providers; `flutter analyze` and `flutter test` must pass.
- [Dropping the status enum changes how states are tested] → Tests assert on `AsyncValue` (loading/error/data) and on provider outputs, covering the same scenarios.
- [Auto-dispose of detail providers drops state on leaving the route] → Intended, equals the previous per-route lifetime; profile data lives in the repository.
- [Committed generated files add diff noise] → Accepted; matches the reference and avoids needing `build_runner` to run the app.
- [Doc drift in CLAUDE.md/README/config] → Doc updates are tasks in this change.
