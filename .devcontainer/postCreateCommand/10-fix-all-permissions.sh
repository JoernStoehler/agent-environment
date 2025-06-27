#!/bin/bash
# ==============================================================================
# 10-fix-all-permissions.sh
# ==============================================================================
# PURPOSE: Fix permissions for all directories and volumes needed by the dev environment
# 
# DESCRIPTION:
#   This script combines workspace and volume permission fixes to ensure:
#   1. Git worktrees can be created in /workspaces without sudo
#   2. Docker volumes for tool configs are writable by the user
#   3. All necessary directories exist with correct ownership
#
# SECTIONS:
#   - Fix /workspaces permissions for git worktrees
#   - Fix Docker volume permissions for persistent configs
#
# DESIGN:
#   - Idempotent: safe to run multiple times
#   - Checks before modifying to avoid unnecessary changes
#   - Clear output about what's being fixed and why
# ==============================================================================

set -e

echo "🔧 Fixing directory and volume permissions..."
echo ""

# ==============================================================================
# SECTION 1: Fix /workspaces permissions for git worktrees
# ==============================================================================
echo "📁 Checking /workspaces directory permissions..."

if [ -d "/workspaces" ]; then
    CURRENT_USER=$(whoami)
    CURRENT_GROUP=$(id -gn)
    CURRENT_OWNER=$(stat -c '%U' /workspaces)
    
    if [ "$CURRENT_OWNER" = "$CURRENT_USER" ]; then
        echo "  ✅ /workspaces is already owned by $CURRENT_USER"
    else
        echo "  Current owner: $CURRENT_OWNER"
        echo "  Changing to: $CURRENT_USER:$CURRENT_GROUP"
        
        if sudo chown "$CURRENT_USER:$CURRENT_GROUP" /workspaces; then
            echo "  ✅ Successfully changed /workspaces ownership"
            echo "  Git worktrees can now be created without sudo"
        else
            echo "  ❌ Failed to change /workspaces ownership"
            echo "  Git worktrees may require sudo to create"
        fi
    fi
else
    echo "  ℹ️  /workspaces directory not found (not in devcontainer?)"
fi

echo ""

# ==============================================================================
# SECTION 2: Fix Docker volume permissions for persistent configs
# ==============================================================================
echo "🐳 Checking Docker volume permissions..."

# Check and fix permissions for config directories
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

echo ""
echo "✅ All permissions fixed successfully"