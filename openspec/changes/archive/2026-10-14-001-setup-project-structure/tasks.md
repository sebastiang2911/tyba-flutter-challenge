# Tasks

## 1. Folder structure

- [x] 1.1 Create `lib/app/`, `lib/data/{models,repositories,services}/` and `lib/domain/{models,repositories,validators}/`; verify the directories exist via `eza --tree lib`
- [x] 1.2 Create `lib/ui/core/` and `lib/ui/features/universities/{view_models,views}/`; verify the directories exist via `eza --tree lib`
- [x] 1.3 Create the mirrored `test/data/{repositories,services}/`, `test/domain/{models,validators}/` and `test/ui/features/universities/{view_models,views}/`; verify the directories exist via `eza --tree test`
- [x] 1.4 Add a `.gitkeep` to every empty leaf directory so git tracks it; verify no leaf lacks one and `fd -e dart . lib test` lists only `lib/main.dart` and `test/widget_test.dart`

## 2. Documentation

- [x] 2.1 Record the layout and conventions (MVVM with `ChangeNotifier` + `provider`, `go_router`, id/order invariant) in `CLAUDE.md`; verify with `rg -n 'ChangeNotifier|go_router|sequential' CLAUDE.md`

## 3. Integration check

- [x] 3.1 Verify the resulting tree matches the layout in design.md, and that `flutter analyze` and `flutter test` still pass
