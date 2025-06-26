# Agent Environment Setup Guide

This guide explains how to set up the agent development environment using VS Code Dev Containers.

## Understanding the Workspace Structure

This devcontainer is designed to mount your entire workspace directory structure into the container. The key concept:

- The devcontainer mounts `../..` (two levels up from `.devcontainer`) as `/workspaces` in the container
- This means the container expects a specific directory structure

### Expected Directory Layout

```
your-workspaces-directory/        # This becomes /workspaces in container
├── .envrc                        # (Optional) Environment variables for direnv
├── agent-environment/            # This repository
│   ├── .devcontainer/
│   │   ├── devcontainer.json
│   │   ├── docker-compose.yml
│   │   └── Dockerfile
│   └── ... (other project files)
└── other-project/                # Any other projects you want accessible
    └── ...
```

## Prerequisites

- Docker installed and running
- VS Code with the "Dev Containers" extension installed
- Git

## Setup Instructions

### 1. Choose Your Workspace Directory

First, decide where you want your development workspace. This should be a directory that will contain:
- The agent-environment repository
- Any other repositories you want to access from within the container
- Shared configuration files

```bash
# Example: Create a dedicated workspace directory
mkdir -p ~/workspaces
cd ~/workspaces
```

### 2. Clone the Repository

Clone agent-environment into your workspace directory:

```bash
git clone <repository-url> agent-environment
```

### 3. Create Shared Configuration

Set up the required configuration files in your workspace root:

```bash
# From your workspace directory (e.g., ~/workspaces)

# Configure Honeycomb credentials for OpenTelemetry collector
cd agent-environment/.devcontainer
cp .env.example .env
# Edit .env and replace the placeholder values with your actual Honeycomb credentials
# Note: .env file is gitignored and used by docker-compose for the OTEL collector

# Note: The container will mount your host's OAuth tokens:
# - ~/.claude → /home/codespace/.claude (Claude CLI tokens)
# - ~/.gemini → /home/codespace/.gemini (Gemini CLI tokens)
# - ~/.config/gh → /home/codespace/.config/gh (GitHub CLI auth)
```

### 4. Open in Dev Container

```bash
cd agent-environment
code .
```

When VS Code opens:
- It will detect the `.devcontainer` configuration
- Click "Reopen in Container" when prompted
- Or use Command Palette (Ctrl/Cmd+Shift+P) → "Dev Containers: Reopen in Container"

## What Gets Mounted Where

Once the container starts:
- Your entire workspace directory (e.g., `~/workspaces`) is mounted as `/workspaces`
- The agent-environment project is at `/workspaces/agent-environment`
- Any sibling directories are at `/workspaces/<directory-name>`
- Honeycomb credentials are in `/workspaces/agent-environment/.devcontainer/.env`
- Claude telemetry is configured via environment variables in docker-compose.yml


## Verifying the Setup

Once in the container, verify everything is working:

```bash
# Check current directory
pwd  # Should show /workspaces/agent-environment

# List workspace contents
ls /workspaces  # Should show all your workspace directories

# Verify tools
which rg jq tree direnv gh npm node claude uv

# Check telemetry environment variables
env | grep -E "(OTEL|CLAUDE)"

# Verify OTEL collector is running
docker ps | grep otlp

# Check mounted OAuth directories
ls -la ~/.claude ~/.gemini ~/.config/gh

# Test agent tools
agent-worktree --help
agent-monitor --help
```

## Troubleshooting

- **"Folder not found" errors**: Ensure you're following the expected directory structure
- **Missing environment variables**: Check docker-compose.yml environment section
- **No telemetry in Honeycomb**: Ensure .env file exists in .devcontainer/ with your Honeycomb credentials
- **Can't access other projects**: Verify they're in the same parent directory as agent-environment