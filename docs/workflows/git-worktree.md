# Git Worktree Development Workflow

## Overview

Git worktrees enable parallel development by creating isolated copies of the repository with different branches. This allows working on multiple features simultaneously without switching branches.

## Quick Start

### Create a Feature Branch
```bash
agent-worktree add feat/user-auth
cd /workspaces/feat-user-auth
```

### Remove After PR Merge
```bash
agent-worktree remove feat/user-auth
```

## The agent-worktree Tool

A comprehensive bash script that automates worktree setup and management.

### What It Does
- Creates worktree in parent directory of main repository
- Validates repository state before operations
- Copies important untracked files (.env, .envrc) to new worktrees
- Runs setup scripts automatically if present
- Optionally starts a new shell or development tool (--bash, --claude, --gemini)

### Commands

#### Create (add)
```bash
agent-worktree add feat/awesome-feature           # Create worktree
agent-worktree --bash add feat/awesome-feature   # Create and start bash shell
agent-worktree --claude add feat/awesome-feature # Create and start claude
agent-worktree --gemini add feat/awesome-feature # Create and start gemini
```

#### Remove
```bash
agent-worktree remove feat/awesome-feature
```
Safely removes worktree after checking for uncommitted changes.

#### Options
- `--dry-run` - Preview what would happen without making changes
- `--bash` - Start a new bash shell in the worktree after creation
- `--claude` - Start 'claude --dangerously-skip-permissions' in the worktree
- `--gemini` - Start 'gemini --yolo' in the worktree

## When to Use Worktrees

### Use Worktrees For
- New features
- Bug fixes
- Experiments
- Any substantial changes
- Working on multiple tasks

### Work on Main For
- Documentation updates
- Small configuration changes
- Typo fixes
- README updates

## Directory Structure

```
/workspaces/
├── your-project/          # Main repository (main branch)
├── feat-authentication/   # Feature worktree
├── fix-parser-bug/       # Bugfix worktree
└── docs-api-update/      # Documentation worktree
```

## Common Workflows

### Starting a New Feature
```bash
# 1. Create worktree and start claude directly
agent-worktree --claude add feat/shopping-cart

# 2. Work on feature...

# 3. Create PR when ready
gh pr create

# 4. After merge, clean up
agent-worktree remove feat/shopping-cart
```

### Parallel Development
```bash
# Terminal 1: Work on authentication
agent-worktree --claude add feat/auth

# Terminal 2: Fix a bug
agent-worktree --gemini add fix/validation

# Terminal 3: Check your worktrees
git worktree list
```

### Quick Bug Fix
```bash
# Create worktree and start working
agent-worktree --bash add fix/null-pointer

# ... fix the bug ...
git add -A && git commit -m "fix: handle null case"
git push -u origin fix/null-pointer
gh pr create

# Clean up
agent-worktree remove fix/null-pointer
```

## Manual Worktree Commands

If you prefer manual control:

```bash
# Create worktree
git worktree add /workspaces/feat-name -b feat/name

# List worktrees
git worktree list

# Remove worktree
git worktree remove /workspaces/feat-name

# Prune stale references
git worktree prune
```

## Best Practices

### Branch Naming
- `feat/` - New features
- `fix/` - Bug fixes
- `docs/` - Documentation
- `refactor/` - Code refactoring
- `test/` - Test improvements

### Workspace Management
- One worktree per feature/fix
- Clean up after PR merge
- Keep main branch clean
- Use descriptive branch names

### VS Code Integration
After removing a worktree:
1. VS Code shows yellow (missing) folders
2. Right-click each yellow folder
3. Select "Remove Folder from Workspace"

## Troubleshooting

### Permission Denied
```bash
# Should be fixed by setup scripts, but if needed:
sudo chown -R $(whoami) /workspaces
```

### Branch Already Exists
```bash
# For local branch
git worktree add /workspaces/feat-name feat/name

# For remote branch
git worktree add /workspaces/feat-name origin/feat/name
```

### Uncommitted Changes
```bash
# Check what's changed
cd /workspaces/feat-name
git status

# Either commit or stash
git add -A && git commit -m "wip: save work"
# OR
git stash
```

### Can't Remove Worktree
```bash
# Force removal (loses uncommitted changes!)
git worktree remove --force /workspaces/feat-name
```

## Implementation Details

The `agent-worktree` tool:
- Validates git repository state before operations
- Checks for uncommitted changes to prevent data loss
- Automatically copies untracked config files (.env, .envrc)
- Runs setup.sh if present in the repository
- Converts forward slashes in branch names to hyphens for directory names
- Ensures local branch is in sync with remote
- Provides bash completion support

Source: @tools/agent-worktree