# Template Synchronization Notes

## Key Concepts

### Separate Git Histories
- Template repos have **completely separate** histories
- Cannot use git merge, cherry-pick, or rebase
- Must copy files between repositories

### Workflow Pattern

1. **One-time clone**
   ```bash
   cd /workspaces
   git clone https://github.com/user/template-repo.git
   ```

2. **Pull updates from template**
   ```bash
   cd /workspaces/template-repo
   git pull origin main
   
   # Copy files to your project
   cp -r docs/workflows /workspaces/my-project/docs/
   ```

3. **Contribute back to template**
   ```bash
   cd /workspaces/template-repo
   git worktree add /workspaces/feat-improvement -b feat/improvement
   cd /workspaces/feat-improvement
   
   # Copy and generalize files
   cp /workspaces/my-project/.devcontainer/scripts/*.sh .devcontainer/scripts/
   # Edit to remove project-specific content
   
   git add -A
   git commit -m "feat: add improved scripts"
   git push -u origin feat/improvement
   gh pr create
   ```

## Generalization Guidelines

When contributing to template:

| Project-Specific | Template Version |
|-----------------|------------------|
| `my-project-name` | `your-project-name` |
| Specific API keys | `YOUR_API_KEY_HERE` |
| Business logic | Generic examples |
| Internal URLs | `https://example.com` |

## Common Pitfalls

### Wrong Approach
```bash
# DON'T: Try to merge between repos
git remote add template https://github.com/template.git
git merge template/main  # FAILS!
```

### Right Approach
```bash
# DO: Copy files
cp /workspaces/template/improved-file.md /workspaces/my-project/
```

## Quick Reference

```bash
# Setup (once)
cd /workspaces && git clone $TEMPLATE_URL

# Pull from template
cd /workspaces/template && git pull
cp files... /workspaces/my-project/

# Push to template
cd /workspaces/template
git worktree add /workspaces/feat-name -b feat/name
# ... copy and edit files ...
gh pr create
```