# Choosing Your Strategy - Which Branching Strategy is Right?

Guide to selecting the best branching strategy for your team and project.

---

## Quick Decision Tree

```
Start here:
    ↓
Single version in production?
├─ YES → GitHub Flow or Trunk-Based
├─ NO → Git Flow
    ↓
How often do you release?
├─ Multiple times per day → Trunk-Based Development
├─ Once per week → GitHub Flow
├─ Monthly or less → Git Flow
```

---

## Strategy Comparison

| Aspect | Git Flow | GitHub Flow | Trunk-Based |
|--------|----------|-------------|------------|
| **Complexity** | High | Low | Medium |
| **Branches** | 5+ types | 2 | 1 main |
| **Learning Curve** | Steep | Gentle | Medium |
| **Multiple Versions** | ✅ Yes | ❌ No | ❌ No |
| **Release Frequency** | Monthly+ | Weekly+ | Daily+ |
| **Team Size** | Large | Small-Medium | Medium-Large |
| **Testing** | Formal | Continuous | Continuous |
| **Feature Flags** | No | Optional | Yes (required) |
| **Rollback Speed** | Slow | Fast | Very Fast |

---

## Git Flow

**When to Use:**
- ✅ Large teams (10+ developers)
- ✅ Multiple versions in production
- ✅ Need stable releases
- ✅ Formal release process
- ✅ Example: Enterprise software, versioned APIs

**Structure:**
```
main (v1.0, v1.1, v2.0)
  ├─ release/v1.2.0 (preparation)
  └─ hotfix/v1.0.1 (emergency fixes)
develop (integration branch)
  ├─ feature/login
  ├─ feature/dashboard
  └─ feature/payments
```

**Workflow:**

1. **New Feature:**
   ```bash
   git checkout develop
   git checkout -b feature/feature-name
   # ... make changes ...
   git push origin feature/feature-name
   # → Create PR to develop → Merge when approved
   ```

2. **Release:**
   ```bash
   git checkout -b release/v1.2.0 develop
   # Update version, test thoroughly
   git push origin release/v1.2.0
   # → PR to main → Merge → Tag v1.2.0
   # → PR back to develop
   ```

3. **Hotfix:**
   ```bash
   git checkout -b hotfix/v1.1.1 main
   # ... fix bug ...
   git push origin hotfix/v1.1.1
   # → PR to main → Merge → Tag v1.1.1
   # → Merge back to develop
   ```

**Advantages:**
- ✅ Multiple versions supported
- ✅ Clear release process
- ✅ Predictable timeline
- ✅ Good for large teams

**Disadvantages:**
- ❌ Complex to learn
- ❌ More branches to manage
- ❌ Slower releases
- ❌ More ceremony required

**Best For:** Enterprise, complex projects, version management

**Detailed Guide:** See [Git Flow Documentation](../docs/02-branching-strategy.md)

---

## GitHub Flow

**When to Use:**
- ✅ Small-medium teams (3-15 developers)
- ✅ Single version in production
- ✅ Continuous deployment
- ✅ Weekly or more releases
- ✅ Example: SaaS products, web applications, startups

**Structure:**
```
main (production)
  ├─ feature/login
  ├─ feature/dashboard
  └─ bugfix/fix-email-validation
```

**Workflow:**

1. **Create Feature Branch:**
   ```bash
   git checkout main
   git pull origin main
   git checkout -b feature/my-feature
   ```

2. **Make Changes & Push:**
   ```bash
   git add .
   git commit -m "feat: add login form"
   git push origin feature/my-feature
   ```

3. **Create Pull Request:**
   - Go to GitHub
   - Click "Create Pull Request"
   - Add description & screenshots
   - Request reviewers

4. **Review & Merge:**
   - Team reviews code
   - Tests run automatically
   - Approve and merge to main
   - Automatic deployment to production

5. **Cleanup:**
   ```bash
   git checkout main
   git pull origin main
   git branch -d feature/my-feature
   git push origin --delete feature/my-feature
   ```

**Advantages:**
- ✅ Simple and easy to learn
- ✅ Fast releases
- ✅ Good code review
- ✅ Clear workflow
- ✅ Minimal overhead

**Disadvantages:**
- ❌ Can't manage multiple versions
- ❌ All code goes to production
- ❌ Requires robust automation
- ❌ Not suitable for huge teams

**Best For:** Startups, SaaS, continuous deployment environments

**Detailed Guide:** See [Branching Workflow Documentation](../docs/03-branching-workflow.md)

---

## Trunk-Based Development

**When to Use:**
- ✅ Very frequent releases (daily)
- ✅ Mature CI/CD pipeline
- ✅ Small teams (under 20)
- ✅ Heavy feature flag usage
- ✅ Example: High-growth tech companies, fast-moving startups

**Structure:**
```
main (production)
  ├─ short-lived-branch-1 (exists 1-2 days)
  └─ short-lived-branch-2 (exists 1-2 days)

Feature toggles in code:
if (config.newDashboard.enabled) { ... }
```

**Workflow:**

1. **Work Directly on Main (or Short-Lived Branches):**
   ```bash
   git checkout -b feature/login
   # ... quick work (hours, not days) ...
   ```

2. **Commit Frequently:**
   ```bash
   git commit -m "feat: login form structure"
   git commit -m "feat: email validation"
   ```

3. **Push & Merge Quick:**
   ```bash
   git push origin feature/login
   # Quick PR review (30 mins)
   # Merge to main immediately
   ```

4. **Control via Feature Flags:**
   ```javascript
   if (features.login.enabled) {
     renderLoginForm();
   } else {
     renderOldForm();
   }
   ```

5. **Gradual Rollout:**
   - 5% users → test for 2 hours
   - 25% users → test for 1 day
   - 100% users → full deployment

**Advantages:**
- ✅ Very fast releases
- ✅ Small, focused changes
- ✅ Instant rollback (toggle feature off)
- ✅ Better for rapid iteration

**Disadvantages:**
- ❌ Requires excellent automation
- ❌ Strong discipline needed
- ❌ All code on main (even incomplete)
- ❌ Feature flags add code complexity

**Best For:** Fast-moving teams, feature-heavy products, daily deployments

**Requirements:**
- Mature CI/CD pipeline
- Automated testing (80%+ coverage)
- Feature flag system
- Small, experienced team

---

## Decision Matrix

**Answer These Questions:**

### 1. Team Size
```
1-5 developers   → GitHub Flow or Trunk-Based
5-15 developers  → GitHub Flow or Git Flow
15+ developers   → Git Flow
```

### 2. Release Frequency
```
Multiple times per day → Trunk-Based
Weekly                 → GitHub Flow
Monthly or less        → Git Flow
```

### 3. Version Management
```
Single version only    → GitHub Flow or Trunk-Based
Multiple versions      → Git Flow only
```

### 4. Testing Capabilities
```
Manual testing only    → Git Flow
Automated tests (30%)  → GitHub Flow
Robust automation      → Trunk-Based Development
```

### 5. Team Experience
```
Git beginners         → GitHub Flow
Git experienced       → Any strategy
Very experienced      → Trunk-Based
```

### 6. Risk Tolerance
```
Very risk-averse      → Git Flow
Medium risk tolerance → GitHub Flow
High confidence       → Trunk-Based
```

---

## Migration Scenarios

### From Git Flow → GitHub Flow

**When to Consider:**
- Team getting smaller
- Can't support multiple versions
- Want faster releases

**Steps:**
1. Mark current develop as main
2. Delete release branches
3. Adjust protection rules
4. Train team on simpler workflow
5. Keep old main as archive (old-main)

### From GitHub Flow → Git Flow

**When to Consider:**
- Supporting multiple versions
- Larger team, need structure
- Formal release process needed

**Steps:**
1. Create develop branch from main
2. Create release/hotfix processes
3. Add branch protection rules
4. Document procedures
5. Train team on new workflow

### To Trunk-Based Development

**When to Consider:**
- Need extreme speed
- High-confidence team
- Mature automation

**Requirements First:**
- ✅ Automated testing (80%+)
- ✅ Continuous deployment
- ✅ Feature flag system
- ✅ Monitoring & alerting
- ✅ Rollback capability

**Steps:**
1. Implement feature flags
2. Build robust automation
3. Shorten branches (max 2 days)
4. Increase commit frequency
5. Reduce PR review time (30 mins)

---

## Implementation Checklist

### Git Flow Setup
- [ ] Create develop branch
- [ ] Create branch protection rules (main & develop)
- [ ] Document release process
- [ ] Set up release checklist
- [ ] Train team on procedures
- [ ] Create hotfix procedures
- [ ] Document versioning scheme

### GitHub Flow Setup
- [ ] Create branch protection on main
- [ ] Require PR reviews (minimum 1-2)
- [ ] Set up status checks
- [ ] Configure auto-deployment
- [ ] Document quick start
- [ ] Create PR template
- [ ] Set up issue linking

### Trunk-Based Setup
- [ ] Implement feature flag system
- [ ] Build automated testing (80%+)
- [ ] Set up continuous deployment
- [ ] Create rollback procedures
- [ ] Implement monitoring & alerting
- [ ] Create deployment dashboard
- [ ] Document feature flag control
- [ ] Train on "small commits" culture

---

## Hybrid Approaches

### Git Flow + GitHub Flow

**Use When:** Need structure + speed

**Approach:**
- Use Git Flow branching (main/develop/feature/release/hotfix)
- Use GitHub Flow review process (quick PR review)
- Release weekly instead of monthly
- Simplify release process

### GitHub Flow + Feature Flags

**Use When:** Single version + need feature control

**Approach:**
- Use GitHub Flow branches
- Add feature flags for major features
- Gradual rollout instead of all-at-once
- Instant rollback if issues

### Trunk-Based + Hotfix Branches

**Use When:** Very fast but need emergency fix isolation

**Approach:**
- Most work directly on main
- Create hotfix branches for critical issues
- Merge hotfix back with priority

---

## Real-World Examples

### Scenario 1: 5-Person Startup

**Challenge:** Move fast, limited QA

**Solution:** GitHub Flow
- Simple workflow
- Automated tests on every PR
- Deploy to staging on branch
- Deploy to production on merge to main
- Rollback: Revert PR

### Scenario 2: 50-Person Enterprise

**Challenge:** Multiple products, versions

**Solution:** Git Flow
- 3 products with different versions
- Feature teams per product
- Formal release process
- Stable hotfix handling
- Clear versioning

### Scenario 3: High-Growth SaaS

**Challenge:** Ship daily, perfect stability

**Solution:** Trunk-Based + Tight Ops
- 90% code on main
- Feature flags for all new work
- Deploy 5-10 times per day
- Rollback in seconds (toggle flag)
- Monitoring alerts on every deploy

---

## Common Mistakes

**Git Flow:**
- ❌ Branches living too long (should be <1 week)
- ❌ No code review on release branches
- ❌ Forgetting to merge hotfix back to develop

**GitHub Flow:**
- ❌ PRs taking too long to review
- ❌ Merging without CI tests passing
- ❌ No clear deployment process
- ❌ Breaking changes on main

**Trunk-Based:**
- ❌ No feature flags (commits block others)
- ❌ Weak automated testing
- ❌ No rollback procedure
- ❌ Forcing on unwilling team

---

## Recommendations

**Start Here:**
1. Most teams: **GitHub Flow** (good balance)
2. Enterprise: **Git Flow** (proven, structured)
3. Startups: **Trunk-Based** (once mature)

**Key Success Factors:**
- ✅ Clear documentation
- ✅ Team training
- ✅ Tool support (GitHub Actions)
- ✅ Regular review & adjustment
- ✅ Metrics (lead time, deployment frequency)

---

**Next Steps:**
1. Discuss with your team
2. Choose strategy
3. Set up [branch protection rules](../docs/06-main-branch.md)
4. Create procedures
5. Train team
6. Monitor and adjust

**Related:**
- [Git Flow Guide](../docs/02-branching-strategy.md)
- [Branching Workflow](../docs/03-branching-workflow.md)
- [Main Branch Rules](../docs/06-main-branch.md)
- [Command Reference](./Command-Reference.md)
