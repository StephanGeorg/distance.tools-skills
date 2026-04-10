# Getting Started with Distance Route Skill

This guide provides practical examples for using the distance-route skill.

## Basic Usage

### Calculate driving distance
```bash
export XBIlling_Token="your-api-token-here"
./skills/distance-route/scripts/distance-route.sh "Paris, France" "Berlin, Germany" "car"
```

**Response:**
```json
{
  "distance": 1050.2,
  "unit": "km",
  "transport": "car",
  "duration": 10800,
  "duration_unit": "seconds"
}
```

### Calculate flight distance
```bash
./skills/distance-route/scripts/distance-route.sh "New York" "London" "flight"
```

**Response:**
```json
{
  "distance": 5570.5,
  "unit": "km",
  "transport": "flight",
  "method": "vincenty"
}
```

### Get both car and flight distances
```bash
./skills/distance-route/scripts/distance-route.sh "Tokyo" "Sydney" "both"
```

## Handling Different Location Formats

### City names
```bash
# Simple city names
./distance-route.sh "Los Angeles" "San Francisco" "car"

# Cities with countries
./distance-route.sh "Rome, Italy" "Athens, Greece" "flight"

# Specific locations
./distance-route.sh "Eiffel Tower" "Brandenburg Gate" "both"
```

### Airport codes
```bash
./distance-route.sh "JFK" "LHR" "flight"
./distance-route.sh "SFO" "LAX" "car"
```

### Coordinates
```bash
./distance-route.sh "48.8566,2.3522" "52.5200,13.4050" "car"
```

## Agent Integration Patterns

### Simple distance query
**User:** "How far is it to drive from Boston to Washington DC?"
**Agent calls:** `./distance-route.sh "Boston" "Washington DC" "car"`

### Travel planning
**User:** "What's the flight distance between Tokyo and San Francisco?"
**Agent calls:** `./distance-route.sh "Tokyo" "San Francisco" "flight"`

### Route comparison
**User:** "Should I drive or fly from Paris to Barcelona?"
**Agent calls:**
```bash
car_result=$(./distance-route.sh "Paris" "Barcelona" "car")
flight_result=$(./distance-route.sh "Paris" "Barcelona" "flight")
```

## Error Handling Examples

### Missing parameters
```bash
./distance-route.sh "Paris" "" "car"
# Error: Both start and end locations are required
```

### Invalid transport mode
```bash 
./distance-route.sh "Paris" "Berlin" "train"
# Error: Invalid transport mode: train. Use 'car', 'flight', or 'both'
```

### Missing API token
```bash
unset XBIlling_Token
./distance-route.sh "Paris" "Berlin" "car"
# Error: XBIlling_Token environment variable is required
```

## Configuration Options

### Custom timeout
```bash
export API_TIMEOUT=45
./distance-route.sh "Paris" "Berlin" "car"
```

### Retry configuration
```bash
export MAX_RETRIES=5
./distance-route.sh "Paris" "Berlin" "car"
```

## Troubleshooting

### Common Issues

**"Unknown locations" error**: The API couldn't find the specified locations. Try:
- More specific location names
- Full city/country format
- Specific landmarks

**"Network timeout"**: Increase the timeout or check network connectivity

**"SSL certificate error"**: Ensure your curl version is up to date and supports modern SSL

### Debugging

Enable verbose output by adding `-v` flag to curl calls within the script.