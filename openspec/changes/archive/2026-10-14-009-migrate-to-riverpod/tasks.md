# Tasks

## 1. Dependencies and codegen

- [x] 1.1 Add `riverpod_annotation`, dev `riverpod_generator` and dev `build_runner` (`flutter pub add`); verify `flutter pub get` succeeds and `dart run build_runner build -d` runs

## 2. App wiring

- [x] 2.1 Rewrite `lib/app/providers.dart` with keepAlive infrastructure providers (`httpClient`, `universitiesApiService`, `imagePickerService`, repositories) using `@Riverpod`; verify generated file exists and `flutter analyze` is clean
- [x] 2.2 Make the router an `@riverpod appRouter` provider; make `App` a `ConsumerWidget` and `main` `runApp(ProviderScope(child: App()))`; update `test/app/*` to use `ProviderScope` overrides with fakes; verify app and router tests pass

## 3. Universities list

- [x] 3.1 Replace the list ViewModel with providers in `ui/features/universities/providers/` (`universities`, layout notifier, `VisibleCount`, `visibleUniversities`); rewrite its tests with `ProviderContainer` covering data, empty, error, pagination by 20, no-more-items, layout toggle and retry; verify the tests pass and the old file is removed
- [x] 3.2 Update `UniversitiesListView` to `.when` over the new providers (retry via `ref.invalidate`); verify the list view widget tests pass

## 4. University detail

- [x] 4.1 Replace the detail ViewModel with the `university` family provider and `UniversityProfileNotifier` family; rewrite its tests covering load, error, pick image (success and failure), student-count validation and save; verify the tests pass and the old file is removed
- [x] 4.2 Update `UniversityDetailView` to the new providers; verify detail view tests and back-navigation tests pass

## 5. Docs and cleanup

- [x] 5.1 Add the `providers.dart` barrel; update `CLAUDE.md`, `README.md` and `openspec/config.yaml` (codegen, folder `providers/`, `build_runner` command); verify `rg -i "ViewModel|view_models|ChangeNotifier"` shows no stale references
- [x] 5.2 Tick `009` in `ROADMAP.md`; run `dart run build_runner build -d`, `flutter analyze` and `flutter test`; verify all pass, generated files are up to date and every `lib/` line (excluding `*.g.dart`) is covered
