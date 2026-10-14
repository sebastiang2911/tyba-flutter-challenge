# Roadmap

Pending work for the Tyba technical test. Each step is delivered as a numbered OpenSpec change (SDD). Mark items `[x]` when done.

## Done

- [x] `001-setup-project-structure`: folder structure (archived)
- [x] `002-app-shell`: dependencies (`go_router`, `http`; `provider` later replaced by Riverpod in 009) and app shell (archived, PR #1)
- [x] `003-universities-data`: domain model, API service and repository with sequential `id` in source order (archived)
- [x] `004-universities-list-viewmodel`: list state (pagination by 20, list/grid toggle), real list screen and state wiring (archived)
- [x] `005-university-detail`: detail screen, image from gallery/camera, student count validator, `Info.plist` / `AndroidManifest.xml` config (archived)
- [x] `006-add-test-coverage`: closed the remaining test gaps (`Failure`, `ImagePickerService`, detail view branches); every `lib/` line is covered (archived)
- [x] `007-readme-documentation`: README with architecture, decisions and how to run (archived)

## Next

- [x] `008-fix-detail-back-navigation`: back from detail returns to the universities list (`go` -> `push`, handle deep-link fallback)
- [x] `009-migrate-to-riverpod`: replace `provider` with `flutter_riverpod` (code-generated providers, `AsyncValue.when`, `ProviderScope` DI), update CLAUDE.md/README conventions

- [x] `010-app-icon`: generate iOS and Android app icon from the triangular mark in `assets/tyba.svg`
- [x] `011-splash-screen`: native + Flutter splash screen using `assets/tyba.svg`
- [x] `012-ui-ux-improvements`: brand light/dark theme, portrait-only, transitions (fade+slide, Hero, layout cross-fade), skeleton, load-more indicator, shared state widgets, detail feedback and a11y
- [x] `013-refactor-views-widgets`: split large views into small, single-purpose widget files (container-presentational) under each feature's `widgets/` folder, so every view reads as a short composition; no behavior change, tests stay green
- [x] `014-dismiss-keyboard-on-tap-outside`: tapping outside the "Number of students" input closes the keyboard (`onTapOutside` or tap-to-unfocus on the detail), with a widget test

## Housekeeping

- [ ] Decide the retry UX in the error state (open question in the design)
- [ ] Update `context` in `openspec/config.yaml`: archived changes carry a date prefix before the `NNN` counter
- [ ] Cross-check requirements against the PDF (its text could not be extracted; `pdftotext` is not installed)
- [ ] Try `/commit` in a new chat; add `.trees/` to `.gitignore` before using `/worktree`
- [ ] First commit and public repo (GitHub/GitLab) for delivery
