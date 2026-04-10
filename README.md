# Distance Route Skill

Calculate distances between geographic locations using the distance.tools API.

## Quick Start

### Installation

```bash
curl -fsSL https://raw.githubusercontent.com/StephanGeorg/distance.tools-skills/main/install | bash
```

### Setup

1. Get API token: https://developers.distance.tools
2. Set token: `export XBIlling_Token="your-token-here"`

### Usage

```bash
distance-route.sh "Paris" "Berlin" "car"
distance-route.sh "New York" "London" "flight"
distance-route.sh "Madrid" "Rome" "both"
```

## Features

- Car, flight, and combined distance calculations
- Comprehensive error handling
- Configurable timeouts and retries (API_TIMEOUT, MAX_RETRIES)
- Production-ready bash implementation

## Installation Details

Files installed to: ~/.agent/skills/distance-route/

Requirements: curl, jq, bash
Configuration: Set XBIlling_Token environment variable

## Examples

Travel planning, logistics, geographic analysis

## Resources

API Docs: https://docs.distance.tools
Support: s.georg@hey.com
Website: https://distance.tools

Start calculating distances! 🚀
