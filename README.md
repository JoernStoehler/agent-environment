# Agent Environment

A comprehensive Docker-based development environment optimized for AI-assisted software development with Claude and Gemini.

## What is this?

Agent Environment provides:
- 🤖 **AI Integration** - Pre-installed Claude and Gemini CLIs for pair programming
- 🛠️ **Developer Tools** - Git worktrees, system monitoring, and modern CLI tools
- 📊 **Observability** - Optional telemetry with OpenTelemetry and Honeycomb
- 🐳 **Consistency** - Docker-based setup works identically everywhere
- 💾 **Persistence** - Credentials and configs survive container rebuilds

## Quick Start

### Local Development
1. Clone this repository
2. Open in VS Code with the Dev Containers extension
3. Click "Reopen in Container" when prompted
4. Start coding with `claude` or `gemini` commands

### GitHub Codespaces
1. Click "Code" → "Create codespace on main"
2. Wait for environment setup
3. Start coding immediately

## Key Features

### AI Assistants
- **Claude Code** - Anthropic's coding assistant (`claude` command)
- **Gemini CLI** - Google's AI assistant (`gemini` command)
- Both configured with persistent auth and optional telemetry

### Development Tools
- **agent-worktree** - Manage git worktrees for parallel development
- **agent-monitor** - Real-time monitoring dashboard for system resources
- **Modern CLI tools** - ripgrep, fd, jq, gh, direnv, tree
- **Python** - uv package manager for fast Python development

### DevContainer Setup
- Based on Microsoft's universal devcontainer image
- Multi-service Docker Compose (main container + OTEL collector)
- Auto-running setup scripts for environment configuration
- Named Docker volumes for persistent configuration

## Documentation Structure

```
docs/
├── development/        # Core concepts and principles
├── workflows/          # Common development workflows  
├── tools/              # Tool-specific documentation
├── setup/              # Environment setup guides
├── python/             # Python-specific guides
└── ARCHITECTURE.md     # System architecture overview
```

### Essential Reading
- [CLAUDE.md](CLAUDE.md) - Entry point for Claude Code sessions
- [Architecture Overview](docs/ARCHITECTURE.md) - How components fit together
- [Development Principles](docs/development/principles.md) - Best practices for AI-assisted development

### Getting Started Guides
- [Environment Setup](docs/development/environment-setup.md) - Configure your environment
- [Git Worktree Workflow](docs/workflows/git-worktree.md) - Work on multiple features
- [Task Management](docs/workflows/task-management.md) - Organize complex work

## Common Commands

```bash
# AI Assistants
claude                                 # Start Claude session
gemini                                 # Start Gemini session

# Git Worktrees
agent-worktree add feat/new-feature    # Create feature branch workspace
agent-worktree remove feat/old-feature # Clean up after merge

# System Monitoring  
agent-monitor                          # Live system dashboard
agent-monitor --interval 10            # Update every 10 seconds

# Python Development (when applicable)
uv sync                                # Install dependencies
uv run pytest                          # Run tests
uv run ruff check .                    # Lint code
```

## Configuration

### Environment Variables
Create a `.env` file (already gitignored):
```bash
# Optional telemetry
HONEYCOMB_API_KEY=your-key
HONEYCOMB_DATASET=claude-code

# Optional API keys
GEMINI_API_KEY=your-key
TAVILY_API_KEY=your-key
```

### Telemetry (Optional)
- OpenTelemetry collector forwards to Honeycomb
- Disabled by default - just omit the environment variables
- See [Telemetry Configuration](docs/setup/telemetry-configuration.md)

## Contributing

This is a template repository. To contribute:
1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Submit a pull request

For major changes, please open an issue first to discuss what you would like to change.

## License

[MIT License](LICENSE) - Feel free to use this template for your own projects!