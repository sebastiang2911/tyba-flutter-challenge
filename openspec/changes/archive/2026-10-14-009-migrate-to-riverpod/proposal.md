# Proposal

## Why

State management and DI use `provider` with `ChangeNotifier` ViewModels created inside widgets and routes. Riverpod gives compile-safe, context-free DI, automatic disposal and easier test overrides, and fits the test's engineering-quality criterion better. The migration follows the style already used in the author's `flutter-riverpod-app` (code-generated providers, small focused providers, `AsyncValue.when` in views) so both codebases read the same.

## What Changes

- Replace `provider` with `flutter_riverpod`; add `riverpod_annotation` (dependency) and `riverpod_generator` + `build_runner` (dev dependencies).
- Providers are declared with `@riverpod` / `@Riverpod(keepAlive: true)`; generated `*.g.dart` files are committed.
- Infrastructure (http client, API service, image picker, repositories) is built by keepAlive function providers; tests override them with fakes.
- Universities list state is split into small providers: a `Future` provider for the data, notifiers for layout and visible count, and a derived provider for the visible page. Views consume it with `AsyncValue.when`.
- University detail uses a family `Future` provider for the university and a family notifier for the profile (image, student count and their errors).
- The router becomes an `appRouter` provider; `main` runs `ProviderScope(child: App())` and `App` is a `ConsumerWidget`.
- `view_models/` folders are renamed to `providers/` with a barrel file.
- Update tests, `CLAUDE.md`, `README.md` and `openspec/config.yaml` context to describe Riverpod.
- No user-visible behavior change.

## Capabilities

### New Capabilities

None.

### Modified Capabilities

None. Pure refactor; the change sets `skip_specs: true`.

## Impact

- Code: `lib/main.dart`, `lib/app/{app,router}.dart`, new `lib/app/providers.dart`, the universities feature providers (replacing the ViewModels) and both views.
- Tests: ViewModel tests become provider tests (`ProviderContainer`); view and app tests use `ProviderScope` overrides.
- Dependencies: remove `provider`; add `flutter_riverpod`, `riverpod_annotation`, `riverpod_generator`, `build_runner`.
- Build: generated `*.g.dart` files are committed; `dart run build_runner build` must be re-run when providers change.
- Docs: `CLAUDE.md`, `README.md`, `openspec/config.yaml`, `ROADMAP.md`.
