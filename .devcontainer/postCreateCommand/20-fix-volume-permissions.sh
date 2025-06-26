#!/bin/bash
# Verifies and fixes permissions for mounted volumes
#
# Purpose:
#   Ensures the dev container user can access mounted directories for
#   storing credentials and configuration files.
#
# Effects:
#   - Checks write permissions on bind-mounted directories
#   - Changes ownership of Docker volumes (but not bind mounts)
#   - Exits with code 0 even if warnings are present
#
# Assumptions:
#   - HOME environment variable is set
#   - Current user has sudo access (standard in dev containers)
#   - ~/.claude and ~/.gemini are bind mounts from host
#   - ~/.config/gh is a Docker named volume
#
# Design rationale:
#   - Never modifies bind mount permissions (would affect host system)
#   - Only fixes permissions on Docker-managed volumes
#   - Warnings are non-fatal to allow development to continue
#   - set -e ensures script fails on unexpected errors

set -e

echo "🔧 Checking mounted directory permissions..."

# .claude and .gemini are bind mounts from host filesystem
for dir in "$HOME/.claude" "$HOME/.gemini"; do
    if [ -d "$dir" ]; then
        if [ ! -w "$dir" ]; then
            echo "  ⚠️  Warning: $dir is not writable by current user"
            echo "     This is a bind mount from host - permission issues may occur"
        else
            echo "  ✅ $dir is writable"
        fi
    else
        echo "  ℹ️  $dir does not exist on host"
    fi
done

# GitHub CLI config is still a named volume, so we can fix its permissions
if [ -d "$HOME/.config/gh" ]; then
    if [ ! -w "$HOME/.config/gh" ]; then
        echo "  Fixing GitHub CLI config permissions..."
        sudo chown -R $(id -u):$(id -g) "$HOME/.config/gh"
        echo "  ✅ GitHub CLI config permissions fixed"
    fi
fi

echo "✅ Directory check complete"