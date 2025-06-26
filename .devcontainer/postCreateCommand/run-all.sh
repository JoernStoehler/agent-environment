#!/bin/bash
set -e
# Orchestrates execution of all post-create setup scripts
#
# Purpose:
#   Single entry point for devcontainer post-create initialization.
#   Ensures consistent execution order and proper error handling.
#
# Effects:
#   - Executes all *.sh files in current directory (except itself)
#   - Stops execution on first script failure
#   - Returns exit code of failed script or 0 on success
#
# Assumptions:
#   - Called from devcontainer.json postCreateCommand
#   - Scripts follow naming convention: NN-description.sh
#   - All scripts have execute permissions
#
# Design rationale:
#   - Numeric prefixes ensure deterministic execution order
#   - find + sort provides cross-platform compatibility
#   - Fail-fast behavior prevents cascading errors
#   - Clear output formatting aids debugging

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

echo "Running post-create commands..."
echo ""

# Find and execute all .sh files except this one, sorted alphabetically
# Using while read to handle filenames with spaces properly
find "$SCRIPT_DIR" -name "*.sh" -not -name "run-all.sh" | sort | while IFS= read -r script; do
    if [ -x "$script" ]; then
        echo "▶ Running: $(basename "$script")"
        echo "─────────────────────────────────────────"
        "$script"
        EXIT_CODE=$?
        if [ $EXIT_CODE -ne 0 ]; then
            echo "❌ Script failed with exit code $EXIT_CODE: $(basename "$script")"
            exit $EXIT_CODE
        fi
        echo ""
    else
        echo "⚠️  Skipping non-executable script: $(basename "$script")"
    fi
done

echo "✅ All post-create commands completed!"