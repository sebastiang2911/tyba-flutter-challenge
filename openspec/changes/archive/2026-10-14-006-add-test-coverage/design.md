# Design

## Context

See proposal.md. `ImagePickerService` takes an optional `ImagePicker` in its constructor and `Failure` is a plain value class. The detail view already has a widget test file with fakes in `test/support/`.

## Goals / Non-Goals

**Goals:**
- Cover every remaining uncovered line reported by `flutter test --coverage`.

**Non-Goals:**
- Coverage thresholds or CI gates.
- Testing `image_picker` internals or the native platform channel.

## Decisions

- **Fake the `ImagePicker` instance, not the platform channel.** A small test double that `implements ImagePicker` and records the requested `ImageSource` keeps the test at the service boundary. Alternative: `ImagePickerPlatform.instance` fake or a mocked method channel, which couples the test to plugin internals.
- **Reuse the existing detail view test file.** New cases extend `university_detail_view_test.dart` with universities that have/lack optional fields, instead of a second file for the same widget.
- **Broken image case via a non-existent file path.** `Image.file` fails to decode and triggers `errorBuilder` without extra tooling.

## Risks / Trade-offs

- [Faking a concrete plugin class may break if `image_picker` adds abstract members] → the pinned version in `pubspec.lock` is stable; the fake lives in `test/support/` so a fix is local.
