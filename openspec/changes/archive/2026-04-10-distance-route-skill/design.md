## Context

New skills project for distance.tools suite. This is the first functional skill, creating the foundation for other API-driven skills. No existing code patterns to follow - establishing conventions for script-based skills.

## Goals / Non-Goals

**Goals:**
- Implement working distance calculation skill using bash/curl/jq
- Establish error handling patterns for API calls
- Provide clear input/output contracts for agent usage
- Create reusable bash function patterns for future skills

**Non-Goals:**
- Multiple transport modes in single call (use separate calls)
- Batch processing multiple routes (focus on single route first)
- Advanced caching or rate limiting (handle at agent level)

## Decisions

**Use bash/curl instead of Node.js/Python:**
- **Rationale**: More portable, no runtime dependencies beyond curl/jq which are ubiquitous
- **Alternatives considered**: JavaScript (Node.js), Python
- **Why not**: JavaScript requires Node.js; Python requires Python 3.x and specific libraries

**Sampling calculation method:**
- **Rationale**: Vincenty formula offers better accuracy for most use cases compared to Haversine
- **Alternatives considered**: Great circle, Haversine formulas
- **Flexibility**: Return all airline distances in response for agent to choose
- **Resolution**: Agent picks appropriate field based on use case

**Input validation approach:**
- **Rationale**: Fail-fast with clear error messages at script level
- **Policy**: Validate required parameters (start, end) and transport mode
- **Collections**: Use format validation for coordinates (lat,lng or free text)

**Authentication handling:**
- **Rationale**: Allow API token through environment variable
- **Security**: Prevent accidental token exposure in logs or command history
- **Service**: Agent must provide token via XBIlling_Token env var

## Risks / Trade-offs

**API Rate Limiting**:→ Prevalidate token and provide agent-level retry logic guidance
**Network Issues**:→ Implement curl timeout and retry logic with exponential backoff
**Data Accuracy**:→ Use API validation route properties values vs manual parsing
**Error Handling**:→ Comprehensive error case parsing with JSON response validation