# 10. Hands-On Example: Complete Git Flow

## Project Overview

This example walks through a complete real-world scenario using Git Flow: developing a feature, releasing, finding a bug, and fixing it with a hotfix.

```
Project: Simple Task Management App
Team: 3 developers
Release Cycle: Monthly (v1.0, v1.1, v1.2...)
```

---

## Scenario: Month 1 - Initial Release

### Week 1-2: Feature Development

#### Developer A: Authentication Feature

```bash
# Day 1: Start feature
git checkout develop
git pull origin develop
git checkout -b feature/user-auth

# Day 2: Add login form
git commit -m "feat(auth): add user login form

Add login form component with email and password fields.
Form validates input before submission.
Includes error message display."

git push -u origin feature/user-auth
```

#### Developer B: Task Management Feature

```bash
# Day 1: Start feature
git checkout develop
git pull origin develop
git checkout -b feature/task-crud

# Day 3: Add create functionality
git commit -m "feat(task): add task creation

Users can create new tasks with title and description.
Tasks are saved to local database.
Auto-generates unique task ID."

git push -u origin feature/task-crud
```

#### Developer C: UI Components

```bash
# Day 1: Start feature
git checkout develop
git pull origin develop
git checkout -b feature/ui-components

# Day 4: Create components
git commit -m "feat(ui): add reusable components

Add Button, Card, Modal, and Form components.
Components follow design system specs.
Includes props for customization."

git push -u origin feature/ui-components
```

### Week 2: Code Review and Merging

#### Merging Feature A: User Authentication

```bash
# Create Pull Request on GitHub
# PR: feature/user-auth → develop
# Review: 2 approvals required
# CI: All tests must pass

# After approval:
git checkout develop
git pull origin develop
git merge --no-ff feature/user-auth -m "Merge feature/user-auth into develop"
git push origin develop
git branch -d feature/user-auth
git push origin --delete feature/user-auth
```

#### Merging Feature B: Task Management

```bash
# Similar process
git checkout develop
git pull origin develop
git merge --no-ff feature/task-crud -m "Merge feature/task-crud into develop"
git push origin develop
git branch -d feature/task-crud
git push origin --delete feature/task-crud
```

#### Merging Feature C: UI Components

```bash
# Similar process
git checkout develop
git pull origin develop
git merge --no-ff feature/ui-components -m "Merge feature/ui-components into develop"
git push origin develop
git branch -d feature/ui-components
git push origin --delete feature/ui-components
```

### Week 3: Release Preparation

#### Release Checklist

```
✓ All features merged
✓ All tests passing
✓ Code coverage at 85%+
✓ No security issues
✓ Documentation complete
✓ Performance acceptable
```

#### Create Release Branch

```bash
git checkout develop
git pull origin develop
git checkout -b release/1.0.0

# Update version
vim package.json
# "version": "1.0.0"

git add package.json
git commit -m "Bump version to 1.0.0"

# Create changelog
cat > CHANGELOG.md << 'EOF'
# Changelog

## [1.0.0] - 2026-01-31

### Added
- User authentication (login/logout)
- Task creation and management
- Reusable UI components

### Features
- Secure password handling
- Task persistence
- Responsive design

EOF

git add CHANGELOG.md
git commit -m "docs: create changelog for 1.0.0"

git push -u origin release/1.0.0
```

#### Testing Release

```
Staging Environment:
✓ Deploy release branch
✓ Run full test suite (1000+ tests)
✓ Performance testing
✓ Security scan
✓ Load testing
✓ UAT approval
```

#### Release to Production

```bash
# Merge to main
git checkout main
git pull origin main
git merge --no-ff release/1.0.0 -m "Release version 1.0.0"
git tag -a v1.0.0 -m "Release version 1.0.0"
git push origin main
git push origin v1.0.0

# Merge back to develop
git checkout develop
git pull origin develop
git merge --no-ff release/1.0.0 -m "Merge release 1.0.0 back to develop"
git push origin develop

# Cleanup
git branch -d release/1.0.0
git push origin --delete release/1.0.0
```

---

## Scenario: Week 4 - Critical Bug Found

### The Bug Report

```
Issue: Login not working after password update
Severity: CRITICAL
Affected Users: All users trying to reset password
Status: Production Down
Reported: 2 hours after v1.0.0 release
```

### Hotfix Creation

```bash
# Immediately create hotfix from main
git checkout main
git pull origin main
git checkout -b hotfix/password-reset-bug

# Investigate and fix
# Found: Password hash doesn't match after reset
# Solution: Properly hash password before comparison

vim auth.js
# Change hash algorithm to use bcrypt

git add auth.js
git commit -m "fix: correct password hashing after reset

The password reset wasn't hashing the new password correctly,
causing login failures. Now using bcrypt consistently for all
password operations.

Fixes #789"

# Bump patch version
vim package.json
# "version": "1.0.1"

git add package.json
git commit -m "Bump version to 1.0.1"
```

### Emergency Testing

```bash
# Quick but thorough testing
npm test                    # Run all tests: 2 min
npm run test:auth         # Auth-specific tests: 1 min
npm run deploy:staging    # Deploy to staging: 3 min
npm run test:e2e-login    # End-to-end login test: 5 min

# Manual testing:
# 1. Create new account
# 2. Reset password
# 3. Login with new password
# ✓ Success!
```

### Emergency Release

```bash
# Merge to main
git checkout main
git pull origin main
git merge --no-ff hotfix/password-reset-bug -m "Hotfix: password reset bug"
git tag -a v1.0.1 -m "Hotfix version 1.0.1"
git push origin main
git push origin v1.0.1

# Automated deploy on tag triggers
# CI/CD Pipeline:
# 1. Tests: ✓ PASS
# 2. Build: ✓ PASS
# 3. Deploy to staging: ✓ PASS
# 4. Smoke tests: ✓ PASS
# 5. Deploy to production: ✓ PASS

# Total time: 15 minutes
```

### Keep Develop in Sync

```bash
# Very important! Don't forget this step
git checkout develop
git pull origin develop
git merge --no-ff hotfix/password-reset-bug -m "Merge hotfix to develop"
git push origin develop

# Now develop also has the fix
# Next release won't regress on this bug
```

### Post-Hotfix

```bash
# Cleanup
git branch -d hotfix/password-reset-bug
git push origin --delete hotfix/password-reset-bug

# Post-incident review
# - Why wasn't this caught in testing?
# - Add test for password reset flow
# - Add integration test for auth
# - Review password handling code again
```

---

## Scenario: Month 2 - Next Release

### New Features Start (After Hotfix)

```bash
# Now developing for v1.1
# All developers get latest code including hotfix

git checkout develop
git pull origin develop
# ✓ Have v1.0.1 hotfix
# ✓ Have all v1.0.0 features
# Ready to build v1.1
```

#### Developer D: Dashboard Feature

```bash
git checkout -b feature/dashboard

git commit -m "feat(dashboard): add user dashboard

Dashboard shows:
- Task list and statistics
- Quick task creation
- Task filtering and sorting
- Recently completed tasks

Uses existing task management API."

git push -u origin feature/dashboard
```

#### Developer E: Export Feature

```bash
git checkout -b feature/export-tasks

git commit -m "feat(export): add task export to CSV

Users can export their tasks to CSV format.
Includes all task fields.
Exported file downloads directly to user device."

git push -u origin feature/export-tasks
```

### Release v1.1 (Similar Process)

```bash
# Week 3: Create release branch
git checkout -b release/1.1.0

vim package.json
# "version": "1.1.0"

git commit -am "Bump version to 1.1.0"

# Week 3: Test and fix bugs on release branch
git commit -m "fix: correct dashboard layout on mobile"

# Week 4: Release
git checkout main
git merge --no-ff release/1.1.0
git tag -a v1.1.0 -m "Release 1.1.0"
git push origin main --tags

# Sync develop
git checkout develop
git merge --no-ff release/1.1.0
git push origin develop
```

---

## Branch History Visualization

### Complete History After All Work

```
Develop Branch:
develop:    ●─●─●─●─●─●─●─●─●─●─●─●
            │ │ │ │ │ │ │ │ │ │ │ │
Features:   ├─┘ ├─┘ ├─┘ ├─┘ ├─┘ ├─┘
            F1  F2  F3  F4  F5  F6

Main Branch (Tags):
main:       ●─────────────────●───────────●
            │                 │           │
           v1.0.0        v1.0.1      v1.1.0
                         (hotfix)

Timeline:
Jan 31: v1.0.0 released
Feb 7:  v1.0.1 hotfix
Feb 28: v1.1.0 released

Features completed:
- v1.0.0: auth, tasks, ui
- v1.1.0: dashboard, export
```

---

## Key Lessons from Example

### What Went Well ✓

```
✓ Clear separation of concerns (feature branches)
✓ Continuous integration (testing on every push)
✓ Code reviews (quality control)
✓ Hotfix process (quick critical fixes)
✓ Keeping develop and main in sync
✓ Clear version tagging
✓ Documented changelog
```

### What Could Be Improved ✗

```
✗ Password reset wasn't well tested initially
✗ Should have had e2e tests for auth
✗ Missing integration tests
✗ Could have staged more gradually
✗ No load testing before release
✗ Could have used feature flags
✗ No canary deployment
```

---

## Common Gotchas and How to Avoid Them

### Gotcha 1: Forgetting to Merge Hotfix Back

```
❌ WRONG:
hotfix/bug ──→ main (v1.0.1) ✓ released
                             ✗ develop missing fix

✓ RIGHT:
hotfix/bug ──→ main (v1.0.1) ✓ released
             └──→ develop    ✓ in sync
```

### Gotcha 2: Committing to Wrong Branch

```
❌ WRONG:
$ git checkout develop
$ git commit -m "fix: my fix"  ← Should be on hotfix!

✓ RIGHT:
$ git checkout main
$ git checkout -b hotfix/bug
$ git commit -m "fix: my fix"  ← Now on hotfix branch
```

### Gotcha 3: Forgetting to Test Release Branch

```
❌ WRONG:
Create release/1.0 Friday 5pm
Merge to main immediately
Release to production
Discover bugs Monday morning
Everyone frustrated

✓ RIGHT:
Create release/1.0 Friday 2pm
Deploy to staging
Run full test suite
Test through weekend
Release Monday morning confident
```

### Gotcha 4: Including Unrelated Changes in Hotfix

```
❌ WRONG:
git checkout -b hotfix/critical-bug
git commit -m "Fix critical bug"
git commit -m "Also refactor this code"
git commit -m "Also update styles"
← Now hotfix has 3 things, hard to track

✓ RIGHT:
git checkout -b hotfix/critical-bug
git commit -m "Fix critical bug only"
← Minimal focused fix
← Refactoring goes to feature branch
← Styles go to feature branch
```

---

## Next Steps

Now that you understand:
- ✓ Git fundamentals
- ✓ Branching strategies
- ✓ Merge vs Rebase
- ✓ Commit best practices
- ✓ All branch types (main, develop, feature, release, hotfix)
- ✓ Real-world workflow

You're ready to apply these practices in your projects!

### Resources
→ See [diagrams/](../diagrams/) folder for visual representations
→ See [examples/](../examples/) folder for command reference
