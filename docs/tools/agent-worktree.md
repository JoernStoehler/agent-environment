# agent-worktree

A Git worktree management tool that streamlines multi-branch development workflows.

## What it does

`agent-worktree` simplifies working with multiple git branches simultaneously by automating the creation and management of [git worktrees](https://git-scm.com/docs/git-worktree). It handles the common pain points of worktree management: branch creation, environment setup, and workspace initialization.

## When to use it

Use `agent-worktree` when you need to:
- Work on multiple features or fixes simultaneously
- Switch between branches without losing uncommitted work
- Test changes in isolation without affecting your main workspace
- Quickly spin up a clean environment for code review or testing

## Requirements

- Git repository with worktree support
- Bash shell
- Write access to the parent directory of your repository

## Basic usage

```bash
# Create a new worktree for a feature branch
agent-worktree add feat/new-feature

# Create a worktree and immediately start Claude in it
agent-worktree --claude add fix/bug-123

# Remove a worktree when done
agent-worktree remove feat/new-feature
```

## Key features

- **Automatic branch creation**: Creates local branches from current HEAD if they don't exist
- **Environment preservation**: Copies `.env`, `.envrc`, and other config files to new worktrees
- **Setup automation**: Runs `setup.sh` if present in the new worktree
- **Tool integration**: Direct integration with development tools (claude, gemini)
- **Safety checks**: Validates repository state and prevents data loss
- **Bash completion**: Context-aware tab completion for commands and branches

## Worktree locations

Worktrees are created as sibling directories to your main repository:
```
parent-directory/
├── your-repo/          (main worktree)
├── your-repo-feature/  (feature branch worktree)
└── your-repo-bugfix/   (bugfix branch worktree)
```

## Environment setup

The tool automatically copies these files to new worktrees:
- `.env` - Environment variables
- `.envrc` - direnv configuration
- `.env.local` - Local environment overrides
- `*.pem` - Certificate files
- `*.key` - Key files

## Bash completion

Enable tab completion by adding to your `.bashrc`:
```bash
source /path/to/agent-worktree
```

The devcontainer environment sets this up automatically via `.devcontainer/postCreateCommand/30-setup-bash-completions.sh`.

## Implementation details

For implementation details, constraints, and internal logic, see the script itself at `tools/agent-worktree`.

## Related tools

- `agent-monitor` - System monitoring dashboard for development
- Standard `git worktree` command - Lower-level worktree management

## Keywords

git, worktree, branch, workspace, development, environment, claude, gemini, bash, completion