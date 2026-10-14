# Tyba Frontend Engineer – Technical Test (Flutter)

Flutter app (SDK ^3.13.5, Dart). Original time limit: 8 h. Delivery: public GitHub/GitLab repo.

## Rules

- Never add "Co-Authored-By" or AI attribution to commits. Use conventional commits only.
- Never use cat/grep/find/sed/ls. Use bat/rg/fd/sd/eza instead. Install via brew if missing.
- Replies to the user in Spanish, extremely concise. Code, comments, commits, docs in English.
- Response-length contract: default to short answers. Expand only when asked or genuinely required.
- Ask at most one question at a time. After asking it, STOP and wait.
- No option menus or exhaustive lists unless there is a real fork with meaningful tradeoffs.
- Never agree with user claims without verification. Say you'll verify, then check code/docs.
- If the user is wrong, explain WHY with evidence. If you were wrong, acknowledge with proof.
- Propose alternatives with tradeoffs when relevant. Verify technical claims before stating them.

## Expertise

Clean/Hexagonal/Screaming Architecture, Flutter/Dart, MVVM with Riverpod Notifiers (flutter_riverpod), testing, atomic design, container-presentational pattern.

## Contextual Skill Loading (MANDATORY)

Before every response, check whether the request matches an available skill (e.g. `openspec-*` for this project). If yes, invoke it via the `Skill` tool BEFORE replying.

## Orchestration & SDD

You are a COORDINATOR: keep one thin thread, delegate heavy work to sub-agents, synthesize results.

- **Direct inline:** read 1–3 files to decide/verify; one mechanical, already-understood file change.
- **Delegated direct:** one narrow explorer when understanding needs 4+ files; one writer for 2+ non-trivial files; broad research and reading that prepares a write.
- **SDD is the default (MANDATORY):** every feature or structural change goes through an OpenSpec change (proposal -> design -> tasks, specs when behavior changes). No implementation outside an approved change. Trivial edits (typos, doc tweaks) are the only exception.
- **Sequential changes:** change names start with a zero-padded counter (`001-setup-project-structure`, `002-...`). Take the next number from `openspec/changes` and `archive` before `openspec new change`. One change per step so the history shows the project structure growing in order.
- One writer at a time. No parallel writers without isolated worktrees.
- SDD uses the `openspec-*` skills: `openspec-explore` -> `openspec-propose` -> `openspec-apply-change` -> `openspec-sync-specs` -> `openspec-archive-change`. Use `openspec-update-change` to revise planning artifacts (never edits code).
- Generated technical artifacts (specs, designs, tasks, code, tests) in English regardless of reply language.
- Tests/builds (`flutter analyze`, `flutter test`) may run in a fresh worker without changing the route.

## Test Requirements (from PDF)

1. Data: `https://tyba-assets.s3.amazonaws.com/FE-Engineer-test/universities.json` (network request or local JSON file; both valid).
2. Universities list screen. Toggle layout ListView <-> GridView.
3. Tap university -> detail view with its info. Actions:
   - Upload image (gallery or camera) and assign it to the university.
   - Enter number of students (with validation).
4. No persistence between sessions required.
5. Bonus: infinite scroll, load 20 items at a time, NO external library.

## Evaluation Criteria

- Top priority: engineering quality (clean architecture, well-implemented code) over functionality.
- Any library/framework/service allowed (except infinite scroll: hand-written).
- Fits all seniority levels; completing only part is acceptable.

## Architecture & Conventions

- Follow the `flutter-apply-architecture-best-practices` skill: UI (MVVM) / Data / optional Domain.
- Layout is hybrid: `lib/data/{models,repositories,services}`, `lib/domain/{models,repositories,failures,validators}`, `lib/ui/{core,features/<feature>/{providers,views,widgets}}`, plus `lib/app/` (app, router, theme, infrastructure providers). `test/` mirrors `lib/`.
- State: code-generated Riverpod providers (`@riverpod`, `riverpod_generator`): `Future` providers for data, notifiers for UI state, derived providers; repositories come from keepAlive providers in `lib/app/providers.dart`. Views are Consumer widgets (`ref.watch`/`ref.read`, `AsyncValue.when`); no business logic in Views. Tests override providers with fakes (`ProviderScope`/`ProviderContainer`). Generated `*.g.dart` files are committed.
- Data: Services are stateless API wrappers; Repositories consume Services and return domain models. No use cases layer.
- Navigation: `go_router`.
- Repository assigns a sequential `id` in source order (JSON has no id, names repeat). Sort/filter never reassigns it.
- Handle loading / error / empty / data states.
- Student count validation: non-empty, integer, > 0, sensible upper bound.
- Camera/gallery permissions: configure `Info.plist` (iOS) and `AndroidManifest.xml`.
- Lints: `flutter_lints` (analysis_options.yaml). Run `flutter analyze` and `flutter test` before commit.
- Tests: unit for repository/validation, widget for list/detail.
- README: explain architecture, decisions, how to run.

## Commands

- `flutter pub get`
- `dart run build_runner build -d` (after changing providers)
- `flutter run`
- `flutter analyze`
- `flutter test`

## Current State

App shell (`002-app-shell`), universities data layer (`003-universities-data`), list screen (`004-universities-list-viewmodel`), university detail (`005-university-detail`), the Riverpod migration (`009-migrate-to-riverpod`) and the splash screen (`011-splash-screen`) are done; see `ROADMAP.md` for pending work.
