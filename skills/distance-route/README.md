# Distance Route Skill - Configuration

## Environment Variables

The distance-route skill uses environment variables for configuration.

### Required Variables

| Variable | Description | Example |
|----------|-------------|---------|
| `XBIlling_Token` | Distance Tools API authentication token | `abc123-xyz-456` |

**Important:** This variable must be set before using the skill.

```bash
export XBIlling_Token="your-api-token-from-distance-tools"
```

### Optional Configuration Variables

| Variable | Description | Default |
|----------|-------------|---------|
| `API_TIMEOUT` | Maximum time in seconds for API requests | 30 |
| `MAX_RETRIES` | Maximum number of retry attempts for network failures | 3 |

### Configuration Examples

#### Standard setup
```bash
export XBIlling_Token="abc123-xyz-456"
export API_TIMEOUT=30
export MAX_RETRIES=3
```

#### High-volume setup with longer timeouts
```bash
export XBIlling_Token="abc123-xyz-456"
export API_TIMEOUT=60
export MAX_RETRIES=5
```

#### Development/testing setup
```bash
export XBIlling_Token="test-token-from-sandbox"
export API_TIMEOUT=5
export MAX_RETRIES=2
```

## Token Management

### Security Guidelines
- Never commit .env files to version control
- Use secrets management systems for production tokens
- Rotate tokens regularly
- Limit token scope to required permissions

### Token Scopes Required
The skill requires a token with:
- `distance:read` - Read distance calculations
- `route:read` - Read routing information

Request token from: https://developers.distance.tools/tokens

## Deployment Patterns

### Docker/Container Setup
```dockerfile
ENV XBIlling_Token=your-token-here
ENV API_TIMEOUT=45
ENV MAX_RETRIES=5
```

### CI/CD Pipelines
```yaml
# GitHub Actions example
env:
  XBIlling_Token: ${{ secrets.DISTANCE_API_TOKEN }}
  API_TIMEOUT: 60
```

### Serverless Functions
```javascript
// AWS Lambda example
process.env.XBIlling_Token = process.env.DISTANCE_API_TOKEN;
process.env.API_TIMEOUT = 30;
```

## Error Handling and Debugging

### Environment Variable Debugging
Check if variables are set correctly:
```bash
# Linux/macOS
echo "Token: ${XBIlling_Token:-NOT SET}"
echo "Timeout: ${API_TIMEOUT:-DEFAULT(30)}"
```

### Common Configuration Issues

#### Missing token error
```
[ERROR] XBIlling_Token environment variable is required
```
**Solution:** `export XBIlling_Token="your-token"`

#### Timeout settings too low
```
[WARN] Request failed (code 408). Request timeout
```
**Solution:** `export API_TIMEOUT=60`

#### Mission critical operation timeout
```
[WARN] Request failed (code 500). Retrying...
[WARN] Request failed (code 500). Request timeout
```
**Solution:** Consider rate limiting or breaking down operation

## Testing Configuration
Verify your setup with a simple test:
```bash
# Test with debug output
bash -x ./skills/distance-route/scripts/distance-route.sh "Paris" "Berlin" "car"
```

Check variable inheritance in subshells:
```bash
export TEST_VAR="test"
(bash -c 'echo "$TEST_VAR"')  # Should output "test"
```