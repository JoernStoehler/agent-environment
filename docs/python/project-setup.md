# Python Project Setup Notes

## Project Structure Template

```
project/
├── src/
│   └── package_name/
│       ├── __init__.py
│       ├── __main__.py      # For `python -m package_name`
│       ├── cli.py           # Click-based CLI
│       ├── core/
│       ├── models/
│       └── utils/
├── tests/
│   ├── conftest.py
│   ├── test_core/
│   └── test_integration/
├── scripts/
│   └── utility-name/
│       ├── script.py
│       └── README.md
├── docs/
├── .devcontainer/
├── .github/
│   └── workflows/
│       └── ci.yml
├── pyproject.toml
├── uv.lock
├── Makefile
├── README.md
├── CHANGELOG.md
├── CLAUDE.md
└── .gitignore
```

## Essential pyproject.toml

```toml
[project]
name = "package-name"
version = "0.1.0"
description = "Brief description"
readme = "README.md"
requires-python = ">=3.11"
dependencies = [
    "pydantic>=2.0",
    "httpx",
    "click",
]

[project.optional-dependencies]
dev = [
    "pytest>=7.0",
    "pytest-cov",
    "pytest-xdist",
    "ruff",
    "pyright",
    "pre-commit",
]

[project.scripts]
package-name = "package_name.cli:main"

[build-system]
requires = ["hatchling"]
build-backend = "hatchling.build"

[tool.ruff]
# Minimal rules for bug prevention
select = ["E", "F", "I"]
ignore = ["E501"]  # Line length handled by formatter

[tool.pyright]
pythonVersion = "3.11"
typeCheckingMode = "standard"
```

## Standard Makefile

```makefile
.PHONY: install dev test lint type check clean

install:
	uv sync

dev:
	uv sync --extra dev

test:
	uv run pytest

lint:
	uv run ruff check .

type:
	uv run pyright .

check: lint type test

clean:
	find . -type d -name __pycache__ -rm -rf
	find . -type f -name "*.pyc" -delete
	rm -rf .pytest_cache .ruff_cache .coverage htmlcov
```

## GitHub Actions CI

```yaml
name: CI

on:
  push:
    branches: [main]
  pull_request:

jobs:
  test:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      
      - name: Install uv
        uses: astral-sh/setup-uv@v3
        with:
          enable-cache: true
      
      - name: Set up Python
        uses: actions/setup-python@v5
        with:
          python-version: "3.11"
      
      - name: Install dependencies
        run: uv sync --extra dev
      
      - name: Run linting
        run: uv run ruff check .
      
      - name: Run type checking
        run: uv run pyright .
      
      - name: Run tests
        run: uv run pytest --cov --cov-fail-under=80
```

## Common Patterns

### Click CLI Setup
```python
# src/package_name/cli.py
import click

@click.group()
def cli():
    """Package description."""
    pass

@cli.command()
@click.option("--verbose", "-v", is_flag=True)
def process(verbose):
    """Process data."""
    if verbose:
        click.echo("Processing...")

if __name__ == "__main__":
    cli()
```

### Pydantic Models
```python
# src/package_name/models.py
from pydantic import BaseModel, Field
from typing import Optional
from datetime import datetime

class Config(BaseModel):
    """Application configuration."""
    api_key: str = Field(..., description="API key")
    timeout: int = Field(30, description="Timeout in seconds")
    retry_count: int = Field(3, ge=0, le=10)
    
    class Config:
        env_prefix = "APP_"  # Read from APP_API_KEY, etc.
```

### Testing Structure
```python
# tests/conftest.py
import pytest
from pathlib import Path

@pytest.fixture
def sample_data():
    """Load sample data for tests."""
    return {"key": "value"}

@pytest.fixture
def temp_dir(tmp_path):
    """Create temporary directory."""
    return tmp_path
```