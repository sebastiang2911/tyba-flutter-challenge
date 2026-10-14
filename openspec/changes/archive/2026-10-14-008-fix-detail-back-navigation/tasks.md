# Tasks

## 1. Navigation fix

- [x] 1.1 Replace `context.go` with `context.push` when opening a university in `universities_list_view.dart`; verify a widget test taps an item, pops, and finds the list again with its items and layout
- [x] 1.2 Add the back fallback (`BackButton` + `PopScope`) in `university_detail_view.dart`; verify a widget test that opens the detail via `router.go(AppRoutes.detailFor(id))` and taps back lands on the list
- [x] 1.3 Verify the app bar shows a back button on the detail (widget test) and that existing list/detail/router tests still pass

## 2. Docs and checks

- [x] 2.1 Note the push/back behavior in the README navigation section; verify the text matches the code
- [x] 2.2 Run `flutter analyze` and `flutter test`; verify both are clean
- [x] 2.3 Mark `008-fix-detail-back-navigation` as done in `ROADMAP.md`
