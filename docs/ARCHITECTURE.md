# Architecture Overview

## System Architecture

The agent-environment is a Docker-based development environment designed for AI-assisted software development.

```
┌─────────────────────────────────────────────────────────┐
│                    Host Machine                         │
│  ┌─────────────────────────────────────────────────┐   │
│  │              Docker Compose                      │   │
│  │  ┌─────────────────┐  ┌───────────────────┐   │   │
│  │  │   DevContainer   │  │  OTEL Collector   │   │   │
│  │  │                  │  │                   │   │   │
│  │  │ - VS Code Server │  │ - Port 4317/4318  │   │   │
│  │  │ - Claude CLI     │  │ - Honeycomb fwd   │   │   │
│  │  │ - Gemini CLI     │  │                   │   │   │
│  │  │ - Python/uv      │  └───────────────────┘   │   │
│  │  │ - Git tools      │                          │   │
│  │  │ - agent-*        │  ┌───────────────────┐   │   │
│  │  └─────────────────┘  │   Named Volumes    │   │   │
│  │                        │ - claude-config    │   │   │
│  │                        │ - gemini-config    │   │   │
│  │                        │ - gh-auth          │   │   │
│  │                        └───────────────────┘   │   │
│  └─────────────────────────────────────────────────┘   │
└─────────────────────────────────────────────────────────┘
```

## Components

### 1. DevContainer Service
The main development environment based on Microsoft's universal devcontainer image.

**Includes**:
- VS Code Server for IDE integration
- AI assistant CLIs (Claude, Gemini)
- Development tools (git, gh, ripgrep, jq)
- Python toolchain with uv
- Custom agent-* tools

**Configuration**:
- Dockerfile extends base image
- Post-create scripts for environment setup
- Named volumes for persistent configuration

### 2. OTEL Collector Service
Optional telemetry collection and forwarding service.

**Features**:
- Receives telemetry from AI tools
- Batches and forwards to Honeycomb
- Provides health check endpoint
- Auto-configured by environment variables

### 3. Named Volumes
Docker volumes that persist data across container rebuilds:
- `claude-config`: Claude CLI OAuth tokens and settings
- `gemini-config`: Gemini CLI configuration
- `gh-auth`: GitHub CLI authentication

### 4. Workspace Mount
The host workspace is mounted at `/workspaces` allowing:
- Direct file editing from host
- Git operations on host repository
- Persistent project data

## Tools

### agent-worktree
Git worktree management tool for parallel development.
- Creates isolated branch workspaces
- Manages worktree lifecycle
- Integrates with AI tools

### agent-monitor
Real-time system monitoring dashboard.
- Tracks resource usage
- Shows running AI agents
- Monitors git status
- Displays file changes

## Configuration Flow

1. **Container Start**
   - Docker Compose launches services
   - Volumes are mounted
   - Workspace is available

2. **Post-Create Setup**
   - Scripts in `.devcontainer/postCreateCommand/` run
   - Environment variables configured
   - Tools initialized
   - Permissions fixed

3. **Runtime**
   - AI tools use OTEL endpoint for telemetry
   - Configuration persists in volumes
   - Git worktrees created as needed

## Security Considerations

- API keys stored in `.env` (gitignored) or GitHub Secrets
- OAuth tokens isolated in Docker volumes
- Non-root user (codespace) for operations
- Network isolation between services

## Extension Points

### Adding Tools
1. Update Dockerfile for global tools
2. Add post-create script for setup
3. Document in appropriate location

### Custom Workflows
1. Create workflow documentation
2. Add tool scripts to `tools/`
3. Update CLAUDE.md for discoverability

### Language Support
1. Add language-specific folder in `docs/`
2. Include setup in post-create scripts
3. Update testing/style guides