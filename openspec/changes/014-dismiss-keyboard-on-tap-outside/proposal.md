# Proposal

## Why

The "Number of students" field uses a numeric keyboard, which has no "done" key on iOS. The keyboard only closes by saving, so users cannot dismiss it without submitting.

## What Changes

- Tapping outside the "Number of students" field removes its focus and closes the keyboard.
- Tapping the Save button keeps working as before.
- Add a widget test for the new behavior.

## Capabilities

### New Capabilities

### Modified Capabilities
- `university-detail`: add a requirement that the student count keyboard is dismissed on a tap outside the field.

## Impact

- `lib/ui/features/universities/widgets/student_count_section.dart` (one callback on the `TextField`).
- `test/ui/features/universities/widgets/student_count_section_test.dart` (new test).
- No new dependencies, no data or provider changes.
