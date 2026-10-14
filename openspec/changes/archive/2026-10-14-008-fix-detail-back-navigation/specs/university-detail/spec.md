# Spec Delta

## ADDED Requirements

### Requirement: Back returns to the universities list
Going back from the detail screen, by the on-screen back button or the system back gesture, SHALL show the universities list. The list MUST keep its loaded items and layout (list or grid). When the detail was opened directly without a previous screen, back MUST navigate to the list instead of leaving the app.

#### Scenario: Back after opening from the list
- **WHEN** the user opens a university from the list and goes back
- **THEN** the universities list is shown with the same items and layout as before

#### Scenario: Back button visible
- **WHEN** the detail is shown
- **THEN** a back button is available in the app bar

#### Scenario: Back after opening the detail directly
- **WHEN** the detail is opened by its route with no previous screen and the user goes back
- **THEN** the universities list is shown
