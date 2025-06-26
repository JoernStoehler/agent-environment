# Roadmap (Owner written)

This doc is written by the owner of the project.
It outlines future features that are needed.

## Worktree Simplification
- we will work with "git worktree add ../feat-add-gpu -b feat/add-gpu" to create a new branch "feat/add-gpu" in a new worktree "/workspaces/feat-add-gpu" (or wherever the workspaces root is located in the HOST or CONTAINER)
- to automatically also run setup scripts, copy untracked but important files like .envrc etc., we will use a script
  `agent-environment/tools/agent-worktree` (bash) with syntax
    `agent-worktree add feat/add-gpu`
    `agent-worktree remove feat/add-gpu`
- the script will also handle `git worktree remove`
- the script validates and errors early with descriptive messages, e.g. to avoid deleting uncommitted changes, or replacing folders, or permission issues, or running "git worktree add" from a repo that has remote commits that haven't been pulled yet. Essentually it first checks if the state of the local, remote, and environment is sane and as expected and demands fixing before it proceeds.

## Agent Monitor
- we need a custom command `agent-monitor` that uses `ps` and reads `/proc` etc to figure out which coding agents are active on the machine
- it should display a nicely formatted table
  - with all active repos (formatted as "owner/repo")
  - with all their active worktrees (formatted as "branch") since branch names and worktree names are similar (e.g. main -> <repo>, feat/add-gpu -> feat-add-gpu)
  - with how long ago the last file change was made, the last commit was made, and if any uncommitted changes exist, if any PR exists, and the PR's check status
  - with all the agents working inside them (cwd inside the worktree)
    - PID, which agent (claude, gemini), started how long ago, memory usage in GB
- the tool is autorefresh if given a "--watch" flag, every second is enough
- your choice what programming language to use, e.g. python with PEP 723 header and #!/usr/bin/env uv run --script or what it's called

## OTLP
- "claude code" needs to be given envvars (via .claude/settings.json ? via /workspaces/.envrc ? unsure what works, will need to test!)
- "gemini cli" similarly.
- they should send to a local OTLP endpoint that is spun up via docker-compose
- the OTLP endpoint then sends to eu1.honeycomb.io (see existing implementation) with the right API keys (unsure where to get them from! /workspaces/.envrc ? inherit from host?)

## Persistent OAuth
- on the host, claude-code and gemini-cli store their OAuth tokens in 
  - ~/.claude/
  - ~/.gemini/
- I think it is easiest to mount said directories into the container. Pushback? In that case we should not set the CLAUDE_CONFIG_DIR envvar at all, since the default location is sufficient.
- I would like the "gh auth login" to also persist rebuilds, and maybe inherit from host, but unsure how

## CLAUDE.md and docs/agent/
- we have a production ready repository with refined and highly optimized prompts for coding agents; tell me once you are ready to write the CLAUDE.md file and the docs/agent files that we developed for higher effectiveness of claude code and gemini cli in all our projects
- in particular, /workspaces/agent-environment/docs/agent will document the environment setup (i.e. this repository) so that coding agents can understand the environment they work in, and how to modify it, and why certain decisions were made.
- besides that, also general information that is not specific to the environment, nor to this repo, are available in docs/agent, e.g. python coding style, test driven development workflows, etc.
