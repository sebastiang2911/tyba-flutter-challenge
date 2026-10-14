# Proposal

## Why

The Tyba red primary does not convey an academic feel for a universities app. A deep indigo with an amber accent fits the domain and matches current edu/fintech palettes.

## What Changes

- Primary seed becomes deep indigo `#283593`; secondary becomes amber `#F2A93B` in both themes.
- Dark theme keeps the Tyba dark gray (`#1C262B`) as surface; light theme keeps it as text color.
- The app bar uses the indigo as background with white title and icons.
- The universities list screen gets a background gradient: indigo from the app bar fading into the surface color toward the bottom.
- The Tyba red constant is no longer used for the theme.
- **BREAKING**: the `app-appearance` requirement that the primary is Tyba red changes to indigo.

## Capabilities

### New Capabilities

### Modified Capabilities
- `app-appearance`: brand theme requirement now specifies indigo primary and amber accent.

## Impact

- `lib/app/theme.dart` (seed, secondary, constants).
- `test/app/theme_test.dart` (hue assertion).
- `lib/ui/core/gradient_backdrop.dart` (new), `universities_list_view.dart`.
- No new dependencies. Logo, launcher icon and splash are unchanged.
