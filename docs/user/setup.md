# Agent Environment Setup Guide

This guide explains how to set up the agent development environment using VS Code Dev Containers.

## Understanding the Workspace Structure

This devcontainer is designed to mount your entire workspace directory structure into the container. The key concept:

- The devcontainer mounts `../..` (two levels up from `.devcontainer`) as `/workspaces` in the container
- This means the container expects a specific directory structure

### Expected Directory Layout

```
your-workspaces-directory/        # This becomes /workspaces in container
├── .envrc                        # Honeycomb credentials (shared across projects)
├── .claude/                      # Claude settings (shared across projects)
│   └── settings.json
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
- Shared configuration files (.envrc, .claude/)

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

# Copy and configure the environment file
cp agent-environment/.envrc.example .envrc
# Edit .envrc and replace the placeholder values with your actual Honeycomb credentials

# Copy Claude settings (if you don't have .claude directory already)
mkdir -p .claude
cp agent-environment/.claude/settings.json.example .claude/settings.json
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
- Configuration files are at `/workspaces/.envrc` and `/workspaces/.claude/`


## Verifying the Setup

Once in the container, verify everything is working:

```bash
# Check current directory
pwd  # Should show /workspaces/agent-environment

# List workspace contents
ls /workspaces  # Should show all your workspace directories

# Verify tools
which rg jq tree direnv gh npm node claude uv

# Check environment variables
env | grep -E "(OTEL|CLAUDE|HONEYCOMB)"
```

## Troubleshooting

- **"Folder not found" errors**: Ensure you're following the expected directory structure
- **Missing environment variables**: Check that .envrc and .claude/settings.json exist in the workspace root
- **Can't access other projects**: Verify they're in the same parent directory as agent-environment