#!/bin/bash
set -e
# Validates OpenTelemetry collector and Honeycomb configuration
#
# Purpose:
#   Ensures telemetry infrastructure is properly configured for development.
#   Fails fast with actionable error messages if setup is incomplete.
#
# Effects:
#   - Sources .env file to check environment variables
#   - Queries Docker to verify OTEL collector is running
#   - Exits with code 1 if critical components are missing
#
# Assumptions:
#   - Docker socket is mounted (standard for dev containers)
#   - OTEL collector service is managed by docker-compose
#   - .env file contains HONEYCOMB_API_KEY and HONEYCOMB_DATASET
#
# Design rationale:
#   - Waits up to 10 seconds for OTEL collector to allow for slow startups
#   - Provides copy-paste commands for fixing common issues
#   - Non-zero exit prevents downstream scripts from running with broken telemetry

echo "🔍 Checking devcontainer setup..."

# Check if .env file exists
if [ ! -f "/workspaces/agent-environment/.devcontainer/.env" ]; then
    echo ""
    echo "⚠️  WARNING: Honeycomb credentials not configured!"
    echo "   Telemetry will not be sent to Honeycomb."
    echo ""
    echo "   To fix this:"
    echo "   1. cd /workspaces/agent-environment/.devcontainer"
    echo "   2. cp .env.example .env"
    echo "   3. Edit .env with your Honeycomb API key and dataset"
    echo "   4. docker-compose up -d otlp"
    echo ""
else
    # Check if credentials are still placeholders
    source /workspaces/agent-environment/.devcontainer/.env
    if [ "$HONEYCOMB_API_KEY" = "your-honeycomb-api-key" ]; then
        echo ""
        echo "⚠️  WARNING: Honeycomb API key is still the placeholder value!"
        echo "   Please edit .devcontainer/.env with your actual credentials"
        echo ""
    else
        echo "✅ Honeycomb credentials configured"
    fi
fi

# Check if OTEL collector is running
# Docker-compose should start all services by default when runServices is not specified
for i in {1..10}; do
    if docker ps | grep -q -E "(otlp|otel)"; then
        echo "✅ OTEL collector is running"
        break
    elif [ $i -eq 10 ]; then
        echo "❌ ERROR: OTEL collector is not running after 10 seconds!"
        echo "   This should not happen - the devcontainer should have started it automatically."
        echo "   Telemetry data will be lost!"
        echo ""
        echo "   Debug info:"
        echo "   - Running containers:"
        docker ps --format "table {{.Names}}\t{{.Status}}" | grep -E "(otlp|otel|devcontainer)" || echo "     No matching containers"
        echo "   - All containers (including stopped):"
        docker ps -a --format "table {{.Names}}\t{{.Status}}" | grep -E "(otlp|otel|devcontainer)" || echo "     No matching containers"
        exit 1
    else
        echo "   Waiting for OTEL collector to start... ($i/10)"
        sleep 1
    fi
done

echo ""
echo "Container ready!"