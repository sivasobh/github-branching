# 9. Hotfix Branch

## What is a Hotfix?

A hotfix is an emergency fix for a critical bug in production. Hotfix branches are created from `main` and merged directly back to `main` for immediate release, then also merged to `develop` to keep branches in sync.

---

## Hotfix Branch Purpose

```
When Production Has Critical Bug:

main (v1.2.0)  ●────────────────┐  (critical bug found!)
               ↑                 ↓
            production      hotfix/critical-db-issue
                                 ↓
                            (fix and test)
                                 ↓
                             ●────→ v1.2.1 (new tag)
                            ↓
                        develop branch also updated
                        (keep in sync)
```

---

## Types of Hotfixes

### Critical (Must Fix Immediately)

```
Examples:
✗ Security vulnerability exposed
✗ System completely down
✗ Data corruption occurring
✗ Data loss possible
✗ Breach in authentication

Response: Release hotfix within hours
Timeline: 1-4 hours
Testing: Essential but quick
```

### Urgent (Fix Soon)

```
Examples:
✗ Major feature broken
✗ Significant performance degradation
✗ Widespread user impact
✗ Financial impact
✗ Compliance issue

Response: Release hotfix within 24 hours
Timeline: 4-24 hours
Testing: Thorough testing before release
```

### Normal (Regular Release)

```
Examples:
- Minor bugs
- Small improvements
- Low-priority fixes

Response: Include in next planned release
Timeline: 1-2 weeks
Testing: Full regression testing
Note: Don't use hotfix branch for these!
```

---

## Hotfix Workflow

### Step 1: Create Hotfix Branch

```bash
# Ensure you have latest main
git checkout main
git pull origin main

# Create hotfix branch from main
git checkout -b hotfix/critical-database-issue

# Branch naming:
# hotfix/database-connection
# hotfix/security-login-bypass
# hotfix/payment-processing
```

### Step 2: Fix the Issue

```bash
# Identify the problem
# Write minimal code to fix only the issue
# No refactoring, no extra changes

# Example: Database connection pooling bug
vim database.js
# Change: poolSize = 1  →  poolSize = 10
git add database.js

git commit -m "fix: increase database connection pool size

The connection pool was limited to 1 connection, causing
timeouts when multiple requests arrived simultaneously.
Increased pool size to 10 to handle expected load.

Fixes #456
Related to incident #2026-01-25-DB-001"
```

### Step 3: Update Version

```bash
# Increment patch version (semantic versioning)
# 1.2.0 → 1.2.1

vim package.json
# "version": "1.2.0" → "version": "1.2.1"

git add package.json
git commit -m "Bump version to 1.2.1"

# Update changelog
vim CHANGELOG.md
# Add entry for 1.2.1

git add CHANGELOG.md
git commit -m "docs: update changelog for 1.2.1"
```

### Step 4: Test Thoroughly

```bash
# Quick but comprehensive testing
# Since it's critical, need to verify:

# Run tests
npm test

# Build
npm run build

# Deploy to staging
npm run deploy:staging

# Test in staging
# - Does the fix work?
# - Are there regressions?
# - Does it pass load tests?
# - Is performance acceptable?
```

### Step 5: Merge to Main

```bash
# Push hotfix branch for review
git push -u origin hotfix/critical-database-issue

# Get quick approval (pair programming or quick review)
# Then merge to main

git checkout main
git pull origin main

# Merge with --no-ff to preserve hotfix history
git merge --no-ff hotfix/critical-database-issue -m "Hotfix: critical database connection issue"

# Create version tag
git tag -a v1.2.1 -m "Hotfix version 1.2.1"

# Push to remote
git push origin main
git push origin v1.2.1
```

### Step 6: Deploy to Production

```bash
# Automated via CI/CD on tag push:
# 1. CI detects v1.2.1 tag
# 2. Runs full test suite
# 3. Builds production artifact
# 4. Deploys to production
# 5. Runs smoke tests

# Manual verification:
# 1. Verify fix is in production
# 2. Monitor error rates
# 3. Monitor performance
# 4. Monitor user reports
```

### Step 7: Merge Back to Develop

**Critical!** Hotfixes must go to develop too:

```bash
# Merge hotfix to develop
git checkout develop
git pull origin develop

git merge --no-ff hotfix/critical-database-issue -m "Merge hotfix to develop"
git push origin develop

# Why? Without this:
# - Next release loses the critical fix
# - Regression happens in next release
# - You're fighting the same bug again
```

### Step 8: Cleanup

```bash
# Delete hotfix branch
git branch -d hotfix/critical-database-issue
git push origin --delete hotfix/critical-database-issue
```

---

## Complete Hotfix Timeline

```
9:00 AM  - Bug reported in production
9:15 AM  - Bug confirmed critical
9:30 AM  - Hotfix branch created
9:45 AM  - Fix implemented
10:00 AM - Deployed to staging
10:15 AM - Testing complete
10:30 AM - Merged to main with v1.2.1 tag
10:45 AM - Deployed to production
11:00 AM - Verified in production
11:15 AM - Merged to develop
11:30 AM - Hotfix branch deleted
12:00 PM - Post-incident review

Total time: ~3 hours
```

---

## Hotfix Rules

### MUST DO

```
✓ Create from main (not develop)
✓ Make minimal fix (only fix the bug)
✓ Merge to main FIRST
✓ Create version tag on main
✓ Deploy from main tag
✓ Merge back to develop
✓ Update version number (patch)
✓ Document the fix in changelog
✓ Review the fix thoroughly
✓ Test before release
```

### MUST NOT DO

```
✗ Create from develop
✗ Include unrelated changes
✗ Use for non-critical bugs
✗ Forget to merge to develop
✗ Merge to develop before main
✗ Use same version as main
✗ Skip testing
✗ Force push to main
✗ Include new features
✗ Commit debugging code
```

---

## Common Hotfix Scenarios

### Scenario 1: Security Issue

```bash
# 1. Create hotfix
git checkout -b hotfix/sql-injection

# 2. Fix SQL injection vulnerability
# Update parameterized queries
git commit -m "fix: prevent SQL injection in user search"

# 3. Bump version (security is patch level unless major)
git commit -m "Bump version to 1.2.1"

# 4. Deploy immediately
# Security issues don't wait for next release

# 5. Also notify users to update
```

### Scenario 2: Data Corruption

```bash
# 1. Identify scope of corruption
# 2. Backup production data immediately
# 3. Create hotfix to prevent further corruption
git checkout -b hotfix/prevent-data-corruption

git commit -m "fix: add validation to prevent data corruption

Added transaction rollback for invalid states.
Prevents concurrent updates that could corrupt data.
Fixes #500"

# 4. Deploy hotfix immediately
# 5. Run data repair script (usually manual)
# 6. Verify data integrity
```

### Scenario 3: Performance Degradation

```bash
# 1. Identify the bottleneck
# 2. Create hotfix with minimal changes
git checkout -b hotfix/slow-query

git commit -m "perf: add database index to slow queries

Added compound index on (user_id, created_at)
Query time reduced from 5s to 50ms.
Fixes #501"

# 3. Benchmark before and after
# 4. Deploy to production
# 5. Monitor performance metrics
```

---

## Preventing Need for Hotfixes

### Prevention Strategies

```
Pre-Release Testing:
├─ Automated unit tests
├─ Integration tests
├─ Staging environment mirror
├─ Load testing
├─ Security scanning
├─ Code review
└─ User acceptance testing

Post-Release Monitoring:
├─ Error rate tracking
├─ Performance monitoring
├─ User feedback channels
├─ Automated alerting
├─ Health checks
└─ Log aggregation
```

### Early Warning System

```
Alert on:
✓ Error rate > 2x baseline
✓ Response time > 1.5x baseline
✓ CPU usage > 80%
✓ Memory usage > 85%
✓ Database connection errors
✓ Deployment failures
✓ API timeout errors
```

---

## Hotfix vs Regular Fix Decision

### Use Hotfix When:

```
✓ Production is down/broken
✓ Critical security issue
✓ Data loss/corruption occurring
✓ Widespread user impact
✓ Can't wait 1-2 weeks
✓ Needs immediate release
```

### Use Regular Feature Branch When:

```
✓ Non-critical bug
✓ Can wait for next release
✓ Development feature
✓ Planned release cycle
✓ Low user impact
```

```
               Is Production Broken?
                      │
                    Yes / No
                   /        \
                  /          \
              HOTFIX      FEATURE
              BRANCH      BRANCH
                │            │
              Now          Release
              Deploy      Schedule
```

---

## Hotfix Documentation

### Post-Hotfix Report

```markdown
# Hotfix Report: v1.2.1

## Issue
- **ID**: INC-2026-01-25-001
- **Severity**: Critical
- **Title**: Database connection pool exhaustion
- **Impact**: Service unavailable (users couldn't connect)

## Root Cause
Connection pool was limited to 1, causing immediate exhaustion
under normal load.

## Fix
Increased default pool size from 1 to 10.

## Timeline
- 09:00 - Issue reported
- 09:30 - Root cause identified
- 09:45 - Fix deployed to staging
- 10:30 - Released to production (v1.2.1)
- 11:00 - Verified production stable

## Prevention
- Add load testing to release checklist
- Monitor connection pool usage
- Set alerts for pool exhaustion
```

---

## Next Steps
→ Continue to [10-hands-on-example.md](10-hands-on-example.md) for a practical walkthrough.
