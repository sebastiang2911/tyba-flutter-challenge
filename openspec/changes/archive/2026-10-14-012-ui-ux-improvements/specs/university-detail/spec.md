# Spec Delta

## ADDED Requirements

### Requirement: Image appears with a fade

The detail SHALL fade in the assigned image instead of swapping it abruptly, and SHALL show a placeholder with an image icon while none is assigned.

#### Scenario: Image assigned

- **WHEN** the user assigns an image
- **THEN** the image fades in over the placeholder

### Requirement: Saving the student count gives feedback

The system SHALL confirm a successful save of the student count with a transient message and SHALL dismiss the keyboard. An invalid value MUST NOT show the confirmation.

#### Scenario: Valid save

- **WHEN** the user submits a valid student count
- **THEN** a confirmation message is shown and the keyboard is dismissed

#### Scenario: Invalid save

- **WHEN** the user submits an invalid student count
- **THEN** the validation error is shown and no confirmation message appears

### Requirement: Student count input accepts digits only

The student count field SHALL accept only digit characters while typing, using a numeric keyboard.

#### Scenario: Non-digit typed

- **WHEN** the user types a letter, a decimal point or a minus sign
- **THEN** the character is not entered in the field

### Requirement: Key actions are accessible

The image area and the gallery, camera and save actions SHALL expose descriptive labels to screen readers.

#### Scenario: Screen reader focus

- **WHEN** a screen reader focuses the image area or an action
- **THEN** it announces a label describing the purpose, including whether an image is assigned
