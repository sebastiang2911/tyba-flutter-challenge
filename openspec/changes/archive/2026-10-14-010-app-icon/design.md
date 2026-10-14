# Design

## Context

`assets/tyba.svg` is the full horizontal logo (1000x194): wordmark "tyba" on the left (x 0-429), the triangular mark in the middle (x 544-730, `#1C262B` mountain plus `#D54028` accent) and small text on the right. The mark's two paths are self-contained, so they can be lifted without editing coordinates. The machine has no SVG rasterizer (`rsvg-convert`, `inkscape`, `magick` are missing). See proposal.md for motivation.

## Goals / Non-Goals

**Goals:**
- iOS and Android icons from the triangular mark, with Android adaptive support.
- Reproducible generation: committed sources plus a single command.

**Non-Goals:**
- Splash screen (change `011`).
- Themed/monochrome Android 13 icon, notification icons, web/desktop icons.
- Changing the app display name.

## Decisions

- **Mark choice**: the triangular mark, not the wordmark. A 4-letter wordmark is unreadable at 29-60 px; the mark is the brand symbol.
- **Square source SVG** (`assets/icon/tyba_mark.svg`): copy the two mark paths into a square `viewBox` of about 290 units centered on the mark (center x 637, y 89), i.e. `viewBox="492 -56 290 290"`. The mark is 186 units wide, which is about 64% of the canvas. That fits the Android adaptive safe zone (66% of 108dp) and leaves a natural margin on iOS. One viewBox serves both variants.
- **Two variants**: `app_icon.png` (1024, white background, opaque, used for iOS and legacy Android) and `app_icon_foreground.png` (1024, transparent, adaptive foreground over a white `adaptive_icon_background`).
- **Rasterization**: one-off `brew install librsvg`, then `rsvg-convert -w 1024 -h 1024`. PNGs are committed, so librsvg is not a project dependency. Alternative rejected: `flutter_svg` + a Dart script (adds a rendering pipeline for a one-time asset).
- **Generation**: `flutter_launcher_icons` as a dev dependency configured in `pubspec.yaml` (`image_path`, `adaptive_icon_background`, `adaptive_icon_foreground`, `remove_alpha_ios: true`). Alternative rejected: hand-built asset sets (error-prone, many sizes).
- **Assets folder**: icon sources live in `assets/icon/`, not declared under `flutter: assets:` because they are build-time only.

## Risks / Trade-offs

- [iOS rejects icons with alpha] -> `remove_alpha_ios: true` and an opaque white `app_icon.png`.
- [Generator overwrites existing icon files] -> intended; review the git diff of `ios/` and `android/` before committing.
- [Red accent low contrast on white at small sizes] -> check the rendered 1024 PNG and a built app on a simulator/emulator.
- [Hand-extracted paths drift from `tyba.svg`] -> accepted; the logo is a fixed brand asset.
