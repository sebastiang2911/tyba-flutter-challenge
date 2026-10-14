# Design

## Context

Existing code (changes 001-006) already fixes the architecture. The README must describe it as built, not as planned, so every claim is checked against `lib/`, `test/`, `pubspec.yaml` and the platform config files.

## Goals / Non-Goals

**Goals:** a README an evaluator can read in a few minutes: what the app does, how to run and test it, how the code is organized and why.
**Non-Goals:** changing code, adding diagrams tooling, generating API docs, localizing the README (English, like all docs).

## Decisions

- **Single `README.md`, no extra docs files.** Keeps the entry point obvious; avoids duplicating OpenSpec artifacts.
- **Structure:** Overview, Features, Getting started (requirements, run, test, analyze), Architecture (layers table, data flow, folder tree, DI, navigation), Key decisions, Testing, Platform setup (permissions), Limitations / next steps.
- **ASCII tree and a small layer diagram in Markdown** instead of images: reviewable in diffs and rendered everywhere.
- **Decisions section lists the non-obvious choices already made:** sequential `id` assigned by the repository in source order (JSON has no id, names repeat); in-memory profile repository (no persistence required); hand-written infinite scroll with pages of 20 (no external library); `ListenableBuilder` views with immutable state snapshots; validator returns an error enum, UI maps it to text; no CAMERA permission on Android since `image_picker` uses the system camera app; no use-cases layer.
- **Facts are verified, not recalled:** commands and versions come from `pubspec.yaml`; test file list from `test/`.

## Risks / Trade-offs

- README can drift from code as the project evolves → keep it high-level and link to folders rather than quoting code.
