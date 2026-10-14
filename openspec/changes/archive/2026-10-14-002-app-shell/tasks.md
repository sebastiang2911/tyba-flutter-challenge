# Tasks

## 1. Dependencies

- [x] 1.1 Add `provider`, `go_router` and `http` with `flutter pub add`; verify `flutter pub get` succeeds and the three appear under `dependencies` in `pubspec.yaml`

## 2. Placeholder views

- [x] 2.1 Create `lib/ui/features/universities/views/universities_list_view.dart` (static placeholder) and `university_detail_view.dart` (takes `int id`, shows it); verify with widget tests that each renders its text, in `test/ui/features/universities/views/`

## 3. App shell

- [x] 3.1 Create `lib/app/theme.dart` with `buildAppTheme()` (Material 3, seed color); verify `flutter analyze` is clean
- [x] 3.2 Create `lib/app/router.dart` with `AppRoutes` (`list`, `detail`, `detailFor`) and `buildRouter()` for `/` and `/university/:id`; verify with widget tests (in `test/app/`) that each path shows its view and that `detailFor(7)` shows id 7
- [x] 3.3 Create `lib/app/app.dart` (`App`, `MaterialApp.router`, optional injected `GoRouter`) and reduce `lib/main.dart` to `runApp(App())`, removing the template counter code; verify with a widget test that `App` boots to the list placeholder
- [x] 3.4 Delete `test/widget_test.dart` (template counter test); verify `flutter test` passes with no reference to `MyApp`

## 4. Integration check

- [x] 4.1 Verify `flutter analyze` is clean and `flutter test` passes (the boot test covers the list placeholder; no device run)
