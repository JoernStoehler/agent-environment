# Python Documentation

This directory contains Python-specific documentation for projects using Python as their primary language.

## Contents

### Core Documentation
- **[code-style.md](code-style.md)** - Python coding standards, type hints, and best practices
- **[testing.md](testing.md)** - Comprehensive pytest guide with examples and patterns
- **[project-setup.md](project-setup.md)** - Python project structure and initialization
- **[dependency-management.md](dependency-management.md)** - Managing dependencies with uv

### Templates
- **[pyproject-template.toml](pyproject-template.toml)** - Template for Python project configuration

## When to Use These Docs

Use this documentation when:
- Starting a new Python project
- Setting up Python tooling (pytest, ruff, pyright)
- Implementing Python-specific patterns
- Managing Python dependencies

## Quick Reference

### Project Setup
```bash
# Create new Python project
mkdir my-project && cd my-project
git init

# Initialize with uv
uv init

# Add dependencies
uv add pandas numpy
uv add --dev pytest ruff pyright
```

### Running Tools
```bash
# Run tests
uv run pytest

# Check code style
uv run ruff check .
uv run pyright .

# Format code
uv run ruff format .
```

### Common Patterns
- Use type hints for all function signatures
- Prefer Pydantic for data validation
- Use pytest for all testing needs
- Follow PEP 8 with ruff for consistency

## Related Documentation
- General development principles: @docs/development/principles.md
- Environment setup: @docs/development/environment-setup.md
- General testing concepts: @docs/development/testing.md