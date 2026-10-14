# Tasks

## 1. Dismiss keyboard on tap outside

- [x] 1.1 Add `onTapOutside` and a shared `_dismissKeyboard()` in `student_count_section.dart`; verify `flutter analyze` is clean.
- [x] 1.2 Add widget tests in `student_count_section_test.dart`: focus the field and verify `tester.testTextInput.isVisible` is true, tap an empty area and verify it is false; typed value is not submitted on tap outside; Save still submits. Verify `flutter test` passes.
- [x] 1.3 Tick `014` in `ROADMAP.md` and verify the entry is marked done.
