#!/bin/bash
# Verifies and fixes permissions for Docker mounted volumes
#
# Purpose:
#   Ensures the dev container user can access Docker volumes for
#   storing credentials and configuration files that persist across rebuilds.
#
# Effects:
#   - Checks write permissions on Docker volume directories
#   - Changes ownership of Docker volumes to current user if needed
#   - Creates directories if they don't exist (for new volumes)
#
# Assumptions:
#   - HOME environment variable is set
#   - Current user has sudo access (standard in dev containers)
#   - Docker volumes are properly mounted via docker-compose.yml
#
# Design rationale:
#   - Docker volumes provide idiomatic persistence across container rebuilds
#   - All config directories (.claude, .gemini, .config/gh) use the same approach
#   - Consistent permissions management for all mounted volumes
#   - set -e ensures script fails on unexpected errors

set -e

echo "🔧 Checking mounted directory permissions..."

# All config directories are now Docker named volumes
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