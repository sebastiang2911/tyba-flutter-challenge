## ADDED Requirements

### Requirement: A university can be fetched by its id
The repository SHALL return the university whose sequential `id` matches the requested one, with the same `id` it has in the full list.

#### Scenario: Existing id
- **WHEN** a university is requested by an `id` present in the source
- **THEN** the repository returns that university with that `id`

#### Scenario: Unknown id
- **WHEN** a university is requested by an `id` that does not exist
- **THEN** the repository throws a `Failure`

#### Scenario: Source cannot be loaded
- **WHEN** the source cannot be loaded
- **THEN** the repository throws a `Failure`
