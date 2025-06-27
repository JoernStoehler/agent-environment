# Environment Setup

## Overview

The development environment uses devcontainers for consistent setup across local development and GitHub Codespaces.

## Environment Variables

### Auto-Configuration
- `WORKSPACE_PATH` - Set automatically by devcontainer to workspace folder
- `.env` file - Auto-loaded in local development
- GitHub Secrets - Used in Codespaces

### Setting Up Secrets

#### Local Development
1. Copy `.env.example` to `.env`
2. Fill in actual values
3. The `.env` file is gitignored for security

#### GitHub Codespaces
Use GitHub CLI to set secrets:
```bash
gh secret set HONEYCOMB_API_KEY --app codespaces
gh secret set TAVILY_API_KEY --app codespaces
```

## Telemetry Configuration

### OpenTelemetry Collector (Optional)

The environment includes an OTEL collector service that forwards telemetry to Honeycomb:

1. Get Honeycomb credentials:
   - Sign up at [honeycomb.io](https://honeycomb.io)
   - Create a new team/environment
   - Get your API key

2. Configure environment:
   ```bash
   # In .env or GitHub secrets
   HONEYCOMB_API_KEY=your-key-here
   HONEYCOMB_DATASET=claude-code
   ```

3. The OTEL collector:
   - Runs automatically as a Docker service
   - Receives telemetry on ports 4317 (gRPC) and 4318 (HTTP)
   - Forwards to Honeycomb with proper authentication

### Disabling Telemetry
Simply omit the Honeycomb environment variables or disable the OTEL service.
See @docs/setup/telemetry-configuration.md for details.

## Claude Configuration

### Persistent Config Directory
Claude Code configuration is stored in Docker named volumes to persist across container rebuilds:
- Location: `~/.claude` (mapped to `claude-config` volume)
- Contains: OAuth tokens, preferences, history, settings.json
- Persists across container rebuilds and workspace changes

### First-Time Setup
On first run, Claude Code will:
1. Prompt for OAuth authentication
2. Store tokens in `~/.claude`
3. Remember settings across rebuilds

## Python Environment (if applicable)

### Using uv Package Manager
```bash
# Install dependencies
uv sync

# Add new package
uv add package-name

# Run commands in venv
uv run python script.py
uv run pytest
```

### Dependency Groups
Projects may organize dependencies into groups:
- Core: Always installed
- dev: Development tools (pytest, ruff, pyright)
- Optional groups: animations, ai, slides, etc.

Install specific groups:
```bash
uv sync --extra dev        # Development environment
uv sync --extra animations # If using manim
```

## Common Tools

The environment includes these CLI tools:
- `rg` (ripgrep) - Fast text search
- `fd` - User-friendly find
- `jq` - JSON processor
- `gh` - GitHub CLI
- `git` - Version control
- `claude` - Claude Code CLI
- `gemini` - Google Gemini CLI (optional)

## Troubleshooting

### Environment Variables Not Loading
```bash
# Reload in current shell
source ~/.bashrc

# Check if loaded
env | grep WORKSPACE_PATH
```

### Permission Issues
If you can't create files in `/workspaces`:
```bash
# This should be fixed by setup scripts
# But if needed:
sudo chown -R $(whoami) /workspaces
```

### Claude Command Not Found
```bash
# Should be in PATH already, but check:
which claude

# If missing, source bashrc:
source ~/.bashrc
```