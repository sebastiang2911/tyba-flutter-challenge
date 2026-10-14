## ADDED Requirements

### Requirement: Universities are presented as cards

The system SHALL present each university as a card in both list and grid layouts. Cards in both layouts SHALL share the same shape, elevation and surface color, SHALL show the university avatar, name and country, and SHALL be separated by consistent spacing. Names that do not fit SHALL wrap or truncate without overflowing the card.

#### Scenario: List layout cards

- **WHEN** the list layout is active
- **THEN** each university is shown as a separate elevated card with its avatar, name, country and a trailing chevron

#### Scenario: Grid layout cards

- **WHEN** the grid layout is active
- **THEN** each university is shown as an elevated card with its avatar above its name and country, centered

#### Scenario: Long name

- **WHEN** a university name is longer than the card width
- **THEN** the name wraps or truncates and the card shows no overflow

#### Scenario: Tapping a card

- **WHEN** the user taps anywhere on a card
- **THEN** the detail screen for that university opens
