#!/bin/bash
# ==============================================================================
# 01-bashrc-loads-env-file.sh
# ==============================================================================
# PURPOSE: Configure automatic loading of .env file for local development
# 
# DESCRIPTION:
#   Modifies ~/.bashrc to automatically source the .env file when starting a
#   new shell session in local devcontainers. In GitHub Codespaces, environment
#   variables should be set via GitHub secrets instead.
#
# BEHAVIOR:
#   - In Codespaces: No action (uses GitHub secrets)
#   - In local devcontainer: Sources .env file if it exists
#   - Warns about misconfigurations (missing .env locally, existing .env in Codespaces)
#
# ENVIRONMENT SETUP:
#   - Codespaces: Use `gh secret set NAME VALUE --app codespaces`
#   - Local: Create .env file in workspace root
# ==============================================================================

set -e

echo "Setting up automatic .env file loading in ~/.bashrc..."

# Add the .env loading logic to ~/.bashrc
cat >> ~/.bashrc << 'EOF'

# Auto-load .env file for local development
if [ -n "$CODESPACES" ]; then
    # In Codespaces - environment variables should come from GitHub secrets
    if [ -f "${WORKSPACE_PATH}/.env" ]; then
        echo "WARNING: .env file found in Codespaces. Environment variables should be set via GitHub secrets instead."
        echo "Use: gh secret set NAME VALUE --app codespaces"
    fi
else
    # In local devcontainer - load .env if it exists
    if [ -f "${WORKSPACE_PATH}/.env" ]; then
        echo "Loading environment variables from .env file..."
        set -a
        source "${WORKSPACE_PATH}/.env"
        set +a
    else
        echo "WARNING: No .env file found in local devcontainer at ${WORKSPACE_PATH}/.env"
        echo "Create one by copying .env.example: cp .env.example .env"
    fi
fi
EOF

echo "✓ Configured automatic .env file loading"