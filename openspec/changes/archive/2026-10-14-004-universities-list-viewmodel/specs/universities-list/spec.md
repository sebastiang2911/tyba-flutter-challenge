## ADDED Requirements

### Requirement: List screen shows every load state

The system SHALL show the universities screen in exactly one of four states: loading, error, empty or data. It SHALL start in loading when the screen opens.

#### Scenario: Loading

- **WHEN** the screen opens and universities are being fetched
- **THEN** a progress indicator is shown

#### Scenario: Data

- **WHEN** the fetch succeeds with at least one university
- **THEN** the universities are shown, each displaying its name and country

#### Scenario: Empty

- **WHEN** the fetch succeeds with no universities
- **THEN** an empty-state message is shown

#### Scenario: Error and retry

- **WHEN** the fetch fails
- **THEN** an error message and a retry action are shown, and activating retry fetches again, showing the loading state

### Requirement: Universities are revealed 20 at a time

The system SHALL initially show the first 20 universities in source order and SHALL reveal the next 20 each time the user scrolls near the end of the shown items, until all are shown. No external pagination library SHALL be used.

#### Scenario: First page

- **WHEN** more than 20 universities are loaded
- **THEN** exactly the first 20 are shown

#### Scenario: Scrolling reveals the next page

- **WHEN** the user scrolls near the end of the shown items and more remain
- **THEN** the next 20 universities (or the remainder) are appended without changing the order or ids of the ones already shown

#### Scenario: No more items

- **WHEN** all universities are already shown
- **THEN** scrolling to the end reveals nothing further

### Requirement: Layout can be toggled between list and grid

The system SHALL let the user switch the universities presentation between a vertical list and a grid with one control, defaulting to list. The switch MUST keep the shown items and the scroll-driven pagination working.

#### Scenario: Switch to grid

- **WHEN** the user activates the layout toggle while in list layout
- **THEN** the same universities are shown as a grid

#### Scenario: Switch back to list

- **WHEN** the user activates the layout toggle while in grid layout
- **THEN** the same universities are shown as a list

### Requirement: Selecting a university opens its detail

The system SHALL navigate to the detail route of a university, identified by its `id`, when the user taps it in either layout.

#### Scenario: Tap in list or grid

- **WHEN** the user taps a university
- **THEN** the detail screen for that university's `id` opens
