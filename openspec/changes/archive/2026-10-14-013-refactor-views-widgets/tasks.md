# Tasks

## 1. Move shared hero widgets

- [x] 1.1 Create `lib/ui/features/universities/widgets/` and move `university_avatar_hero.dart` and `university_title_hero.dart` there with `git mv`; update imports in both views and verify `flutter analyze` and `flutter test` pass

## 2. Split the list view

- [x] 2.1 Extract `UniversityTile` and `UniversityCard` (take `university` and `onTap`) into `widgets/` with widget tests under `test/ui/features/universities/widgets/`; verify the tests and the existing list view tests pass
- [x] 2.2 Extract `UniversitiesContent` (scroll controller + pagination), the load-more indicator and the layout toggle action into `widgets/`; verify the existing infinite-scroll and layout-switch tests pass
- [x] 2.3 Reduce `universities_list_view.dart` to the scaffold, `AsyncValue.when` and the cross-fade; verify it is under ~80 lines and `flutter test` passes

## 3. Split the detail view

- [x] 3.1 Extract `UniversityImageSection` and `ImagePlaceholder` into `widgets/` with widget tests (placeholder vs. image, gallery/camera callbacks, error text); verify the tests pass
- [x] 3.2 Extract `UniversityInfoSection` and `InfoRow` with widget tests (optional fields hidden when absent); verify the tests pass
- [x] 3.3 Extract `StudentCountSection` with widget tests (error messages, submit, snackbar on success); verify the tests pass
- [x] 3.4 Extract `UniversityDetailContent` and reduce `university_detail_view.dart` to scaffold, back navigation and `AsyncValue.when`; verify the existing detail view tests pass

## 4. Docs and final checks

- [x] 4.1 Update the folder layout in README.md and CLAUDE.md (`features/<feature>/{providers,views,widgets}`); verify the documented paths exist
- [x] 4.2 Run `flutter analyze` and `flutter test` on the whole project; verify no warnings, all tests green and no `_`-prefixed widget classes remain in the two views
