# agent-monitor

A real-time monitoring dashboard for system resources and agent activity.

## What it does

`agent-monitor` provides a live terminal dashboard that displays:
- System resource usage (CPU, memory, disk)
- Git repository status and recent commits
- Running AI agent processes (Claude, Gemini, etc.)
- Recent file changes in the workspace
- Docker container status

## When to use it

Use `agent-monitor` when you need to:
- Track system resource usage during development
- Monitor multiple AI agents running in parallel
- Keep an eye on git repository changes
- Debug performance issues
- Get a quick overview of your development environment

## Requirements

- Python 3.12 or higher
- Git repository (for repository status features)
- Docker (optional, for container monitoring)

## Basic usage

```bash
# Start the monitor with default 5-second refresh
agent-monitor

# Update every 2 seconds
agent-monitor --interval 2

# Update every 10 seconds for lower CPU usage
agent-monitor --interval 10
```

## Dashboard sections

### System Resources
- **CPU**: Current usage percentage and load averages
- **Memory**: Used/available RAM and swap
- **Disk**: Filesystem usage for the workspace

### Git Status
- Current branch and commit
- Number of modified/staged/untracked files
- Recent commits with authors and timestamps

### Running Agents
- Active AI agent processes (claude, gemini, etc.)
- Process ID, working directory, and runtime
- Memory usage per agent

### Recent File Changes
- Last 10 modified files in the workspace
- Modification timestamps
- File paths relative to workspace root

### Docker Containers (if Docker is running)
- Container names and status
- CPU and memory usage per container
- Uptime information

## Keyboard controls

- `q` or `Ctrl+C`: Quit the monitor
- The dashboard updates automatically at the specified interval

## Implementation details

The tool is implemented as a Python script using:
- `psutil` for system and process monitoring
- `rich` for the terminal UI
- `gitpython` for repository information
- `uv run --script` for dependency management

## Examples

### Basic monitoring
```bash
# Monitor your development environment
cd /workspaces/my-project
agent-monitor
```

### Low-frequency updates for long sessions
```bash
# Update every 30 seconds to minimize CPU usage
agent-monitor --interval 30
```

### Quick system check
```bash
# Run for a quick look (then press 'q' to quit)
agent-monitor --interval 1
```

## Troubleshooting

### "No git repository found"
The monitor must be run from within a git repository to show repository status.

### High CPU usage
Increase the update interval with `--interval` to reduce CPU usage.

### Permission errors
Some system information may require elevated permissions. The monitor will gracefully handle what it can access.

## Related tools

- `htop` - General process monitor
- `docker stats` - Docker-specific monitoring
- `git status` - Detailed git information
- [agent-worktree](agent-worktree.md) - Manage git worktrees