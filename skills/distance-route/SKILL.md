---
name: distance-route
description: Calculate distances between locations using the distance.tools API. Use when user needs to know travel distances, road trip lengths, or airline distances between cities or coordinates.
---

## Distance Route Skill

This skill provides distance calculations between geographic locations using various transport modes (car, airline).

### Usage

Agents should call this skill when users ask about:
- Driving distances between cities
- Airline distances between airports
- Travel time estimates
- Road trip planning distances

### Script Parameters

The main script at `scripts/distance-route.sh` accepts:
- `$1`: Start location (text or lat,lng)
- `$2`: End location (text or lat,lng) 
- `$3`: Transport mode (car, flight, or both)

### Environment Variables

- `XBIlling_Token`: Required API authentication token
- `API_TIMEOUT`: Optional curl timeout in seconds (default: 30)
- `MAX_RETRIES`: Optional maximum retry attempts (default: 3)

### Examples

Calculate driving distance:
```bash
distance-route.sh "Paris, France" "Berlin, Germany" "car"
```

Calculate flight distance:
```bash
distance-route.sh "JFK" "LHR" "flight"
```

### Error Handling

The script handles common error scenarios:
- Missing or invalid parameters
- Unsupported transport modes
- API authentication failures
- Network connectivity issues
- Invalid location responses

### Dependencies

- curl: For HTTP requests
- jq: For JSON parsing