# Bash Completion Snippets

This file contains useful bash completion patterns extracted from the seminar project. These snippets can be adapted for your own tools.

## Basic Command Completion

```bash
# Simple command completion with subcommands
_my_tool_complete() {
    local cur prev opts
    COMPREPLY=()
    cur="${COMP_WORDS[COMP_CWORD]}"
    prev="${COMP_WORDS[COMP_CWORD-1]}"
    
    # Main commands
    if [ $COMP_CWORD -eq 1 ]; then
        opts="create remove status list help"
        COMPREPLY=( $(compgen -W "${opts}" -- ${cur}) )
        return 0
    fi
}

complete -F _my_tool_complete my-tool
```

## Subcommand-Specific Completion

```bash
# Different completions based on subcommand
case "${COMP_WORDS[1]}" in
    create)
        if [ $COMP_CWORD -eq 2 ]; then
            # Suggest common prefixes
            opts="feat/ fix/ docs/ refactor/ test/ chore/"
            COMPREPLY=( $(compgen -W "${opts}" -- ${cur}) )
        fi
        ;;
    remove)
        if [ $COMP_CWORD -eq 2 ]; then
            # Complete with actual items
            local items=$(ls /some/directory 2>/dev/null)
            COMPREPLY=( $(compgen -W "${items}" -- ${cur}) )
        fi
        ;;
esac
```

## Git Integration Example

```bash
# Complete with git branches
if command -v git &> /dev/null; then
    # Get branches from worktrees
    local branches=$(git worktree list --porcelain 2>/dev/null | grep "^branch" | cut -d' ' -f2 | sed 's|refs/heads/||')
    COMPREPLY=( $(compgen -W "${branches}" -- ${cur}) )
fi
```

## Directory Completion

```bash
# Complete with directories, filtering some patterns
local dirs=$(ls -d /workspaces/*/ 2>/dev/null | xargs -n1 basename | grep -v "^feat-" | grep -v "^fix-")
COMPREPLY=( $(compgen -W "${dirs}" -- ${cur}) )
```

## Adding to PATH and Installing Completion

```bash
#!/bin/bash
# In a setup script

# Add tools to PATH
cat >> ~/.bashrc << 'EOF'
# Add custom tools to PATH
export PATH="${WORKSPACE_PATH}/tools:$PATH"

# Source completion function here or add the function directly
_my_tool_complete() {
    # ... completion logic ...
}

complete -F _my_tool_complete my-tool
EOF
```

## Advanced Pattern: Multi-Level Completion

```bash
_advanced_complete() {
    local cur prev opts
    COMPREPLY=()
    cur="${COMP_WORDS[COMP_CWORD]}"
    prev="${COMP_WORDS[COMP_CWORD-1]}"
    
    # Level 1: Main command
    if [ $COMP_CWORD -eq 1 ]; then
        opts="project task config"
        COMPREPLY=( $(compgen -W "${opts}" -- ${cur}) )
        return 0
    fi
    
    # Level 2: Subcommands
    if [ $COMP_CWORD -eq 2 ]; then
        case "${COMP_WORDS[1]}" in
            project)
                opts="create delete list"
                ;;
            task)
                opts="add complete list"
                ;;
            config)
                opts="get set list"
                ;;
        esac
        COMPREPLY=( $(compgen -W "${opts}" -- ${cur}) )
        return 0
    fi
    
    # Level 3: Context-specific
    if [ $COMP_CWORD -eq 3 ]; then
        case "${COMP_WORDS[1]}" in
            config)
                case "${COMP_WORDS[2]}" in
                    get|set)
                        # Complete with config keys
                        opts="user.name user.email core.editor"
                        COMPREPLY=( $(compgen -W "${opts}" -- ${cur}) )
                        ;;
                esac
                ;;
        esac
    fi
}
```

## File Type Completion

```bash
# Complete only with specific file types
_complete_python_files() {
    local cur="${COMP_WORDS[COMP_CWORD]}"
    # Use compgen with glob pattern
    COMPREPLY=( $(compgen -f -X '!*.py' -- "$cur") )
}
```

## Dynamic Option Discovery

```bash
# Discover options from help output
_dynamic_options() {
    local opts
    # Extract options from help (example)
    opts=$(my-command --help 2>/dev/null | grep -oE '^\s*--[a-z-]+' | tr -d ' ')
    COMPREPLY=( $(compgen -W "${opts}" -- ${cur}) )
}
```

## Installation in Devcontainer

To add bash completion to your devcontainer:

1. Create a setup script in `.devcontainer/postCreateCommand/`
2. Add the completion function to `~/.bashrc`
3. Use `complete -F function_name command_name`

Example script: `11-setup-tool-completion.sh`
```bash
#!/bin/bash
set -e

echo "Setting up bash completion for custom tools..."

cat >> ~/.bashrc << 'EOF'
# Tool completion functions
_my_tool_complete() {
    # ... your completion logic ...
}

complete -F _my_tool_complete my-tool
EOF

echo "✓ Bash completion configured"
```

## Best Practices

1. **Check command availability**: Use `command -v cmd &> /dev/null` before using external commands
2. **Handle errors silently**: Use `2>/dev/null` to suppress errors in completion
3. **Keep it fast**: Completion should be instant, avoid slow operations
4. **Test thoroughly**: Test with partial inputs, special characters, and edge cases
5. **Document options**: Help users discover features through completion