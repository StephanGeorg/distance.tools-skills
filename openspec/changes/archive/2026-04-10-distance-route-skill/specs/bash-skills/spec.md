## ADDED Requirements

### Requirement: Bash-based skill execution
The skill SHALL implement functionality using bash scripts for maximum portability.

#### Scenario: Script execution
- **WHEN** skill is invoked
- **THEN** bash script executes with provided parameters

#### Scenario: Dependency availability
- **WHEN** skill starts execution
- **THEN** system verifies curl and jq are available

### Requirement: Environment variable configuration
The skill SHALL accept configuration through environment variables.

#### Scenario: API token configuration
- **WHEN** skill requires API token
- **THEN** system reads XBIlling_Token from environment variable

#### Scenario: Timeout configuration
- **WHEN** API request is made
- **THEN** curl uses configured timeout value from environment