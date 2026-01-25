# 13. Cherry Picking & Feature Flipping

## Overview

Two advanced techniques for managing code changes across branches and controlling feature visibility:

- **Cherry Picking** - Applying specific commits from one branch to another
- **Feature Flipping** - Toggling features on/off without code deployment

These techniques solve real-world problems in team development and production environments.

---

## Part 1: Cherry Picking

### What is Cherry Picking?

Cherry picking is the process of selecting specific commits from one branch and applying them to another branch.

**Visual Analogy:**
```
Branch A: [Commit 1] → [Commit 2] → [Commit 3] → [Commit 4]
                           ↓
                    (cherry pick)
                           ↓
Branch B: [Commit 5] → [Commit 2'] → [Commit 6]
```

The commit is applied but gets a new commit hash because it's applied to a different base.

### When to Use Cherry Picking

**✅ Good Use Cases:**

| Scenario | Example |
|----------|---------|
| **Critical Bug on Wrong Branch** | Feature branch has security fix; need on main immediately |
| **Selective Backport** | Want specific feature in v1.0.1; don't want others from develop |
| **Forgotten Commit** | Realized commit should go on release branch, not develop |
| **Multi-Version Support** | Same fix needed on v1.x and v2.x branches |
| **Partial Release** | Release some features; defer others from same develop |

**❌ Bad Use Cases (Avoid):**

| Scenario | Why Avoid |
|----------|-----------|
| **Merging entire branches** | Use merge/rebase instead |
| **Routine feature integration** | Use merge PRs to develop |
| **Copying unrelated commits** | Creates messy history |
| **Avoiding merge conflicts** | Conflicts hide real problems |
| **Rewriting history** | Creates confusion; use rebase instead |

### Cherry Picking Workflow

#### Basic Cherry Pick

**Step 1: Identify the commit**
```bash
# View commits on source branch
git log --oneline feature/important-fix

# Output:
# abc1234 fix: critical security vulnerability
# def5678 feat: related feature
# ghi9101 docs: update readme
```

**Step 2: Switch to target branch**
```bash
git checkout main
git pull origin main
```

**Step 3: Cherry pick the specific commit**
```bash
# Apply single commit
git cherry-pick abc1234

# Output:
# [main 7x8y9z0] fix: critical security vulnerability
# 1 file changed, 5 insertions(+)
```

**Step 4: Push to remote**
```bash
git push origin main
```

#### Cherry Picking Multiple Commits

**Sequential commits:**
```bash
# Cherry pick range of consecutive commits
git cherry-pick abc1234..def5678

# This picks: abc1234 and def5678 (including both endpoints)
```

**Non-consecutive commits:**
```bash
# Pick specific commits in order
git cherry-pick abc1234 def5678 ghi9101

# Applies in order: abc1234 → def5678 → ghi9101
```

**Interactive cherry pick:**
```bash
# Choose which commits to apply
git cherry-pick -i abc1234..def5678

# Opens editor, let you reorder, skip, or modify commits
```

### Handling Cherry Pick Conflicts

**Conflict occurs during cherry pick:**
```bash
$ git cherry-pick abc1234

# CONFLICT (content): Merge conflict in file.js
# error: could not apply abc1234... fix: critical bug
# hint: after resolving the conflicts, mark the resolved files
```

**Resolve conflicts:**
```bash
# 1. Open conflicted file and resolve
# 2. Stage resolved file
git add file.js

# 3. Continue cherry pick
git cherry-pick --continue

# OR abort if needed
git cherry-pick --abort
```

### Cherry Pick vs Merge

```
MERGE:
┌─ feature/new-feature
│  ├─ Commit A
│  ├─ Commit B
│  └─ Commit C
│       ↓
│    (Merge Commit)
│       ↓
└─→ main: [D] → [E] → [F] → [Merge Commit]

Result: All commits from feature/ on main
History: Shows parallel development

---

CHERRY PICK:
┌─ feature/new-feature
│  ├─ Commit A
│  ├─ Commit B ← Selected
│  └─ Commit C
│       ↓
│    (git cherry-pick B)
│       ↓
└─→ main: [D] → [E] → [F] → [B']

Result: Only Commit B applied to main
History: Linear, cleaner (but loses context)
```

### Real-World Examples

**Example 1: Backporting Security Fix**

Scenario: Security vulnerability found in v1.0.0 (on main). Fix merged to develop. Need fix on main immediately.

```bash
# 1. Find the fix commit on develop
git log develop --oneline | grep -i "security\|fix"
# Output: abc1234 fix(security): patch CVE-2026-1234

# 2. Switch to main
git checkout main

# 3. Cherry pick the fix
git cherry-pick abc1234

# 4. Push to production
git push origin main

# 5. Create patch release v1.0.1
git tag -a v1.0.1 -m "Security patch"
git push origin v1.0.1
```

**Example 2: Selective Feature in Release**

Scenario: Develop has 10 features. Release v1.1.0 only needs 3 features.

```bash
# 1. Create release branch from develop
git checkout develop
git pull origin develop
git checkout -b release/v1.1.0

# 2. Identify needed features (assume features A, C, E needed)
git log develop --oneline

# 3. Reset to main (v1.0.0 state)
git reset --hard main

# 4. Cherry pick only needed features
git cherry-pick feature-A-commit
git cherry-pick feature-C-commit
git cherry-pick feature-E-commit

# 5. Test the release
npm test

# 6. Push release branch
git push -u origin release/v1.1.0
```

**Example 3: Applying Hotfix Back to Develop**

Scenario: Hotfix created on main. Now need same fix on develop.

```bash
# 1. Hotfix is merged to main as v1.0.1
# 2. Check what was in the hotfix
git log v1.0.0..v1.0.1 --oneline
# Output: abc1234 fix(payment): critical payment bug

# 3. Switch to develop
git checkout develop
git pull origin develop

# 4. Cherry pick the hotfix
git cherry-pick abc1234

# 5. Push to develop
git push origin develop
```

### Best Practices for Cherry Picking

**DO's ✅**

- ✅ Use for individual, independent commits
- ✅ Prefer merge if picking entire feature set
- ✅ Communicate with team about cherry picks
- ✅ Document why cherry pick was used
- ✅ Test thoroughly after cherry pick
- ✅ Keep cherry picked commits small
- ✅ Update documentation/tests if needed

**DON'Ts ❌**

- ❌ Don't cherry pick to avoid conflicts
- ❌ Don't use instead of proper merge
- ❌ Don't create cherry pick chains (A→B→C)
- ❌ Don't cherry pick without testing
- ❌ Don't forget to merge parent feature eventually
- ❌ Don't skip communicating changes
- ❌ Don't create duplicate commits without tracking

---

## Part 2: Feature Flipping (Feature Flags)

### What is Feature Flipping?

Feature flipping is a technique to control which features are visible/active in production without redeploying code.

**Core Concept:**
```
Feature Code: Always deployed to production
Feature Flag: Determines if feature is visible/active

┌─────────────────────────────────────┐
│ if (isFeatureEnabled('new-ui')) {   │
│   showNewUserInterface();           │
│ } else {                             │
│   showOldUserInterface();           │
│ }                                    │
└─────────────────────────────────────┘

Feature Flag On:   New UI shown
Feature Flag Off:  Old UI shown
No code deployment needed!
```

### Benefits of Feature Flipping

| Benefit | Impact |
|---------|--------|
| **Decouple Deployment & Release** | Deploy code early, release features later |
| **Gradual Rollout** | Show feature to 5% → 25% → 50% → 100% of users |
| **Easy Rollback** | Turn off buggy feature instantly (no redeployment) |
| **A/B Testing** | Show feature A to 50%, feature B to 50%, compare |
| **Team Development** | Multiple features in progress, released independently |
| **Risk Reduction** | Test in production before full rollout |

### Types of Feature Flags

**1. Release Toggles (Release Flags)**
```javascript
// Turn feature on/off for all users

if (flags.isEnabled('new-checkout')) {
  // Show new checkout page
} else {
  // Show old checkout page
}

// Used for: Major features, controlled rollout
// Lifetime: Days to weeks
```

**2. Permission Toggles (Authorization Flags)**
```javascript
// Different features for different user roles

if (flags.isEnabled('admin-analytics', {role: 'admin'})) {
  // Show admin analytics dashboard
} else if (flags.isEnabled('basic-reporting', {role: 'user'})) {
  // Show basic reporting
}

// Used for: Role-based features, premium features
// Lifetime: Permanent or long-term
```

**3. Experiment Toggles (A/B Testing)**
```javascript
// Show different variants to test

if (flags.getVariant('checkout-button') === 'large-red') {
  // Show large red checkout button
} else if (flags.getVariant('checkout-button') === 'small-blue') {
  // Show small blue checkout button
}

// Track which variant converts better
// Used for: Optimization, user experience testing
// Lifetime: Weeks to months
```

**4. Ops Toggles (Operations Flags)**
```javascript
// Control system behavior based on load

if (flags.isEnabled('cache-expensive-queries')) {
  // Enable caching (improves performance)
} else {
  // Disable caching (if database is fast enough)
}

// Used for: Performance tuning, circuit breakers
// Lifetime: Temporary, as needed
```

### Implementing Feature Flags

#### Simple JavaScript Implementation

```javascript
// flags.js - Feature flag service
class FeatureFlags {
  constructor() {
    this.flags = {
      'new-dashboard': true,
      'dark-mode': false,
      'analytics-v2': true,
      'beta-features': false
    };
  }

  isEnabled(flagName, context = {}) {
    const flag = this.flags[flagName];
    
    if (typeof flag === 'function') {
      return flag(context);
    }
    
    return flag === true;
  }

  setFlag(flagName, value) {
    this.flags[flagName] = value;
  }

  getVariant(flagName) {
    return this.variants[flagName] || 'default';
  }
}

// Usage in application
const featureFlags = new FeatureFlags();

if (featureFlags.isEnabled('new-dashboard')) {
  renderNewDashboard();
} else {
  renderOldDashboard();
}
```

#### With User Context

```javascript
class FeatureFlags {
  constructor() {
    this.flags = {
      'premium-feature': (user) => user.tier === 'premium',
      'beta-feature': (user) => user.isAdmin || user.isBetaTester,
      'new-ui': (user) => {
        // Roll out to 10% of users
        return hashUserId(user.id) % 100 < 10;
      }
    };
  }

  isEnabled(flagName, context = {}) {
    const flag = this.flags[flagName];
    
    if (typeof flag === 'function') {
      return flag(context);
    }
    
    return flag === true;
  }
}

// Usage
const user = { id: 123, tier: 'premium', isAdmin: false };

if (featureFlags.isEnabled('premium-feature', user)) {
  showPremiumFeature();
}

if (featureFlags.isEnabled('beta-feature', user)) {
  showBetaFeature();
}

if (featureFlags.isEnabled('new-ui', user)) {
  showNewUI();
} else {
  showOldUI();
}
```

#### Configuration File Based

```yaml
# features.yml
features:
  new-dashboard:
    enabled: true
    rolloutPercentage: 100
  
  dark-mode:
    enabled: false
    rolloutPercentage: 0
  
  analytics-v2:
    enabled: true
    rolloutPercentage: 50
    description: "Roll out v2 analytics to 50% of users"
  
  premium-export:
    enabled: true
    allowedRoles:
      - premium
      - admin
    description: "CSV export for premium users only"
  
  beta-ai-features:
    enabled: true
    betaTesters:
      - user@example.com
      - admin@example.com
    description: "AI features for beta testers"
```

**Load and use:**
```javascript
const yaml = require('yaml');
const fs = require('fs');

const features = yaml.parse(fs.readFileSync('features.yml', 'utf8'));

function isFeatureEnabled(flagName, context = {}) {
  const feature = features.features[flagName];
  
  if (!feature || !feature.enabled) {
    return false;
  }

  // Check rollout percentage
  if (feature.rolloutPercentage < 100) {
    const userId = context.user?.id;
    const hash = hashUserId(userId);
    if (hash % 100 > feature.rolloutPercentage) {
      return false;
    }
  }

  // Check allowed roles
  if (feature.allowedRoles) {
    const userRole = context.user?.role;
    return feature.allowedRoles.includes(userRole);
  }

  return true;
}
```

### Feature Flag Workflow

```
Development Phase:
1. Developer writes feature with flag wrapping
2. Feature is disabled (flag: false)
3. Code merged to develop and main
4. Feature not visible to users

Testing Phase:
5. QA/DevOps enables flag for testers
6. Feature tested in production
7. Bugs fixed while flag disabled

Rollout Phase:
8. Enable flag for 10% of users
9. Monitor metrics/errors
10. Increase to 50%
11. Monitor again
12. Release to 100% of users

Post-Release:
13. Once fully stable, remove flag from code
14. Clean up feature flag in config

Rollback (if issues):
15. Disable flag immediately (no redeployment)
16. Revert to old behavior instantly
```

### Gradual Rollout Example

```yaml
# Gradual rollout schedule
features:
  new-checkout:
    enabled: true
    rolloutSchedule:
      - timestamp: "2026-01-25 00:00"
        percentage: 5
        description: "5% canary deployment"
      
      - timestamp: "2026-01-25 08:00"
        percentage: 25
        description: "25% after monitoring metrics"
      
      - timestamp: "2026-01-25 16:00"
        percentage: 50
        description: "50% if all looks good"
      
      - timestamp: "2026-01-26 00:00"
        percentage: 100
        description: "100% rollout to all users"
```

### Monitoring During Rollout

Track key metrics while rolling out:

```javascript
// Track feature usage
metrics.increment('feature.new-checkout.page_loads', {
  variant: 'new-checkout'
});

// Track errors
if (error) {
  metrics.increment('feature.new-checkout.errors', {
    errorType: error.type
  });
}

// Track conversions
if (checkoutSuccess) {
  metrics.increment('feature.new-checkout.conversions');
}

// Calculate conversion rate
conversionRate = conversions / pageLoads
```

### Real-World Scenarios

**Scenario 1: Rolling Out New Feature**

```
Day 1:
8:00 AM  → Enable for 5% (early adopters) - monitor 1 hour
9:00 AM  → 0% errors, good performance → increase to 25%
10:00 AM → All metrics green → increase to 50%
2:00 PM  → Still good → 100% to all users
8:00 PM  → 24-hour stable → remove feature flag from code

If issues detected at any point:
         → Instantly disable feature (flag: false)
         → No redeployment, instantaneous rollback
         → Investigate root cause
         → Fix bug
         → Re-enable when ready
```

**Scenario 2: A/B Testing**

```
Test: Which checkout button converts better?
- Red large button (current)
- Blue small button (new)

Variant A: 50% of users see red button
Variant B: 50% of users see blue button

Track:
- Page loads: A = 1000, B = 1000
- Conversions: A = 150, B = 180
- Conversion Rate: A = 15%, B = 18%

Result: Blue button wins!
Action: Roll out blue button to 100%
```

**Scenario 3: Emergency Rollback**

```
Tuesday 3:00 PM: Deploy new payment system (feature-flagged)
Tuesday 3:15 PM: Enable for 5% users
Tuesday 3:20 PM: Error spike detected!

┌─ Option 1: Gradual Rollout
│  ├─ Increase monitoring
│  └─ Wait for data
│
└─ Option 2: Feature Flag (recommended)
   ├─ Set flag to 0%
   ├─ INSTANT rollback (< 1 second)
   ├─ Old payment system active
   ├─ Investigate issue
   └─ Re-enable when ready

Feature flags win!
```

### Feature Flag Best Practices

**DO's ✅**

- ✅ Use feature flags for all new features
- ✅ Wrap flag logic with clear intent
- ✅ Test both flag on and flag off paths
- ✅ Monitor metrics during rollout
- ✅ Do gradual rollout (5% → 25% → 50% → 100%)
- ✅ Remove flags after feature is stable
- ✅ Use config files for easy management
- ✅ Document flag purpose and timeline

**DON'Ts ❌**

- ❌ Don't leave flags in code forever
- ❌ Don't roll out to 100% immediately
- ❌ Don't skip monitoring during rollout
- ❌ Don't ignore metrics/errors
- ❌ Don't test only flag-on path
- ❌ Don't create complex nested flag logic
- ❌ Don't hardcode flag values
- ❌ Don't forget to update docs

---

## Part 3: Cherry Pick + Feature Flags Together

These techniques complement each other:

**Cherry Pick:** Selectively apply commits across branches
**Feature Flags:** Control visibility without redeployment

### Combined Example: Hotfix Rollout

```
Scenario: Security bug found in v1.0.0

Step 1: Create hotfix on main
├─ git checkout -b hotfix/v1.0.1
├─ Fix the security issue
└─ Wrap with feature flag (flag: off by default)

Step 2: Test with flag disabled
├─ Deploy to production
├─ Old code path used (flag: off)
├─ No impact on users

Step 3: Enable for internal team
├─ flag.allowed_users = ['internal@company.com']
├─ Internal team tests the fix
└─ Monitors for any issues

Step 4: Gradual rollout
├─ 5% of external users → Monitor
├─ 25% → All metrics green
├─ 50% → Still good
└─ 100% → Feature stable

Step 5: After stability confirmed
├─ Remove feature flag from code
├─ Commit cleanup: "refactor: remove feature flag"
└─ Include in next release
```

---

## Summary

**Cherry Picking:**
- Selectively apply commits from one branch to another
- Useful for backports, selective releases, hotfixes
- Creates new commit with same changes but different hash
- Use sparingly; prefer merge when possible

**Feature Flipping:**
- Control feature visibility without code deployment
- Enable gradual rollout (5% → 25% → 50% → 100%)
- Enable instant rollback (no redeployment)
- Essential for production safety

**When to Use:**
- Cherry pick: Selective commits, backports, hotfixes
- Feature flags: All new features, controlled rollouts, A/B tests

**Best Practices:**
- Keep cherry picks minimal and well-documented
- Always test cherry picked commits
- Use feature flags for gradual rollouts
- Monitor metrics during rollout
- Remove flags after feature is stable
- Document decision to cherry pick or feature flag

**Next Steps:**
1. Implement feature flag system in your application
2. Use cherry pick for hotfix backporting
3. Establish gradual rollout process
4. Monitor metrics during feature releases
5. Clean up old feature flags regularly

