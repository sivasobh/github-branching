# Command Reference - Git Commands

Quick reference for essential Git commands organized by task.

## Setup & Configuration

**Initial Setup**
```bash
git config --global user.name "Your Name"
git config --global user.email "your.email@example.com"
```

**Check Configuration**
```bash
git config --global --list
```

**Clone a Repository**
```bash
git clone https://github.com/user/repo.git
git clone git@github.com:user/repo.git          # SSH
cd repo
```

---

## Daily Workflow

**See Current Status**
```bash
git status                      # Show all changes
git status -s                   # Short format
```

**View Changes**
```bash
git diff                        # Unstaged changes
git diff --staged               # Staged changes
git diff main                   # Changes vs main branch
```

**Stage Changes**
```bash
git add filename                # Stage specific file
git add .                       # Stage all changes
git add -p                      # Stage parts of file (interactive)
```

**Unstage Changes**
```bash
git reset filename              # Unstage file
git reset                       # Unstage all
```

**Commit**
```bash
git commit -m "message"         # Simple commit
git commit -m "feat: desc"      # Conventional format
git commit --amend              # Fix last commit
```

**Push to Remote**
```bash
git push origin branch-name     # Push branch
git push origin                 # Push current branch
git push --all                  # Push all branches
```

**Pull from Remote**
```bash
git pull origin main            # Fetch + merge
git fetch origin                # Just fetch (safe)
git pull --rebase               # Fetch + rebase (linear)
```

---

## Branches

**List Branches**
```bash
git branch                      # List local branches
git branch -a                   # List all (local + remote)
git branch -v                   # Show last commit on each
```

**Create Branch**
```bash
git branch feature/my-feature   # Create locally
git checkout -b feature/my-feature  # Create + switch
```

**Switch Branches**
```bash
git checkout main               # Switch to main
git checkout -                  # Switch to previous branch
git switch develop              # Modern syntax
```

**Delete Branch**
```bash
git branch -d feature/my-feature    # Delete locally (safe)
git branch -D feature/my-feature    # Force delete
git push origin --delete feature/my-feature  # Delete remote
```

**Rename Branch**
```bash
git branch -m old-name new-name # Rename locally
git push origin --delete old-name
git push origin new-name
```

**Track Remote Branch**
```bash
git checkout --track origin/feature/branch  # Create local + track
git branch -u origin/main                   # Start tracking
```

---

## Commits

**View Commit History**
```bash
git log                         # Full log
git log --oneline               # Shortened
git log -n 5                    # Last 5 commits
git log --graph --all --oneline # Visual tree
git log feature/branch          # Log for specific branch
```

**View Specific Commit**
```bash
git show commit-hash            # Show commit details
git show commit-hash:file.js    # Show file at that commit
```

**Find Commits**
```bash
git log --grep="keyword"        # Search commit messages
git log --author="name"         # Commits by author
git blame file.js               # Who changed each line
```

**Undo Changes**
```bash
git checkout -- file.js         # Discard changes (before commit)
git reset filename              # Unstage file
git reset --soft HEAD~1         # Undo last commit (keep changes)
git reset --hard HEAD~1         # Undo last commit (lose changes)
```

**Revert Commit**
```bash
git revert commit-hash          # Create new commit undoing changes
```

---

## Merging

**Merge Branch**
```bash
git checkout main               # Switch to target
git pull origin main            # Get latest
git merge feature/my-feature    # Merge feature in
```

**Merge with No Fast Forward**
```bash
git merge --no-ff feature/name  # Preserves branch history
```

**Squash Merge**
```bash
git merge --squash feature/name # Combine commits into one
git commit -m "feat: ..."
```

**Abort Merge**
```bash
git merge --abort               # Cancel in-progress merge
```

---

## Rebasing

**Rebase Branch**
```bash
git checkout feature/branch
git rebase main                 # Replay on latest main
git rebase -i HEAD~3            # Interactive rebase last 3
```

**During Rebase Conflict**
```bash
git rebase --abort              # Cancel rebase
git rebase --continue           # After resolving conflicts
```

**Rebase with Main Updates**
```bash
git fetch origin
git rebase origin/main          # Replay on latest remote
```

---

## Stashing

**Save Work Temporarily**
```bash
git stash                       # Stash all changes
git stash save "description"    # Stash with message
git stash list                  # Show all stashes
```

**Restore Stashed Work**
```bash
git stash pop                   # Restore latest stash
git stash apply stash@{0}       # Apply without removing
git stash drop stash@{0}        # Delete stash
```

---

## Tags

**Create Tag**
```bash
git tag v1.0.0                  # Lightweight tag
git tag -a v1.0.0 -m "message" # Annotated tag
git tag -a v1.0.0 commit-hash   # Tag specific commit
```

**List Tags**
```bash
git tag                         # List all tags
git tag -l "v1.*"               # Filter by pattern
git show v1.0.0                 # Show tag details
```

**Push Tags**
```bash
git push origin v1.0.0          # Push specific tag
git push origin --tags          # Push all tags
```

**Delete Tag**
```bash
git tag -d v1.0.0               # Delete locally
git push origin --delete v1.0.0 # Delete remote
```

---

## Cherry Picking

**Apply Specific Commit**
```bash
git cherry-pick commit-hash     # Apply single commit
git cherry-pick commit1 commit2 # Apply multiple
```

**Resolve Cherry Pick Conflict**
```bash
git cherry-pick --abort         # Cancel
git cherry-pick --continue      # Resume after fix
```

---

## Remote Operations

**View Remotes**
```bash
git remote                      # List remotes
git remote -v                   # Show URLs
git remote show origin          # Detailed info
```

**Add Remote**
```bash
git remote add upstream https://github.com/original/repo.git
```

**Change Remote**
```bash
git remote set-url origin new-url
```

**Fetch from Specific Remote**
```bash
git fetch origin                # Get latest
git fetch upstream              # From upstream repo
```

---

## Searching & History

**Find Deleted Content**
```bash
git log -S "text"               # Commits adding/removing "text"
git log --follow file.js        # Follow file renames
```

**Show Previous Versions**
```bash
git show commit-hash:file.js    # Content at specific commit
git show HEAD~3:file.js         # File 3 commits ago
```

**Get Specific File from Another Branch**
```bash
git checkout main -- file.js    # Get file from main
```

---

## Cleanup

**Remove Untracked Files**
```bash
git clean -fd                   # Remove untracked files
git clean -fX                   # Remove ignored files
```

**Remove Commits from Local**
```bash
git reset --hard origin/main    # Discard all, match remote
```

**Delete Merged Branches**
```bash
git branch -d feature/done      # Delete merged branch
git branch -D feature/done      # Force delete
```

---

## Advanced

**Interactive Rebase (Combine/Reorder/Edit)**
```bash
git rebase -i HEAD~5            # Last 5 commits
# Options in editor:
# pick = use commit
# reword = edit message
# squash = combine with previous
# drop = remove
```

**See Branch Differences**
```bash
git log main..feature/branch    # Commits in feature not in main
git log --left-right --graph main...feature/branch
```

**Export Patch**
```bash
git diff main > changes.patch   # Create patch file
git apply changes.patch         # Apply patch elsewhere
```

**Bisect (Find Breaking Commit)**
```bash
git bisect start
git bisect bad HEAD
git bisect good v1.0.0
# Git will check out commits between good/bad
# Mark each: git bisect good/bad
git bisect reset
```

---

## Undoing Things Summary

| Scenario | Command |
|----------|---------|
| Unstage file | `git reset filename` |
| Discard local changes | `git checkout -- file` |
| Undo last commit (keep changes) | `git reset --soft HEAD~1` |
| Undo last commit (lose changes) | `git reset --hard HEAD~1` |
| Undo pushed commit | `git revert commit-hash` |
| Abort in-progress merge | `git merge --abort` |
| Abort in-progress rebase | `git rebase --abort` |
| Undo stash | `git stash pop` |
| Restore to match remote | `git reset --hard origin/main` |

---

## Common Workflows

**Complete Feature Development**
```bash
# 1. Create branch from develop
git checkout develop
git pull origin develop
git checkout -b feature/my-feature

# 2. Make changes and commit
git add .
git commit -m "feat: add login form"

# 3. Push to GitHub
git push origin feature/my-feature

# 4. Create PR on GitHub (via web UI)

# 5. After merge, delete branch
git branch -d feature/my-feature
git push origin --delete feature/my-feature
```

**Release Process**
```bash
# 1. Create release branch
git checkout main
git pull origin main
git checkout -b release/v1.2.0

# 2. Update version numbers, commit
git commit -m "chore: bump version to 1.2.0"

# 3. Create PR and merge to main
git push origin release/v1.2.0
# → Create PR, approve, merge on GitHub
# → Auto-tags as v1.2.0

# 4. Merge back to develop
git checkout develop
git pull origin main
git merge release/v1.2.0
git push origin develop
```

**Hotfix**
```bash
# 1. Create hotfix from main
git checkout main
git pull origin main
git checkout -b hotfix/v1.2.1

# 2. Fix bug and commit
git commit -m "fix: critical security issue"

# 3. Merge to main (auto-tags v1.2.1)
git push origin hotfix/v1.2.1
# → Create PR, merge to main on GitHub

# 4. Merge back to develop
git checkout develop
git pull origin main
git merge hotfix/v1.2.1
git push origin develop
```

**Sync Fork with Upstream**
```bash
git fetch upstream
git checkout main
git merge upstream/main
git push origin main
```

---

## Configuration Tips

**Set Default Branch**
```bash
git config --global init.defaultBranch main
```

**Create Aliases**
```bash
git config --global alias.co checkout
git config --global alias.br branch
git config --global alias.ci commit
git config --global alias.st status
git config --global alias.log-oneline "log --oneline"
```

**Then use:**
```bash
git co main                     # Instead of: git checkout main
git st                          # Instead of: git status
```

---

**Need more help?** See [FAQ](./FAQ.md) | [Glossary](./Glossary.md) | [Home](./Home.md)
