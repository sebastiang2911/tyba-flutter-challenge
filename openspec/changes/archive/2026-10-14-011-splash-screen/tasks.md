# Tasks

## 1. Assets and native splash

- [x] 1.1 Export the wordmark from `assets/tyba.svg` to `assets/images/tyba_wordmark.png` (3x) and register it in `pubspec.yaml`; verify the file exists and `flutter pub get` succeeds
- [x] 1.2 Add `flutter_native_splash` as dev dependency with config (white background, triangular mark, Android 12 block); verify `flutter pub get` succeeds
- [x] 1.3 Run `dart run flutter_native_splash:create`; verify iOS `LaunchScreen.storyboard` and Android `launch_background` / `styles.xml` changed and `flutter build apk --debug` (or `flutter run`) shows the mark on cold start

## 2. Splash gate provider

- [x] 2.1 Add `lib/ui/features/splash/providers/splash_providers.dart` with `splashMinDurationProvider` (800 ms) and `splashReady` (`@riverpod Future<void>`: waits for `universitiesProvider`, swallowing errors, and the minimum delay); run `dart run build_runner build -d` and verify `*.g.dart` is generated
- [x] 2.2 Unit tests in `test/ui/features/splash/providers/`: fast fetch waits for min duration, slow fetch waits for fetch, failed fetch still completes; verify `flutter test` passes

## 3. Splash view and routing

- [x] 3.1 Add `lib/ui/features/splash/views/splash_view.dart`: white background, wordmark with fade + scale (`TweenAnimationBuilder`), skips animation when `MediaQuery.disableAnimations`; navigates with `context.go(AppRoutes.list)` when `splashReady` completes (no business logic in the view)
- [x] 3.2 Add `AppRoutes.splash`, route, and set it as `initialLocation` in `lib/app/router.dart`; run `dart run build_runner build -d`; verify `flutter analyze` is clean
- [x] 3.3 Widget tests in `test/ui/features/splash/views/` with fake repository and zero/short min duration: splash shown first, navigates to list on success, navigates to list showing error and retry on failure, back from list does not return to splash; update `test/app/router_test.dart` and `app_test.dart` for the new initial route; verify `flutter test` passes

## 4. Docs and integration

- [x] 4.1 Update README (startup flow, native splash regeneration command), tick `011-splash-screen` in `ROADMAP.md`, and update CLAUDE.md "Current State"; verify docs mention the commands as written
- [x] 4.2 Run `flutter analyze` and `flutter test`, then launch on a simulator and verify native mark -> animated wordmark -> list with no white flash or back-to-splash
