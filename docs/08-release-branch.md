# 8. Release Branch

## What is a Release Branch?

A release branch is created when you're preparing for a new production release. It branches from `develop` and allows for final testing, bug fixes, and version updates before merging to `main`.

---

## Release Branch Purpose

```
Timeline:
develop branch   ─ ─ ─ ── Various features ──

                      ↓ Create when ready
                      
release/x.x.x ────── Final bug fixes & version bump ──┐
                                                      ↓
main (production) ────────────────────── ● v1.2.0 ────
```

---

## Release Branch Workflow

### Step 1: Decide to Release

```bash
# Check develop status
git checkout develop
git pull origin develop

# See what's new since last release
git log --oneline main..develop

# Decide: Ready to release?
# - Are all planned features complete?
# - Do all tests pass?
# - Is documentation updated?
```

### Step 2: Create Release Branch

```bash
# Create release branch from develop
git checkout develop
git pull origin develop
git checkout -b release/1.2.0

# Update version numbers
# Typically in these files:
# - package.json (Node.js)
# - pom.xml (Java/Maven)
# - setup.py (Python)
# - Cargo.toml (Rust)
# - build.gradle (Android/Gradle)

# Example for Node.js
vim package.json
# Change: "version": "1.1.0" → "version": "1.2.0"

git add package.json
git commit -m "Bump version to 1.2.0"
```

### Step 3: Testing and Fixes

```bash
# On release branch, ONLY:
# ✓ Version bumps
# ✓ Critical bug fixes
# ✓ Documentation updates
# ✗ New features (go to develop)
# ✗ Major refactoring (goes to develop)

# Example: Critical bug found during testing
git commit -m "fix(release): correct database connection leak"
git commit -m "docs: update release notes for 1.2.0"

# Push release branch
git push -u origin release/1.2.0
```

### Step 4: Update Changelog

```bash
# Update CHANGELOG.md
cat > CHANGELOG.md << 'EOF'
# Changelog

## [1.2.0] - 2026-01-25

### Added
- New authentication module
- User profile management
- Email notifications

### Fixed
- Database connection timeout
- Memory leak in image processing
- Session validation bypass

### Changed
- Improved API response time by 30%
- Updated dependencies to latest versions

### Removed
- Legacy authentication method

## [1.1.0] - 2026-01-10
...
EOF

git add CHANGELOG.md
git commit -m "docs: update changelog for 1.2.0"
git push origin release/1.2.0
```

### Step 5: Final Testing

On release branch:
```
Staging Environment Checklist:
┌─────────────────────────────┐
│ ✓ Deploy release branch     │
│ ✓ Run full test suite       │
│ ✓ Smoke tests               │
│ ✓ Performance tests         │
│ ✓ Security scans            │
│ ✓ Load testing              │
│ ✓ Compatibility testing     │
│ ✓ Documentation review      │
│ ✓ User acceptance testing   │
└─────────────────────────────┘
```

### Step 6: Release to Production

#### Create Release Tag

```bash
# Switch to main
git checkout main
git pull origin main

# Merge release branch (with --no-ff for clear history)
git merge --no-ff release/1.2.0 -m "Release version 1.2.0"

# Create annotated tag
git tag -a v1.2.0 -m "Release version 1.2.0"

# Push to remote
git push origin main
git push origin v1.2.0

# Or push together
git push origin main --tags
```

#### Deploy to Production

```bash
# Automated by CI/CD on tag push
# Manual steps if not automated:

git checkout v1.2.0  # Check out specific version
# Deploy to production servers
# Run deployment tests
# Update monitoring dashboards
# Notify stakeholders
```

### Step 7: Merge Back to Develop

**Critical!** Keep develop and main in sync:

```bash
# Merge release branch back to develop
git checkout develop
git pull origin develop

git merge --no-ff release/1.2.0 -m "Merge release 1.2.0 back to develop"
git push origin develop

# This ensures:
# - Bug fixes are in develop
# - Next release has all previous fixes
# - Develop is ready for new features
```

### Step 8: Cleanup

```bash
# Delete local release branch
git branch -d release/1.2.0

# Delete remote release branch
git push origin --delete release/1.2.0

# Verify deletion
git branch -a | grep release  # Should be empty
```

---

## Release Branch Rules

```
✓ ALLOWED:
├─ Bug fixes found during testing
├─ Version number updates
├─ Documentation updates
├─ Changelog updates
├─ Build configuration changes
└─ Minor dependency updates

✗ NOT ALLOWED:
├─ New features
├─ Major refactoring
├─ Design changes
├─ Large dependency updates
├─ API changes
└─ Breaking changes
```

---

## Release Branch Examples

### Simple Release (No Fixes Needed)

```bash
# Straight path
develop ──→ release/1.2.0 ──→ main (v1.2.0)
  ↓ (merge back)                  ↓
  └──────────────────────────────┘

Time: 1-2 days
Actions: Version bump, changelog, tag
```

### Complex Release (Multiple Fixes)

```bash
develop ──→ release/1.2.0 ──→ fix ──→ fix ──→ main (v1.2.0)
  │            (staging)      │      │       ↓
  │                          └──────┘    (after testing)
  └──────────────────────────────────────────┘ (merge back)

Time: 3-5 days
Actions: Multiple iterations of testing and fixes
```

### Emergency Release (Hotfix Only)

```
If critical bug found just before release:

develop ──→ release/1.2.0 ──→ CRITICAL FIX ──→ main (v1.2.0)
  │                                            ↓
  └────────────────────────────────────────────┘ (merge back)

Quick timeline, immediate release needed
```

---

## Release Versioning

### Semantic Versioning Explained

```
v MAJOR . MINOR . PATCH
  │       │       │
  │       │       └─ Bug fixes only (increment)
  │       │          Example: 1.2.0 → 1.2.1
  │       │
  │       └─ New features, backward compatible
  │          Example: 1.2.0 → 1.3.0
  │
  └─ Breaking changes (requires migration)
     Example: 1.2.0 → 2.0.0
```

### Release Naming Conventions

```
Production Release:       v1.2.0
Release Candidate:        v1.2.0-rc.1
Beta Release:             v1.2.0-beta.2
Alpha Release:            v1.2.0-alpha.3
Development Build:        v1.2.0-dev.10
Internal Build:           v1.2.0-internal.1
```

---

## Release Checklist

### Before Release

```
Code Readiness:
□ All features complete
□ All tests passing
□ Code review completed
□ No TODOs in code
□ Dependencies updated

Documentation:
□ README updated
□ API documentation updated
□ CHANGELOG updated
□ User guide updated
□ Migration guide (if breaking changes)

Testing:
□ Unit tests pass
□ Integration tests pass
□ Smoke tests pass
□ Performance tests pass
□ Security scan passed
□ Load testing completed
□ User acceptance testing done

Infrastructure:
□ Deployment scripts tested
□ Rollback procedure tested
□ Monitoring configured
□ Alerts configured
□ Backup strategy verified
```

### During Release

```
□ Create release branch
□ Update version numbers
□ Generate changelog
□ Deploy to staging
□ Run final tests
□ Get approval
□ Merge to main
□ Create version tag
□ Deploy to production
□ Verify in production
□ Announce release
□ Monitor for issues
```

### After Release

```
□ Merge release back to develop
□ Delete release branch
□ Update release notes
□ Notify stakeholders
□ Monitor metrics
□ Update documentation
□ Archive build artifacts
□ Update version schedule
```

---

## Release Cadences

### Planned Release Schedule

```
Sprint-based:     Every 2-3 weeks
Quarterly:        Every 3 months
Monthly:          First of each month
As-needed:        When features are ready

Example Sprint Release:
Week 1-2: Development
Week 3: Bug fixes and testing (release branch)
Week 4: Release to production
Week 5: Monitor and hotfixes if needed
```

### Continuous Release

```
With automated testing and staging:
- Create release branch daily
- Test thoroughly
- Release immediately if passing
- Hotfix if issues found

Advantages: Faster feedback, smaller releases
Challenges: More releases, constant vigilance
```

---

## Handling Release Issues

### Issue During Release Testing

```bash
# On release branch
git commit -m "fix: critical issue found in testing"
git push origin release/1.2.0

# Continue testing
# If all good, proceed with release
# If more issues, repeat fixes
```

### Issue After Release (Use Hotfix)

```bash
# See hotfix documentation (next section)
# Create hotfix from main
# Merge to main as v1.2.1
# Merge back to develop
# Do NOT use release branch after release
```

### Rollback Procedure

```bash
# If critical issue found in production
git checkout main
git reset --hard v1.2.0  # Go back to previous version
git push -f origin main

# OR revert the release commit
git revert <release-commit-hash>
git push origin main

# Investigate issue
# Create hotfix when ready
```

---

## Next Steps
→ Continue to [09-hotfix-branch.md](09-hotfix-branch.md) to learn about hotfix procedures.
