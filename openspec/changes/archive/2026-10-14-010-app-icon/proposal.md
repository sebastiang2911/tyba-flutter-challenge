# Proposal

## Why

The app still ships the default Flutter launcher icon on iOS and Android. A branded icon is the first thing a reviewer sees on the device, and `assets/tyba.svg` already contains the brand mark.

## What Changes

- Extract the triangular mark (dark mountain + red accent) from `assets/tyba.svg` into a standalone square SVG.
- Rasterize it to the PNG sources the icon tooling needs (full icon on white, transparent adaptive foreground).
- Generate the iOS `AppIcon.appiconset` and Android `mipmap-*` / adaptive icon resources with `flutter_launcher_icons`.
- Declare the tool configuration in `pubspec.yaml` so the icons are reproducible.

No runtime behavior, UI code or public API changes.

## Capabilities

### New Capabilities

None.

### Modified Capabilities

None. This is tooling and static assets only, so the change sets `skip_specs: true`.

## Impact

- New dev dependency: `flutter_launcher_icons`.
- New files: `assets/icon/*.svg`, `assets/icon/*.png`.
- Regenerated: `ios/Runner/Assets.xcassets/AppIcon.appiconset/*`, `android/app/src/main/res/mipmap-*/ic_launcher.png`, adaptive icon XML and colors.
- `pubspec.yaml`, `README.md` (how to regenerate icons), `ROADMAP.md`.
