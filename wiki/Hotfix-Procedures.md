# Hotfix Procedures - Handling Emergency Fixes

Guide for quickly fixing critical production issues.

---

## Overview

**When to Use Hotfix:**
- 🚨 Critical bug in production
- 🔒 Security vulnerability in production
- 💥 Service outage
- 📊 Data integrity issue
- ⚠️ Any breaking production issue

**Hotfix Process:**
```
Critical issue found in production
   ↓
1. Alert team immediately
   ↓
2. Create hotfix branch
   ↓
3. Fix the bug
   ↓
4. Test thoroughly
   ↓
5. Deploy immediately
   ↓
6. Verify fix in production
   ↓
7. Merge back to develop
   ↓
8. Post-incident review
```

**Time Limits:**
- Alert team: Immediately
- Fix deployed: <30 minutes (target)
- All merged: <1 hour

---

## 1. Alert Team

**Immediately Notify:**

**Slack (example):**
```
🚨 CRITICAL PRODUCTION ISSUE

Issue: Payment processing returning 500 errors
Impact: Users cannot complete transactions
Severity: CRITICAL
Status: INVESTIGATING

On it: @john-dev

#incident-response
```

**Who to Alert:**
- Engineering team lead
- DevOps/infrastructure team
- Product manager
- CEO/CTO (for critical issues)

**Include:**
- What's broken
- Who's affected
- Business impact
- Severity level

---

## 2. Create Hotfix Branch

**From Main (Important!):**

```bash
# Switch to main
git checkout main

# Get latest
git pull origin main

# Create hotfix branch
git checkout -b hotfix/v1.2.1
```

**Branch Naming:**
```
hotfix/v1.2.1           ✅ Semantic versioning
hotfix/critical-bug     ❌ Avoid generic names
hotfix/payment-fix      ✅ Descriptive
```

**DO NOT use develop branch for hotfix!**

---

## 3. Fix the Bug

**Diagnose First:**

```bash
# Check production logs
kubectl logs -l app=myapp --tail=200

# Check error tracking
# (Sentry, DataDog, etc.)

# Reproduce locally if possible
npm start
# ... reproduce the issue ...
```

**Implement Fix:**

```bash
# Make minimal changes only!
# Don't refactor, don't optimize
# Fix the bug, nothing else

# Edit files
# ... minimal fix only ...

# Stage and commit
git add .
git commit -m "fix: payment processing returning 500 errors"
```

**Keep Commits Minimal:**
- One commit if possible
- Maximum 2-3 commits for complex fixes
- Clear commit message explaining the fix

---

## 4. Test Thoroughly

**Local Testing:**

```bash
# Build
npm run build

# Test locally
npm start

# Reproduce the issue
# ... verify it's fixed ...

# Run tests
npm test
```

**Verify Fix:**
- ✅ Original issue resolved
- ✅ No new errors introduced
- ✅ Related features still work
- ✅ No performance regression

**Automated Tests:**

```bash
# Run full test suite
npm test

# Run relevant tests
npm test -- --grep "payment"
```

**If Tests Fail:**
- Fix the issue
- Commit again
- Re-run tests
- Don't proceed until tests pass

---

## 5. Deploy Immediately

**Fast Deployment Path:**

```bash
# Option 1: Via GitHub Actions (Recommended)
git push origin hotfix/v1.2.1

# Create PR to main
# → Review (quick!)
# → Merge
# → GitHub Actions deploys automatically

# Option 2: Direct deployment (if emergency)
docker build -t myapp:hotfix-v1.2.1 .
docker push myapp:hotfix-v1.2.1
kubectl set image deployment/myapp myapp=myapp:hotfix-v1.2.1
```

**Timeline:**
- Create fix: 5 minutes
- Test: 5 minutes
- Deploy: 5 minutes
- Total: ~15 minutes

---

## 6. Verify in Production

**Immediate Verification:**

```bash
# Check deployment status
kubectl rollout status deployment/myapp

# Verify pods running
kubectl get pods -l app=myapp

# Check logs for errors
kubectl logs -l app=myapp --tail=50

# Test the fix manually
curl https://api.example.com/payments
# or test via UI
```

**Monitor Metrics:**
- Error rate (should drop)
- Response time (should normalize)
- User sessions (should increase)

**If Fix Didn't Work:**

```bash
# Rollback immediately!
kubectl rollout undo deployment/myapp

# Or redeploy previous version
docker run -d myapp:v1.2.0
```

**Alert team:**
```
Rollback in progress. Working on v2 of fix.
```

---

## 7. Merge Back to Develop

**After Production Verification:**

```bash
# Switch to develop
git checkout develop
git pull origin develop

# Merge hotfix
git merge hotfix/v1.2.1

# Push to develop
git push origin develop

# This ensures fix is in next release
```

**Why merge back?**
- Prevents re-introduction of bug in next release
- Keeps develop in sync with main
- Tracks all fixes in history

---

## 8. Post-Incident Review

**After System Stable:**

**Create Incident Report:**

```markdown
# Incident Report

## Summary
Payment processing was down for 15 minutes due to database connection timeout.

## Timeline
- 2:45 PM: First report from customer
- 2:50 PM: Issue confirmed (500 errors)
- 2:55 PM: Root cause identified (connection pool depleted)
- 3:10 PM: Fix deployed (v1.2.1)
- 3:15 PM: Verified working, monitoring normal

## Root Cause
Connection pool not being released properly under high load.

## Fix
Added explicit connection.close() in error handler.

## Prevention
1. Add connection pool monitoring alerts
2. Increase default pool size from 10 to 20
3. Add automated tests for error scenarios

## Action Items
- [ ] Implement connection pool alerts (John, by tomorrow)
- [ ] Increase pool size (Sarah, by tomorrow)
- [ ] Add error scenario tests (Team, by sprint end)

## Lessons Learned
- Detection was fast (5 min)
- Fix and deploy was fast (20 min)
- Need better alerting to detect earlier
```

**Team Discussion:**
- What went well?
- What could be better?
- Action items for prevention

---

## Hotfix Branch Management

**After Merge:**

```bash
# Delete hotfix branch locally
git branch -d hotfix/v1.2.1

# Delete hotfix branch on GitHub
git push origin --delete hotfix/v1.2.1
```

---

## Version Bumping

**Hotfix Versions:**

```
Current production: v1.2.0
Hotfix version: v1.2.1 (PATCH bump)

Format: MAJOR.MINOR.PATCH
        1.2.1 = 1.2.0 + 1 (patch increment)
```

**Update Version Files:**

Before deploying:
```bash
# Update version in all files
# package.json, pom.xml, etc.

# Example package.json:
{
  "version": "1.2.1"
}

git add .
git commit -m "chore: bump version to 1.2.1"
```

---

## Communication Template

**Initial Alert:**
```
🚨 CRITICAL ISSUE - Payment Processing
Detected: 2024-01-25 14:45 UTC
Impact: Users cannot complete checkout
Status: INVESTIGATING
ETA: 15 minutes
Contact: @john-dev
```

**Status Update (5 min):**
```
✅ Root cause identified: Database timeout
🔧 Fix in progress
🚀 Expected deployment: 14:55 UTC
```

**Resolution:**
```
✅ RESOLVED - v1.2.1 deployed
⏱️ Downtime: 15 minutes
📊 Impact: ~500 transactions affected
🔄 Monitoring: All metrics normal
📝 Incident report: [link]
```

---

## Hotfix Best Practices

### ✅ DO

- ✅ Create from main (current production)
- ✅ Make minimal changes only
- ✅ Test thoroughly before deploy
- ✅ Deploy quickly but carefully
- ✅ Monitor production after deploy
- ✅ Merge back to develop
- ✅ Document the incident
- ✅ Plan prevention for next time
- ✅ Update version number
- ✅ Alert appropriate team members

### ❌ DON'T

- ❌ Create from develop
- ❌ Refactor or optimize in hotfix
- ❌ Add multiple unrelated fixes
- ❌ Deploy without testing
- ❌ Skip merging back to develop
- ❌ Make hotfix and forget about it
- ❌ Deploy without monitoring
- ❌ Ignore prevention recommendations
- ❌ Create multiple competing hotfixes
- ❌ Use hotfix for non-critical issues

---

## Complex Hotfix Scenarios

### Multiple People Fixing

**Coordinate:**
```bash
# Person 1: Fix database issue
git checkout -b hotfix/database

# Person 2: Fix API timeout
git checkout -b hotfix/api-timeout

# Test independently
# Deploy person 1's fix first (more critical)
# Then person 2's fix
# Then merge both back to develop
```

### Conflict with Unreleased Code

**If hotfix conflicts with develop:**

```bash
# After merging to develop
# Resolve conflicts carefully

git checkout develop
git merge hotfix/v1.2.1

# If conflicts:
# Use git mergetool
git mergetool

# Commit merge
git commit -m "merge: hotfix v1.2.1 to develop"
```

### Hotfix for Old Version

**If customers using v1.0.0 and v1.1.0:**

```bash
# Create hotfix from old tag
git checkout v1.0.0
git checkout -b hotfix/v1.0.1

# Fix bug
# Deploy as v1.0.1

# Then create same fix for newer version
git checkout v1.1.0
git checkout -b hotfix/v1.1.1

# Apply same fix
# Deploy as v1.1.1
```

---

## Monitoring After Hotfix

**First 10 Minutes:**
- Check error logs every minute
- Monitor key metrics
- Have team standing by

**First Hour:**
- Monitor error trends
- Check user reports
- Compare with baseline metrics

**First Day:**
- Monitor for edge cases
- Watch for delayed failures
- Gather user feedback

**Alerts to Set:**
```
- Error rate spikes
- Response time increases
- Database connection errors
- Memory usage anomalies
- CPU usage anomalies
```

---

## Prevention Strategies

**Better Monitoring:**
```bash
# Alert before crisis
# Example: Alert if error rate > 1%
# Alert if response time > 2s
# Alert if memory > 80%
```

**Automated Tests:**
```bash
# Test error scenarios
# Test high-load scenarios
# Test recovery scenarios
```

**Code Review:**
```bash
# Ensure error handling
# Check connection management
# Verify cleanup code
```

---

## Rollback Procedure

**If Hotfix Causes New Issues:**

```bash
# Immediate rollback
kubectl rollout undo deployment/myapp

# Or redeploy previous version
docker run -d myapp:v1.2.0

# Verify rollback
curl https://api.example.com/health
```

**Alert Team:**
```
Rolled back to v1.2.0. Creating v2 of fix.
```

**Create New Hotfix:**
```bash
git checkout main
git pull origin main
git checkout -b hotfix/v1.2.2

# Different approach to fix
# Test even more thoroughly
# Deploy
```

---

## Related Guides

- [Release Process](./Release-Process.md)
- [Troubleshooting](./Troubleshooting.md)
- [Feature Development](./Feature-Development.md)
- [Command Reference](./Command-Reference.md)

---

**Key Takeaway:** Speed is important for hotfixes, but don't sacrifice quality. Test thoroughly before deploying to production.

**Main Navigation:** [Home](./Home.md) | [Quick Start](./Quick-Start.md) | [FAQ](./FAQ.md)
