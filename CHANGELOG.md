# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

### Added
- Additional VS Code extensions for enhanced development experience:
  - google.geminicodeassist - Gemini AI code assistant
  - github.vscode-github-actions - GitHub Actions workflow support
  - tamasfe.even-better-toml - TOML language support
  - ms-azuretools.vscode-containers - Container management
  - tomoki1207.pdf - PDF viewer
  - charliermarsh.ruff - Python linter and formatter

## [0.1.0] - 2024-01-XX

### Added
- Initial devcontainer setup based on mcr.microsoft.com/devcontainers/universal:2
- Docker Compose configuration with OTLP collector for telemetry
- Extended Dockerfile with additional tools:
  - ripgrep (rg)
  - jq
  - tree
  - direnv
  - GitHub CLI (gh)
  - Claude Code CLI (@anthropic-ai/claude-code)
  - uv (Python package manager)
- Example configuration files:
  - `.envrc.example` for Honeycomb credentials
  - `.claude/settings.json.example` for Claude Code telemetry settings
- Comprehensive setup documentation in `docs/user/setup.md`
- VS Code extensions auto-installed:
  - ms-python.python
  - ms-python.vscode-pylance
  - redhat.vscode-yaml
  - ms-azuretools.vscode-docker
  - ms-vscode.makefile-tools
  - ms-vscode-remote.remote-containers

### Features
- Mounts parent directory as `/workspaces` for multi-project access
- Automatic direnv integration for bash and zsh
- OTLP collector configured with debug output (ready for Honeycomb integration)
- Environment variables configured for Claude Code telemetry