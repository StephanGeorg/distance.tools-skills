## ADDED Requirements

### Requirement: Calculate distance between locations
The skill SHALL support calculating distance between geographical locations using specified transport modes.

#### Scenario: Car distance calculation
- **WHEN** user requests driving distance between "Paris" and "Berlin"
- **THEN** system returns car routing distance in kilometers and estimated duration

#### Scenario: Airline distance calculation
- **WHEN** user requests airline distance between "New York" and "London"
- **THEN** system returns Vincenty, Haversine, and Great Circle distances

#### Scenario: Invalid location handling
- **WHEN** user provides invalid or non-existent location
- **THEN** system returns appropriate error with error code 404

### Requirement: Multiple routing methods
The skill SHALL provide access to different routing algorithms and distance calculation methods.

#### Scenario: Car routing response
- **WHEN** transport mode "car" is specified
- **THEN** response includes distance, duration, and status fields in car object