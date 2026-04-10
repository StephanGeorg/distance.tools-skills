# Distance API Guide

This document provides technical specifications for the distance.tools API integration.

## API Endpoint

### Base URL
```
https://api.distance.tools/api/v2
```

### Distance Route Endpoint
```
POST /distance/route
```

### Query Parameters

| Parameter | Type | Required | Default | Description |
|-----------|------|----------|---------|-------------|
| car | boolean | No | false | Calculate car routing distance |
| flight | boolean | No | false | Calculate airline distance |
| equal | boolean | No | false | Get equal distances |

### Request Body

```json
{
  "route": [
    {
      "name": "Start location",
      "country": "ISO-3166-1-A3 code (optional)"
    },
    {
      "name": "End location",
      "country": "ISO-3166-1-A3 code (optional)"
    }
  ]
}
```

### Response Format

#### Success Response (200)

```json
{
  "route": {
    "vincenty": 1150.2,           // Airline distance (km) - Vincenty formula
    "haversine": 1148.8,          // Airline distance (km) - Haversine formula
    "greatCircle": 1145.6,        // Airline distance (km) - Great Circle formula
    "car": {
      "distance": 1234.5,          // Car routing distance (km)
      "duration": 10800,           // Car routing duration (seconds)
      "status": "found"            // Route status
    }
  }
}
```

#### Error Response (400, 404, etc.)

```json
{
  "code": "InvalidUrl",
  "message": "The requested URL is invalid"
}
```

### Common Error Codes

| Code | Status | Description |
|------|--------|-------------|
| InvalidUrl | 400 | Invalid URL structure |
| InvalidQuery | 400 | Missing or invalid query parameters |
| NoRoute | 404 | No route found between locations |
| NoSegment | 404 | No route segments found |

### Authentication

All requests require the `X-Billing-Token` header with a valid API token from Distance Tools.

## Transport Mode Mapping

| Script Parameter | API Query Param | Description |
|------------------|------------------|-------------|
| car | car=true | Car routing distances |
| flight | flight=true | Airline distances |
| both | car=true & flight=true | Both types |

## Distance Calculation Methods

### Airline Distances
- **Vincenty**: Most accurate for most use cases
- **Haversine**: Good approximation for global distances
- **Great Circle**: Simplified spherical earth calculation

### Car Routing
- Uses actual road network data
- Returns driving distance and estimated duration
- Includes route status indicator

## Response Processing

The script handles:
1. JSON parsing with jq
2. Error code translation
3. Distance method selection
4. Result formatting for agent consumption