# AI Coding Assistant Guide for Tyba Technical Test

Essential knowledge for AI coding assistants working in this Flutter codebase.

---

## Project Overview

**Tyba Frontend Engineer technical test**: Flutter app that lists universities (ListView/GridView toggle, infinite scroll), with a detail view where the user assigns an image and enters a student count.

### Key Technologies

- **Flutter / Dart**: SDK ^3.13.5
- **State management**: Riverpod (`flutter_riverpod` + `riverpod_generator`, `@riverpod`)
- **Navigation**: `go_router`
- **HTTP**: `http`
- **Media**: `image_picker` (gallery / camera)
- **Lints**: `flutter_lints`
- **Spec-driven development**: OpenSpec (`openspec/`)

---

## Architecture Highlights

### Layers (UI MVVM / Data / optional Domain)

- `lib/app/`: app, router, theme, infrastructure providers (`providers.dart`)
- `lib/data/{models,repositories,services}`: services are stateless API wrappers; repositories consume services and return domain models
- `lib/domain/{models,repositories,failures,validators}`
- `lib/ui/{core,features/<feature>/{providers,views,widgets}}`
- `test/` mirrors `lib/`

### State

- Code-generated providers: `Future` providers for data, notifiers for UI state, derived providers
- Repositories come from keepAlive providers in `lib/app/providers.dart`
- Views are Consumer widgets (`ref.watch` / `ref.read`, `AsyncValue.when`); no business logic in Views
- Generated `*.g.dart` files are committed
- No use cases layer

### Data rules

- Source: `https://tyba-assets.s3.amazonaws.com/FE-Engineer-test/universities.json`
- The repository assigns a sequential `id` in source order (JSON has no id, names repeat). Sort/filter never reassigns it.
- Handle loading / error / empty / data states

---

## Developer Workflows

### Critical Commands

```bash
flutter pub get
dart run build_runner build -d   # after changing providers
flutter run
flutter analyze
flutter test
```

### Spec-Driven Development (mandatory)

Every feature or structural change goes through an OpenSpec change (proposal, design, tasks, specs when behavior changes). No implementation outside an approved change. Only trivial edits (typos, doc tweaks) are exempt.

| Task                    | Skill                    |
| ----------------------- | ------------------------ |
| Explore an idea         | `openspec-explore`       |
| Propose a change        | `openspec-propose`       |
| Implement tasks         | `openspec-apply-change`  |
| Sync specs              | `openspec-sync-specs`    |
| Archive                 | `openspec-archive-change`|
| Revise planning docs    | `openspec-update-change` |

- Change names start with a zero-padded counter (`001-setup-project-structure`, `002-...`). Take the next number from `openspec/changes` and `archive`.
- One change per step; one writer at a time.

### Validation Workflow

Run before completing any task:

```bash
flutter analyze && flutter test
```

---

## Project-Specific Conventions

### Naming

- `snake_case` files, `PascalCase` classes, `camelCase` members
- Views end in `_view.dart`; widgets are single-purpose

### Dart Rules

- Avoid `dynamic`; prefer typed models and `Object?`
- Student count validation: non-empty, integer, > 0, sensible upper bound
- Infinite scroll: 20 items at a time, hand-written, no external library

### Testing

- Unit tests for repository and validators; widget tests for list and detail
- Override providers with fakes (`ProviderScope` / `ProviderContainer`)

### Git

- Conventional commits only
- Link work to its GitHub issue: `Closes #N` in the commit body or PR description
- Code, comments, commits, docs in English

---

## Debugging Tips

- Provider changes not reflected: re-run `dart run build_runner build -d`
- Stale build: `flutter clean && flutter pub get`
- iOS pods: `cd ios && pod install && cd ..`
- Camera/gallery permissions live in `ios/Runner/Info.plist` and `android/app/src/main/AndroidManifest.xml`

---

## Key References

- Entry: `lib/main.dart`, `lib/app/app.dart`
- Router: `lib/app/router.dart`
- Providers: `lib/app/providers.dart`
- Roadmap: `ROADMAP.md`
- Project rules: `CLAUDE.md`
