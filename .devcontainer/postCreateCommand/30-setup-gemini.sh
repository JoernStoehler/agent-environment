#!/bin/bash
set -e

echo "Setting up Gemini CLI configuration..."

# Create Gemini config directory in workspaces if it doesn't exist
mkdir -p /workspaces/.gemini-config

# Create symlink from default location to workspaces for persistence
if [ ! -L "/home/codespace/.gemini" ]; then
    # Remove existing directory if it exists
    if [ -d "/home/codespace/.gemini" ]; then
        rm -rf /home/codespace/.gemini
    fi
    ln -s /workspaces/.gemini-config /home/codespace/.gemini
fi

# Create initial settings.json with OTLP telemetry configuration if it doesn't exist
if [ ! -f "/workspaces/.gemini-config/settings.json" ]; then
    cat > /workspaces/.gemini-config/settings.json << 'EOF'
{
  "telemetry": {
    "enabled": true,
    "target": "otlp",
    "otlpEndpoint": "http://otlp:4318",
    "serviceName": "gemini-cli"
  }
}
EOF
    echo "Created initial Gemini settings.json with OTLP configuration"
fi

# Ensure proper permissions
chmod -R 755 /workspaces/.gemini-config
chown -R codespace:codespace /workspaces/.gemini-config

echo "Gemini CLI configuration setup complete!"