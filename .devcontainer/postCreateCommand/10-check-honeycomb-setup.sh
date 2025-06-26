#!/bin/bash
# Check devcontainer setup and provide helpful warnings
#
# This script validates that Honeycomb telemetry is properly configured:
# - Checks if .devcontainer/.env file exists
# - Verifies credentials aren't still placeholder values
# - Checks if OTEL collector container is running
#
# Provides clear instructions if any issues are found.

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
if docker ps | grep -q otlp; then
    echo "✅ OTEL collector is running"
else
    echo "ℹ️  OTEL collector is not running. Start with: docker-compose up -d otlp"
fi

echo ""
echo "Container ready!"