#!/bin/bash
# Configures OpenTelemetry settings for Claude and Gemini CLI tools
#
# Purpose:
#   Sets up default OTEL configuration in user settings files for both
#   Claude Code and Gemini CLI to enable telemetry collection.
#
# Effects:
#   - Creates ~/.claude/settings.json with OTEL environment variables
#   - Creates ~/.gemini/settings.json with OTEL telemetry configuration
#   - Only creates files if they don't already exist (preserves user settings)
#
# Assumptions:
#   - Docker volumes for ~/.claude and ~/.gemini are already mounted
#   - OTLP collector is running at otlp:4318 (HTTP) and otlp:4317 (gRPC)
#
# Design rationale:
#   - User-level settings provide defaults for all projects
#   - Files are only created if missing to preserve existing configurations
#   - Uses proper JSON formatting with jq for reliability

set -e

echo "🔧 Configuring OpenTelemetry settings..."

# Configure Claude Code OTEL settings
if [ ! -f "$HOME/.claude/settings.json" ]; then
    echo "  Creating Claude Code OTEL settings..."
    cat > "$HOME/.claude/settings.json" << 'EOF'
{
  "env": {
    "OTEL_EXPORTER_OTLP_ENDPOINT": "http://otlp:4318",
    "OTEL_SERVICE_NAME": "claude-code",
    "OTEL_METRICS_EXPORTER": "otlp",
    "OTEL_LOGS_EXPORTER": "otlp",
    "OTEL_EXPORTER_OTLP_PROTOCOL": "http/protobuf"
  }
}
EOF
    echo "  ✅ Claude Code OTEL settings created"
else
    echo "  ✅ Claude Code settings.json already exists"
fi

# Configure Gemini CLI OTEL settings
if [ ! -f "$HOME/.gemini/settings.json" ]; then
    echo "  Creating Gemini CLI OTEL settings..."
    cat > "$HOME/.gemini/settings.json" << 'EOF'
{
  "telemetry": {
    "enabled": true,
    "target": "otlp",
    "otlpEndpoint": "http://otlp:4317",
    "serviceName": "gemini-cli"
  }
}
EOF
    echo "  ✅ Gemini CLI OTEL settings created"
else
    echo "  ✅ Gemini CLI settings.json already exists"
fi

echo "✅ OpenTelemetry configuration complete"