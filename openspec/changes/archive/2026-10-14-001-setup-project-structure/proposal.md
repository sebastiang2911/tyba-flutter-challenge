# Proposal

## Why

The project is the default Flutter template (`lib/main.dart` counter app, no dependencies). The test is graded on engineering quality first, so the architecture must be fixed before any feature code lands, otherwise later work will drift and need rework.

## What Changes

- Create the folder structure only, following the `flutter-apply-architecture-best-practices` layout (UI MVVM / Data / Domain, hybrid organization) under `lib/` and a mirrored tree under `test/`.
- Add a `.gitkeep` to every empty leaf directory so git tracks it.
- No code, dependencies, or README changes. `lib/main.dart` and `test/widget_test.dart` stay as the template.
- Record the target conventions in `CLAUDE.md` (layout, MVVM with `ChangeNotifier` + `provider`, `go_router`, id/order invariant).

Feature code, dependencies and the README are delivered by later changes.

## Capabilities

### New Capabilities

None. This change is structural scaffolding; it sets `skip_specs: true`.

### Modified Capabilities

None.

## Impact

- Code: new empty directories under `lib/` and `test/`; no Dart files added or changed.
- Dependencies: none now. Later changes are expected to add `provider`, `go_router`, `http`.
- Docs: `CLAUDE.md` architecture section updated.
