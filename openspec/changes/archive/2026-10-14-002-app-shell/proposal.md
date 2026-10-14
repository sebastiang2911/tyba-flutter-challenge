# Proposal

## Why

The folder structure from `001-setup-project-structure` is in place, but the app is still the template counter app and has no dependencies. Feature work (data, list, detail) needs a running shell with routing, theme and dependency injection root first, so each later change plugs into it instead of reworking `main.dart`.

## What Changes

- Add dependencies: `provider`, `go_router`, `http`.
- Add `lib/app/theme.dart` (app `ThemeData`), `lib/app/router.dart` (`go_router` with `/` and `/university/:id`) and `lib/app/app.dart` (`MaterialApp.router`).
- Add placeholder views for the two routes under `lib/ui/features/universities/views/` (static text only, no logic, no data).
- Reduce `lib/main.dart` to `runApp(App())`; remove the template counter code.
- Replace `test/widget_test.dart` with tests for the app boot and the two routes.

Out of scope: data layer, domain models, ViewModels, real list/detail UI, validators, and any provider registrations (added by the changes that introduce what they register).

## Capabilities

### New Capabilities

None. This change is application scaffolding with no spec-level behavior; it sets `skip_specs: true`.

### Modified Capabilities

None.

## Impact

- Code: `lib/main.dart` rewritten; new files under `lib/app/` and `lib/ui/features/universities/views/`; `test/widget_test.dart` replaced.
- Dependencies: `pubspec.yaml` gains `provider`, `go_router`, `http`.
- No README change (documented in a later change).
