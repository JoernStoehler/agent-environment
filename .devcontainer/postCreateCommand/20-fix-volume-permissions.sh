#!/bin/bash
# Verifies and fixes permissions for mounted volumes
#
# Purpose:
#   Ensures the dev container user can access mounted directories for
#   storing credentials and configuration files.
#
# Effects:
#   - Checks write permissions on Docker volume directories
#   - Changes ownership of Docker volumes to current user
#   - Creates directories if they don't exist
#
# Assumptions:
#   - HOME environment variable is set
#   - Current user has sudo access (standard in dev containers)
#   - ~/.claude, ~/.gemini, and ~/.config/gh are Docker named volumes
#
# Design rationale:
#   - Fixes permissions on all Docker-managed volumes
#   - Creates directories if they don't exist
#   - set -e ensures script fails on unexpected errors

set -e

echo "🔧 Checking mounted directory permissions..."

# .claude, .gemini, and .config/gh are Docker named volumes
for dir in "$HOME/.claude" "$HOME/.gemini" "$HOME/.config/gh"; do
    if [ -d "$dir" ]; then
        if [ ! -w "$dir" ]; then
            echo "  Fixing $dir permissions..."
            sudo chown -R $(id -u):$(id -g) "$dir"
            echo "  ✅ $dir permissions fixed"
        else
            echo "  ✅ $dir is writable"
        fi
    else
        echo "  Creating $dir..."
        mkdir -p "$dir"
        echo "  ✅ $dir created"
    fi
done


echo "✅ Directory check complete"