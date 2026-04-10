#!/usr/bin/env bash

# Distance Route Skill - Main Script
# Calulates distances between locations using distance.tools API

set -euo pipefail

# ============================================
# CONSTANTS AND CONFIGURATION
# ============================================

API_BASE_URL="https://api.distance.tools/api/v2"
API_ENDPOINT="/distance/route"
DEFAULT_TIMEOUT=${API_TIMEOUT:-30}
MAX_RETRIES=${MAX_RETRIES:-3}
RETRY_DELAY=2

# ============================================
# ERROR HANDLING FUNCTIONS
# ============================================

error_exit() {
    echo "[ERROR] $1" >&2
    exit 1
}

check_dependencies() {
    # 3.4 Tool dependency checking
    if ! command -v curl >/dev/null 2>&1; then
        error_exit "curl is required but not installed"
    fi
    
    if ! command -v jq >/dev/null 2>&1; then
        error_exit "jq is required but not installed"
    fi
}

# ============================================
# PARAMETER VALIDATION (2.2)
# ============================================

validate_parameters() {
    local start="$1"
    local end="$2" 
    local transport="$3"
    
    # Check required parameters
    if [[ -z "$start" || -z "$end" ]]; then
        error_exit "Both start and end locations are required"
    fi
    
    # Validate transport mode
    case "$transport" in
        "car"|"flight"|"both")
            # Valid transport mode
            ;;
        "")
            # Default to both if empty
            transport="both"
            ;;
        *)
            error_exit "Invalid transport mode: $transport. Use 'car', 'flight', or 'both'"
            ;;
    esac
    
    # Check API token
    if [[ -z "${XBIlling_Token:-}" ]]; then
        error_exit "XBIlling_Token environment variable is required for API authentication"
    fi
    
    echo "$transport"
}

# ============================================
# API REQUEST FUNCTIONS (2.3, 2.5, 3.2)
# ============================================

build_api_url() {
    local transport="$1"
    local url="$API_BASE_URL$API_ENDPOINT"
    
    # Add transport query parameters
    if [[ "$transport" = "car" || "$transport" = "both" ]]; then
        url+="?car=true"
    fi
    
    if [[ "$transport" = "flight" || "$transport" = "both" ]]; then
        if [[ "$url" == *"?"* ]]; then
            url+="&flight=true"
        else
            url+="?flight=true"
        fi
    fi
    
    echo "$url"
}

build_request_body() {
    local start="$1"
    local end="$2"
    
    cat <<EOF
{
  "route": [
    {"name": "$start"},
    {"name": "$end"}
  ]
}
EOF
}

make_api_request() {
    local url="$1"
    local body="$2"
    local retry_count=0
    local response
    
    while [[ $retry_count -lt $MAX_RETRIES ]]; do
        # Make the curl request with timeout (3.2)
        response=$(curl -s -w "\n%{response_code}" \
            -X POST "$url" \
            -H "Content-Type: application/json" \
            -H "X-Billing-Token: $XBIlling_Token" \
            -d "$body" \
            --max-time $DEFAULT_TIMEOUT)
        
        # Extract response code
        local response_code=$(echo "$response" | tail -n1)
        local response_body=$(echo "$response" | sed '$d')
        
        # Check for successful response
        if [[ "$response_code" -eq 200 ]]; then
            echo "$response_body"
            return 0
        fi
        
        # Handle rate limiting (429)
        if [[ "$response_code" -eq 429 ]]; then
            local retry_after=$(echo "$response_body" | jq -r '.retryAfter // 5')
            echo "[WARN] Rate limited. Retrying after $retry_after seconds..." >&2
            sleep "$retry_after"
        else
            # For other errors, wait before retrying
            if [[ $retry_count -lt $(($MAX_RETRIES-1)) ]]; then
                echo "[WARN] Request failed (code $response_code). Retrying $((retry_count+1))/$MAX_RETRIES..." >&2
                sleep $((RETRY_DELAY * (retry_count + 1)))
            fi
        fi
        
        retry_count=$((retry_count + 1))
    done
    
    # Return error response if all retries failed
    echo "$response_body"
    return 1
}

# ============================================
# RESPONSE PROCESSING (2.4, 3.3)
# ============================================

parse_api_response() {
    local response="$1"
    local transport="$2"
    
    # Check for error response (3.1)
    local response_code=$(echo "$response" | jq -r '.code // empty')
    
    if [[ -n "$response_code" ]]; then
        case "$response_code" in
            "InvalidUrl"|"InvalidService"|"InvalidVersion"|"InvalidOptions"|"InvalidQuery"|"InvalidValue")
                error_exit "Invalid request: $(echo "$response" | jq -r '.message // "Unknown error"')"
                ;;
            "NoSegment"|"NoRoute")
                error_exit "Route not found: $(echo "$response" | jq -r '.message // "Route could not be calculated"')"
                ;;
            "NoTrips")
                error_exit "Trip planning failed: $(echo "$response" | jq -r '.message // "No trips available"')"
                ;;
            *)
                error_exit "API error: $(echo "$response" | jq -r '.message // "Unknown error"')"
                ;;
        esac
    fi
    
    # Parse successful response
    local route_data=$(echo "$response" | jq -r '.route // {}')
    
    # Check if route data exists
    if [[ "$route_data" == "null" || "$route_data" == "{}" ]]; then
        error_exit "No route data returned from API"
    fi
    
    # Process based on transport mode
    if [[ "$transport" = "car" ]]; then
        local car_distance=$(echo "$route_data" | jq -r '.car.distance // 0')
        local car_duration=$(echo "$route_data" | jq -r '.car.duration // 0')
        
        if [[ "$car_distance" != "0" ]]; then
            echo "{\"distance\": $car_distance, \"unit\": \"km\", \"transport\": \"car\", \"duration\": $car_duration, \"duration_unit\": \"seconds\"}"
            return
        fi
    fi
    
    if [[ "$transport" = "flight" ]]; then
        local flight_distance=$(echo "$route_data" | jq -r '.vincenty // 0')
        
        if [[ "$flight_distance" != "0" ]]; then
            echo "{\"distance\": $flight_distance, \"unit\": \"km\", \"transport\": \"flight\", \"method\": \"vincenty\"}"
            return
        fi
    fi
    
    # If we get here, try all distances
    local vincenty=$(echo "$route_data" | jq -r '.vincenty // 0')
    local haversine=$(echo "$route_data" | jq -r '.haversine // 0')
    local greatCircle=$(echo "$route_data" | jq -r '.greatCircle // 0')
    
    if [[ "$vincenty" != "0" ]]; then
        echo "{\"distance\": $vincenty, \"unit\": \"km\", \"transport\": \"flight\", \"method\": \"vincenty\"}"
    elif [[ "$haversine" != "0" ]]; then
        echo "{\"distance\": $haversine, \"unit\": \"km\", \"transport\": \"flight\", \"method\": \"haversine\"}"
    elif [[ "$greatCircle" != "0" ]]; then
        echo "{\"distance\": $greatCircle, \"unit\": \"km\", \"transport\": \"flight\", \"method\": \"great-circle\"}"
    else
        error_exit "No valid distance data found in API response"
    fi
}

# ============================================
# MAIN EXECUTION
# ============================================

main() {
    # 3.4 Check dependencies first
    check_dependencies
    
    # Process command line arguments
    local start="${1:-}"
    local end="${2:-}"
    local transport="${3:-}"
    
    # 2.2 Validate parameters
    transport=$(validate_parameters "$start" "$end" "$transport")
    
    # 2.3 Build API request
    local api_url=$(build_api_url "$transport")
    local request_body=$(build_request_body "$start" "$end")
    
    # 2.5 Make the API request (with 3.2 retry logic)
    local api_response=$(make_api_request "$api_url" "$request_body")
    
    # 2.4 & 3.3 Process the response
    local result=$(parse_api_response "$api_response" "$transport")
    
    # Display the result
    echo "$result"
}

# Run the main function with all arguments
main "$@"
