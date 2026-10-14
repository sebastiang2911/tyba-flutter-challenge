# Tasks

## 1. Icon sources

- [x] 1.1 Create `assets/icon/tyba_mark.svg` with the two mark paths from `assets/tyba.svg` in a square `viewBox` (`492 -56 290 290`); verify it opens correctly in a browser or `qlmanage -p`
- [x] 1.2 Install a rasterizer (`brew install librsvg`) and render `assets/icon/app_icon.png` (1024x1024, white background, opaque); verify with `file` that size is 1024x1024 and there is no alpha channel
- [x] 1.3 Render `assets/icon/app_icon_foreground.png` (1024x1024, transparent background); verify with `file` that it has an alpha channel and visually check the mark is centered inside the safe zone

## 2. Icon generation

- [x] 2.1 Add `flutter_launcher_icons` to `dev_dependencies` and its `flutter_launcher_icons:` config block to `pubspec.yaml` (`ios: true`, `android: true`, `image_path`, adaptive background/foreground, `remove_alpha_ios: true`); verify `flutter pub get` succeeds
- [x] 2.2 Run `dart run flutter_launcher_icons`; verify `AppIcon.appiconset` and `mipmap-*` files changed and the adaptive icon XML exists under `android/app/src/main/res/mipmap-anydpi-v26/`
- [x] 2.3 Run `flutter analyze` and `flutter test`; verify both pass with no new issues
- [x] 2.4 Build and launch on an iOS simulator and an Android emulator (`flutter run`); verify the home screen shows the Tyba mark on both platforms

## 3. Documentation

- [x] 3.1 Add a short "App icon" section to `README.md` with the regeneration command and the source files; verify the documented command runs as written
- [x] 3.2 Mark `010-app-icon` as done in `ROADMAP.md`
