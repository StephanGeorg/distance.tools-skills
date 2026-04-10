## Why

Enable agents to calculate distances between locations using the distance.tools API. This provides the first functional SKILL in the distance.tools-skills project, demonstrating the basic pattern for creating skills that call external APIs.

## What Changes

- Create a new `distance-route` skill that calls the `/distance/route` API endpoint
- Implement using bash scripts with curl for maximum portability
- Support both airline and car routing distance calculations
- Provide proper error handling and input validation

## Capabilities

### New Capabilities
- `distance-calculation`: Ability to calculate distances between geographic locations using various transport modes (airline, car)
- `api-integration`: Integration with distance.tools REST API using proper authentication and error handling
- `bash-skills`: Framework for creating skills using bash scripting with external tools like curl/jq

### Modified Capabilities
- None (this is a new skills project)

## Impact

- Create `distance-route` skill directory with SKILL.md, scripts/, and references/
- Add bash script to call distance API using curl
- Establish pattern for API error handling and input validation
- Add documentation for API usage and expected formats