#!/bin/bash
# Execute all scripts in postCreateCommand directory in alphabetical order
#
# This script is called by devcontainer.json's postCreateCommand.
# It finds and executes all *.sh files in this directory (except itself)
# in alphabetical order. Scripts should follow naming convention:
# <number>-<descriptive-name>.sh (e.g., 10-check-honeycomb-setup.sh)
#
# If any script exits with non-zero code, execution stops and error is reported.

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

echo "Running post-create commands..."
echo ""

# Find and execute all .sh files except this one, sorted alphabetically
for script in $(find "$SCRIPT_DIR" -name "*.sh" -not -name "run-all.sh" | sort); do
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