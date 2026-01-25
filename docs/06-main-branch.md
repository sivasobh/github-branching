# 6. Main Branch (Production)

## What is the Main Branch?

The `main` branch (formerly `master`) is your production branch. It contains code that is actively running in production or is ready to be deployed immediately.

---

## Main Branch Rules

### Protection Rules

The main branch must be protected with rules:

```
Rules for 'main':
├── Require pull request reviews before merging
│   └── Minimum 1 approving review
├── Require status checks to pass before merging
│   ├── Automated tests must pass
│   ├── Code style checks must pass
│   └── Build must succeed
├── Require branches to be up to date before merging
├── Require code reviews from code owners
├── Require conversations to be resolved
├── Require signed commits
├── Include administrators in restrictions
└── Restrict who can push to matching branches
```

### Setting Up Branch Protection on GitHub

1. Go to repository Settings
2. Click "Branches" in sidebar
3. Under "Branch protection rules" click "Add rule"
4. Set pattern to: `main`
5. Enable desired protection rules
6. Click "Create"

---

## Main Branch Stability

### What Should Be in Main

✓ **Production-ready code**
✓ **Fully tested features**
✓ **All tests passing**
✓ **Code reviewed and approved**
✓ **Complete documentation**
✓ **Release versions (tagged)**

### What Should NOT Be in Main

✗ **Work in progress**
✗ **Experimental features**
✗ **Broken code**
✗ **Untested features**
✗ **Commented-out code**
✗ **Debug statements**

---

## Main Branch Deployment

### Deployment Flow

```
Commit to main
       ↓
Automated tests run
       ↓
If tests pass:
       ├─→ Build production artifact
       ├─→ Deploy to staging
       ├─→ Run integration tests
       ├─→ If all pass: Deploy to production
       └─→ If any fail: Rollback & notify
       ↓
If tests fail:
       ├─→ Alert developers
       └─→ Prevent further pushes
```

### Continuous Integration/Continuous Deployment (CI/CD)

```bash
# Example: GitHub Actions workflow for main branch
name: Deploy to Production

on:
  push:
    branches: [main]
  pull_request:
    branches: [main]

jobs:
  test:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v2
      - name: Run tests
        run: npm test
      - name: Build
        run: npm run build
      - name: Deploy
        if: success()
        run: npm run deploy:prod
```

---

## Merging to Main: Git Flow Approach

### Release Branch to Main

```bash
# Create release branch when ready to release
git checkout develop
git checkout -b release/1.2.0

# On release branch: only bug fixes and version bumps
git commit -am "Bump version to 1.2.0"

# Merge release to main with tag
git checkout main
git merge --no-ff release/1.2.0 -m "Release 1.2.0"
git tag -a v1.2.0 -m "Release version 1.2.0"
git push origin main --tags

# Merge back to develop
git checkout develop
git merge --no-ff release/1.2.0
git push origin develop

# Delete release branch
git branch -d release/1.2.0
git push origin --delete release/1.2.0
```

### Direct Feature to Main: GitHub Flow Approach

```bash
# Create feature from main
git checkout main
git checkout -b feature/critical-feature

# Develop and test thoroughly
git commit -m "feat: implement critical feature"

# Create Pull Request
# GitHub shows: feature/critical-feature → main

# After review and approval:
# Click "Merge pull request" on GitHub
# GitHub merges with merge commit
# GitHub deletes feature branch

# Locally, update main
git checkout main
git pull origin main
```

---

## Protecting Against Bad Commits

### Strategies to Prevent Issues

#### 1. Code Review Requirements
```
Require at least 2 approvals before merge
Reviewers can't be PR author
Comments must be resolved
```

#### 2. Automated Testing
```
All tests must pass
Code coverage must be maintained
Linting must pass
Build must succeed
```

#### 3. Commit Signing
```
Require commits to be GPG signed
Only verified commits can merge
Developers have trusted GPG keys
```

#### 4. Status Checks
```
CI/CD pipeline must pass
Security scans must pass
Code quality gates must pass
Performance benchmarks must pass
```

---

## Version Tagging on Main

### Semantic Versioning

```
Version Format: MAJOR.MINOR.PATCH
Example: v1.2.3

MAJOR: Breaking changes (requires migration)
MINOR: New features, backward compatible
PATCH: Bug fixes only
```

### Creating Tags

```bash
# Create annotated tag (recommended)
git tag -a v1.2.3 -m "Release version 1.2.3"

# Create lightweight tag (simpler)
git tag v1.2.3

# Push tags to remote
git push origin v1.2.3
git push origin --tags  # Push all tags

# View tags
git tag
git tag -l "v1.*"      # View specific versions
git show v1.2.3        # Show tag details
```

### Tag Naming Conventions

```
Recommended format: v1.2.3
Also acceptable: 1.2.3, release-1.2.3, 2026-01-25

Pattern:
├── v = version prefix (optional)
├── 1 = MAJOR version
├── 2 = MINOR version  
└── 3 = PATCH version

Examples:
✓ v1.0.0      (initial release)
✓ v1.5.2      (patch release)
✓ v2.0.0      (major release)
✓ v1.0.0-rc.1 (release candidate)
✓ v1.0.0-beta (beta release)
```

---

## Main Branch Workflows in Summary

### Workflow 1: Git Flow (Planned Releases)

```
develop ──→ release/x.x.x ──→ main (tagged)
  ↓                             ↑
feature ──→ develop ────────────┘
```

Steps:
1. Develop features on feature branches
2. Merge features to develop
3. Create release branch from develop
4. Make release branch, version bump
5. Merge release to main with version tag
6. Merge release back to develop

### Workflow 2: GitHub Flow (Continuous Deployment)

```
main ──→ feature/name ──→ Pull Request ──→ main
↓                                           ↓
Deploy immediately              Deploy immediately
```

Steps:
1. Create feature branch from main
2. Develop and test thoroughly
3. Create Pull Request
4. Get review and approval
5. Merge directly to main
6. Deploy automatically

### Workflow 3: Trunk-Based Development (Frequent Releases)

```
main: c1 ── c2 ── c3 ── c4 ── c5 ──
      ↓     ↓     ↓     ↓     ↓
      Feature flags control visibility
      
Deploy frequently (daily/multiple times)
```

---

## Rollback Strategies

### Quick Rollback with Revert

```bash
# Revert a specific commit (creates new commit)
git revert <commit-hash>
git push origin main

# Pro: Clean history, clear rollback commit
# Con: Doesn't undo code, just creates opposite
```

### Emergency Rollback with Reset

```bash
# Move main back to previous commit
git reset --hard <previous-commit-hash>
git push -f origin main

# Pro: Removes commits entirely
# Con: Rewrites history, requires force push
```

### Blue-Green Deployment (Safer)

```
Blue:  Production environment running v1.2.1
Green: Staging environment running v1.2.2

Test v1.2.2 thoroughly in Green
If successful: Switch load balancer to Green
If failed: Keep running Blue (instant rollback)
```

---

## Monitoring Main Branch Health

### Metrics to Track

```
├── Build Status
│   ├── Tests passing rate
│   ├── Build success rate
│   └── Deployment success rate
├── Code Quality
│   ├── Code coverage
│   ├── Linting violations
│   └── Security vulnerabilities
├── Performance
│   ├── Page load time
│   ├── API response time
│   └── Error rates
└── Deployment
    ├── Time to deploy
    ├── Rollback frequency
    └── Uptime percentage
```

---

## Next Steps
→ Continue to [07-develop-branch.md](07-develop-branch.md) to learn about the develop branch.
