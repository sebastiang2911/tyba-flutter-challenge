# Design

## Context

`GoRouter` starts at `/` (list). `universitiesProvider` is a keepAlive `Future` provider (`retry: noRetry`) in `lib/ui/features/universities/providers/universities_list_providers.dart`; the list view already renders its loading/error/empty/data states and retries via invalidate. Launch screens are Flutter defaults. App icon was generated with `flutter_launcher_icons` from `assets/icon/`. See proposal.md for motivation.

## Goals / Non-Goals

**Goals:**
- Branded native launch screen plus animated Flutter splash.
- Splash waits on real work (the universities prefetch), not an arbitrary timer.
- Testable without real time or network.

**Non-Goals:**
- Dark-mode splash variants.
- Persisting or caching data across sessions.
- Changing list/detail behavior or the error/retry UX.

## Decisions

1. **Native splash via `flutter_native_splash` (dev dep), config in `pubspec.yaml`.** Same pattern as `flutter_launcher_icons`; generates iOS storyboard and Android 12+ resources. Uses the triangular mark (`assets/icon/app_icon_foreground.png` / mark PNG) on `#FFFFFF`, because Android 12 only renders a centered icon on a solid background. Alternative: hand-edit storyboard and styles: error-prone, not reproducible.

2. **Flutter splash is a route `/splash` (`AppRoutes.splash`) and the new `initialLocation`.** Keeps navigation in `go_router`. Leaving uses `context.go(AppRoutes.list)`, which replaces the stack, so back never returns. Alternative: `redirect` based on a ready flag: more indirection for one-shot startup.

3. **Gate logic in a provider, not the view.** `splashReady` in `lib/ui/features/splash/providers/splash_providers.dart` (`@riverpod Future<void>`): awaits `Future.wait` of the universities (errors swallowed) and a minimum delay. The view only does `ref.listen`/`AsyncValue.when` and navigates on completion. Failure is swallowed in the gate because `universitiesProvider` stays cached in its error state and the list view shows it. Alternative: logic in the view's `initState`: untestable and breaks the MVVM rule.

4. **Minimum duration injectable.** `splashMinDurationProvider` (default 800 ms) overridden in tests with `Duration.zero`/short value; avoids `pumpAndSettle` hanging on real timers.

5. **Animation: `TweenAnimationBuilder` fade + scale of the wordmark**, no `AnimationController` boilerplate and no animation package. Honors `MediaQuery.disableAnimations` (skips to the final frame).

6. **Wordmark as PNG (`assets/images/tyba_wordmark.png`) exported from `assets/tyba.svg`.** Avoids `flutter_svg` for a single screen. Trade-off: raster asset, mitigated by exporting at 3x.

## Risks / Trade-offs

- [Native and Flutter splash visually jump] → Same white background and centered mark; wordmark fades in so the change reads as continuation.
- [Prefetch error hidden in splash] → Intentional; list shows error and retry (`universitiesProvider` is keepAlive and caches the error).
- [Generated native files add a large diff] → Isolated in one task/commit; regenerate with `dart run flutter_native_splash:create`.
- [Added fixed 800 ms on fast networks] → Short and bounded; configurable via provider.

## Migration Plan

Additive. Rollback: revert the commit and re-run `dart run flutter_native_splash:remove` if the native files must be restored.
