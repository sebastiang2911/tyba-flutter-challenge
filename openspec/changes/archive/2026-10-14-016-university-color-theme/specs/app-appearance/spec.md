## MODIFIED Requirements

### Requirement: Brand theme with light and dark variants

The system SHALL provide a light and a dark theme with a deep indigo primary color and an amber secondary accent, using the Tyba dark gray as text color in light mode and as surface in dark mode, and SHALL follow the device's system brightness setting.

#### Scenario: System in light mode

- **WHEN** the device uses the light appearance
- **THEN** the app shows the light theme with the indigo as primary color and the amber as secondary accent

#### Scenario: App bar color

- **WHEN** any screen shows an app bar in either theme
- **THEN** it has the indigo background with white title and icons

#### Scenario: List screen gradient

- **WHEN** the universities list screen is shown
- **THEN** its background is indigo below the app bar and fades into the surface color toward the bottom

#### Scenario: System in dark mode

- **WHEN** the device uses the dark appearance
- **THEN** the app shows the dark theme with readable contrast between text and background

#### Scenario: System appearance changes while running

- **WHEN** the device appearance changes while the app is open
- **THEN** the app switches theme without restarting
