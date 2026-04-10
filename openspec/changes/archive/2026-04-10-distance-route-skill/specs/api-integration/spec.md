## ADDED Requirements

### Requirement: Distance API integration
The skill SHALL integrate with the distance.tools API using proper authentication and request formatting.

#### Scenario: API endpoint call
- **WHEN** skill needs to calculate distance
- **THEN** system makes POST request to https://api.distance.tools/api/v2/distance/route

#### Scenario: Authentication handling
- **WHEN** distance API is called
- **THEN** request includes X-Billing-Token header with valid token

#### Scenario: Request format validation
- **WHEN** skill prepares API request
- **THEN** request body contains route array with proper name and country format

### Requirement: Error response handling
The skill SHALL properly handle and translate API error responses.

#### Scenario: Bad request error
- **WHEN** API returns 400 status
- **THEN** skill returns clear error message indicating invalid request

#### Scenario: Not found error
- **WHEN** API returns 404 status
- **THEN** skill returns location not found error to user