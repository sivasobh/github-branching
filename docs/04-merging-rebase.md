# 4. Merge vs Rebase

## Understanding the Difference

Both merge and rebase integrate changes from one branch into another, but they work differently and produce different histories.

---

## Merging

### How Merge Works

Merge combines two branches by creating a new commit that has two parent commits (merge commit).

```
BEFORE:
  develop:    A ─── B ─── C
                    │
  feature:         D ─── E

AFTER (merge commit):
  develop:    A ─── B ─── C ─── M (merge commit)
              │           │   / 
              └─── D ─── E ───
```

### Merge Command

```bash
# Switch to target branch
git checkout develop

# Merge feature branch
git merge feature/user-auth

# This creates a merge commit automatically
```

### Types of Merges

#### 1. Three-Way Merge (Creates merge commit)
```bash
# Default merge when branches have diverged
git merge feature/branch
# Result: Creates merge commit with two parents
```

#### 2. Fast-Forward Merge (No merge commit)
```bash
# Happens when feature branch is ahead but on same line
git merge --ff feature/branch
# Result: Moves pointer forward, no new commit
```

#### 3. Forced Merge Commit
```bash
# Always create merge commit, even if fast-forward possible
git merge --no-ff feature/branch
# Result: Creates explicit merge commit (recommended for Git Flow)
```

#### 4. Squash Merge (Combines all commits)
```bash
# Squash all commits into one before merging
git merge --squash feature/branch
# Still need to commit after squashing
```

### Merge Advantages
✓ Preserves complete history
✓ Non-destructive operation
✓ Clearly shows when features merged
✓ Easy to revert entire feature
✓ Safe for shared branches

### Merge Disadvantages
✗ Creates merge commits (can clutter history)
✗ Less linear history
✗ Harder to read with many branches
✗ More commits to review

---

## Rebasing

### How Rebase Works

Rebase replays your commits on top of another branch. It rewrites history to create a linear progression.

```
BEFORE:
  develop:    A ─── B ─── C
                    │
  feature:         D ─── E

AFTER (rebase):
  develop:    A ─── B ─── C
                          │
  feature:               D' ─── E'
                        (replayed commits)
```

### Rebase Command

```bash
# Switch to feature branch
git checkout feature/user-auth

# Rebase onto develop
git rebase develop

# Result: D and E are replayed on top of C
```

### Interactive Rebase

```bash
# Rebase last 3 commits interactively
git rebase -i HEAD~3

# Available options:
# p (pick)     - use commit
# r (reword)   - use commit but edit message
# s (squash)   - combine with previous commit
# f (fixup)    - like squash but discard log message
# d (drop)     - remove commit
# e (edit)     - pause for amending

# Example editor shows:
# pick abc1234 First commit
# squash def5678 Second commit  
# pick ghi9012 Third commit
```

### Rebase with Merge

```bash
# Rebase feature onto develop, then merge with --no-ff
git checkout feature/branch
git rebase develop
git checkout develop
git merge --no-ff feature/branch
```

### Rebase Advantages
✓ Linear, clean history
✓ Easier to understand commit sequence
✓ Fewer merge commits
✓ Simpler to review changes
✓ Easier to find bugs with git bisect

### Rebase Disadvantages
✗ Rewrites history (changes commit hashes)
✗ Can be dangerous with shared branches
✗ Requires force push
✗ Harder to recover from mistakes
✗ Less clear when features integrated

---

## Merge vs Rebase Decision Tree

```
                    Merge or Rebase?
                           │
                           ▼
                  Is it a shared branch?
                    /              \
                  YES              NO
                  │                │
                  ▼                ▼
                MERGE          Should history
              (default)        be linear?
                               /        \
                             YES       NO
                             │         │
                             ▼         ▼
                          REBASE    MERGE
                       (interactive) (ok)
```

---

## Practical Examples

### Example 1: Feature Development (Rebase)

```bash
# Recommended flow for feature branches
# 1. Create feature from main
git checkout main
git pull origin main
git checkout -b feature/dark-mode

# 2. Make commits
git commit -m "Add dark mode styles"
git commit -m "Add dark mode toggle button"

# 3. Main gets new commits
# 4. Rebase feature onto updated main
git rebase origin/main

# 5. Force push to remote (only on feature branch!)
git push -f origin feature/dark-mode

# 6. Create Pull Request
# 7. Merge with --no-ff on GitHub
```

Result: Linear history, easy to review, clean PR.

---

### Example 2: Git Flow Integration (Merge)

```bash
# Features merge into develop using --no-ff
# 1. Create feature from develop
git checkout develop
git checkout -b feature/auth-module

# 2. Make commits (don't rebase)
git commit -m "Add login form"
git commit -m "Add session validation"

# 3. When ready, merge back to develop
git checkout develop
git merge --no-ff feature/auth-module

# This creates explicit merge commit showing feature integration
```

Result: Clear feature boundaries, merge commit shows integration point.

---

### Example 3: Cleaning Up Commits (Interactive Rebase)

```bash
# Before PR review - fix messy commit history
git log --oneline
# abc1234 Fix typo
# def5678 Add feature
# ghi9012 Fix test
# jkl3456 Add feature continued

# Rebase interactively
git rebase -i HEAD~4

# Change squash for commits to combine:
# pick def5678 Add feature
# squash abc1234 Fix typo
# squash jkl3456 Add feature continued  
# pick ghi9012 Fix test

# Result: Cleaner history with logical commits
```

---

### Example 4: Integrating Changes (Rebase vs Merge)

```bash
# Scenario: develop has new commits, 
# you're on feature branch

# OPTION A: Merge (safe, creates merge commit)
git merge origin/develop
git push origin feature/branch

# OPTION B: Rebase (linear, force push needed)
git rebase origin/develop
git push -f origin feature/branch
```

---

## When to Use Each

### Use MERGE when:
- ✓ Merging to shared branch (main, develop)
- ✓ Using Git Flow
- ✓ Want to preserve all history
- ✓ Collaborating on feature branch
- ✓ Want clear merge point documentation

### Use REBASE when:
- ✓ Feature branch only you're using
- ✓ Want clean linear history
- ✓ Before creating Pull Request
- ✓ Cleaning up local commits
- ✓ Interactive rebase to organize commits

### Use SQUASH when:
- ✓ Feature has many small commits
- ✓ Want single clean commit on main
- ✓ Clean up messy development history

---

## The Golden Rule

```
DO NOT REBASE commits that are shared!
DO REBASE only commits on your feature branch
```

**Example of NOT to do:**
```bash
# BAD: Don't rebase shared develop branch
git checkout develop
git rebase -i main  # ❌ WRONG! breaks for others

# GOOD: Rebase only your feature branch
git checkout feature/branch
git rebase develop  # ✓ Correct
```

---

## Next Steps
→ Continue to [05-commits.md](05-commits.md) to learn commit best practices.
