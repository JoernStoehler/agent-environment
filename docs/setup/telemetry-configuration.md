# Telemetry Configuration

## Overview

The agent environment uses OpenTelemetry (OTEL) to collect telemetry data from Claude Code and Gemini CLI. An OTEL collector runs as a separate Docker container service that receives telemetry data and forwards it to Honeycomb.

## Architecture

```
┌─────────────┐     ┌──────────────┐     ┌───────────┐
│ Claude Code │────▶│     OTEL     │────▶│ Honeycomb │
│ Gemini CLI  │     │  Collector   │     │           │
└─────────────┘     └──────────────┘     └───────────┘
```

- **Claude Code & Gemini CLI**: Send telemetry to local OTEL collector
- **OTEL Collector**: Runs at `otlp:4317` (gRPC) and `otlp:4318` (HTTP)
- **Honeycomb**: Receives processed telemetry data

## Setup

### 1. Get Honeycomb Credentials

1. Sign up at [honeycomb.io](https://honeycomb.io)
2. Create a team/environment
3. Get your API key from Account Settings

### 2. Configure Environment Variables

#### Local Development
Add to `.env` in the repository root:
```bash
HONEYCOMB_API_KEY=your-api-key-here
HONEYCOMB_DATASET=claude-code
```

#### GitHub Codespaces
```bash
gh secret set HONEYCOMB_API_KEY --app codespaces
gh secret set HONEYCOMB_DATASET --app codespaces
```

### 3. Start the Environment

The OTEL collector starts automatically when you open the devcontainer. To verify:

```bash
# Check collector health
curl -s http://localhost:13133 | jq .

# Check if environment variables are set
echo $HONEYCOMB_API_KEY
```

## How It Works

### 1. Docker Compose Services

The `.devcontainer/docker-compose.yml` defines two services:
- **devcontainer**: Main development environment
- **otlp**: OpenTelemetry collector

### 2. Automatic Configuration

When the devcontainer starts:
1. OTEL collector launches and listens on ports 4317/4318
2. Settings files are created for Claude Code and Gemini CLI
3. Both tools are configured to send telemetry to the local collector

### 3. Data Flow

1. Tools send telemetry to `http://otlp:4318` (HTTP) or `otlp:4317` (gRPC)
2. OTEL collector batches and processes the data
3. Data is forwarded to Honeycomb with proper headers

## What Gets Collected

### Metrics
- API request counts
- Token usage per request
- Response times
- Error rates

### Traces
- Full request lifecycle
- Tool usage patterns
- Performance bottlenecks
- Error context

### Logs
- Error messages
- Warnings
- System events

## Viewing Telemetry

### Honeycomb Dashboard

1. Log into Honeycomb
2. Navigate to your environment
3. View datasets:
   - `claude-code` - All telemetry data from tools

### Useful Queries
- Request volume over time
- Token usage by operation
- Error rate trends
- Slow request analysis

## Configuration Details

### OTEL Collector Config

The collector configuration (`otel-config.yaml`) defines:
- **Receivers**: OTLP on ports 4317 (gRPC) and 4318 (HTTP)
- **Processors**: Batch processor for efficiency
- **Exporters**: Honeycomb with dynamic headers

### Claude Code Settings

Created in `~/.claude/settings.json`:
```json
{
  "env": {
    "OTEL_EXPORTER_OTLP_ENDPOINT": "http://otlp:4318",
    "OTEL_SERVICE_NAME": "claude-code",
    "OTEL_METRICS_EXPORTER": "otlp",
    "OTEL_LOGS_EXPORTER": "otlp",
    "OTEL_EXPORTER_OTLP_PROTOCOL": "http/protobuf"
  }
}
```

### Gemini CLI Settings

Created in `~/.gemini/settings.json`:
```json
{
  "telemetry": {
    "enabled": true,
    "target": "otlp",
    "otlpEndpoint": "http://otlp:4317",
    "serviceName": "gemini-cli"
  }
}
```

## Disabling Telemetry

### Option 1: Stop the OTEL Collector

Add to `.devcontainer/devcontainer.json`:
```json
{
  "runServices": ["devcontainer"]
}
```

### Option 2: Don't Set Environment Variables

Simply omit the Honeycomb environment variables.

### Option 3: Disable in Tool Settings

Modify the settings files to disable telemetry for specific tools.

## Troubleshooting

### No Data in Honeycomb

1. Check OTEL collector is running:
   ```bash
   docker ps | grep otlp
   ```

2. Verify environment variables are set:
   ```bash
   docker compose exec otlp env | grep HONEYCOMB
   ```

3. Check collector logs:
   ```bash
   docker compose logs otlp
   ```

4. Test with a simple command:
   ```bash
   claude --version
   # Wait 1-2 minutes for data to appear
   ```

### Region Configuration

The OTEL collector config uses EU endpoint by default (`api.eu1.honeycomb.io`). To use US region:

1. Edit `.devcontainer/otel-config.yaml`
2. Change endpoint to `https://api.honeycomb.io`
3. Rebuild the devcontainer

### Collector Connection Issues

If tools can't connect to the collector:
```bash
# Check collector is listening
netstat -an | grep -E "4317|4318"

# Test connectivity from devcontainer
curl http://otlp:4318/v1/metrics
```

## Privacy and Security

- No source code is sent
- No file contents included
- Only metadata and metrics
- All data stays within your Docker network until sent to Honeycomb
- Use secrets management for API keys

## Advanced Configuration

### Custom Dataset Names

Edit the docker-compose.yml environment:
```yaml
environment:
  - HONEYCOMB_DATASET=my-custom-dataset
```

### Debug Mode

Add to otel-config.yaml exporters:
```yaml
exporters:
  debug:
    verbosity: detailed
```

Then add `debug` to the pipeline exporters list.

### Different Service Names

Modify the settings.json files to use custom service names for better organization in Honeycomb.