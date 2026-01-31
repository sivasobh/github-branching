# Feature Development - Creating & Managing Features

Step-by-step guide for developing features in a team environment.

---

## Overview

**Feature Development Process:**
```
1. Plan & Discuss
   ↓
2. Create Feature Branch
   ↓
3. Develop & Commit
   ↓
4. Push & Create PR
   ↓
5. Code Review
   ↓
6. Address Feedback
   ↓
7. Merge to Develop/Main
   ↓
8. Verify in Staging
   ↓
9. Release to Production
```

---

## 1. Before You Start

**Prerequisites:**
- [ ] Feature is in backlog/assigned to you
- [ ] You understand requirements
- [ ] You have latest code locally
- [ ] You're on develop/main branch

**Get Latest Code:**
```bash
git checkout develop
git pull origin develop
```

---

## 2. Create Feature Branch

**Branch Naming Convention:**
```
feature/feature-name
feature/user-authentication
feature/dashboard-redesign
feature/payment-processing
```

**Create Branch:**
```bash
git checkout develop
git checkout -b feature/my-feature
```

**Push to Remote (Optional, but recommended):**
```bash
git push origin feature/my-feature
```

---

## 3. Develop & Commit

### Make Your Changes

```bash
# Edit files
# Save them

# See what changed
git status

# See the differences
git diff
```

### Commit Frequently

**Golden Rules:**
- ✅ Commit after completing each logical unit
- ✅ Write clear commit messages
- ✅ Test before committing
- ✅ One feature = multiple focused commits

**Good Commit Patterns:**
```bash
# Commit 1: Add form structure
git add form.html
git commit -m "feat: add login form structure"

# Commit 2: Add form validation
git add form-validation.js
git commit -m "feat: add email validation"

# Commit 3: Style the form
git add form.css
git commit -m "style: style login form"

# Commit 4: Add error messages
git add form.js
git commit -m "feat: add form error messages"
```

**Bad Commit Pattern:**
```bash
# ❌ One huge commit with everything
git add .
git commit -m "did the thing"
```

### Use Conventional Commits

**Format:**
```
type(scope): description

Optional: longer explanation
- Detail 1
- Detail 2

Related issues:
Fixes #123
Relates to #456
```

**Types:**
- `feat` - New feature
- `fix` - Bug fix
- `refactor` - Code reorganization
- `style` - Formatting, not logic
- `docs` - Documentation
- `test` - Tests
- `chore` - Build, config, etc.

**Examples:**
```
feat(auth): add password reset flow

Users can now reset forgotten passwords via email.

- Send reset email with token
- Validate token expiry (24 hours)
- Allow new password entry
- Log password change

Fixes #123
```

```
fix(api): handle null response gracefully

The API endpoint was crashing when external service returned null.
Now we show a user-friendly error message instead.

Fixes #456
Relates to #457
```

---

## 4. Push & Create Pull Request

**Push Your Branch:**
```bash
# Push first time (sets upstream)
git push -u origin feature/my-feature

# Push subsequent commits
git push origin feature/my-feature
```

**Create Pull Request:**

1. Go to GitHub repository
2. Click "Pull requests" tab
3. Click "New pull request"
4. Select:
   - **Base**: develop (or main, depending on strategy)
   - **Compare**: feature/my-feature
5. Click "Create pull request"

**Write PR Description:**
```markdown
## What
Added user password reset feature

## Why
Users need way to regain account access if password forgotten.
Currently have no reset mechanism.

## How to Test
1. Go to login page
2. Click "Forgot password?"
3. Enter email address
4. Check email for reset link
5. Click link and set new password
6. Login with new password

## Screenshots
[Add before/after screenshots]

## Related Issues
Fixes #123

## Checklist
- [x] Tests added/updated
- [x] Documentation updated
- [x] No breaking changes
- [x] Code follows style guide
```

---

## 5. Code Review

**What Happens:**
1. Team reviews your code
2. Automated tests run
3. Code quality checks run
4. Reviewers provide feedback

**Common Feedback:**
- "Can you add more error handling?"
- "This could be simpler by..."
- "Could you add tests for..."
- "Add comment explaining why..."

**During Review:**
- ✅ Respond to questions
- ✅ Don't take feedback personally
- ✅ Ask clarifying questions
- ✅ Discuss alternatives

---

## 6. Address Feedback

**If Changes Needed:**

```bash
# Make the changes
# Edit the files

# Commit (don't create new branch!)
git add .
git commit -m "refactor: simplify logic per review feedback"

# Push to same branch
git push origin feature/my-feature
```

**PR Automatically Updates** with new commits.

**Iterate Until Approved:**
- Get feedback → Make changes → Push → Repeat

---

## 7. Merge to Develop/Main

**Once Approved:**

1. All comments resolved ✅
2. All tests passing ✅
3. Approved by minimum reviewers ✅
4. No conflicts ✅

**Merge:**

**Option A: Merge Commit (Preserves history)**
```bash
git checkout develop
git pull origin develop
git merge --no-ff feature/my-feature
git push origin develop
```

**Option B: Via GitHub (Recommended)**
- Click "Merge pull request" on GitHub
- Choose merge type (merge, squash, rebase)
- Click confirm
- Delete branch

**Branch is deleted** (usually auto-cleanup)

---

## 8. Verify in Staging

**Before Production:**

```bash
# Pull latest
git checkout develop
git pull origin develop

# Verify changes
git log --oneline -5

# Check out feature to test
git checkout feature/my-feature
npm install                    # if needed
npm start                      # run locally
```

**Test Locally:**
- [ ] Feature works as described
- [ ] No errors in console
- [ ] Styling looks correct
- [ ] Tested on multiple browsers/devices

---

## 9. Release to Production

**For Git Flow:**

```bash
# Create release branch
git checkout -b release/v1.2.0 develop

# Update version
# Update CHANGELOG

# Commit
git commit -m "chore: prepare v1.2.0 release"

# Push and create PR to main
git push origin release/v1.2.0
```

**For GitHub Flow:**

Feature is automatically released when merged to main (if auto-deployment enabled)

---

## Complete Example Workflow

```bash
# 1. Start from develop
git checkout develop
git pull origin develop

# 2. Create feature branch
git checkout -b feature/user-auth

# 3. Make changes and commit (multiple commits)
# ... edit files ...
git add .
git commit -m "feat(auth): add login form"

# ... edit more files ...
git add .
git commit -m "feat(auth): add email validation"

# ... style changes ...
git add .
git commit -m "style(auth): style login form"

# 4. Push to GitHub
git push -u origin feature/user-auth

# 5. Create PR on GitHub (via web UI)
# (Add description, request reviewers)

# 6. Get feedback, make changes
# ... edit files based on feedback ...
git add .
git commit -m "refactor: simplify validation per feedback"
git push origin feature/user-auth

# 7. PR is approved and merged

# 8. Delete branch locally
git checkout develop
git pull origin develop
git branch -d feature/user-auth

# 9. Delete branch on GitHub
git push origin --delete feature/user-auth
```

---

## Branching Strategies

### Git Flow
```
feature/my-feature → develop (PR) → main (release) → production
```

### GitHub Flow
```
feature/my-feature → main (PR) → production (auto)
```

### Trunk-Based
```
short-lived-branch → main (quick PR) → production (immediate)
```

See [Choosing Your Strategy](./Choosing-Your-Strategy.md) for details.

---

## Best Practices

### ✅ DO

- ✅ Create branch from latest develop/main
- ✅ Commit frequently with clear messages
- ✅ Push regularly (don't wait until end)
- ✅ Keep branches short-lived (<5 days)
- ✅ Keep commits small and focused
- ✅ Test thoroughly before PR
- ✅ Respond to review feedback
- ✅ Delete branches after merge
- ✅ Write clear commit messages
- ✅ Link to related issues

### ❌ DON'T

- ❌ Commit directly to main/develop
- ❌ Create massive branches (50+ commits)
- ❌ Commit and push without testing
- ❌ Write vague commit messages ("stuff", "fixed it")
- ❌ Ignore code review feedback
- ❌ Merge without approval
- ❌ Mix multiple features in one branch
- ❌ Leave huge time gaps between commits
- ❌ Rewrite history on shared branches
- ❌ Force push to main/develop

---

## Common Issues

**Q: How long should a feature branch live?**
A: Ideally < 5 days. Longer = more conflicts.

**Q: Can I work on multiple features at once?**
A: Create separate branches for each feature.

**Q: What if main updated while I was working?**
A: Pull latest and merge: `git merge origin/main`

**Q: Do I commit tests?**
A: Yes! Tests are code too. Commit them with feature.

**Q: Can I commit unfinished code?**
A: Only if you mark it with `TODO` or use feature flags.

---

## Related Guides

- [Commit Message Guide](./Commit-Message-Guide.md)
- [Code Review Guidelines](./Code-Review-Guidelines.md)
- [Troubleshooting](./Troubleshooting.md)
- [Command Reference](./Command-Reference.md)
- [Choosing Your Strategy](./Choosing-Your-Strategy.md)

---

**Main Navigation:** [Home](./Home.md) | [Quick Start](./Quick-Start.md) | [FAQ](./FAQ.md)
