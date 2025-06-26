#!/usr/bin/env bash
# Bash completion for agent-worktree
#
# To enable:
#   source /path/to/agent-worktree-completion.bash
# Or add to your .bashrc:
#   source /path/to/agent-worktree-completion.bash

_agent_worktree() {
    local cur prev opts
    COMPREPLY=()
    cur="${COMP_WORDS[COMP_CWORD]}"
    prev="${COMP_WORDS[COMP_CWORD-1]}"
    
    # Top-level options and commands
    local commands="add remove"
    local options="--dry-run --bash --claude --gemini -h --help"
    
    # Check if we're completing a command or option
    case "${prev}" in
        agent-worktree)
            # First argument - show commands and options
            COMPREPLY=( $(compgen -W "${commands} ${options}" -- ${cur}) )
            return 0
            ;;
        add)
            # After 'add' command - suggest branch names based on existing branches
            # but filter out current branch and branches that already have worktrees
            if command -v git &> /dev/null && git rev-parse --git-dir &> /dev/null; then
                local current_branch=$(git rev-parse --abbrev-ref HEAD 2>/dev/null)
                local worktree_branches=$(git worktree list --porcelain | grep "^branch" | cut -d' ' -f2 | sed 's|refs/heads/||')
                local all_branches=$(git branch -a | sed 's/^[* ]*//' | sed 's|remotes/origin/||' | grep -v "HEAD" | sort -u)
                
                # Filter out current branch and branches with existing worktrees
                local available_branches=""
                for branch in $all_branches; do
                    if [[ "$branch" != "$current_branch" ]] && ! echo "$worktree_branches" | grep -q "^$branch$"; then
                        available_branches="$available_branches $branch"
                    fi
                done
                
                COMPREPLY=( $(compgen -W "${available_branches}" -- ${cur}) )
            fi
            return 0
            ;;
        remove)
            # After 'remove' command - suggest branches that have worktrees
            if command -v git &> /dev/null && git rev-parse --git-dir &> /dev/null; then
                local worktree_branches=$(git worktree list --porcelain | grep "^branch" | cut -d' ' -f2 | sed 's|refs/heads/||' | grep -v "^$")
                COMPREPLY=( $(compgen -W "${worktree_branches}" -- ${cur}) )
            fi
            return 0
            ;;
        --dry-run|--bash|--claude|--gemini)
            # After flags, suggest commands if not already present
            local has_command=false
            for word in "${COMP_WORDS[@]}"; do
                if [[ "$word" == "add" || "$word" == "remove" ]]; then
                    has_command=true
                    break
                fi
            done
            
            if [[ "$has_command" == "false" ]]; then
                COMPREPLY=( $(compgen -W "${commands}" -- ${cur}) )
            fi
            return 0
            ;;
        *)
            # Check if we have a command already
            local has_command=""
            for word in "${COMP_WORDS[@]}"; do
                if [[ "$word" == "add" || "$word" == "remove" ]]; then
                    has_command="$word"
                    break
                fi
            done
            
            if [[ -n "$has_command" ]]; then
                # We have a command, check if we need to complete branch name
                local branch_arg_index=$((COMP_CWORD))
                for i in $(seq 1 $((COMP_CWORD-1))); do
                    if [[ "${COMP_WORDS[$i]}" == "$has_command" ]]; then
                        branch_arg_index=$((i+1))
                        break
                    fi
                done
                
                if [[ $COMP_CWORD -eq $branch_arg_index ]]; then
                    # Complete branch name
                    case "$has_command" in
                        add)
                            # Suggest branches for add
                            if command -v git &> /dev/null && git rev-parse --git-dir &> /dev/null; then
                                local current_branch=$(git rev-parse --abbrev-ref HEAD 2>/dev/null)
                                local worktree_branches=$(git worktree list --porcelain | grep "^branch" | cut -d' ' -f2 | sed 's|refs/heads/||')
                                local all_branches=$(git branch -a | sed 's/^[* ]*//' | sed 's|remotes/origin/||' | grep -v "HEAD" | sort -u)
                                
                                local available_branches=""
                                for branch in $all_branches; do
                                    if [[ "$branch" != "$current_branch" ]] && ! echo "$worktree_branches" | grep -q "^$branch$"; then
                                        available_branches="$available_branches $branch"
                                    fi
                                done
                                
                                COMPREPLY=( $(compgen -W "${available_branches}" -- ${cur}) )
                            fi
                            ;;
                        remove)
                            # Suggest branches for remove
                            if command -v git &> /dev/null && git rev-parse --git-dir &> /dev/null; then
                                local worktree_branches=$(git worktree list --porcelain | grep "^branch" | cut -d' ' -f2 | sed 's|refs/heads/||' | grep -v "^$")
                                COMPREPLY=( $(compgen -W "${worktree_branches}" -- ${cur}) )
                            fi
                            ;;
                    esac
                fi
            else
                # No command yet, suggest commands and unused options
                local used_options=""
                for word in "${COMP_WORDS[@]:1}"; do
                    if [[ "$word" == -* ]]; then
                        used_options="$used_options $word"
                    fi
                done
                
                local available_options=""
                for opt in $options; do
                    if ! echo "$used_options" | grep -q "$opt"; then
                        available_options="$available_options $opt"
                    fi
                done
                
                COMPREPLY=( $(compgen -W "${commands} ${available_options}" -- ${cur}) )
            fi
            return 0
            ;;
    esac
}

complete -F _agent_worktree agent-worktree