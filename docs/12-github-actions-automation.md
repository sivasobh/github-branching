# 12. GitHub Actions Automation for Git Flow & Versioning

## Overview

GitHub Actions provides powerful automation for:
- **Semantic versioning** - Automatic version tagging based on commit messages
- **Branch protection** - Enforcing Git Flow strategy and naming conventions
- **Release automation** - Creating releases from release branches
- **Hotfix automation** - Managing emergency production fixes

This guide explains the workflows and how to use them.

---

## 1. Version Tagging Workflow (`version-tagging.yml`)

### What It Does

Automatically creates semantic version tags on commits to `main` and `develop` branches.

**Features:**
- Reads conventional commit messages to determine version bump
- Creates annotated git tags with metadata
- Updates version files (package.json, pom.xml, version.txt)
- Creates GitHub releases automatically
- Sends Slack notifications

### Triggering the Workflow

**Automatic (on push to main or develop):**
```bash
# Push to main - creates MAJOR/MINOR/PATCH tag
git push origin main

# Push to develop - creates development snapshot tag
git push origin develop
```

**Manual trigger via GitHub UI:**
1. Go to Actions → Semantic Versioning & Auto-Tagging
2. Click "Run workflow"
3. Select version type: major, minor, or patch
4. Click "Run workflow"

### How Version Incrementation Works

The workflow reads commit messages to determine the version bump:

```
Commit Message Format: type(scope): description

❌ Fix broken password reset feature        → PATCH (fix)
✅ fix(auth): broken password reset         → PATCH
✅ feat(api): new user endpoint             → MINOR
✅ feat(api)!: redesigned API endpoints     → MAJOR (breaking)
✅ feat!: complete rewrite                  → MAJOR (breaking)
```

#### Conventional Commit Types

| Type | Version | Example |
|------|---------|---------|
| `feat:` | MINOR | `feat(dashboard): add export to CSV` |
| `fix:` | PATCH | `fix(auth): resolve login timeout` |
| `feat!:` | MAJOR | `feat(api)!: change endpoint structure` |
| `refactor!:` | MAJOR | `refactor!: restructure database schema` |

**Breaking Changes:**
- Use `!` before the colon to indicate breaking change
- Automatically triggers MAJOR version bump
- Example: `feat(api)!: change authentication endpoint`

### Version Incrementation Logic

```
Current: v1.2.3
Commits since tag:
  - feat(dashboard): add export       → MINOR
  - fix(auth): timeout issue          → PATCH
  - feat(api): new endpoint           → MINOR

Result: v1.3.0 (MINOR takes precedence)
```

### Manual Version Override

You can override automatic detection by manually triggering:

```
1. Go to Actions tab
2. Select "Semantic Versioning & Auto-Tagging"
3. Click "Run workflow"
4. Choose version type: major, minor, or patch
5. Click "Run workflow"
```

### Output

**What gets created:**
- Git tag: `v1.2.3`
- GitHub release with notes
- Updated version files
- Slack notification (if webhook configured)

---

## 2. Branch Protection Workflow (`branch-protection.yml`)

### What It Does

Enforces Git Flow strategy and validates:
- ✅ Branch naming conventions
- ✅ Conventional commit message format
- ✅ Pull request requirements
- ✅ Prevents direct pushes to main/develop

### Branch Naming Validation

**Valid branch names:**

```
✅ feature/user-authentication       → New feature
✅ feature/PROJ-123-dashboard        → Feature with ticket
✅ bugfix/password-reset             → Bug fix
✅ release/v1.0.0                    → Release branch
✅ hotfix/v1.0.1                     → Emergency fix
✅ chore/update-dependencies         → Maintenance
✅ docs/api-documentation            → Documentation
```

**Invalid branch names:**

```
❌ feature/UserAuthentication        → Use lowercase
❌ Feature/authentication             → Use lowercase
❌ my feature branch                  → No spaces
❌ feature_authentication             → Use hyphens, not underscores
❌ release/1.0.0                      → Must include 'v'
```

### Commit Message Validation

The workflow checks that commits follow Conventional Commits format:

**Format:**
```
type(scope): description

feat(auth): add password reset feature
fix(api): resolve null pointer exception
docs(readme): update installation steps
```

**Valid types:**
- `feat` - New feature
- `fix` - Bug fix
- `docs` - Documentation
- `style` - Code formatting
- `refactor` - Code restructuring
- `perf` - Performance improvement
- `test` - Tests
- `chore` - Build, dependencies, etc.
- `ci` - CI/CD changes
- `revert` - Revert previous commit

**Breaking changes:**
```
feat(api)!: change authentication method
refactor!: restructure database schema
```

### What Happens on Violations

When you create a PR with invalid branch name or commit message:

1. **GitHub check fails** ❌
2. **Bot comments on PR** with details
3. **PR can't be merged** until fixed
4. **Guide provided** on how to fix

### How to Fix Violations

**Rename branch:**
```bash
git branch -m old-branch-name feature/new-feature-name
git push origin feature/new-feature-name
```

**Fix commit message:**
```bash
git commit --amend -m "feat(auth): fix password reset flow"
git push origin --force-with-lease
```

---

## 3. Release Automation Workflow (`release-automation.yml`)

### What It Does

Automates the release process when pushing to `release/*` branches.

**Steps:**
1. ✅ Validates release branch name (release/v1.0.0)
2. ✅ Extracts version number
3. ✅ Generates changelog from commits
4. ✅ Creates GitHub release
5. ✅ Creates PRs for merging to main and develop
6. ✅ Sends Slack notification

### How to Create a Release

**Step 1: Create release branch from develop**
```bash
git checkout develop
git pull origin develop
git checkout -b release/v1.1.0
```

**Step 2: Prepare release**
```bash
# Update version numbers
echo "1.1.0" > version.txt

# Update package.json (npm automatically)
npm version 1.1.0 --no-git-tag-version

# Update CHANGELOG
# Add new version header with changes
```

**Step 3: Push to GitHub**
```bash
git add version.txt package.json CHANGELOG.md
git commit -m "chore(release): prepare v1.1.0 release"
git push -u origin release/v1.1.0
```

**Step 4: Workflow runs automatically**
- Release branch triggers the workflow
- GitHub release created
- Two PRs created (merge to main and develop)
- Team notified

**Step 5: Merge PRs**
```bash
# Merge to main first (production)
# Then merge to develop
# Delete release branch
```

### Release Branch Naming

**Format:** `release/v<MAJOR>.<MINOR>.<PATCH>`

```
✅ release/v1.0.0          → First release
✅ release/v1.1.0          → Minor feature release
✅ release/v2.0.0          → Major breaking release
✅ release/v1.0.1          → Should use hotfix instead
```

**Important:** Use `hotfix/` for patch releases, not `release/`

---

## 4. Hotfix Automation Workflow (`hotfix-automation.yml`)

### What It Does

Automates emergency production fixes.

**Triggers:**
- Push to `hotfix/*` branches
- Automatically validates and creates release

**Features:**
- ✅ Validates hotfix branch name
- ✅ Checks commits are minimal
- ✅ Creates patch version tag
- ✅ Generates hotfix release notes
- ✅ Creates PRs for merging
- ✅ Sends CRITICAL alerts

### How to Create a Hotfix

**Step 1: Create hotfix branch from main**
```bash
git checkout main
git pull origin main
git checkout -b hotfix/v1.0.1
```

**Step 2: Fix the issue**
```bash
# Make minimal changes to fix the critical issue
git add .
git commit -m "fix(payment): critical payment processing bug"
```

**Step 3: Test thoroughly**
```bash
npm test
# or
pytest
# or
mvn test
```

**Step 4: Push to GitHub**
```bash
git push -u origin hotfix/v1.0.1
```

**Step 5: Workflow runs automatically**
- Hotfix branch triggers workflow
- Release created with CRITICAL alert
- Two PRs created (merge to main and develop)
- Team alerted on Slack
- Incident ticket created

**Step 6: Merge immediately**
```bash
# Merge to main first (production)
git checkout main
git merge --no-ff hotfix/v1.0.1
git push origin main

# Deploy to production immediately
# Then sync to develop
git checkout develop
git merge --no-ff hotfix/v1.0.1
git push origin develop
```

### Hotfix Branch Naming

**Format:** `hotfix/v<MAJOR>.<MINOR>.<PATCH>`

```
✅ hotfix/v1.0.1           → First hotfix for v1.0.0
✅ hotfix/v1.0.2           → Second hotfix
✅ hotfix/v1.1.1           → Hotfix for v1.1.0

❌ hotfix/v2.0.0           → Should use release/
❌ hotfix/v1.0             → Must include patch version
```

---

## 5. Complete Git Flow Example with Automation

### Month Timeline

```
Week 1: Feature Development
├─ Create feature/dashboard branch
├─ Make commits with conventional messages
├─ Push: git push origin feature/dashboard
└─ Create PR → Merge to develop

Week 2: More Features
├─ Multiple feature branches active
├─ All follow commit convention
├─ Merge PRs to develop as complete
└─ Develop branch accumulates features

Week 3: Release Preparation
├─ Create release/v1.1.0 from develop
├─ Update version files
├─ Workflow creates release
│  ├─ GitHub release created
│  ├─ Changelog generated
│  └─ PRs created for main/develop
└─ Team reviews and merges PR to main

Week 4: Production & Hotfix
├─ Main branch tagged: v1.1.0
├─ Deployed to production
├─ Bug discovered in production
├─ Create hotfix/v1.1.1 from main
├─ Workflow runs:
│  ├─ Creates v1.1.1 release
│  ├─ Critical alert sent
│  ├─ PRs created
│  └─ Incident ticket opened
├─ Merge to main → Deploy immediately
└─ Merge to develop for sync
```

---

## 6. Setting Up Workflows in Your Repository

### Step 1: Add Workflow Files

Copy all `.yml` files to your repository:

```
your-repo/
├── .github/
│   └── workflows/
│       ├── version-tagging.yml
│       ├── branch-protection.yml
│       ├── release-automation.yml
│       └── hotfix-automation.yml
```

### Step 2: Push to GitHub

```bash
git add .github/workflows/
git commit -m "ci: add GitHub Actions workflows"
git push origin main
```

### Step 3: Enable GitHub Actions

1. Go to your repository Settings
2. Select "Actions"
3. Ensure "Actions permissions" is enabled
4. Workflows should now be available

### Step 4: Configure Secrets (Optional)

For Slack notifications, add:

1. Go to Settings → Secrets and variables → Actions
2. Click "New repository secret"
3. Name: `SLACK_WEBHOOK`
4. Value: Your Slack webhook URL (e.g., https://hooks.slack.com/services/...)
5. Click "Add secret"

### Step 5: Test Workflows

**Test branch protection:**
```bash
# Create feature branch
git checkout -b feature/test-workflow
# Try commit with bad message
git commit -m "bad commit message"
# Create PR → Should fail
```

**Test version tagging:**
```bash
# On develop branch
git commit -m "feat(api): test feature"
git push origin develop
# Check Actions tab → version-tagging should run
```

---

## 7. Workflow Monitoring & Troubleshooting

### View Workflow Status

1. Go to repository → Actions tab
2. Select workflow name
3. View recent runs
4. Click run to see detailed logs

### Common Issues

**Workflow doesn't run:**
- ✓ Check `.github/workflows/` directory exists
- ✓ Files are `.yml` format (not `.yaml`)
- ✓ GitHub Actions is enabled in Settings
- ✓ Branch filter matches (main, develop, etc.)

**Tags not created:**
- ✓ Check commit messages follow conventional format
- ✓ Verify branch is `main` or `develop`
- ✓ Check workflow logs for errors
- ✓ Ensure no duplicate tag already exists

**Slack notification not sent:**
- ✓ Add `SLACK_WEBHOOK` secret to repository
- ✓ Verify webhook URL is valid
- ✓ Check workflow permissions allow notifications

### Viewing Logs

```
Repository → Actions tab → Select workflow run → View logs
```

---

## 8. Best Practices with GitHub Actions

### DO's ✅

- ✅ Use conventional commits for automatic versioning
- ✅ Protect main and develop branches
- ✅ Require status checks to pass
- ✅ Require PR reviews before merge
- ✅ Use hotfix for critical production issues only
- ✅ Deploy releases after main merge
- ✅ Test before pushing to release/hotfix branches
- ✅ Monitor workflow runs regularly

### DON'Ts ❌

- ❌ Skip commit message convention
- ❌ Push directly to main or develop
- ❌ Use release/ for patch versions (use hotfix/)
- ❌ Merge hotfix without immediate deployment
- ❌ Forget to merge hotfix back to develop
- ❌ Disable branch protection
- ❌ Create hotfix from develop (must be from main)
- ❌ Manually delete tags

---

## 9. Integration with Development Tools

### Pre-commit Hook (Optional)

Validate commits locally before pushing:

```bash
# .git/hooks/pre-commit
#!/bin/bash

COMMIT_MSG=$(git diff --cached --diff-filter=ACM -z | git apply --cached --unidiff-zero | head -1)

if ! [[ $COMMIT_MSG =~ ^(feat|fix|docs|style|refactor|perf|test|chore|ci|revert)(\(.+\))?!?: ]]; then
  echo "❌ Commit message must follow Conventional Commits format"
  echo "Examples:"
  echo "  feat(auth): add password reset"
  echo "  fix(api): resolve null pointer"
  exit 1
fi
```

### VS Code Extension

Install "Conventional Commits" extension for automatic formatting.

---

## 10. Customization Guide

### Modifying Version File Locations

Edit `version-tagging.yml`:

```yaml
env:
  VERSION_FILE: 'version.txt'
  PACKAGE_JSON: 'package.json'
  POM_FILE: 'pom.xml'
```

Change paths for your project structure.

### Adding Custom Release Notes

Edit `release-automation.yml` to customize release note format.

### Changing Slack Channel

Edit notifications section to target different channels.

---

## Summary

**GitHub Actions workflows automate:**
1. **Version tagging** - Semantic versioning from commits
2. **Branch protection** - Enforcing Git Flow strategy
3. **Release automation** - Creating releases from branches
4. **Hotfix automation** - Managing emergency fixes

**Key benefits:**
- ✅ Consistency - Same process every time
- ✅ Speed - Automated release creation
- ✅ Safety - Protection rules enforced
- ✅ Visibility - Team notifications
- ✅ Compliance - Audit trail of all releases

**Next steps:**
1. Copy workflow files to `.github/workflows/`
2. Configure Slack webhook (optional)
3. Set branch protection rules in GitHub
4. Test with a feature branch
5. Create first release following the process

