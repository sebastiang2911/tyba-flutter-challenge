## Purpose

Defines how the application obtains the list of universities, including the identity and ordering guarantees that the UI and per-university state rely on, and how load failures are reported.

## ADDED Requirements

### Requirement: Universities are loaded from the remote source

The system SHALL load the full list of universities with a single request to `https://tyba-assets.s3.amazonaws.com/FE-Engineer-test/universities.json` and expose each entry with its name, country, two-letter country code, optional state or province, domains and web pages.

#### Scenario: Successful load

- **WHEN** the source responds with status 200 and a JSON array of universities
- **THEN** the system returns one university per array entry with all its fields populated

#### Scenario: Missing state or province

- **WHEN** an entry has a `null` state or province
- **THEN** the corresponding university is returned with no state or province and loading does not fail

### Requirement: Each university has a stable sequential identity

The system SHALL assign each university an integer `id` equal to its zero-based position in the source array, and SHALL return universities in the same order as the source. The `id` MUST be unique even when names repeat, and MUST NOT depend on any later sorting or filtering.

#### Scenario: Ids follow source order

- **WHEN** the source contains the entries "B", "A", "C" in that order
- **THEN** the universities are returned in the order "B", "A", "C" with ids 0, 1 and 2

#### Scenario: Duplicate names get distinct ids

- **WHEN** the source contains two entries with the same name
- **THEN** the two universities are returned with different ids

### Requirement: Load failures are reported as a domain failure

The system SHALL report any failure to load the universities as a single domain failure, regardless of whether the cause is a non-200 response, a network error, or a malformed payload.

#### Scenario: Non-200 response

- **WHEN** the source responds with a status other than 200
- **THEN** loading fails with a domain failure

#### Scenario: Network error

- **WHEN** the request cannot be completed
- **THEN** loading fails with a domain failure

#### Scenario: Malformed payload

- **WHEN** the response body is not a JSON array of valid university entries
- **THEN** loading fails with a domain failure
