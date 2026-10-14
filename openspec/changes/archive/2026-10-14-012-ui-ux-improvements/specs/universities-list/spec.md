# Spec Delta

## MODIFIED Requirements

### Requirement: List screen shows every load state

The system SHALL show the universities screen in exactly one of four states: loading, error, empty or data. It SHALL start in loading when the screen opens. Loading, error and empty presentations SHALL be consistent across screens.

#### Scenario: Loading

- **WHEN** the screen opens and universities are being fetched
- **THEN** skeleton placeholders shaped like the list items are shown

#### Scenario: Data

- **WHEN** the fetch succeeds with at least one university
- **THEN** the universities are shown, each displaying its name and country

#### Scenario: Empty

- **WHEN** the fetch succeeds with no universities
- **THEN** an empty-state message is shown

#### Scenario: Error and retry

- **WHEN** the fetch fails
- **THEN** an error message and a retry action are shown, and activating retry fetches again, showing the loading state

### Requirement: Layout can be toggled between list and grid

The system SHALL let the user switch the universities presentation between a vertical list and a grid with one control, defaulting to list. The switch MUST keep the shown items and the scroll-driven pagination working, and SHALL be animated with a cross-fade.

#### Scenario: Switch to grid

- **WHEN** the user activates the layout toggle while in list layout
- **THEN** the same universities are shown as a grid, cross-fading from the list

#### Scenario: Switch back to list

- **WHEN** the user activates the layout toggle while in grid layout
- **THEN** the same universities are shown as a list, cross-fading from the grid

#### Scenario: Pagination after switching

- **WHEN** the user switches layout and scrolls near the end of the shown items
- **THEN** the next page is still revealed

## ADDED Requirements

### Requirement: Load-more indicator

The system SHALL show a progress indicator after the last shown university while more universities remain to be revealed, and MUST NOT show it once all are shown.

#### Scenario: More items remain

- **WHEN** fewer universities are shown than loaded
- **THEN** a progress indicator is shown after the last item

#### Scenario: All items shown

- **WHEN** all universities are shown
- **THEN** no progress indicator is shown at the end
