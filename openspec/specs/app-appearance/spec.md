# app-appearance Specification

## Purpose

Defines the app-wide look and feel: a Tyba-branded light and dark theme, portrait-only orientation and animated screen transitions.

## Requirements

### Requirement: Brand theme with light and dark variants

The system SHALL provide a light and a dark theme whose colors derive from the Tyba logo (red primary, dark gray base) and SHALL follow the device's system brightness setting.

#### Scenario: System in light mode

- **WHEN** the device uses the light appearance
- **THEN** the app shows the light theme with the Tyba red as primary color

#### Scenario: System in dark mode

- **WHEN** the device uses the dark appearance
- **THEN** the app shows the dark theme with readable contrast between text and background

#### Scenario: System appearance changes while running

- **WHEN** the device appearance changes while the app is open
- **THEN** the app switches theme without restarting

### Requirement: Portrait-only orientation

The system SHALL display the app in portrait orientation only, on iOS and Android, and MUST NOT rotate to landscape when the device is rotated.

#### Scenario: Device rotated

- **WHEN** the user rotates the device to landscape
- **THEN** the app stays in portrait

### Requirement: Animated screen transitions

The system SHALL animate navigation between the universities list and the detail with a fade and slide transition in both directions, and SHALL animate the tapped university's initial avatar and title from the list item (list tile or grid card) into the detail header row shown below the image.

#### Scenario: Open detail

- **WHEN** the user taps a university
- **THEN** the detail enters with a fade and slide transition and the university's initial avatar and name animate together from the tapped item to the detail header row

#### Scenario: Open detail from the grid

- **WHEN** the user taps a university card in grid layout
- **THEN** the card's initial avatar and name animate to the detail header row as in the list layout

#### Scenario: Go back

- **WHEN** the user goes back from the detail
- **THEN** the detail leaves with the reverse transition and the list is shown

#### Scenario: Reduced motion

- **WHEN** the device requests reduced motion (animations disabled)
- **THEN** transitions complete without animation
