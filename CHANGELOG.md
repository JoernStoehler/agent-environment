# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

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