# Proposal

## Why

`universities_list_view.dart` (202 lines) and `university_detail_view.dart` (315 lines) each hold the screen plus every private sub-widget (tiles, cards, sections, rows, form). They are hard to scan, and the private classes cannot be tested or reused on their own. Engineering quality is the top evaluation criterion, so the views should read as short compositions of small, named widgets.

## What Changes

- Add a `widgets/` folder under `lib/ui/features/universities/` and move every private sub-widget there as a public, single-purpose widget in its own file (container-presentational: views and containers read providers, widgets receive data and callbacks).
- List: extract `UniversityTile`, `UniversityCard`, `UniversitiesContent` (scroll + pagination), and the load-more indicator; the layout toggle becomes its own widget.
- Detail: extract `UniversityImageSection`, `ImagePlaceholder`, `UniversityInfoSection`, `InfoRow`, `StudentCountSection` and the detail content container.
- Move `UniversityAvatarHero` and `UniversityTitleHero` from `views/` into `widgets/`.
- Views keep only the screen scaffold (app bar, `AsyncValue.when`, navigation).
- Tests mirror the new files; existing view tests stay green, no behavior change.
- Update README/CLAUDE.md layout notes (`views/` + `widgets/`).

## Capabilities

### New Capabilities

None.

### Modified Capabilities

None. Pure refactor: no spec-level behavior changes (`skip_specs: true`).

## Impact

- Code: `lib/ui/features/universities/views/*` split into `views/` + `widgets/`; imports updated.
- Tests: new focused widget tests under `test/ui/features/universities/widgets/`; existing view tests untouched except import paths.
- Docs: README and CLAUDE.md folder layout.
- Dependencies: none.
- Non-goals: visual or behavior changes, splash view (already 48 lines), `lib/ui/core` widgets.
