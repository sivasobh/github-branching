# Release Process - Preparing & Deploying Releases

Complete guide for releasing features to production.

---

## Overview

**Release Process Steps:**
```
1. Prepare Release Branch
   ↓
2. Version Bump & Changelog
   ↓
3. Testing & QA
   ↓
4. Create Release PR
   ↓
5. Review & Approve
   ↓
6. Merge to Main & Tag
   ↓
7. Auto-Deploy to Production
   ↓
8. Verify in Production
   ↓
9. Release Announcement
```

---

## 1. Prepare Release Branch

**When to Release:**
- All planned features tested ✅
- Bug fixes completed ✅
- No critical issues ✅
- Team agreement ✅

**Create Release Branch:**

```bash
# Get latest develop
git checkout develop
git pull origin develop

# Create release branch
git checkout -b release/v1.2.0
```

**Branch Naming:**
```
release/v1.2.0      ✅ Semantic versioning
release/v1.1.1      ✅ Patch release
release/version-2.0 ❌ Avoid this format
```

---

## 2. Version Bump & Changelog

### Update Version Numbers

**Where to Update:**
- `package.json` (for Node.js projects)
- `pom.xml` (for Java/Maven projects)
- `build.gradle` (for Java/Gradle projects)
- `version.txt` or similar
- Documentation if needed

**Example package.json:**
```json
{
  "name": "my-app",
  "version": "1.2.0",
  "description": "..."
}
```

### Update Changelog

**Create/Update CHANGELOG.md:**

```markdown
# Changelog

## [1.2.0] - 2024-01-25

### Added
- User password reset feature (#123)
- Dark mode toggle (#456)
- Email notifications system (#789)

### Fixed
- Login timeout after 30 minutes (#120)
- Dashboard loading slowly with 1000+ items (#121)
- Mobile menu not closing on link click (#122)

### Changed
- Updated authentication library to v3.0
- Improved error messages for clarity

### Security
- Updated npm packages for security patches

## [1.1.0] - 2024-01-10

### Added
- Two-factor authentication
- User profile customization

### Fixed
- Password validation regex bug

---

[Keep older releases below]
```

**Commit Changes:**
```bash
git add .
git commit -m "chore: bump version to 1.2.0 and update changelog"
```

---

## 3. Testing & QA

**On Release Branch:**

### Manual Testing

- [ ] All features working
- [ ] No regressions (old features still work)
- [ ] Edge cases handled
- [ ] Error messages clear
- [ ] Performance acceptable
- [ ] Mobile/responsive design works
- [ ] Cross-browser compatibility

### Automated Tests

```bash
npm test
npm run lint
npm run build
```

**Fix Any Issues:**
```bash
# Make fixes
git add .
git commit -m "fix: resolve QA issue with login"
git push origin release/v1.2.0
```

---

## 4. Create Release PR

**Push Release Branch:**
```bash
git push origin release/v1.2.0
```

**Create PR on GitHub:**
- **From**: release/v1.2.0
- **To**: main
- **Title**: "release: v1.2.0"
- **Description**:

```markdown
## Release v1.2.0

**Release Date**: January 25, 2024

### Summary
This release includes user authentication improvements and performance optimizations.

### Features
- User password reset (#123)
- Dark mode toggle (#456)

### Fixes
- Login timeout bug (#120)
- Dashboard performance (#121)

### Testing
- [x] Manual testing completed
- [x] Automated tests passing
- [x] QA approved
- [x] No critical issues

### Deployment
- Merge to main → Auto-tag v1.2.0
- GitHub Actions deploys to production
- Notify team in Slack

### Rollback Plan
If critical issue found:
1. Hotfix branch from main
2. Deploy v1.2.1
3. Revert to v1.1.0 if needed

See CHANGELOG.md for detailed changes.
```

---

## 5. Review & Approve

**What Reviewers Check:**
- ✅ Version bumped correctly
- ✅ Changelog complete and accurate
- ✅ No accidental commits included
- ✅ All tests passing
- ✅ No breaking changes
- ✅ Deployment plan clear

**If Issues Found:**
- Address on release branch
- Push updates
- Re-request review

---

## 6. Merge to Main & Tag

**Option A: Via GitHub UI (Recommended)**

1. Go to PR on GitHub
2. Click "Merge pull request"
3. Choose merge type:
   - "Create a merge commit" ✅ (Recommended for releases)
   - Don't use squash for releases
4. Confirm merge
5. Create tag:

```bash
git tag -a v1.2.0 -m "Release v1.2.0"
git push origin v1.2.0
```

**Option B: Command Line**

```bash
# Merge to main
git checkout main
git pull origin main
git merge --no-ff release/v1.2.0

# Tag the release
git tag -a v1.2.0 -m "Release v1.2.0"

# Push both
git push origin main
git push origin v1.2.0
```

**Verify Tag:**
```bash
git show v1.2.0
```

---

## 7. Auto-Deploy to Production

**GitHub Actions Deployment:**

With our GitHub Actions setup:
1. Tag created automatically triggers deployment
2. Code deployed to production servers
3. Health checks verify deployment
4. Slack notification sent

**Manual Deployment** (if needed):
```bash
# Deploy specific tag
docker pull myapp:v1.2.0
docker run -d myapp:v1.2.0
```

---

## 8. Verify in Production

**Production Checks:**

- [ ] Application loads without errors
- [ ] All features working
- [ ] Database migrations successful (if applicable)
- [ ] Performance metrics normal
- [ ] Error tracking shows no spikes
- [ ] User reports no issues

**Monitor Logs:**
```bash
# View recent logs
kubectl logs -l app=myapp --tail=100

# Check error rates
# (via monitoring dashboard)
```

**Database Verification** (if needed):
```sql
-- Verify migration
SELECT * FROM migration_history ORDER BY date DESC LIMIT 1;

-- Check data integrity
SELECT COUNT(*) FROM users;
```

---

## 9. Release Announcement

**Notify Team:**

**Slack Message:**
```
🚀 Release v1.2.0 is live!

📋 Changes:
• User password reset (#123)
• Dark mode toggle (#456)
• Login timeout fix (#120)

📊 Stats:
• 4 features added
• 3 bugs fixed
• 150+ files changed

🔗 Links:
• Changelog: https://github.com/...
• GitHub Release: https://github.com/.../releases/v1.2.0
• Dashboard: https://monitoring.example.com

Questions? Ask in #dev-support
```

**Create GitHub Release:**

On GitHub, go to Releases:
1. Click "Create release"
2. Select tag: v1.2.0
3. Title: "Release v1.2.0"
4. Description: Copy from CHANGELOG
5. Publish release

---

## Semantic Versioning

**Version Format:** MAJOR.MINOR.PATCH

```
1.2.3
↑ ↑ ↑
| | └─ Patch (bug fixes): 1.2.0 → 1.2.1
| └─── Minor (new features): 1.2.0 → 1.3.0
└───── Major (breaking changes): 1.0.0 → 2.0.0
```

**When to Bump:**
- **MAJOR**: Breaking API changes, incompatible upgrades
  - Example: Removed deprecated function, changed data format
  - Release: v1.0.0 → v2.0.0
  
- **MINOR**: New backwards-compatible features
  - Example: New endpoint, new CLI flag
  - Release: v1.0.0 → v1.1.0
  
- **PATCH**: Bug fixes, internal changes
  - Example: Fixed security vulnerability, optimized query
  - Release: v1.0.0 → v1.0.1

**Pre-release Versions:**
```
v1.2.0-alpha.1      Alpha (early testing)
v1.2.0-beta.1       Beta (limited testing)
v1.2.0-rc.1         Release Candidate (final testing)
v1.2.0              Stable Release
```

---

## Hotfix on Release Branch

**If Bug Found During Release Testing:**

```bash
# On release branch
git checkout release/v1.2.0

# Fix the bug
# ... edit files ...

# Commit fix
git add .
git commit -m "fix: critical bug found during testing"

# Push
git push origin release/v1.2.0
```

Branch stays on GitHub, re-test, then merge as normal.

---

## After Release: Merge Back

**For Git Flow (merge back to develop):**

```bash
# After main merge completes
git checkout develop
git pull origin develop

# Merge release branch back
git merge release/v1.2.0

# Push
git push origin develop

# Delete release branch
git branch -d release/v1.2.0
git push origin --delete release/v1.2.0
```

This ensures develop has all release changes.

---

## Release Checklist

Use this before every release:

**Pre-Release:**
- [ ] All features merged to develop
- [ ] All tests passing
- [ ] Code reviewed and approved
- [ ] No critical open issues
- [ ] Performance benchmarked
- [ ] Documentation updated

**Release Branch:**
- [ ] Branch created from develop
- [ ] Version bumped in all files
- [ ] CHANGELOG updated
- [ ] Tested thoroughly
- [ ] No new commits should be added (only fixes)

**Merge to Main:**
- [ ] All tests passing
- [ ] QA approved
- [ ] PR reviewed
- [ ] Release notes ready
- [ ] Team notified

**Post-Release:**
- [ ] Tag created
- [ ] Deployed to production
- [ ] Production verification passed
- [ ] Team announcement sent
- [ ] Monitoring active

---

## Release Strategies

### Scheduled Release (Monthly)
```
First Monday of each month:
1. Branch from develop
2. Week 1-2: Testing & fixes
3. Week 3: QA & final review
4. Week 4: Deploy to production
```

### Feature-Based Release (When ready)
```
When all features tested:
1. Create release branch
2. 1-2 days testing
3. Deploy to production
4. Immediate release announcement
```

### Continuous Release (Daily)
```
For smaller teams with high confidence:
1. Merge feature to main
2. Automatic tag creation
3. Automatic deployment
4. Continuous monitoring
```

---

## Common Issues

**Q: Version already exists as tag?**
A: You need a new version number. Don't release same version twice.

**Q: Should I release from develop or main?**
A: Create release branch FROM develop, merge TO main.

**Q: What if develop has untested features?**
A: Don't release yet. Only release tested features.

**Q: Can I skip testing?**
A: No. Releasing untested code causes production issues.

**Q: What if critical bug found after release?**
A: Create hotfix branch from main (see Hotfix guide).

---

## Related Guides

- [Choosing Your Strategy](./Choosing-Your-Strategy.md)
- [Feature Development](./Feature-Development.md)
- [Hotfix Procedures](./Hotfix-Procedures.md)
- [Semantic Versioning](./Semantic-Versioning.md)
- [GitHub Actions Setup](./GitHub-Actions.md)

---

**Main Navigation:** [Home](./Home.md) | [Quick Start](./Quick-Start.md) | [FAQ](./FAQ.md)
