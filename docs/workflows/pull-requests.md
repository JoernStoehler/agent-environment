# Pull Request Workflows

## Overview

Creating effective pull requests ensures smooth code review and integration.

## Git Configuration

### Commit Standards
Use conventional commits format:
```
type(scope): subject

[optional body]

[optional footer]
```

Types:
- `feat`: New feature
- `fix`: Bug fix
- `docs`: Documentation only
- `style`: Code style (formatting, etc)
- `refactor`: Code restructure
- `test`: Test additions/corrections
- `chore`: Maintenance tasks

Examples:
```bash
git commit -m "feat: add user authentication"
git commit -m "fix(parser): handle empty input gracefully"
git commit -m "docs: update API documentation"
```

## Creating Pull Requests

### 1. Prepare Changes

```bash
# Review what you're about to commit
git status
git diff

# Stage specific files (avoid git add -A)
git add src/feature.py tests/test_feature.py

# Verify staged changes
git status
git diff --staged

# Commit with meaningful message
git commit -m "feat(auth): implement OAuth2 flow"
```

### 2. Push to Remote

```bash
# First push
git push -u origin branch-name

# Subsequent pushes
git push
```

### 3. Create PR with GitHub CLI

```bash
# Basic PR
gh pr create --title "feat: add OAuth2 authentication" \
  --body "## Summary
- Implemented OAuth2 flow
- Added token refresh logic
- Updated user model

## Testing
- All tests pass
- Manual testing completed"

# Detailed PR
gh pr create --title "fix: resolve memory leak in data processor" \
  --body "## Summary
Fixes memory leak that occurred when processing large datasets.

## Changes
- Added proper cleanup in process_data()
- Implemented context manager for resources
- Fixed circular reference in cache

## Testing
- Memory usage stays constant during 1hr test
- All existing tests pass
- Added specific test for memory leak

## Performance Impact
- 15% reduction in memory usage
- No impact on processing speed"
```

### 4. Monitor CI Status

```bash
# Check PR status
gh pr checks

# Watch in real-time
gh pr checks --watch

# View failed logs
gh run view --log-failed
```

## PR Best Practices

### Title Guidelines
- Use conventional commit format
- Be specific and concise
- Include ticket number if applicable

✅ Good:
- `feat(auth): add GitHub OAuth provider`
- `fix(api): handle rate limit errors`
- `refactor: extract validation logic`

❌ Bad:
- `Update code`
- `Fixed bug`
- `Changes`

### Description Template

```markdown
## Summary
[Brief description of what this PR does]

## Motivation
[Why this change is needed]

## Changes
- [Specific change 1]
- [Specific change 2]
- [Technical details if relevant]

## Testing
- [ ] Unit tests added/updated
- [ ] Integration tests pass
- [ ] Manual testing completed
- [ ] Performance impact assessed

## Screenshots
[If applicable]

## Breaking Changes
[List any breaking changes or "None"]
```

### Careful File Staging

Always review before staging:
```bash
# See all changes
git status

# Review file contents
git diff path/to/file

# Stage only what's needed
git add file1 file2

# Avoid blind staging
# DON'T: git add -A
# DON'T: git add .
```

Common files to avoid committing:
- Temporary scripts
- Debug logs
- Personal config files
- Test outputs
- Experimental code

## Handling CI Failures

### Linting Issues
```bash
# Python
uv run ruff check . --fix

# JavaScript
npm run lint:fix
```

### Type Checking
```bash
# Python
uv run pyright .

# TypeScript
npm run type-check
```

### Test Failures
```bash
# Run specific test
uv run pytest tests/test_failing.py -xvs

# Debug with prints
uv run pytest -s
```

### Pre-commit Hooks
```bash
# Install hooks
pre-commit install

# Run manually
pre-commit run --all-files

# If files are modified by hooks
git add -A
git commit --amend --no-edit
```

## Code Review Process

### Before Requesting Review

1. **Self-review**
   ```bash
   # View your PR in browser
   gh pr view --web
   ```

2. **Ensure CI passes**
   ```bash
   gh pr checks
   ```

3. **Update documentation**
   - Inline comments
   - README updates
   - API docs

4. **Add to CHANGELOG**
   ```markdown
   ## [Unreleased]
   ### Added
   - New feature description
   ```

### Requesting Review

```bash
# After CI passes
gh pr comment --body "@username This PR is ready for review.

## Key Changes
- Implemented X feature
- Refactored Y module
- Fixed Z bug

## Review Focus
Please pay attention to:
- Error handling in src/module.py
- Performance of new algorithm
- API compatibility"
```

## Common Issues and Solutions

### Merge Conflicts
```bash
# Update from main
git fetch origin
git merge origin/main

# Resolve conflicts in editor
# Then:
git add resolved-files
git commit
git push
```

### Large PRs
Split into smaller PRs:
1. Infrastructure/setup
2. Core functionality
3. Tests and docs

### Commit History
```bash
# Clean up commits before PR
git rebase -i main

# Or squash during merge
gh pr merge --squash
```

## PR Checklist

Before creating PR:
- [ ] Tests pass locally
- [ ] Linting passes
- [ ] Type checking passes
- [ ] Documentation updated
- [ ] CHANGELOG updated
- [ ] Self-review completed

After creating PR:
- [ ] CI passes
- [ ] Description is clear
- [ ] Added reviewers
- [ ] Responded to feedback

## Quick Commands Reference

```bash
# Create PR
gh pr create

# Check status
gh pr checks

# View PR
gh pr view --web

# List your PRs
gh pr list --author @me

# Merge PR
gh pr merge
```