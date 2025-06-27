#!/bin/bash
# ==============================================================================
# 10-install-python-environment.sh
# ==============================================================================
# PURPOSE: Set up Python development environment
# 
# DESCRIPTION:
#   Checks if the project uses Python (has pyproject.toml) and sets up the
#   development environment using uv. This should run after uv is installed.
#
# ACTIONS:
#   - Checks for pyproject.toml in workspace
#   - If found, syncs dependencies with uv
#   - Installs development dependencies by default
#
# NOTES:
#   - This script should run after 06-install-uv.sh
#   - Uses 'uv sync' which respects lock files for reproducible installs
# ==============================================================================

set -e

echo "Setting up Python environment..."

# Check if there's a pyproject.toml in the workspace
if [ -f "${WORKSPACE_PATH}/pyproject.toml" ]; then
    echo "Found pyproject.toml - setting up Python environment..."
    
    # Change to workspace directory
    cd "${WORKSPACE_PATH}"
    
    # Sync dependencies
    # Check if project has optional dependency groups
    if grep -q "project.optional-dependencies" pyproject.toml; then
        # Check specifically for dev group
        if grep -A 20 "project.optional-dependencies" pyproject.toml | grep -q "dev.*="; then
            echo "Installing with dev dependencies..."
            uv sync --extra dev
        else
            echo "Installing core dependencies only..."
            uv sync
        fi
    else
        echo "Installing core dependencies..."
        uv sync
    fi
    
    echo "✓ Python environment setup complete"
    
    # Show Python version being used
    if command -v uv &> /dev/null; then
        echo ""
        echo "Python environment info:"
        uv run python --version
    fi
else
    echo "ℹ No pyproject.toml found in workspace - skipping Python setup"
    echo "  This is expected for non-Python projects"
fi

echo ""
echo "✓ Environment setup complete!"