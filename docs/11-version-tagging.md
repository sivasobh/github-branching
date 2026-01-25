# 11. Git Version Tagging & Semantic Versioning

## Overview

Version tagging is a critical practice in software development that identifies specific release points in your repository. Combined with semantic versioning, it provides a clear, standardized way to communicate changes to your software users and team members.

**What You'll Learn:**
- Semantic versioning fundamentals (MAJOR.MINOR.PATCH)
- How version tagging integrates with your Git workflow
- Version incrementation rules for different branch types
- Best practices for managing versions across all branches
- Real-world examples and diagrams

---

## 1. Semantic Versioning Fundamentals

### Version Number Format: MAJOR.MINOR.PATCH

```
v2.5.3
 │ │ │
 │ │ └─ PATCH (Hotfix/Bug fixes)
 │ └─── MINOR (New features, backwards compatible)
 └───── MAJOR (Breaking changes, incompatible API changes)
```

### Semantic Versioning Rules

| Component | Increments When | Example | Reset When |
|-----------|-----------------|---------|-----------|
| **MAJOR** | Breaking changes, incompatible changes | v1.0.0 → v2.0.0 | Major version bumped |
| **MINOR** | New features added (backwards compatible) | v2.0.0 → v2.1.0 | Major incremented or feature added |
| **PATCH** | Bug fixes, patches, hotfixes | v2.1.0 → v2.1.1 | Feature or major release |

### When to Increment Each Version Component

**MAJOR.0.0** - Breaking Changes
- Removing/changing API endpoints
- Changing function signatures incompatibly
- Database schema breaking changes
- Removing deprecated features
- Major architectural changes

**major.MINOR.0** - New Features (Backwards Compatible)
- Adding new endpoints/functions
- Extending existing features
- Performance improvements
- Non-breaking enhancements
- New configuration options

**major.minor.PATCH** - Bug Fixes (No New Features)
- Fixing bugs/defects
- Hotfixes for production issues
- Patch security vulnerabilities
- Minor updates to documentation
- Internal refactoring

---

## 2. Versioning Strategy by Branch

### Main Branch (Production)

**Purpose:** Stable, production-ready releases only
**Version Tags:** MAJOR.MINOR.PATCH (semantic versioning)
**Who Tags:** Release manager, CI/CD pipeline, team lead
**When to Tag:** Every production release

```
Main Branch Timeline:
┌─────────────────────────────────────────────────────────────┐
│ v1.0.0 (Initial)  v1.0.1 (Hotfix)  v1.1.0 (Release)        │
│    ↓                  ↓                 ↓                    │
├─────[o]───────────────[o]─────────────[o]──────────────────┤
│     │                  │                │                    │
│  Features             Bug Fix        New Features             │
│  Complete            From Hotfix    From Release              │
│                      Branch         Branch                    │
└─────────────────────────────────────────────────────────────┘

All main branch commits are tagged with version numbers.
Each tag represents a production release.
```

**Versioning Rules for Main:**
- v1.0.0 for initial release
- v1.x.y for all subsequent releases
- Tag with annotated tags: `git tag -a v1.0.0 -m "Release version 1.0.0"`
- Only merge from release and hotfix branches
- Never commit directly to main

**Example Version Progression on Main:**
```
Initial Release:        v1.0.0
First Hotfix:          v1.0.1
First New Feature Set: v1.1.0
Second Hotfix:         v1.1.1
Second Feature Set:    v1.2.0
Breaking Changes:      v2.0.0
```

### Release Branch

**Purpose:** Final testing and preparation for production
**Version Tags:** Pre-release tags (optional)
**Who Tags:** Release manager, QA lead
**When to Tag:** Release branch creation and post-testing

```
Release Branch Pattern:
┌─ release/v1.1.0
│  ├─ Version bump to v1.1.0
│  ├─ Update CHANGELOG
│  ├─ Testing & QA
│  └─ Tag: v1.1.0-rc.1 (Release Candidate 1)
│     Tag: v1.1.0-rc.2 (if issues found)
│     Tag: v1.1.0 (final, merged to main)
```

**Versioning Rules for Release:**
- Create from develop branch with version number
- Branch name: `release/v1.1.0`
- Pre-release tags: `v1.1.0-rc.1`, `v1.1.0-rc.2`, etc.
- Update version numbers in code (package.json, pom.xml, etc.)
- Update CHANGELOG with new features and fixes
- Final tag (v1.1.0) after successful QA

**Pre-release Version Format:**
```
v1.1.0-alpha.1    ← Early development
v1.1.0-beta.1     ← Feature complete, testing
v1.1.0-rc.1       ← Release candidate (final testing)
v1.1.0            ← Stable release
```

### Develop Branch

**Purpose:** Integration point for features
**Version Tags:** Development/snapshot versions (optional)
**Who Tags:** CI/CD pipeline, team lead
**When to Tag:** Periodic snapshots, before major merges

```
Develop Branch Pattern:
┌─────────────────────────────────────────┐
│ dev snapshot tags (optional)             │
│ v1.1.0-dev.20260125 (date-based)        │
│ v1.1.0-dev.1, v1.1.0-dev.2, etc. (seq)  │
└─────────────────────────────────────────┘
```

**Versioning Rules for Develop:**
- Version matches next planned release (v1.1.0)
- Optional snapshot tags: `v1.1.0-dev.1`
- Date-based format: `v1.1.0-dev.20260125`
- Build number: `v1.1.0-dev.build.42`
- Useful for CI/CD to reference build artifacts

### Feature Branches

**Purpose:** Isolated development of individual features
**Version Tags:** Not typically tagged
**Who Tags:** Usually not tagged directly
**When to Tag:** Only if branch needs to be shareable

```
Feature Branch Pattern (No Tags):
┌─ feature/user-authentication
│  ├─ Multiple commits
│  ├─ Work in progress
│  └─ No version tags
```

**Versioning Rules for Feature:**
- No formal version tags
- May use branch name references
- If tagged for sharing: `feature/user-auth-v1`
- Naming: `feature/auth-service` or `feature/PROJ-123`

### Hotfix Branch

**Purpose:** Critical production fixes
**Version Tags:** Patch version tags
**Who Tags:** Release manager, on-call engineer
**When to Tag:** Hotfix completion and merge

```
Hotfix Branch Pattern:
┌─ hotfix/v1.0.1
│  ├─ Critical bug fix
│  ├─ Minimal testing
│  ├─ Tag: v1.0.1 (on main merge)
│  └─ Also merge to develop
│
└─ Increments PATCH version only
```

**Versioning Rules for Hotfix:**
- Branch name includes version: `hotfix/v1.0.1`
- Only increments PATCH version (bug fixes)
- Created from main branch
- Tag immediately after merge to main
- Also merge back to develop
- Example: v1.0.0 → v1.0.1 (patch only)

---

## 3. Version Incrementation Rules

### Decision Tree for Version Bumps

```
                    What changes are included?
                            │
            ┌───────────────┼───────────────┐
            │               │               │
      Breaking?         New Features?    Bug Fixes Only?
            │               │               │
           YES              YES             YES
            │               │               │
         MAJOR           MINOR           PATCH
        v1.0.0 →       v1.0.0 →       v1.0.0 →
        v2.0.0         v1.1.0         v1.0.1
```

### Real-World Incrementation Examples

**Scenario 1: Regular Feature Release**
```
Previous Release:      v1.0.0
Features added:        ✅ New user dashboard
                       ✅ Export to CSV
Bugs fixed:            ✅ Login timeout issue
Breaking changes:      ❌ No

New version:           v1.1.0 (MINOR increment)

Logic: New backwards-compatible features → MINOR
Bug fixes don't affect version increment when features are added.
```

**Scenario 2: Critical Bug on Production**
```
Current Release:       v1.2.3
Bug:                   Payment processing failing
Type:                  Critical hotfix
Breaking changes:      ❌ No

New version:           v1.2.4 (PATCH increment)

Logic: Hotfix only → PATCH
No new features, just bug fix.
```

**Scenario 3: Major Refactoring**
```
Current Release:       v2.1.5
Changes:               API endpoint structure changed
                       Database schema redesigned
                       Old endpoints removed
Breaking changes:      ✅ YES

New version:           v3.0.0 (MAJOR increment)

Logic: Breaking changes → MAJOR
Users must update their integrations.
```

**Scenario 4: Security Patch Release**
```
Current Release:       v2.3.1
Security Issue:        Critical vulnerability in dependency
Type:                  CVE patch
Breaking changes:      ❌ No

New version:           v2.3.2 (PATCH increment)

Logic: Security fix with no new features → PATCH
Customers should update immediately.
```

**Scenario 5: Major Release from Develop**
```
Current Release:       v1.5.2
Develop contains:      ✅ New API redesign (breaking)
                       ✅ Microservices refactoring
                       ✅ 15+ new features
Breaking changes:      ✅ YES

New version:           v2.0.0 (MAJOR increment)

Logic: Accumulated breaking changes → MAJOR
Create release/v2.0.0 for final testing.
Then tag v2.0.0 on main after merge.
```

---

## 4. Version Tagging Workflow by Branch Type

### Feature Development → Release → Production

```
Timeline:     Month 1                Month 2

DEVELOP       ─────[●]─────[●]─────[●]─────
              Features from        All features
              feature branches      tested & ready

RELEASE       ───────────────────[release/v1.1.0]─
              (created from develop)   Testing    

MAIN          ─────[v1.0.0]──────────────[v1.1.0]─
              Initial release    New features merged

              Tag Timeline:
              v1.0.0 = Initial release (MAJOR.MINOR.PATCH)
              v1.1.0 = First feature release (MINOR increment)

              Commands:
              git tag -a v1.0.0 -m "Release v1.0.0: Initial release"
              git tag -a v1.1.0 -m "Release v1.1.0: User dashboard, CSV export"
```

### Hotfix During Release Cycle

```
Timeline:     Week 1          Week 2          Week 3

DEVELOP       ─[●]───[●]──────[●]──────────[●]───
              Feature work    Features        Resume feature
                              paused          development

RELEASE       ─────[release/v1.1.0]─────────────
              Testing phase        QA approved

HOTFIX        ─────────[●][hotfix/v1.0.1][●]─
                        ↓ Critical issue
                    Created from main
                    When: In-flight release

MAIN          ─[v1.0.0]───────────────────[v1.0.1]─
              Initial                   Hotfix merged
              
              Tag Timeline:
              v1.0.1 = Hotfix release (PATCH increment)
              
              git tag -a v1.0.1 -m "Release v1.0.1: Critical bug fix"
```

### Emergency Production Hotfix

```
Timeline:     Day 1          Day 2          Day 3

MAIN          ─[v2.1.0]──────[CRITICAL BUG]────[v2.1.1]─
              Normal ops   Users reporting    Fix deployed
                          issue

HOTFIX        ─────────────[hotfix/v2.1.1]─
              (created immediately from main)
              │ ├─ Diagnose (30 min)
              │ ├─ Fix (1 hour)
              │ ├─ Quick test (30 min)
              │ └─ Deploy (30 min)

DEVELOP       ─[●]────────[●]──────────[●]─
              (continues normally)
              (gets hotfix merged back)

              Tag Timeline:
              v2.1.1 = Emergency hotfix (PATCH increment)
              
              Commands:
              git tag -a v2.1.1 -m "Release v2.1.1: Emergency fix for payment issue"
              git push origin v2.1.1
```

---

## 5. Version Tagging Commands

### Creating Version Tags

```bash
# Annotated tag (recommended for releases)
git tag -a v1.0.0 -m "Release version 1.0.0: Initial production release"

# Lightweight tag (simple, no metadata)
git tag v1.0.0

# Tag a specific commit (not HEAD)
git tag -a v1.0.0 abc1234 -m "Release v1.0.0"

# Sign tag with GPG (secure)
git tag -s v1.0.0 -m "Release v1.0.0"

# Push single tag
git push origin v1.0.0

# Push all tags
git push origin --tags

# Delete local tag
git tag -d v1.0.0

# Delete remote tag
git push origin --delete v1.0.0
```

### Version Tag Naming Conventions

```
Stable Release:        v1.0.0
                       v1.1.0
                       v2.0.0

Pre-release (Alpha):   v1.1.0-alpha.1
                       v1.1.0-alpha.2

Pre-release (Beta):    v1.1.0-beta.1
                       v1.1.0-beta.2

Release Candidate:     v1.1.0-rc.1
                       v1.1.0-rc.2

Build/Development:     v1.1.0-dev.20260125
                       v1.1.0-build.42
```

### Viewing Tags and Versions

```bash
# List all tags
git tag

# List tags matching pattern
git tag -l "v1.*"

# Show tag details
git show v1.0.0

# Show tags with commit info
git tag -n

# Show commits from specific tag
git log v1.0.0..HEAD

# Show changes between versions
git diff v1.0.0..v1.1.0

# Show commits in specific version
git log v1.0.0^..v1.0.0
```

---

## 6. Version Management Best Practices

### DO's ✅

- ✅ **Use Semantic Versioning consistently** - Provides clarity to users
- ✅ **Tag all production releases** - Enables quick rollbacks
- ✅ **Update version in code files** - Matches git tags with actual code
- ✅ **Maintain CHANGELOG** - Document what changed in each version
- ✅ **Use annotated tags** - Includes metadata and is more secure
- ✅ **Sign releases** - Use GPG signing for security
- ✅ **Create release notes** - Describe features, fixes, breaking changes
- ✅ **Plan major versions** - Announce breaking changes in advance
- ✅ **Document version support** - Indicate LTS versions or EOL dates
- ✅ **Tag from release/main branch** - Never from feature branches

### DON'Ts ❌

- ❌ **Don't skip version numbers** - Creates confusion
- ❌ **Don't tag feature branches** - Reserve tags for releases
- ❌ **Don't change tags** - Tags are immutable milestones
- ❌ **Don't use vague versions** - Be clear about MAJOR.MINOR.PATCH
- ❌ **Don't bump major without migration guide** - Breaking changes need documentation
- ❌ **Don't release directly from develop** - Use release branch for final testing
- ❌ **Don't forget to merge hotfixes back** - Must update develop branch
- ❌ **Don't mix conventions** - Stick to one versioning approach
- ❌ **Don't deprecate silently** - Announce removal in advance

---

## 7. Real-World Example: Year-Long Project

```
Month 1:  v1.0.0 released
          - Initial feature set
          - 5 developers
          
Month 2:  v1.0.1 hotfix
          - Critical bug found 2 weeks post-release
          
Month 3:  v1.1.0 released
          - 8 new features added
          - Performance improvements
          
Month 4:  v1.1.1 hotfix
          - Security patch
          
Month 5:  v1.2.0 released
          - 5 new features
          - UI redesign (non-breaking)
          
Month 6:  v1.2.1, v1.2.2 hotfixes
          - 2 production issues
          
Month 7:  v2.0.0 released
          - API redesign (breaking changes)
          - Database schema rewrite
          - 10+ new features
          
Month 8:  v2.0.1, v2.1.0
          - Hotfix + new features
          
Month 9-12: Continued releases
          - Regular MINOR versions for features
          - PATCH versions for critical bugs
          - 1-2 MAJOR versions for strategic changes

Version Timeline:
v1.0.0 ──→ v1.0.1 ──→ v1.1.0 ──→ v1.1.1 ──→ v1.2.0 ──→ v1.2.1 ──→ 
v1.2.2 ──→ v2.0.0 ──→ v2.0.1 ──→ v2.1.0 ──→ v2.1.1 ──→ v2.2.0 ──→ v2.3.0
```

---

## 8. Integration with CI/CD

### Automatic Version Tagging

Many CI/CD systems can automatically create tags:

```yaml
# Example: GitHub Actions
- name: Create Release Tag
  if: github.event_name == 'push' && github.ref == 'refs/heads/main'
  run: |
    VERSION=$(cat version.txt)
    git tag -a $VERSION -m "Release $VERSION"
    git push origin $VERSION
```

### Build Artifacts with Version Tags

```bash
# Docker image versioning
docker build -t myapp:v1.0.0 .
docker build -t myapp:latest .

# Versioned releases
Release: v1.0.0
├── myapp-1.0.0.jar
├── myapp-1.0.0.tar.gz
└── Release_Notes_v1.0.0.md
```

---

## 9. Version Tagging in Team Context

### Communication Pattern

**Developer:**
- Works on feature branch
- No tagging responsibility

**Release Manager:**
- Creates release branch
- Creates and manages version tags
- Communicates version changes to team

**DevOps:**
- Deploys tagged versions
- Monitors production releases
- Triggers rollbacks if needed

**QA:**
- Tests specific tagged versions
- Reports on version stability
- Validates hotfixes

### Version Communication

```
To Team:
"v1.1.0 has been released with the following:

✨ New Features:
  - User dashboard
  - CSV export

🐛 Bug Fixes:
  - Login timeout issue
  - Password reset flow

📊 Performance:
  - 20% faster page loads

⚠️  Breaking Changes: None

📅 Release Date: Jan 25, 2026
🔗 Changelog: github.com/org/repo/releases/tag/v1.1.0
"
```

---

## 10. Common Versioning Scenarios

### Scenario: Parallel Release Branches

```
v1.0.x branch (LTS support)  ─[●]─[v1.0.1]─[●]─[v1.0.2]
                              Maintenance only

v1.1.x branch (Standard)     ─────[v1.1.0]─[●]─[v1.1.1]─[●]
                              Feature + hotfix

v2.0.x branch (Latest)       ────────────────[v2.0.0]─[●]
                              New development
```

### Scenario: Security Release

```
Normal Release:    v1.2.3
Security Advisory: CVE discovered in v1.2.3
Action:           Release v1.2.4 with security patch
Also:             Release v2.0.1 (if 2.0 also affected)
                  Release v2.1.0 (if 2.1 also affected)

Affected Users:
- v1.2.x users → update to v1.2.4
- v2.0.x users → update to v2.0.1
- v2.1.x users → update to v2.1.0
```

### Scenario: Sunset Old Version

```
Version Timeline:
v1.0.0 ─────────────────────────┐
(Maintained)                     │
                                 ├─ Overlap
v2.0.0 ──────────────────────────┤ period: 6 months
(New Major)                      │
                                 │
Jan 2025: v2.0.0 released
Jul 2025: v1.0.x becomes unsupported
- Announce 6 months in advance
- Provide clear migration guide
- Maintain security patches during overlap
```

---

## Summary

**Key Takeaways:**

1. **Semantic Versioning** - MAJOR.MINOR.PATCH is the universal standard
2. **Branch-Specific Tagging** - Different branches have different versioning needs
3. **Incrementation Rules** - Clear logic for when to bump versions
4. **Release Workflow** - Plan versions before release branch creation
5. **Hotfix Strategy** - Quick patches don't affect feature versioning
6. **Communication** - Always document what changed in each version
7. **Automation** - Use CI/CD to create and manage version tags
8. **LTS Versions** - Consider long-term support versions for critical software

**Next Steps:**
- Implement semantic versioning in your project
- Update version numbers in your codebase
- Create tags for all releases
- Maintain a CHANGELOG file
- Document your version support policy

