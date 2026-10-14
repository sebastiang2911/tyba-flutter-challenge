# Design

## Context

`UniversityTile` is a bare `ListTile`; `UniversityCard` is a `Card` with a small avatar, `elevation: 0` from the global `cardTheme`, in a fixed 120 px grid extent. Both use `UniversityAvatarHero` / `UniversityTitleHero`, which must keep working for the detail transition.

## Goals / Non-Goals

**Goals:**
- Both layouts read as the same card family.
- Keep widget APIs (`university`, `onTap`) unchanged so callers and providers are untouched.

**Non-Goals:**
- Changing the avatar content (initial stays), skeleton placeholders, detail screen or data.

## Decisions

- **Card style lives in `cardTheme`** (low elevation, rounded 16, `surfaceContainerLow`), not per-widget, so both items stay consistent. Alternative: a shared `UniversityCardShell` widget; rejected as unnecessary for two small widgets.
- **List item = `Card` + `InkWell` + `ListTile`** with `contentPadding`, larger avatar (radius 24) and horizontal/vertical margin 16/6. Keeps ListTile a11y semantics.
- **Grid item = centered `Column`**: avatar (radius 28), name (`titleSmall`, centered, max 2-3 lines), country. Grid delegate changes from `mainAxisExtent: 120` to a taller fixed extent (~180) to fit centered content.
- Hero widgets unchanged; avoid `Clip` changes that would crop the hero flight.

## Risks / Trade-offs

- [Fixed grid extent may overflow with large text scale] → use `FittedBox`-free layout with `maxLines` + ellipsis and verify with a widget test at text scale 2.0.
- [Theme change affects other Cards (detail screen)] → check detail cards visually; scope via per-widget `elevation` override if they regress.
