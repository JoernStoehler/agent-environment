#!/bin/bash
# ==============================================================================
# 20-setup-telemetry.sh
# ==============================================================================
# PURPOSE: Configure and validate telemetry setup for Claude and Gemini tools
# 
# DESCRIPTION:
#   This script combines telemetry validation and configuration:
#   1. Checks if Honeycomb environment variables are set
#   2. Validates OTEL collector connectivity
#   3. Creates OTEL settings files for Claude and Gemini tools
#
# PREREQUISITES:
#   - Docker Compose with OTLP collector service
#   - Optional: HONEYCOMB_API_KEY and HONEYCOMB_DATASET env vars
#
# DESIGN:
#   - Works with or without Honeycomb configuration
#   - Creates tool settings only if files don't already exist
#   - Provides clear feedback about telemetry status
# ==============================================================================

set -e

echo "📊 Setting up telemetry configuration..."
echo ""

# ==============================================================================
# SECTION 1: Check Honeycomb configuration
# ==============================================================================
echo "🍯 Checking Honeycomb setup..."

if [ -n "$HONEYCOMB_API_KEY" ] && [ -n "$HONEYCOMB_DATASET" ]; then
    echo "  ✅ Honeycomb API key is set"
    echo "  ✅ Dataset: $HONEYCOMB_DATASET"
    
    # Detect API key prefix for region info
    if [[ "$HONEYCOMB_API_KEY" == hcbik_* ]]; then
        echo "  ✅ Region: EU (api.eu1.honeycomb.io)"
    elif [[ "$HONEYCOMB_API_KEY" == hcaik_* ]]; then
        echo "  ✅ Region: US (api.honeycomb.io)"
    else
        echo "  ⚠️  Unknown API key format (expected hcbik_* or hcaik_*)"
    fi
else
    if [ -z "$HONEYCOMB_API_KEY" ]; then
        echo "  ℹ️  HONEYCOMB_API_KEY not set"
    fi
    if [ -z "$HONEYCOMB_DATASET" ]; then
        echo "  ℹ️  HONEYCOMB_DATASET not set"
    fi
    echo "  ℹ️  Telemetry will be disabled or use local collection only"
fi

echo ""

# ==============================================================================
# SECTION 2: Check OTEL collector connectivity
# ==============================================================================
echo "🔌 Checking OpenTelemetry collector..."

# Function to check if a port is open
check_port() {
    local host=$1
    local port=$2
    timeout 1 bash -c "echo >/dev/tcp/$host/$port" 2>/dev/null
}

# Check OTLP service connectivity
if check_port otlp 4318; then
    echo "  ✅ OTEL HTTP endpoint (otlp:4318) is reachable"
else
    echo "  ⚠️  OTEL HTTP endpoint (otlp:4318) is not reachable"
fi

if check_port otlp 4317; then
    echo "  ✅ OTEL gRPC endpoint (otlp:4317) is reachable"
else
    echo "  ⚠️  OTEL gRPC endpoint (otlp:4317) is not reachable"
fi

# Check health endpoint
if command -v curl >/dev/null 2>&1; then
    if curl -s -f http://otlp:13133 >/dev/null 2>&1; then
        echo "  ✅ OTEL collector health check passed"
    else
        echo "  ⚠️  OTEL collector health check failed"
    fi
else
    echo "  ℹ️  curl not available, skipping health check"
fi

echo ""

# ==============================================================================
# SECTION 3: Configure OTEL settings for tools
# ==============================================================================
echo "⚙️  Configuring tool OTEL settings..."

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

echo ""

# ==============================================================================
# SECTION 4: Summary
# ==============================================================================
echo "📋 Telemetry Setup Summary:"

if [ -n "$HONEYCOMB_API_KEY" ] && [ -n "$HONEYCOMB_DATASET" ]; then
    echo "  ✅ Honeycomb configuration: ACTIVE"
    echo "     Telemetry will be forwarded to Honeycomb"
else
    echo "  ℹ️  Honeycomb configuration: NOT SET"
    echo "     Telemetry will be collected locally only"
fi

if check_port otlp 4318 || check_port otlp 4317; then
    echo "  ✅ OTEL collector: RUNNING"
else
    echo "  ⚠️  OTEL collector: NOT ACCESSIBLE"
    echo "     Check if Docker Compose started the otlp service"
fi

echo "  ✅ Tool configurations: CREATED/VERIFIED"
echo ""
echo "✅ Telemetry setup complete"