# Gemini CLI Documentation

## Overview
Gemini CLI is Google's open-source AI agent that brings the power of Gemini directly into your terminal. It's installed globally in the devcontainer and configured for persistent storage and telemetry.

## Installation
Gemini CLI is automatically installed when the devcontainer is built via:
```bash
npm install -g @google/gemini-cli
```

## Configuration

### Configuration Directory
- **Location**: `~/.gemini` (Docker named volume)
- **Purpose**: Ensures OAuth tokens and settings persist across container rebuilds
- **Note**: The `~/.gemini` directory is mounted as a Docker volume for persistence

### Settings File
Configuration is stored in `~/.gemini/settings.json`:
```json
{
  "telemetry": {
    "enabled": true,
    "target": "otlp",
    "otlpEndpoint": "http://otlp:4318",
    "serviceName": "gemini-cli"
  }
}
```

### Environment Variables
Gemini CLI doesn't support a custom config directory environment variable. OTLP telemetry variables are inherited from the container environment.

## Getting Started

### First Time Setup
1. Start the devcontainer
2. Run `gemini` from any directory
3. Sign in with your personal Google account when prompted
4. You'll receive a free Gemini Code Assist license with:
   - Access to Gemini 2.5 Pro
   - 1 million token context window
   - 60 model requests per minute
   - 1,000 requests per day

### Using an API Key (Optional)
If you need higher request capacity:
1. Generate a key from [Google AI Studio](https://makersuite.google.com/app/apikey)
2. Set the environment variable:
   ```bash
   export GOOGLE_API_KEY="your-api-key"
   ```

## Common Commands

### Basic Usage
```bash
# Start Gemini CLI
gemini

# Get help
gemini --help

# Use a specific model
gemini --model gemini-1.5-pro-latest

# Enable debug mode
gemini --debug
```

### Project Commands
```bash
# Start in a specific project
cd /path/to/project
gemini

# Enable sandbox mode (isolates tool execution)
gemini --sandbox
```

## Telemetry
Telemetry is automatically configured to send data to the local OTLP collector:
- **Endpoint**: `http://otlp:4318`
- **Service Name**: `gemini-cli`
- **Data**: Traces, metrics, and logs (without prompts by default)

To disable telemetry, edit `~/.gemini/settings.json`:
```json
{
  "telemetry": {
    "enabled": false
  }
}
```

## MCP Servers
Gemini CLI supports Model Context Protocol (MCP) servers for extending functionality. Configure them in your project's `.gemini/mcp.json` file.

## Persistence
All Gemini CLI data persists in the `gemini-config` Docker volume at `~/.gemini/`:
- OAuth tokens
- User settings
- Shell history (per project)
- Temporary files

This ensures you only need to authenticate once and your preferences are maintained across container rebuilds.

## Troubleshooting

### OAuth Token Issues
If you're having authentication issues:
1. Check if `~/.gemini/` exists and has proper permissions
2. Try removing the directory and re-authenticating:
   ```bash
   rm -rf ~/.gemini
   gemini
   ```

### Configuration Not Loading
Ensure the volume is mounted:
```bash
df -h ~/.gemini
# Should show it's mounted as a Docker volume
```

If not mounted, check the docker-compose.yml configuration.

## Additional Resources
- [Official GitHub Repository](https://github.com/google-gemini/gemini-cli)
- [Google's Announcement Blog](https://blog.google/technology/developers/introducing-gemini-cli-open-source-ai-agent/)
- [Gemini API Documentation](https://ai.google.dev/)