## ADDED Requirements

### Requirement: Keyboard is dismissed on tap outside the student count field

The system SHALL close the keyboard and remove focus from the student count field when the user taps anywhere outside it. Tapping outside MUST NOT save or validate the value.

#### Scenario: Tap outside while editing

- **WHEN** the student count field is focused and the user taps outside it
- **THEN** the field loses focus and the keyboard is dismissed

#### Scenario: Tap outside does not submit

- **WHEN** the user types a value and taps outside the field
- **THEN** the value is not saved and no confirmation message is shown

#### Scenario: Save button still works

- **WHEN** the field is focused and the user taps Save
- **THEN** the keyboard is dismissed and the value is submitted
