# Design

## Context

Both big views follow the same shape: a `ConsumerWidget` screen plus private widgets in the same file. Hero widgets already live as public files in `views/`. Provider names and public APIs stay as they are. See proposal.md for motivation.

## Goals / Non-Goals

**Goals:**
- One public widget per file, named for what it renders, under `widgets/`.
- Presentational widgets take plain data and callbacks; only views and the list/detail containers touch `ref`.
- Identical rendered output and keys (`ValueKey`s, Hero tags, semantics labels, tooltips) so existing tests keep passing.

**Non-Goals:**
- No new features, styling or provider changes.
- No generalization beyond the universities feature (core widgets untouched).

## Decisions

- **`widgets/` sibling of `views/`**: matches the layout in CLAUDE.md (`features/<feature>/{providers,views}`) plus one folder; keeps `views/` for routed screens only. Alternative: keep files in `views/` with prefixes, rejected as it blurs screens vs. components.
- **Public classes, no `_` prefix**: required to live in separate files and to be widget-tested directly. Alternative: `part` files, rejected as it keeps one library and hides the dependencies.
- **Containers vs. presentational**: `UniversitiesContent` (needs `ref` for pagination) and `UniversityDetailContent` (reads profile state) stay `Consumer` widgets; tiles, cards, sections, rows are stateless and receive data/callbacks. `StudentCountSection` stays `StatefulWidget` (owns its `TextEditingController`).
- **`openDetail` helper**: tile and card both navigate; pass `onTap` from the container instead of calling `context.push` inside the presentational widgets, so they do not depend on the router.
- **Move, then split**: first move hero widgets, then extract one widget at a time, running `flutter analyze` and `flutter test` after each, so a regression is localized.

## Risks / Trade-offs

- [Hero or key changes break animations/tests] → keep tags, keys and widget tree unchanged; run the full suite after each extraction.
- [More files to navigate] → consistent naming (`university_*.dart`) and a short layout section in the README.
- [Over-splitting tiny widgets] → extract only widgets with their own responsibility (`InfoRow` and `ImagePlaceholder` qualify; do not split single `Text` wrappers).
