# 7. Develop Branch

## What is the Develop Branch?

The `develop` branch is the integration branch used in Git Flow. It contains code for the next release - all completed features ready for testing but not yet in production.

---

## Develop Branch Purpose

```
FEATURE BRANCHES          DEVELOP BRANCH         MAIN BRANCH
(isolated work)          (integration)          (production)

feature/auth    ──┐                               
feature/pay     ──├──→  develop  ──→  release/  ──→  main (v1.2.0)
feature/ui      ──┤         ↑          v1.2.0        (stable)
                  │         │                        (tagged)
hotfix/bug ─────┘          └── ← ← ←
                           (sync after release)
```

---

## Develop Branch Rules

### Protection Rules (Similar to Main, but Less Strict)

```
Rules for 'develop':
├── Require pull request reviews before merging
│   └── Minimum 1 approving review (vs 2 for main)
├── Require status checks to pass
│   ├── Tests must pass
│   ├── Build must succeed
│   └── No security issues
├── Require branches to be up to date
├── Require conversation resolution
├── Include administrators in restrictions
└── Allow force pushes: NO
```

---

## Working with Develop Branch

### Setting Up Develop

```bash
# Create develop branch from main (if not exists)
git checkout main
git checkout -b develop
git push -u origin develop

# If develop already exists
git fetch origin
git checkout develop
git pull origin develop
```

### Keeping Develop Up to Date

```bash
# Before starting new feature
git checkout develop
git pull origin develop

# Get latest changes from remote
git fetch origin

# See what's different
git log --oneline main..develop  # Commits in develop not in main
git log --oneline develop..main  # Commits in main not in develop
```

---

## Merging Features to Develop

### Feature Merge Workflow

```bash
# 1. Ensure develop is current
git checkout develop
git pull origin develop

# 2. Create feature from develop
git checkout -b feature/user-notifications

# 3. Develop with multiple commits
git commit -m "feat(notif): add notification system"
git commit -m "feat(notif): add email notifications"
git commit -m "test(notif): add notification tests"

# 4. Push feature
git push -u origin feature/user-notifications

# 5. Create Pull Request on GitHub
#    Base: develop
#    Compare: feature/user-notifications

# 6. After review and approval
git checkout develop
git pull origin develop
git merge --no-ff feature/user-notifications -m "Merge feature/user-notifications"
git push origin develop

# 7. Delete feature branch
git branch -d feature/user-notifications
git push origin --delete feature/user-notifications
```

### Best Practices for Develop

✓ Always pull before starting new work
✓ Create feature branches FROM develop
✓ Merge features TO develop with `--no-ff`
✓ Never force push to develop
✓ Keep CI/CD tests passing
✓ Delete feature branches after merging

---

## Develop Branch Policies

### What Should Be in Develop

✓ **Completed features**
✓ **Code-reviewed features**
✓ **Features that pass all tests**
✓ **Well-documented code**
✓ **Ready for staging deployment**

### What Should NOT Be in Develop

✗ **Incomplete features**
✗ **Unreviewed code**
✗ **Code with failing tests**
✗ **Experimental/risky code**
✗ **Debug statements**
✗ **Dead code**

---

## Creating Release from Develop

### Release Branch Process

```bash
# When ready to release
git checkout develop
git pull origin develop

# Create release branch
git checkout -b release/1.2.0

# On release branch: only bug fixes and version updates
echo "1.2.0" > VERSION
git commit -am "Bump version to 1.2.0"

# Fix critical bugs
git commit -m "fix(release): critical production bug"

# Merge to main
git checkout main
git pull origin main
git merge --no-ff release/1.2.0 -m "Release version 1.2.0"
git tag -a v1.2.0 -m "Release version 1.2.0"
git push origin main --tags

# Merge back to develop
git checkout develop
git pull origin develop
git merge --no-ff release/1.2.0 -m "Merge release 1.2.0 back to develop"
git push origin develop

# Delete release branch
git branch -d release/1.2.0
git push origin --delete release/1.2.0
```

### Why Merge Back to Develop?

```
Without merging back:

develop:  ●─●─●─●─●  (v1.1.0)
           ↓
release/1.2.0: ●─●  (bug fixes)
                ↓
main: ●───────────●  (v1.2.0)

Problem: Develop is missing bug fixes from release!

With merging back:

develop:  ●─●─●─●─●───●─●  (now has bug fixes)
           ↓          ↑
release/1.2.0: ●─●───┘  (merged back)
                ↓
main: ●───────────●  (v1.2.0)

Solution: Develop and main stay in sync!
```

---

## Hotfixes and Develop

### Hotfix Integration

```bash
# Hotfix created from main
git checkout main
git checkout -b hotfix/security-patch

# Fix issue
git commit -m "fix: close security vulnerability"

# Merge to main
git checkout main
git merge --no-ff hotfix/security-patch
git tag -a v1.2.1 -m "Hotfix 1.2.1"
git push origin main --tags

# Merge to develop (important!)
git checkout develop
git merge --no-ff hotfix/security-patch -m "Merge hotfix to develop"
git push origin develop

# Delete hotfix
git branch -d hotfix/security-patch
git push origin --delete hotfix/security-patch
```

### Why Hotfixes Must Merge to Develop

```
Without merging hotfix to develop:

main:      ●─────●  (v1.2.1 with fix)
           ↑     ↑
           │     └─ hotfix applied here
           │
develop:   ●─●─●  (MISSING the fix!)

Problem: Next release will lose the hotfix!

With hotfix merging back:

main:      ●─────●  (v1.2.1 with fix)
           ↑     ↑
           │     hotfix applied here
           │     │
develop:   ●─●─●─●  (HAS the fix now)

Solution: Fix is in both branches!
```

---

## Managing Multiple Features

### Parallel Development

```
Develop branch is stable and shared

multiple developers can work simultaneously:

feature/auth ──┐
feature/api ───┼──→ develop (integration point)
feature/ui ────┤
feature/docs ──┘

Each feature:
- Created from develop
- Developed independently
- Merged back when complete
- Does not affect other features
```

### Handling Feature Dependencies

```
If Feature B depends on Feature A:

Option 1: Linear approach
├─ Merge Feature A to develop
├─ Create Feature B from updated develop
└─ Feature B automatically has Feature A

Option 2: Branch from feature
├─ Create Feature B from feature/A
├─ Merge Feature A to develop
├─ Rebase Feature B onto develop
└─ Merge Feature B to develop

Option 3: Coordinate timing
├─ Both features develop independently
├─ Plan merges so A merges first
├─ B can pull updates before merging
└─ Use git rebase if needed
```

---

## Develop Branch Monitoring

### Health Checks

```bash
# Check develop branch status
git checkout develop
git pull origin develop

# See commits not in main
git log --oneline main..develop

# Check if any branches are stale
git branch -a -v

# Check for merged branches that need cleaning
git branch --merged develop | grep -v develop

# View develop branch protection status
# (On GitHub: Settings → Branches → Branch protection rules)
```

### Metrics to Track

```
├── Build Status
│   ├── Tests passing on develop
│   ├── Code coverage percentage
│   └── Build time
├── Activity
│   ├── Commits per week
│   ├── Active features in progress
│   └── Time between commits
├── Code Health
│   ├── Technical debt
│   ├── Code duplication
│   └── Security issues
└── Release Readiness
    ├── Days since main
    ├── Features ready to release
    └── Known issues
```

---

## Develop vs Main Comparison

| Aspect | Main | Develop |
|--------|------|---------|
| **Purpose** | Production code | Next release prep |
| **Stability** | Very High | High |
| **Update Frequency** | Per release | Weekly |
| **Deploy to** | Production | Staging/Testing |
| **Testing Level** | Extensive | Good |
| **Who merges** | Release manager | Team leads |
| **Revert if broken** | Yes | Usually |
| **Force push** | Never | Never |
| **Branch protection** | Strictest | Strict |

---

## Next Steps
→ Continue to [08-release-branch.md](08-release-branch.md) to learn about release management.
