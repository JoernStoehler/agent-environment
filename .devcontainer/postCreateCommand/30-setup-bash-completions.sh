#!/bin/bash
set -e
# Configures bash completions for agent tools
#
# Purpose:
#   Sets up bash command completion for agent-worktree and other agent tools
#   by sourcing the scripts themselves (which include completion functions).
#
# Effects:
#   - Sources agent-worktree script in .bashrc for completions
#   - Enables tab completion for agent commands
#   - Provides context-aware suggestions (branches, commands, options)
#
# Assumptions:
#   - Agent tools are installed in /workspaces/agent-environment/tools/
#   - User's shell is bash (default in devcontainer)
#   - Tools contain embedded completion functions
#
# Design rationale:
#   - Automatic setup ensures all users get completions without manual steps
#   - Idempotent: safe to run multiple times
#   - Uses standard bash completion mechanism
#   - Follows devcontainer best practices for shell customization

echo "Setting up bash completions for agent tools..."

TOOLS_DIR="/workspaces/agent-environment/tools"
BASHRC="$HOME/.bashrc"

# Ensure .bashrc exists
touch "$BASHRC"

# Add completion sourcing for agent-worktree if not already present
if ! grep -q "source.*agent-worktree" "$BASHRC"; then
    echo "" >> "$BASHRC"
    echo "# Agent tool completions" >> "$BASHRC"
    echo "[ -f \"$TOOLS_DIR/agent-worktree\" ] && source \"$TOOLS_DIR/agent-worktree\"" >> "$BASHRC"
    echo "✓ Added agent-worktree completion to .bashrc"
else
    echo "✓ agent-worktree completion already configured"
fi

# Source immediately for current session
if [ -f "$TOOLS_DIR/agent-worktree" ]; then
    source "$TOOLS_DIR/agent-worktree"
    echo "✓ Completions loaded for current session"
fi

echo "✓ Bash completions setup complete"