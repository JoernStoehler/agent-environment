# Claude Code Development Guidelines

This is the entry point for Claude Code. This file is automatically read at the start of each session.

## Quick Start

You are working in the agent-environment development setup:
- **Current directory**: `/workspaces/{repository-name}` or worktree branch
- **Python**: `uv` package manager pre-installed (use `uv run` for Python projects)
- **Tools available**: `agent-worktree`, `agent-monitor`, `rg`, `fd`, `jq`, `gh`, `git`
- **AI assistants**: `claude` and `gemini` CLIs are installed

## Environment Overview

### Architecture
- **DevContainer**: Docker Compose with two services
  - Main development container with all tools
  - OTEL collector for telemetry (if configured)
- **Persistence**: Docker named volumes for credentials
- **Auto-setup**: Post-create scripts configure environment

### Key Tools
- **agent-worktree**: Create/manage git worktrees for parallel development
- **agent-monitor**: Real-time system and agent monitoring dashboard
- **claude/gemini**: AI assistant CLIs for pair programming

## Essential Documentation

### 📁 Core Concepts
- [Development Principles](docs/development/principles.md) - How to work effectively with Claude Code
- [Environment Setup](docs/development/environment-setup.md) - DevContainer and tool configuration
- [Testing Guidelines](docs/development/testing.md) - General testing best practices

### 🔄 Workflows
- [Task Management](docs/workflows/task-management.md) - Using todos to track complex work
- [Git Worktree Workflow](docs/workflows/git-worktree.md) - Parallel development with `agent-worktree`
- [Pull Request Process](docs/workflows/pull-requests.md) - Creating effective PRs

### 🛠️ Tools
- [agent-worktree](docs/tools/agent-worktree.md) - Git worktree management
- [agent-monitor](docs/tools/agent-monitor.md) - System monitoring dashboard
- [Claude CLI](docs/tools/claude.md) - Claude Code assistant
- [Gemini CLI](docs/tools/gemini-cli.md) - Google's AI assistant

### 🐍 Python Development
- [Python Guide](docs/python/README.md) - Python-specific documentation index
- [Code Style](docs/python/code-style.md) - Python coding standards
- [Testing](docs/python/testing.md) - Comprehensive pytest guide

## Common Commands

```bash
# Git worktree management
agent-worktree add feat/new-feature    # Create feature worktree
agent-worktree remove feat/old-feature # Remove after PR merge
git worktree list                      # List all worktrees

# System monitoring
agent-monitor                          # Live system dashboard
agent-monitor --interval 10            # Update every 10 seconds

# Python development (if applicable)
uv sync                               # Install dependencies
uv run pytest                         # Run tests
uv run ruff check .                   # Lint code
uv run pyright .                      # Type check

# Git workflow
git status                            # Check changes
git add <files>                       # Stage specific files
git commit -m "type: message"         # Conventional commit
gh pr create                          # Create pull request
```

## Working Patterns

### Task Management
- Use the Todo tool for complex multi-step tasks
- Break work into manageable pieces
- Update task status as you progress

### Code Development
- Follow existing patterns in the codebase
- Write tests first (TDD) when possible
- Use type hints and documentation
- Keep commits focused and atomic

### Communication
- Direct communication preferred
- Ask for clarification when needed
- Submit PRs for review
- Document decisions and rationale

## Environment Details

### File Paths
- **Workspace**: `/workspaces/{project-name}`
- **Tools**: `/workspaces/agent-environment/tools`
- **Config**: `~/.claude`, `~/.gemini` (Docker volumes)

### Environment Variables
- `.env` file auto-loads in local development
- GitHub secrets used in Codespaces
- `WORKSPACE_PATH` always points to current workspace

### Telemetry (Optional)
- OTEL collector at `http://otlp:4318`
- Forwards to Honeycomb if configured
- See [Telemetry Setup](docs/setup/telemetry-configuration.md)

## Getting Help

- **Documentation**: Browse `docs/` for detailed guides
- **Troubleshooting**: Check specific tool documentation
- **Examples**: Look for existing patterns in the codebase

Remember: This environment is designed for efficient development with AI assistance. Use the tools provided to explore, understand, and modify code effectively.