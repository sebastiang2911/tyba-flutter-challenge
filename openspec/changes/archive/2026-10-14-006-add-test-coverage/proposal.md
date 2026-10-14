# Proposal

## Why

Changes 003-005 shipped with their own tests, so the roadmap item "Tests" is mostly done (60 passing tests). A coverage run still shows three gaps: `Failure` (3/7 lines), `ImagePickerService` (0/6) and `university_detail_view.dart` (94/98). Closing them finishes the testing step before the README.

## What Changes

- Unit tests for `Failure`: equality, `hashCode` and `toString`.
- Unit tests for `ImagePickerService`: gallery and camera sources map to the right `ImageSource`; a cancelled pick returns `null`.
- Widget tests for the uncovered branches of the detail view: broken image fallback and the optional info rows (state/province, domains, web pages).
- Mark the "Tests" item as done in `ROADMAP.md`.
- No production code changes.

## Capabilities

### New Capabilities

None.

### Modified Capabilities

None. Behavior does not change, so the change sets `skip_specs: true`.

## Impact

- `test/` only, plus `ROADMAP.md`.
- No new dependencies: `ImagePicker` is already injectable through the `ImagePickerService` constructor.
