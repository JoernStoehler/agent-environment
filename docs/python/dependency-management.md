# Dependency Management Notes

## Python Projects with uv

### Modular Dependencies
Projects can organize dependencies into groups for flexibility:

```toml
[project]
dependencies = [
    # Core dependencies only
    "pandas",
    "numpy",
    "pydantic",
]

[project.optional-dependencies]
dev = [
    "pytest",
    "ruff",
    "pyright",
]
animations = [
    "manim",  # Requires system deps: libcairo2-dev, libpango1.0-dev, ffmpeg
]
ai = [
    "openai",
    "anthropic",
    "langchain",
]
```

### Installation Patterns
```bash
# Core only
uv sync

# Development
uv sync --extra dev

# Specific features
uv sync --extra animations
uv sync --extra ai

# Multiple groups
uv sync --extra dev --extra animations
```

### CI Optimization
- Use minimal deps for CI: `uv sync --extra ci`
- Reduces build time significantly
- Only include test/lint tools

### System Dependencies
Some Python packages need system libraries:

```bash
# For manim (animations)
sudo apt-get install -y libcairo2-dev libpango1.0-dev ffmpeg

# For machine learning
sudo apt-get install -y libopenblas-dev

# For image processing
sudo apt-get install -y libjpeg-dev libpng-dev
```

## JavaScript/TypeScript Projects

### Package Management
```bash
# Install all deps
npm install

# Production only
npm install --production

# Dev dependencies
npm install --save-dev eslint

# Global tools
npm install -g typescript
```

### Workspace Management
For monorepos:
```json
{
  "workspaces": [
    "packages/*",
    "apps/*"
  ]
}
```

## Best Practices

1. **Lock Files**: Always commit lock files (uv.lock, package-lock.json)
2. **Version Pinning**: Pin major versions for stability
3. **Audit Regularly**: Check for vulnerabilities
4. **Document System Deps**: Note any required system packages
5. **Group Logically**: Organize optional deps by feature/purpose