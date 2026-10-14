# Proposal

## Why

The app works but looks generic: an indigo seed unrelated to the Tyba brand, no dark theme, abrupt screen and layout changes, no feedback after saving, and duplicated loading/error/empty UI. Engineering quality is the top evaluation criterion, so polishing the UI/UX with shared, tested components fits now that the functional scope is complete.

## What Changes

- Brand theme: light and dark `ThemeData` derived from the logo (red `#D54028`, dark gray `#1C262B`), following the system `ThemeMode`.
- Portrait-only: lock orientation on iOS (`Info.plist`, iPhone and iPad), Android (`AndroidManifest.xml`) and in `main()` via `SystemChrome`.
- Route transitions: custom fade + slide pages in `go_router` for list and detail (splash keeps its own hand-off).
- Hero animation from the tapped list item (tile and card) to the detail header row (initial avatar + title, below the image); the grid card gains the same avatar.
- Animated list <-> grid switch (`AnimatedSwitcher`), keeping scroll-driven pagination working.
- Load-more indicator at the end of the list while more items remain.
- Skeleton placeholders instead of a bare spinner for the list loading state.
- Shared loading / error (with retry) / empty widgets in `lib/ui/core`, replacing the duplicated code in both views.
- Detail UX: fade-in of the assigned image, snackbar confirming a saved student count, keyboard dismissed on save, digits-only input.
- Accessibility: `Semantics` labels on key actions and the Hero/image areas.

## Capabilities

### New Capabilities

- `app-appearance`: brand light/dark theme following the system, portrait-only orientation and animated route transitions.

### Modified Capabilities

- `universities-list`: skeleton loading, load-more indicator, animated layout switch and Hero source on items.
- `university-detail`: Hero target, image fade-in, saved-count feedback, digits-only input with keyboard dismissal.

## Impact

- Code: `lib/app/theme.dart`, `lib/app/app.dart`, `lib/app/router.dart`, `lib/main.dart`, new `lib/ui/core/` widgets, list and detail views.
- Platform files: `ios/Runner/Info.plist`, `android/app/src/main/AndroidManifest.xml`.
- Tests: widget tests for shared widgets, list/detail behavior and theme; existing tests updated where finders change.
- Dependencies: none new (no skeleton or animation packages).
- Non-goals: adaptive/tablet layout, persistence, user-selectable theme toggle.
