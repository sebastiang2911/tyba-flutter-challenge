# Design

## Context

Theme is `ColorScheme.fromSeed(Colors.indigo)` in `lib/app/theme.dart`; router uses default `builder` pages; list and detail views each duplicate loading/error/empty UI; `Info.plist` allows landscape. The Tyba logo (`assets/tyba.svg`) uses red `#D54028` and dark gray `#1C262B`. No new dependencies are wanted.

## Goals / Non-Goals

**Goals:**
- Brand light/dark theme, portrait-only, polished transitions and feedback.
- Shared UI building blocks in `lib/ui/core`, no duplicated state UI.
- Keep Views free of business logic; keep existing providers untouched where possible.

**Non-Goals:**
- Adaptive/tablet layouts, manual theme toggle, persistence, skeleton/animation packages.

## Decisions

- **Theme**: `buildLightTheme()` / `buildDarkTheme()` using `ColorScheme.fromSeed(seedColor: 0xFFD54028, brightness: ...)`, with `surface`/`onSurface` tuned to `#1C262B` in dark. `MaterialApp.router` gets `theme`, `darkTheme`, `themeMode: ThemeMode.system`. Alternative (hand-written `ColorScheme`) rejected: more code, same result.
- **Orientation**: three layers: `Info.plist` (iPhone + iPad lists reduced to portrait), `AndroidManifest.xml` `android:screenOrientation="portrait"`, and `SystemChrome.setPreferredOrientations` in `main()` as a Dart-level guarantee. Splash native asset unaffected.
- **Transitions**: one `fadeSlidePage` helper in `lib/app/` returning `CustomTransitionPage` (FadeTransition + small SlideTransition, ~300 ms, `Curves.easeOutCubic`); used by list and detail routes. Splash route keeps its own hand-off. `MediaQuery.disableAnimations` makes the duration zero.
- **Hero**: two Heroes per university: `university-<id>-title` on the name `Text` and `university-<id>-avatar` on a `CircleAvatar` with the initial. Sources: list tile and grid card (card gains the avatar). Target: a `Row[avatar, title]` in `_InfoSection`, below the image (the AppBar title is not a Hero). Title is wrapped with `Material(type: transparency)` to avoid text style flicker. A shared `UniversityAvatarHero` keeps the avatar identical in all three places. Image is not a Hero (it is user-assigned and absent at list time).
- **Layout switch**: `AnimatedSwitcher` (250 ms) keyed by `UniversitiesLayout`; the shared `ScrollController` is attached to only one scrollable at a time (old child is removed from the tree after fade, so use `layoutBuilder`/`transitionBuilder` carefully and verify no "ScrollController attached to multiple positions" error). Fallback: switch without cross-fade if this proves flaky.
- **Load-more indicator**: extra last item (`itemCount + 1`) when `visible.hasMore`; grid uses a `SliverToBoxAdapter` via `CustomScrollView` only if needed, else a bottom overlay. Decide at implementation; spec only fixes the behavior.
- **Skeleton**: small `Skeleton` widget in `ui/core` with a looping opacity/shimmer-like `AnimationController` (no package); list skeleton renders ~8 tile-shaped bars.
- **Shared state widgets**: `LoadingView`, `ErrorView(message, onRetry)`, `EmptyView(message)` in `lib/ui/core`; both screens use them. Detail loading keeps a spinner (single item).
- **Detail UX**: `AnimatedSwitcher` for the image (FadeTransition); `ScaffoldMessenger` snackbar on valid save. Success detection: the notifier already exposes `studentCountError`; save succeeds when it is null after submit. Keyboard dismissed with `FocusScope.of(context).unfocus()`. `FilteringTextInputFormatter.digitsOnly`.
- **A11y**: `Semantics` on image area (label varies assigned/unassigned) and `tooltip`/`label` on actions; layout toggle already has a tooltip.

## Risks / Trade-offs

- `AnimatedSwitcher` + shared `ScrollController` may attach to two scrollables during the fade -> mitigate with separate keys and detaching, or drop the cross-fade.
- Hero text between different text styles can jump -> use `flightShuttleBuilder` or a transparency `Material`.
- Avatar and title fly as two independent Heroes with different sizes; they may drift slightly apart mid-flight -> keep the same row alignment in source and target, and check on device.
- Existing widget tests find `CircularProgressIndicator`/error text in the list -> update finders to the shared widgets.
- Dark palette contrast of Tyba red on dark gray must be checked (`onPrimary`, error colors) to stay readable.
