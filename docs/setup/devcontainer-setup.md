# Devcontainer Setup

## Overview

The agent environment uses a Docker Compose-based devcontainer setup that provides a consistent development environment with pre-installed tools, telemetry collection, and persistent configuration.

## Architecture

The setup consists of:
- **Dockerfile**: Base image with tools installed
- **docker-compose.yml**: Multi-service setup (devcontainer + OTEL collector)
- **devcontainer.json**: VS Code configuration
- **postCreateCommand scripts**: Automatic environment setup

## Quick Start

### Local Development
1. Install Docker and VS Code with Dev Containers extension
2. Open project in VS Code
3. Select "Reopen in Container" when prompted
4. Wait for setup to complete (~3-5 minutes first time)

### GitHub Codespaces
1. Click "Code" → "Create codespace on main"
2. Wait for setup to complete
3. Environment is ready with all tools installed

## What Gets Installed

### Base Image Tools (via Dockerfile)
- **OS Packages**: ripgrep, jq, tree, direnv
- **GitHub CLI**: For PR management and API access
- **Claude Code**: Anthropic's AI assistant CLI
- **Gemini CLI**: Google's AI assistant CLI
- **uv**: Fast Python package manager
- **Common utilities**: curl, wget, git, make

### Via Post-Create Scripts
- Environment variable auto-loading from `.env`
- Telemetry configuration for OTEL collector
- Bash completions for agent-worktree tool
- Python environment (if `pyproject.toml` exists)
- Proper permissions for git worktrees

## Docker Compose Services

### 1. devcontainer Service
The main development environment with:
- Mounted workspace at `/workspaces`
- Named volumes for persistent config:
  - `gh-auth`: GitHub CLI authentication
  - `claude-config`: Claude Code settings and auth
  - `gemini-config`: Gemini CLI settings

### 2. otlp Service
OpenTelemetry collector that:
- Receives telemetry on ports 4317 (gRPC) and 4318 (HTTP)
- Forwards to Honeycomb (if configured)
- Provides health check endpoint on port 13133

## Post-Create Scripts

Scripts in `.devcontainer/postCreateCommand/` run automatically after container creation:

1. **01-bashrc-loads-env-file.sh** - Auto-loads `.env` file if present
2. **10-fix-all-permissions.sh** - Fixes permissions for /workspaces and Docker volumes
3. **20-setup-telemetry.sh** - Validates and configures OTEL telemetry
4. **30-setup-bash-completions.sh** - Installs bash completions for tools
5. **40-install-python-environment.sh** - Sets up Python environment if needed

The scripts run in numeric order and are designed to be idempotent (safe to run multiple times).

## Environment Variables

### Automatically Set
- `WORKSPACE_PATH`: Points to `/workspaces`
- `PATH`: Includes `/workspaces/agent-environment/tools`
- `CLAUDE_CONFIG_DIR`: Points to `~/.claude` (via docker-compose.yml)

### User-Provided (Optional)
Add to `.env` file:
```bash
# Telemetry (optional)
HONEYCOMB_API_KEY=your-key-here
HONEYCOMB_DATASET=claude-code

# AI Tools (optional)
GEMINI_API_KEY=your-key-here
TAVILY_API_KEY=your-key-here
```

## VS Code Extensions

The devcontainer automatically installs:
- Python extensions (Python, Pylance, Ruff)
- Container/Docker tools
- GitHub Actions support
- YAML, TOML, Makefile support
- PDF viewer
- Gemini Code Assist

## Persistent Data

### Named Volumes
Data that persists across container rebuilds:
- `gh-auth`: GitHub CLI credentials
- `claude-config`: Claude Code OAuth tokens and settings
- `gemini-config`: Gemini CLI configuration

### Workspace Data
- `.env` file (gitignored)
- Project code and git repository
- Any files created in `/workspaces`

## Customization

### Adding New Tools
1. For all users: Add to Dockerfile
2. For specific projects: Add to post-create scripts

### Disabling Services
To disable OTEL collector, add to devcontainer.json:
```json
{
  "runServices": ["devcontainer"]
}
```

### Custom Extensions
Add to devcontainer.json:
```json
{
  "customizations": {
    "vscode": {
      "extensions": [
        "your.extension-id"
      ]
    }
  }
}
```

## Troubleshooting

### Container Won't Start
```bash
# Check Docker is running
docker version

# Check for port conflicts
docker ps
lsof -i :4317,4318,13133
```

### Scripts Not Running
```bash
# Check script permissions
ls -la .devcontainer/postCreateCommand/

# Run manually to debug
bash .devcontainer/postCreateCommand/run-all.sh
```

### Environment Variables Missing
```bash
# Reload shell
source ~/.bashrc

# Check if .env was loaded
env | grep HONEYCOMB

# Check Docker Compose environment
docker compose exec devcontainer env
```

### Tools Not Found
```bash
# Check PATH includes tools directory
echo $PATH | grep -o '/workspaces/[^:]*'

# Verify tools are installed
which claude
which gemini
which agent-worktree
```

### Permission Denied
```bash
# For git operations
sudo chown -R $(whoami) /workspaces

# For Docker volumes
docker compose exec devcontainer bash -c "chown -R codespace:codespace ~/.claude ~/.gemini"
```

## Security Considerations

- API keys should only be in `.env` (gitignored) or GitHub Secrets
- Docker volumes store authentication tokens securely
- OTEL collector only forwards telemetry, no source code
- All tools run as non-root user `codespace`