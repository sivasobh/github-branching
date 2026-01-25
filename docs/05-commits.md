# 5. Commit Best Practices

## What Makes a Good Commit

A good commit is atomic, focused, and well-documented. It represents a single logical change that could be reverted independently.

---

## Commit Message Standards

### The Seven Rules of Great Commit Messages

1. **Separate subject from body with a blank line**
2. **Limit the subject line to 50 characters**
3. **Capitalize the subject line**
4. **Do not end the subject line with a period**
5. **Use imperative mood in the subject line**
6. **Wrap the body at 72 characters**
7. **Use the body to explain what and why, not how**

### Commit Message Format

```
<type>(<scope>): <subject>

<body>

<footer>
```

---

## Types of Commits

### Conventional Commits Standard

```bash
# Feature
git commit -m "feat(auth): add user login functionality"

# Bug fix
git commit -m "fix(api): resolve timeout issue in user endpoint"

# Documentation
git commit -m "docs(readme): update installation instructions"

# Style
git commit -m "style(ui): format button styles consistently"

# Refactoring
git commit -m "refactor(core): simplify authentication logic"

# Performance
git commit -m "perf(database): optimize user query with indexing"

# Testing
git commit -m "test(auth): add unit tests for login module"

# Chore
git commit -m "chore(deps): upgrade dependencies to latest versions"

# CI/CD
git commit -m "ci(github): add automated testing workflow"
```

### Type Definitions

| Type | Purpose | Example |
|------|---------|---------|
| **feat** | New feature | Add payment processing |
| **fix** | Bug fix | Fix null pointer error |
| **docs** | Documentation | Update API docs |
| **style** | Code style (no logic change) | Fix indentation |
| **refactor** | Code refactoring | Extract method |
| **perf** | Performance improvement | Cache results |
| **test** | Testing additions | Add unit tests |
| **chore** | Maintenance/dependencies | Update npm packages |
| **ci** | CI/CD changes | Add GitHub Actions |

---

## Good Commit Examples

### Example 1: Simple Feature

```
feat(cart): add item quantity selector

Users can now adjust item quantities directly in the shopping 
cart without navigating to product details. This improves the 
checkout experience by reducing steps.
```

### Example 2: Bug Fix with Details

```
fix(auth): prevent session hijacking with token refresh

The previous implementation did not refresh authentication tokens,
making sessions vulnerable to hijacking attacks. Now tokens are
refreshed every 15 minutes, and expired tokens trigger re-login.

Fixes #123
```

### Example 3: Performance Improvement

```
perf(images): implement lazy loading for product galleries

Product page load time decreased from 3.2s to 1.1s by deferring
image loading until they come into viewport. Only visible images
are loaded immediately.

Related: #456
```

---

## Bad Commit Examples

### ❌ Too Vague
```
update things
fixed bugs
changes
it works now
```

### ❌ Too Long Subject Line
```
Add the new authentication system with support for OAuth, JWT, 
two-factor authentication, and session management with cookie 
handling and token refresh endpoints
```

### ❌ No Context
```
asdf
wip
temp fix
todo: check this later
```

### ❌ Multiple Unrelated Changes
```
fix(api): resolve timeout + update styles + add comments + fix typo
```

---

## Atomic Commits

### What is Atomic?

An atomic commit is indivisible - it can be reverted without breaking functionality.

### Good Atomic Commits
```
Commit 1: refactor(auth): extract password validation logic
Commit 2: feat(auth): add password strength indicator
Commit 3: test(auth): add tests for password validation
```

Each can be reverted independently without breaking anything.

### Bad Non-Atomic Commits
```
Commit: Added auth feature, fixed database bug, updated styles, 
        and refactored payment module
```

If you need to revert only the auth feature, you can't without affecting others.

---

## Commit Organization Workflow

### Before Committing: Check Your Changes

```bash
# See all changes
git diff

# See staged changes
git diff --staged

# See changes by file
git diff --stat

# See changes interactively
git diff -p
```

### Staging Selectively

```bash
# Stage specific file
git add src/auth.js

# Stage specific lines (interactive)
git add -p

# Stage all of a type
git add *.js

# Stage all changes
git add .
```

### Commit Workflow Example

```bash
# File has multiple unrelated changes:
# auth.js: Added login feature + Fixed typo in comment

# Stage only login feature
git add -p auth.js
# Select only auth changes, skip typo fix

# Commit login feature
git commit -m "feat(auth): add user login functionality"

# Stage remaining changes
git add -p auth.js
# Select typo fix

# Commit typo separately
git commit -m "fix(auth): correct comment typo"
```

---

## Writing Better Commit Messages

### Use the Editor Instead of -m

```bash
# Opens your default editor for longer messages
git commit

# Allows multi-line messages with formatting
# Much better for complex changes
```

### Template for Body Text

```
Explain the problem that this commit is solving. 
Focus on WHY you are making the change, not HOW or WHAT.

The code is already in the commit - you don't need to describe
what the code does. Instead, explain:
- Why this change was needed
- What alternatives were considered
- What the impact is
- Any important context

If this fixes a bug, explain:
- How the bug manifested
- Why it happened  
- How the fix prevents it
```

### Linking to Issues

```bash
# Reference issue in commit message
git commit -m "feat(auth): add 2FA support

Implements two-factor authentication using TOTP.
Users can enable 2FA in account settings.

Fixes #234
Closes #235
Related to #236"

# Keywords that work:
# - close, closes, closed
# - fix, fixes, fixed  
# - resolve, resolves, resolved
# - Related to
```

---

## Fixing Commits

### Fix Last Commit Message

```bash
# Amend the message
git commit --amend -m "new message"

# Amend with editor
git commit --amend
```

### Fix Last Commit Content

```bash
# Made a mistake in last commit
git add forgotten_file.js

# Add to last commit without new commit
git commit --amend --no-edit
```

### Fix Multiple Commits with Interactive Rebase

```bash
# Change messages of last 3 commits
git rebase -i HEAD~3

# Mark commits to edit:
# e abc1234 Old message 1
# e def5678 Old message 2
# pick ghi9012 Message 3

# Git will stop at each, let you amend
# After editing each, continue:
git rebase --continue
```

---

## Commit Frequency Guidelines

### Too Frequent (Too Many Commits)
```
Commit 1: Type "a"
Commit 2: Type "b"  
Commit 3: Delete "b", type "c"
Commit 4: Add space
Commit 5: Actually implement feature
```

### Too Infrequent (Too Few Commits)
```
Commit 1: Added auth, payment, redesigned UI, fixed 5 bugs,
          refactored core, updated docs, added tests
```

### Just Right (Balanced)
```
Commit 1: feat(auth): implement user login
Commit 2: feat(auth): add password reset
Commit 3: test(auth): add login integration tests
```

---

## Viewing Commits Effectively

```bash
# View commits with diff
git log -p

# View commits with changed files
git log --stat

# View commits graphically
git log --graph --oneline --all

# View commits by author
git log --author="John Doe"

# View commits in date range
git log --since="2 weeks ago" --until="now"

# Search commit messages
git log --grep="auth"

# Search for code changes
git log -S "function_name" -p
```

---

## Next Steps
→ Continue to [06-main-branch.md](06-main-branch.md) to learn about the main/production branch.
