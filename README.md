# Agent Environment

A development environment for AI agents with built-in telemetry, monitoring tools, and VS Code Dev Container support.

## Quick Start

1. Clone this repository into your workspace directory
2. Open in VS Code
3. Click "Reopen in Container" when prompted
4. Configure Honeycomb credentials (see setup guide)

## Documentation

- [Setup Guide](docs/user/setup.md) - Detailed setup instructions
- [Changelog](CHANGELOG.md) - Version history
- [Roadmap](ROADMAP.md) - Future plans

## Tools

- **agent-monitor** - Real-time system monitoring dashboard
- **agent-worktree** - Simplified git worktree management

## Features

- Pre-configured VS Code Dev Container
- OpenTelemetry integration with Honeycomb
- Claude Code CLI with telemetry enabled
- Essential development tools (ripgrep, jq, direnv, gh)
- Python environment with uv package manager
- Extensible post-create command system

## Repository Structure

```
.devcontainer/          # Dev container configuration
├── postCreateCommand/  # Auto-executed setup scripts
├── docker-compose.yml  # Services configuration
├── Dockerfile         # Container image definition
└── otel-config.yaml   # OpenTelemetry collector config

tools/                 # Agent helper scripts
docs/                  # User documentation
```

## Contributing

See the setup guide for development environment configuration.