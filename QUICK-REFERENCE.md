# Quick Reference Guide

## Essential Commands Cheat Sheet

### Initialization
```bash
git clone <url>                 # Clone repository
git init                        # Initialize new repo
git config user.name "Name"     # Set user name
git config user.email "email"   # Set user email
```

### Branching
```bash
git branch                      # List branches
git branch -a                   # List all branches
git checkout -b feature/name    # Create & switch branch
git checkout develop            # Switch branch
git push -u origin feature/name # Push new branch
git branch -d feature/name      # Delete local branch
git push origin --delete feature/name # Delete remote
```

### Commits
```bash
git status                      # Check status
git add .                       # Stage all changes
git commit -m "message"         # Commit changes
git commit --amend              # Modify last commit
git log --oneline               # View history
```

### Merging
```bash
git merge --no-ff branch        # Merge with commit
git rebase develop              # Rebase branch
git merge --squash branch       # Squash commits
git merge --abort               # Cancel merge
```

### Updates
```bash
git fetch origin                # Get updates
git pull origin develop         # Pull changes
git push origin develop         # Push changes
```

---

## Decision Matrix

| Need to do... | Command | Branch Type |
|---------------|---------|------------|
| Add feature | `git checkout -b feature/name` | Feature |
| Fix bug | `git checkout -b bugfix/name` | Feature |
| Emergency fix | `git checkout -b hotfix/name` | Hotfix (from main) |
| Prepare release | `git checkout -b release/1.0` | Release (from develop) |
| Merge to develop | `git merge --no-ff feature/name` | Feature → Develop |
| Merge to main | Tag & create release | Release → Main |

---

## Git Flow Steps

### Feature
```bash
git checkout develop
git pull origin develop
git checkout -b feature/my-feature
# Make commits...
git push -u origin feature/my-feature
# Create PR, get approval
git checkout develop
git merge --no-ff feature/my-feature
git push origin develop
git branch -d feature/my-feature
git push origin --delete feature/my-feature
```

### Release
```bash
git checkout -b release/1.2.0
# Update version, changelog
git commit -am "Bump version"
git checkout main
git merge --no-ff release/1.2.0
git tag -a v1.2.0 -m "Release"
git push origin main --tags
git checkout develop
git merge --no-ff release/1.2.0
git push origin develop
git branch -d release/1.2.0
git push origin --delete release/1.2.0
```

### Hotfix
```bash
git checkout main
git checkout -b hotfix/critical-bug
# Make fix...
git commit -m "fix: ..."
git checkout main
git merge --no-ff hotfix/critical-bug
git tag -a v1.2.1 -m "Hotfix"
git push origin main --tags
git checkout develop
git merge --no-ff hotfix/critical-bug
git push origin develop
git branch -d hotfix/critical-bug
git push origin --delete hotfix/critical-bug
```

---

## Commit Message Format

```
<type>(<scope>): <subject>

<body>

Fixes #123
```

Types: `feat`, `fix`, `docs`, `style`, `refactor`, `perf`, `test`, `chore`

Examples:
```
feat(auth): add user login
fix(api): resolve timeout
docs(readme): update instructions
```

---

## Common Issues & Fixes

| Issue | Fix |
|-------|-----|
| Merge conflict | Edit files, `git add .`, `git commit` |
| Wrong branch | `git checkout correct-branch` |
| Undo last commit | `git reset --soft HEAD~1` |
| Undo with files | `git reset --hard HEAD~1` |
| Missing commits | `git pull origin branch` |
| Need to rebase | `git rebase develop` then `git push -f` |

---

## Branch Protection Rules

### For Main Branch
- ✓ Require PR reviews (2+)
- ✓ Require status checks pass
- ✓ No force pushes
- ✓ Require up to date

### For Develop Branch  
- ✓ Require PR reviews (1+)
- ✓ Require status checks pass
- ✓ No force pushes
- ✓ Require up to date

---

## Helpful Aliases

```bash
git config --global alias.co checkout
git config --global alias.br branch
git config --global alias.ci commit
git config --global alias.st status
git config --global alias.visual 'log --oneline --graph --all'
```

---

## Need More Help?

| Topic | Document |
|-------|----------|
| Git Basics | [01-git-fundamentals.md](docs/01-git-fundamentals.md) |
| Choose Strategy | [02-branching-strategy.md](docs/02-branching-strategy.md) |
| Step-by-Step Workflow | [03-branching-workflow.md](docs/03-branching-workflow.md) |
| Merge vs Rebase | [04-merging-rebase.md](docs/04-merging-rebase.md) |
| Commit Best Practices | [05-commits.md](docs/05-commits.md) |
| Main Branch | [06-main-branch.md](docs/06-main-branch.md) |
| Develop Branch | [07-develop-branch.md](docs/07-develop-branch.md) |
| Release Process | [08-release-branch.md](docs/08-release-branch.md) |
| Hotfix Process | [09-hotfix-branch.md](docs/09-hotfix-branch.md) |
| Real Example | [10-hands-on-example.md](docs/10-hands-on-example.md) |
| Version Tagging | [11-version-tagging.md](docs/11-version-tagging.md) |
| All Commands | [examples/branch-commands.sh](examples/branch-commands.sh) |
| Commit Examples | [examples/commit-examples.md](examples/commit-examples.md) |
| Visual Diagrams | [diagrams/](diagrams/) folder |

---

**Tip**: Keep this reference handy! Print it or bookmark it. 📌
