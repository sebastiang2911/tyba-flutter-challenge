# app-splash Specification

## Purpose
Defines the startup experience: a native launch screen followed by a branded in-app splash that prefetches the universities and then hands off to the list screen.

## Requirements

### Requirement: Native launch screen is branded

The system SHALL show the Tyba mark centered on a white background from process start until the first Flutter frame, on iOS and Android.

#### Scenario: Cold start

- **WHEN** the app is launched from a terminated state
- **THEN** the Tyba mark on a white background is shown instead of a blank screen

### Requirement: Splash is the first in-app screen

The system SHALL open on the splash screen, which shows the animated Tyba wordmark, before any other screen.

#### Scenario: App opens

- **WHEN** the app finishes starting
- **THEN** the splash screen is shown and the wordmark animates in

### Requirement: Splash waits for data and a minimum duration

The system SHALL prefetch the universities while the splash is shown and SHALL leave the splash only when the prefetch has finished and a minimum display time has elapsed, whichever happens later.

#### Scenario: Fast fetch

- **WHEN** the universities load before the minimum display time elapses
- **THEN** the splash stays visible until the minimum display time elapses, then the list screen opens

#### Scenario: Slow fetch

- **WHEN** the universities take longer than the minimum display time
- **THEN** the splash stays visible until the fetch finishes, then the list screen opens

### Requirement: Splash never blocks on failure

The system SHALL open the list screen even when the prefetch fails, and the list screen SHALL show its error state with retry.

#### Scenario: Fetch fails

- **WHEN** the universities fetch fails while the splash is shown
- **THEN** after the minimum display time the list screen opens showing the error message and retry action

### Requirement: Splash is not reachable by back navigation

The system SHALL replace the splash with the list screen so that navigating back from the list does not return to the splash.

#### Scenario: Back from list

- **WHEN** the user is on the list screen after the splash and navigates back
- **THEN** the splash is not shown again
