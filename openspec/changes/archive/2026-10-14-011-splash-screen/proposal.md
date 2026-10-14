# Proposal

## Why

The app opens on the default white Flutter launch screen and jumps straight to the list's loading spinner. A branded splash gives a polished first impression and hides the initial universities fetch behind real work, not an artificial delay.

## What Changes

- Native launch screen (iOS and Android 12+) with the Tyba triangular mark on a white background, generated with `flutter_native_splash`.
- New Flutter splash screen at `/splash` showing the animated Tyba wordmark (PNG asset, no new runtime dependency).
- Splash prefetches the universities list and leaves after a short minimum duration (~800 ms), whichever is later.
- If the prefetch fails, the splash still navigates to the list, which shows its own error and retry state.
- Router starts at `/splash`; leaving it replaces the stack so back never returns to it.

## Capabilities

### New Capabilities

- `app-splash`: startup splash behavior: shown first, branded animation, prefetch of universities, minimum duration, navigation to the list on success or failure.

### Modified Capabilities

<!-- None: list and detail requirements are unchanged. -->

## Impact

- Code: `lib/app/router.dart` (initial location, new route), new `lib/ui/features/splash/{providers,views}`.
- Assets: wordmark PNG exported from `assets/tyba.svg`.
- Dependencies: `flutter_native_splash` (dev only).
- Native: iOS `LaunchScreen.storyboard` and Android `launch_background` / `values*/styles.xml` regenerated.
- Tests: widget tests for splash navigation (success, failure, minimum duration).
