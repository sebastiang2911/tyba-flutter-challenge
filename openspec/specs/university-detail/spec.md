# university-detail Specification

## Purpose
Defines the university detail screen: the information it shows, the session-only image and student count the user assigns, the student count validation rules and the platform permissions the image picker needs.

## Requirements
### Requirement: Detail shows the university information
The detail screen SHALL show the name, country, state/province (when present), domains and web pages of the university identified by the route `id`, and handle loading, error and data states.

#### Scenario: Data loaded
- **WHEN** the university is loaded
- **THEN** its information is displayed

#### Scenario: Load failure
- **WHEN** the university cannot be loaded
- **THEN** an error message is displayed

### Requirement: An image can be assigned to a university
The user SHALL be able to pick an image from the gallery or the camera and assign it to the university. The image SHALL be displayed on the detail and kept for the rest of the session.

#### Scenario: Pick from gallery
- **WHEN** the user chooses the gallery and selects an image
- **THEN** the image is assigned to that university and displayed

#### Scenario: Pick from camera
- **WHEN** the user chooses the camera and takes a photo
- **THEN** the photo is assigned to that university and displayed

#### Scenario: Picker cancelled
- **WHEN** the user cancels the picker
- **THEN** the previously assigned image, if any, is unchanged

#### Scenario: Image kept across navigation
- **WHEN** the user leaves the detail and opens the same university again in the same session
- **THEN** the assigned image is still displayed

### Requirement: Student count is validated
The user SHALL be able to enter the number of students. The value MUST be non-empty, an integer, greater than 0 and not greater than 10,000,000. Surrounding whitespace is ignored. An invalid value MUST NOT be saved and MUST show an error message.

#### Scenario: Valid value
- **WHEN** the user submits `1500`
- **THEN** the count is saved and displayed

#### Scenario: Empty value
- **WHEN** the user submits an empty value
- **THEN** a "required" error is shown and nothing is saved

#### Scenario: Not an integer
- **WHEN** the user submits `12.5` or `abc`
- **THEN** a "must be a whole number" error is shown and nothing is saved

#### Scenario: Out of range
- **WHEN** the user submits `0`, a negative number, or a number above 10,000,000
- **THEN** an out-of-range error is shown and nothing is saved

#### Scenario: Count kept across navigation
- **WHEN** the user leaves the detail and opens the same university again in the same session
- **THEN** the saved count is still displayed

### Requirement: Platform permissions are declared
The app SHALL declare the camera and photo-library usage descriptions on iOS and the camera feature and image-capture intent query on Android, so the picker works on both platforms.

#### Scenario: Config present
- **WHEN** the platform files are inspected
- **THEN** `Info.plist` has `NSCameraUsageDescription` and `NSPhotoLibraryUsageDescription`, and `AndroidManifest.xml` declares the camera feature as optional and queries `IMAGE_CAPTURE`
