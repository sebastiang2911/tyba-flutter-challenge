# Design

## Context

`lib/app/theme.dart` builds both themes with `ColorScheme.fromSeed(seedColor: tybaRed)` and overrides `surface`/`onSurface` with `tybaDarkGray`. Cards already read colors from the scheme.

## Goals / Non-Goals

**Goals:**
- Swap the palette in one place; all widgets inherit it.

**Non-Goals:**
- Changing logo, launcher icon or splash assets.

## Decisions

- **Seed indigo, force `secondary` to amber** via `copyWith`, because `fromSeed` would otherwise derive a muted indigo secondary. Alternative: `fromSeed` with `dynamicSchemeVariant`; rejected, less predictable.
- **Keep `tybaDarkGray`** so dark mode retains some brand identity.
- **Remove `tybaRed`** from theme use; keep it only if still referenced elsewhere (none found outside the theme and its test).

## Risks / Trade-offs

- [Amber on light surfaces has low contrast] → use it only for accents with `onSecondary` text; verify `onSecondary` contrast in a test.
- [Splash/icon keep red, slight mismatch] → accepted; out of scope.
