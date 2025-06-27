# Google Gemini CLI

## Overview

The Google Gemini CLI is an interactive terminal-based AI assistant that provides multimodal AI capabilities for development workflows.

## Installation

### Automatic (via devcontainer)
The CLI is installed automatically if your project includes the setup script.

### Manual Installation
```bash
# Global installation
npm install -g @google/gemini-cli

# One-time usage
npx @google/gemini-cli
```

**Requirements**: Node.js 18+

## Authentication

### OAuth (Default - Free)
- No setup required
- Uses personal Google account
- Limits: 60 requests/minute, 1,000/day

### API Key (Optional)
1. Get key from [Google AI Studio](https://aistudio.google.com/app/apikey)
2. Add to `.env`: `GEMINI_API_KEY=your-key`
3. Update config to use `auth_method = "api_key"`

## Usage Modes

### TUI Mode (Interactive)
```bash
gemini
```

Features:
- Slash commands for operations
- Multimodal input support
- Conversation context
- Customizable themes

Common commands:
- `/help` - Show commands
- `/clear` - Clear history
- `/model` - Switch models
- `/exit` - Exit session

### CLI Mode (Scripting)
```bash
# Direct prompt
gemini --prompt "Explain this code" --file main.py

# Batch processing
gemini --input questions.txt --output answers.md

# Model selection
gemini --model gemini-pro --prompt "Generate tests"
```

## Key Features

### Development Tasks
- **Code Analysis**: Architecture review, security audit
- **Documentation**: Generate docs from code
- **Testing**: Create comprehensive test suites
- **Debugging**: Analyze errors and suggest fixes
- **Refactoring**: Improve code quality

### Multimodal Capabilities
- Process images (screenshots, diagrams)
- Analyze PDFs and documents
- Generate visualizations
- Convert between formats

## Best Practices

### Effective Prompting
```bash
# Specific and contextual
gemini --prompt "Find security vulnerabilities" --file auth.py

# Multi-step tasks
gemini --prompt "1. Analyze schema 2. Suggest optimizations 3. Generate migration" --file db.sql
```

### Integration Examples
```bash
# Code review
git diff > changes.diff
gemini --prompt "Review these changes" --file changes.diff

# Test generation
gemini --prompt "Create pytest tests" --file calculator.py --output test_calculator.py

# Documentation
gemini --prompt "Generate API docs" --file api.py --output API.md
```

## Model Selection

- `gemini-2.5-pro` - Latest, most capable
- `gemini-pro` - Complex reasoning
- `gemini-pro-vision` - Multimodal tasks
- `gemini-flash` - Fast responses

## Telemetry (Optional)

### Automatic Setup
If Honeycomb is configured for Claude Code, Gemini automatically uses the same instance.

### Manual Setup
```bash
# Local telemetry (Jaeger UI)
gemini --telemetry --telemetry-target local

# Custom endpoint
gemini --telemetry --telemetry-otlp-endpoint "https://your-endpoint"
```

### Privacy
- Disabled by default
- Optional prompt logging
- Local-only option available

## Configuration

### Config File Location
- Project: `.gemini/config`
- Global: `~/.gemini/config`

### Example Config
```ini
# Authentication
auth_method = "oauth"  # or "api_key"
# api_key = "your-key"  # if using API key

# Model
model = "gemini-pro"

# Telemetry (optional)
telemetry = false
telemetry_target = "local"
telemetry_log_prompts = true
```

## Common Workflows

### Security Review
```bash
gemini --prompt "Identify security vulnerabilities and suggest fixes" --file src/
```

### API Documentation
```bash
gemini --prompt "Generate OpenAPI spec from FastAPI code" --file app.py --output openapi.yaml
```

### Test Coverage
```bash
gemini --prompt "Identify untested code paths and generate tests" --file module.py
```

### Code Explanation
```bash
gemini --prompt "Explain this algorithm for a junior developer" --file complex_algo.py
```

## Troubleshooting

### Rate Limiting
- Use API key for higher limits
- Add delays in automation scripts
- Monitor usage in AI Studio

### Authentication Issues
```bash
# Check API key
echo $GEMINI_API_KEY

# Test connection
gemini --prompt "Hello" --no-interactive
```

### Installation Problems
```bash
# Check Node version (needs 18+)
node --version

# Reinstall
npm uninstall -g @google/gemini-cli
npm install -g @google/gemini-cli
```