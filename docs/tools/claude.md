# Claude Code CLI Documentation

## Overview
Claude Code is Anthropic's official CLI for Claude, providing an interactive command-line interface for AI-assisted software engineering. It's installed globally in the devcontainer with persistent storage and telemetry configured.

## Installation
Claude Code is automatically installed when the devcontainer is built via:
```bash
npm install -g @anthropic-ai/claude-code
```

## Configuration

### Configuration Directory
- **Location**: `~/.claude` (Docker named volume)
- **Purpose**: Stores API keys, settings, and session data across container rebuilds
- **Note**: The `~/.claude` directory is mounted as a Docker volume for persistence
- **Config file**: `~/.claude/.claude.json` stores user preferences and project history

### Settings Files
Claude Code uses multiple configuration files:
- `~/.claude/settings.json` - User-specific settings
- `.claude/settings.local.json` - Project-specific settings (in project root)

### Environment Variables
The following environment variables are configured in the devcontainer:
- `CLAUDE_CODE_ENABLE_TELEMETRY=1` - Enables telemetry
- `OTEL_SERVICE_NAME=claude-code` - Service name for telemetry
- `OTEL_METRICS_EXPORTER=otlp` - Metrics exporter
- `OTEL_LOGS_EXPORTER=otlp` - Logs exporter
- `OTEL_EXPORTER_OTLP_PROTOCOL=http/protobuf` - OTLP protocol
- `OTEL_EXPORTER_OTLP_ENDPOINT=http://otlp:4318` - OTLP endpoint

## Getting Started

### First Time Setup
1. Start the devcontainer
2. Run `claude` from any directory
3. Set your API key when prompted (or use environment variable)

### API Key Configuration
Set your API key using one of these methods:

1. **Interactive Setup**:
   ```bash
   claude
   # Follow prompts to enter API key
   ```

2. **Environment Variable**:
   ```bash
   export ANTHROPIC_API_KEY="your-api-key"
   ```

3. **Configuration File**:
   Edit `~/.claude/settings.json`:
   ```json
   {
     "apiKey": "your-api-key"
   }
   ```

## Common Commands

### Basic Usage
```bash
# Start Claude Code
claude

# Get help
claude --help

# Show version
claude --version

# Use a specific model
claude --model claude-3-opus-20240229
```

### Session Management
```bash
# Resume last session
claude --resume

# Start with extended thinking
claude --thinking

# Enable verbose output
claude --verbose
```

### File Operations
```bash
# Start with specific files
claude file1.py file2.js

# Start in a directory
cd /path/to/project
claude
```

## Telemetry
Telemetry is automatically configured to send data to the local OTLP collector:
- **Endpoint**: `http://otlp:4318`
- **Service Name**: `claude-code`
- **Data**: Traces, metrics, and logs

To disable telemetry:
1. Set environment variable: `CLAUDE_CODE_ENABLE_TELEMETRY=0`
2. Or in settings.json:
   ```json
   {
     "telemetry": {
       "enabled": false
     }
   }
   ```

## MCP Servers
Claude Code supports Model Context Protocol (MCP) servers for extending functionality. Configure them in:
- `~/.claude/mcp.json` - Global MCP configuration
- `.claude/mcp.json` - Project-specific MCP configuration

Example MCP configuration:
```json
{
  "servers": {
    "filesystem": {
      "command": "npx",
      "args": ["@anthropic/mcp-server-filesystem", "/path/to/allowed/directory"]
    }
  }
}
```

## Interactive Mode Features

### Keyboard Shortcuts
- `Ctrl+C` - Cancel current generation
- `Ctrl+D` - Exit Claude Code
- `Ctrl+L` - Clear screen
- `Tab` - Autocomplete file paths

### Slash Commands
- `/help` - Show available commands
- `/clear` - Clear conversation history
- `/exit` - Exit Claude Code
- `/model` - Switch model
- `/settings` - View/edit settings

## Persistence
All Claude Code data persists in the `claude-config` Docker volume at `~/.claude/`:
- API keys
- User settings (in `.claude.json`)
- Conversation history
- MCP server configurations

This ensures your configuration is maintained across container rebuilds. The volume is mounted automatically when the devcontainer starts.

## Troubleshooting

### API Key Issues
If Claude Code can't find your API key:
1. Check if it's set: `echo $ANTHROPIC_API_KEY`
2. Verify settings file: `cat ~/.claude/settings.json`
3. Re-run setup: `claude config set`

### Telemetry Connection Issues
If telemetry isn't working:
1. Check OTLP collector status: `docker compose ps otlp`
2. Verify endpoint connectivity: `curl http://otlp:4318`
3. Check environment variables: `env | grep OTEL`

### Permission Issues
If you encounter permission errors:
```bash
# Fix permissions on config directory
sudo chown -R codespace:codespace ~/.claude
chmod 700 ~/.claude
# Verify volume is mounted
df -h ~/.claude
```

## Additional Resources
- [Official Documentation](https://docs.anthropic.com/en/docs/claude-code)
- [GitHub Repository](https://github.com/anthropics/claude-code)
- [MCP Documentation](https://modelcontextprotocol.io/)
- [Anthropic API Documentation](https://docs.anthropic.com/)