# 3. Branching Workflow Examples

## Git Flow Workflow in Detail

### Understanding Git Flow Structure

```
┌─────────────────────────────────────────────────────────┐
│                   GIT FLOW STRUCTURE                    │
├─────────────────────────────────────────────────────────┤
│                                                         │
│  MAIN BRANCH:    ●─────────●─────────● (releases)      │
│                  │ v1.0    │ v1.1    │ v2.0            │
│                  │         │         │                 │
│  DEVELOP:        ●─●─●─●─●─●─●─●─●(integration)       │
│                  │ │ │ │ │ │ │ │ │                  │
│  FEATURES:       └─┘ └─┘ └─┘  ...  (parallel work)    │
│                                                         │
└─────────────────────────────────────────────────────────┘
```

### Step 1: Starting a Feature

```bash
# Ensure develop is up to date
git checkout develop
git pull origin develop

# Create feature branch from develop
git checkout -b feature/user-authentication

# Start making changes
echo "new code" > auth.js
git add auth.js
git commit -m "Add user authentication module"
```

### Step 2: Working on Feature

```bash
# Make multiple commits as you develop
git commit -m "Add login validation"
git commit -m "Add password hashing"
git commit -m "Add session management"

# Push to remote
git push -u origin feature/user-authentication

# Keep feature updated with develop changes
git fetch origin develop
git rebase origin/develop  # or git merge origin/develop
```

### Step 3: Creating Pull Request

```bash
# Push all commits
git push origin feature/user-authentication

# On GitHub:
# 1. Create Pull Request from feature/user-authentication → develop
# 2. Add description and link issues
# 3. Request review
# 4. Wait for approval and CI checks
```

### Step 4: Merging Feature

```bash
# After approval, merge to develop
# Option 1: Merge Commit (recommended for Git Flow)
git checkout develop
git pull origin develop
git merge --no-ff feature/user-authentication -m "Merge feature/user-authentication into develop"
git push origin develop

# Option 2: Squash and Merge (clean history)
git checkout develop
git merge --squash feature/user-authentication
git commit -m "Add user authentication module"
git push origin develop

# Delete feature branch
git branch -d feature/user-authentication
git push origin --delete feature/user-authentication
```

---

## Release Branch Workflow

### Preparing for Release

```bash
# Create release branch from develop
git checkout develop
git pull origin develop
git checkout -b release/1.0.0

# Update version numbers
# Update CHANGELOG
# Make only bug fixes and release-specific commits

git commit -am "Bump version to 1.0.0"
git commit -am "Update CHANGELOG for release 1.0.0"
```

### Releasing to Production

```bash
# Merge release branch to main with tag
git checkout main
git pull origin main
git merge --no-ff release/1.0.0 -m "Release version 1.0.0"
git tag -a v1.0.0 -m "Release version 1.0.0"
git push origin main
git push origin v1.0.0

# Merge back to develop (to keep them in sync)
git checkout develop
git pull origin develop
git merge --no-ff release/1.0.0 -m "Merge release back to develop"
git push origin develop

# Delete release branch
git branch -d release/1.0.0
git push origin --delete release/1.0.0
```

---

## Hotfix Branch Workflow

### Critical Production Bug

```bash
# Create hotfix from main (production)
git checkout main
git pull origin main
git checkout -b hotfix/critical-security-fix

# Make critical fix
echo "security fix" > security.js
git add security.js
git commit -m "Fix critical security vulnerability"

# Tag and push to main
git checkout main
git merge --no-ff hotfix/critical-security-fix -m "Hotfix: critical-security-fix"
git tag -a v1.0.1 -m "Hotfix version 1.0.1"
git push origin main
git push origin v1.0.1

# Also merge to develop to keep in sync
git checkout develop
git pull origin develop
git merge --no-ff hotfix/critical-security-fix -m "Merge hotfix to develop"
git push origin develop

# Delete hotfix branch
git branch -d hotfix/critical-security-fix
git push origin --delete hotfix/critical-security-fix
```

---

## GitHub Flow Workflow in Detail

### Simple Feature Development

```bash
# 1. Create feature branch from main
git checkout main
git pull origin main
git checkout -b feature/add-dark-mode

# 2. Make changes
echo "dark mode styles" > dark-theme.css
git add dark-theme.css
git commit -m "Add dark mode styles"

# 3. Push to remote
git push -u origin feature/add-dark-mode

# 4. Create Pull Request on GitHub
# (PR is created with base: main, compare: feature/add-dark-mode)

# 5. After approval, merge on GitHub via web interface

# 6. Delete local branch
git checkout main
git pull origin main
git branch -d feature/add-dark-mode
```

### Syncing with Main During Development

```bash
# While feature is in progress, main might get new commits
git fetch origin main

# Option 1: Rebase (linear history)
git rebase origin/main
git push -f origin feature/add-dark-mode

# Option 2: Merge (merge commit)
git merge origin/main
git push origin feature/add-dark-mode
```

---

## Branch Deletion Best Practices

```bash
# Delete local branch
git branch -d <branch-name>          # Safe (refuses if not merged)
git branch -D <branch-name>          # Force delete

# Delete remote branch
git push origin --delete <branch-name>
git push origin -d <branch-name>     # Shorter syntax

# Delete multiple branches
git branch -d feature/auth feature/payment feature/profile

# Clean up local branches that track deleted remotes
git remote prune origin
git fetch -p  # Shorter syntax
```

---

## Common Workflow Patterns

### Pattern 1: Feature from Develop → Develop
**Best for:** Git Flow strategy
```
develop → feature/name → Pull Request → develop
```

### Pattern 2: Feature from Main → Main
**Best for:** GitHub Flow strategy
```
main → feature/name → Pull Request → main
```

### Pattern 3: Bug Fix in Release
**Best for:** Git Flow with active releases
```
develop → release/version → bugfix in release → release → main
```

### Pattern 4: Hotfix in Production
**Best for:** Urgent fixes needed immediately
```
main → hotfix/name → main (and develop)
```

---

## Next Steps
→ Continue to [04-merging-rebase.md](04-merging-rebase.md) to understand Merge vs Rebase.
