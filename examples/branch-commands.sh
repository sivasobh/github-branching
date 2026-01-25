#!/bin/bash

# ============================================================================
# Common Git Branching & Workflow Commands
# ============================================================================
# This file contains useful Git commands organized by topic
# Copy and adapt these commands for your use case
# ============================================================================

# SETUP & CONFIGURATION
# ============================================================================

# Configure your identity
git config --global user.name "Your Name"
git config --global user.email "your@email.com"

# View your configuration
git config --global --list

# Set default editor
git config --global core.editor "vim"

# Create helpful aliases
git config --global alias.st status
git config --global alias.co checkout
git config --global alias.br branch
git config --global alias.ci commit
git config --global alias.unstage 'reset HEAD --'
git config --global alias.visual 'log --oneline --graph --all'

# ============================================================================
# REPOSITORY SETUP
# ============================================================================

# Clone a repository
git clone <repository-url>
git clone <repository-url> <local-directory-name>

# Clone a specific branch
git clone -b <branch-name> <repository-url>

# Create a new repository
git init

# View remote repositories
git remote -v
git remote show origin

# Add a remote repository
git remote add origin <repository-url>

# Change remote URL
git remote set-url origin <new-url>

# ============================================================================
# VIEWING STATUS & HISTORY
# ============================================================================

# Check status
git status
git status -s  # Short format

# View commit history
git log
git log --oneline                    # One line per commit
git log --oneline -n 10             # Last 10 commits
git log --graph --oneline --all     # Visual branch history
git log --oneline develop..main     # Commits in main not in develop
git log --oneline main..develop     # Commits in develop not in main

# View specific commit
git show <commit-hash>
git show <commit-hash>:<file-path>  # Show file at specific commit

# View differences
git diff                            # Uncommitted changes
git diff --staged                   # Staged changes
git diff <branch1> <branch2>        # Diff between branches
git diff <commit1> <commit2>        # Diff between commits

# View file history
git log <filename>
git log -p <filename>               # With changes
git log --follow <filename>         # Include renames

# ============================================================================
# BRANCH MANAGEMENT
# ============================================================================

# List branches
git branch                          # Local branches only
git branch -a                       # All branches (local + remote)
git branch -v                       # With last commit info
git branch -a -v                    # All with commit info

# Create branch
git branch <branch-name>
git branch -b <branch-name>         # Create from current branch

# Create branch from specific commit
git branch <branch-name> <commit-hash>

# Switch branches
git checkout <branch-name>
git switch <branch-name>            # Newer syntax

# Create and switch
git checkout -b <branch-name>
git switch -c <branch-name>         # Newer syntax

# Rename branch
git branch -m <old-name> <new-name>
git branch -m <new-name>            # Rename current branch

# Delete branch
git branch -d <branch-name>         # Safe delete (checks if merged)
git branch -D <branch-name>         # Force delete

# Delete remote branch
git push origin --delete <branch-name>
git push origin -d <branch-name>    # Shorter syntax

# Track remote branch
git branch -u origin/<branch-name>
git branch --set-upstream-to=origin/<branch-name>

# ============================================================================
# GIT FLOW FEATURE BRANCH WORKFLOW
# ============================================================================

# Start a feature (from develop)
git checkout develop
git pull origin develop
git checkout -b feature/my-feature

# Work on feature
git add .
git commit -m "feat(module): add new feature"
git push -u origin feature/my-feature

# Keep feature updated with develop
git fetch origin develop
git rebase origin/develop           # Or: git merge origin/develop

# When ready, merge feature to develop
git checkout develop
git pull origin develop
git merge --no-ff feature/my-feature -m "Merge feature/my-feature"
git push origin develop

# Delete feature branch
git branch -d feature/my-feature
git push origin --delete feature/my-feature

# ============================================================================
# STAGING & COMMITTING
# ============================================================================

# Stage files
git add <filename>                  # Stage specific file
git add .                           # Stage all changes
git add *.js                        # Stage all JS files
git add -p                          # Interactive staging

# Unstage files
git reset <filename>
git reset                           # Unstage all

# View staged changes
git diff --staged
git diff --cached                   # Same as above

# Commit changes
git commit -m "message"             # Short message
git commit                          # Opens editor for longer message
git commit -am "message"            # Add + commit tracked files

# Commit with multiple paragraphs
git commit -m "Title" -m "Description" -m "Fixes #123"

# Amend last commit
git commit --amend                  # Edit message and files
git commit --amend --no-edit        # Add files without changing message

# ============================================================================
# MERGING STRATEGIES
# ============================================================================

# Merge with merge commit (recommended for shared branches)
git merge --no-ff <branch-name>
git merge --no-ff <branch-name> -m "Merge message"

# Fast-forward merge
git merge --ff <branch-name>

# Squash merge (combines all commits)
git merge --squash <branch-name>
git commit -m "Squashed feature"

# Merge with conflict resolution strategy
git merge -X theirs <branch-name>   # Keep theirs in conflicts
git merge -X ours <branch-name>     # Keep ours in conflicts

# Abort merge
git merge --abort

# ============================================================================
# REBASING
# ============================================================================

# Rebase current branch on another
git rebase <branch-name>
git rebase origin/develop           # Rebase on remote develop

# Interactive rebase
git rebase -i HEAD~3                # Last 3 commits
git rebase -i <commit-hash>         # Interactive rebase

# Continue after conflict
git rebase --continue

# Abort rebase
git rebase --abort

# Rebase and merge together
git rebase develop
git checkout develop
git merge --no-ff feature/branch

# ============================================================================
# RELEASE BRANCH WORKFLOW
# ============================================================================

# Create release branch
git checkout develop
git pull origin develop
git checkout -b release/1.2.0

# Update version (e.g., in package.json)
# vim package.json
# Then commit
git add package.json
git commit -m "Bump version to 1.2.0"

# Fix bugs on release branch
git commit -m "fix(release): critical bug"

# Merge to main
git checkout main
git pull origin main
git merge --no-ff release/1.2.0 -m "Release 1.2.0"
git tag -a v1.2.0 -m "Release version 1.2.0"
git push origin main
git push origin v1.2.0

# Merge back to develop
git checkout develop
git pull origin develop
git merge --no-ff release/1.2.0 -m "Merge release back to develop"
git push origin develop

# Delete release branch
git branch -d release/1.2.0
git push origin --delete release/1.2.0

# ============================================================================
# HOTFIX BRANCH WORKFLOW
# ============================================================================

# Create hotfix (from main)
git checkout main
git pull origin main
git checkout -b hotfix/critical-bug

# Fix the issue
git commit -m "fix: resolve critical bug"
git commit -m "Bump version to 1.2.1"

# Merge to main
git checkout main
git merge --no-ff hotfix/critical-bug -m "Hotfix: critical bug"
git tag -a v1.2.1 -m "Hotfix 1.2.1"
git push origin main
git push origin v1.2.1

# Merge to develop
git checkout develop
git pull origin develop
git merge --no-ff hotfix/critical-bug -m "Merge hotfix to develop"
git push origin develop

# Delete hotfix
git branch -d hotfix/critical-bug
git push origin --delete hotfix/critical-bug

# ============================================================================
# TAGGING FOR RELEASES
# ============================================================================

# Create annotated tag (recommended)
git tag -a v1.2.0 -m "Release version 1.2.0"

# Create lightweight tag
git tag v1.2.0

# Push tags
git push origin v1.2.0              # Push specific tag
git push origin --tags              # Push all tags

# View tags
git tag
git tag -l "v1.*"                   # List specific tags
git show v1.2.0                     # Show tag details

# Delete tag
git tag -d v1.2.0                   # Delete local tag
git push origin --delete v1.2.0     # Delete remote tag

# ============================================================================
# UNDOING CHANGES
# ============================================================================

# Discard changes in working directory
git checkout <filename>
git checkout .                      # Discard all

# Unstage file
git reset <filename>
git reset                           # Unstage all

# Undo last commit (keep changes)
git reset --soft HEAD~1

# Undo last commit (lose changes)
git reset --hard HEAD~1

# Revert commit (create opposite commit)
git revert <commit-hash>
git revert HEAD                     # Revert last commit

# ============================================================================
# CLEANING UP
# ============================================================================

# List merged branches
git branch --merged

# Delete merged branches
git branch -d $(git branch --merged | grep -v develop | grep -v main)

# Prune remote branches
git remote prune origin
git fetch -p                        # Shorter syntax

# Clean untracked files
git clean -fd                       # Delete untracked directories
git clean -fX                       # Delete ignored files

# ============================================================================
# STASHING
# ============================================================================

# Stash current changes
git stash
git stash save "message"            # With message

# List stashes
git stash list

# Apply stash
git stash apply                     # Apply latest stash
git stash apply stash@{0}          # Apply specific stash

# Pop stash (apply and delete)
git pop
git stash pop stash@{0}            # Specific stash

# Delete stash
git stash drop stash@{0}           # Delete specific
git stash clear                     # Delete all

# ============================================================================
# PUSHING & PULLING
# ============================================================================

# Fetch updates from remote
git fetch                           # All branches
git fetch origin                    # Specific remote
git fetch origin <branch-name>      # Specific branch

# Pull = fetch + merge
git pull                            # Current branch
git pull origin develop             # Specific branch
git pull --rebase                   # Pull with rebase instead of merge

# Push changes
git push                            # Current branch
git push origin <branch-name>       # Specific branch
git push -u origin <branch-name>    # Push and set upstream (-u)
git push origin --all               # All branches

# Force push (dangerous!)
git push -f                         # Force push
git push --force-with-lease         # Safer force push

# Delete remote branch
git push origin --delete <branch-name>
git push origin -d <branch-name>

# ============================================================================
# HELPFUL QUERIES
# ============================================================================

# Branches I created
git branch --contains <your-commits>

# Find where a line was added
git log -S "specific text" --oneline

# Find commits by author
git log --author="John"

# Find commits in date range
git log --since="2 weeks ago" --until="now"
git log --since="2026-01-15" --until="2026-01-25"

# Find commits with specific message
git log --grep="keyword"

# Show who changed each line
git blame <filename>

# ============================================================================
# USEFUL ALIASES TO SETUP
# ============================================================================

# Add these to your git config for faster workflows:

git config --global alias.co checkout
git config --global alias.br branch
git config --global alias.ci commit
git config --global alias.st status
git config --global alias.unstage 'reset HEAD --'
git config --global alias.last 'log -1 HEAD'
git config --global alias.visual 'log --oneline --graph --all'
git config --global alias.amend 'commit --amend --no-edit'
git config --global alias.clean-branches 'branch --merged | grep -v develop | grep -v main | xargs -n 1 git branch -d'

# Then use like:
git co develop           # Instead of: git checkout develop
git ci -m "message"      # Instead of: git commit -m "message"
git br -a                # Instead of: git branch -a
git st                   # Instead of: git status

# ============================================================================
# COMMON WORKFLOWS SUMMARY
# ============================================================================

# Feature branch complete workflow:
# git checkout develop && git pull
# git checkout -b feature/name
# git commit -m "feat: ..."
# git push -u origin feature/name
# [Create PR, get approval]
# git checkout develop && git pull
# git merge --no-ff feature/name
# git push origin develop
# git branch -d feature/name && git push origin --delete feature/name

# Release complete workflow:
# git checkout -b release/1.2.0 && [update version]
# git commit -am "Bump version"
# [test thoroughly]
# git checkout main && git merge --no-ff release/1.2.0
# git tag -a v1.2.0 -m "Release 1.2.0"
# git push origin main --tags
# git checkout develop && git merge --no-ff release/1.2.0
# git push origin develop
# git branch -d release/1.2.0 && git push origin --delete release/1.2.0

# Hotfix complete workflow:
# git checkout main && git checkout -b hotfix/bug
# git commit -m \"fix: ...\"
# git checkout main && git merge --no-ff hotfix/bug
# git tag -a v1.2.1 -m \"Hotfix 1.2.1\"
# git push origin main --tags
# git checkout develop && git merge --no-ff hotfix/bug
# git push origin develop
# git branch -d hotfix/bug && git push origin --delete hotfix/bug

# ============================================================================
# CHERRY PICKING
# ============================================================================

# Cherry pick single commit
git cherry-pick abc1234

# Cherry pick range of commits (from C to E, exclusive of C, inclusive of E)
git cherry-pick C^..E

# Cherry pick multiple specific commits
git cherry-pick abc1234 def5678 ghi9101

# Interactive cherry pick (choose which commits to apply)
git cherry-pick -i abc1234..def5678

# Cherry pick with conflict resolution
git cherry-pick abc1234
# (resolve conflicts in editor)
git add .
git cherry-pick --continue

# Continue cherry pick after resolving conflicts
git cherry-pick --continue

# Skip a problematic commit during cherry pick
git cherry-pick --skip

# Abort cherry pick if issues arise
git cherry-pick --abort

# Show which commits are cherry picked (not merged from other branch)
git log --cherry-pick origin/main..HEAD

# Cherry pick specific commit from another branch
git cherry-pick origin/feature/important-fix

# ============================================================================
# FEATURE FLIPPING / FEATURE FLAGS
# ============================================================================

# Example: Feature flag configuration in code
# 
# JavaScript:
# const featureFlags = {
#   'new-dashboard': true,
#   'dark-mode': false,
#   'premium-feature': true,
#   'beta-features': false
# };
#
# Usage:
# if (featureFlags['new-dashboard']) {
#   renderNewDashboard();
# } else {
#   renderOldDashboard();
# }
#
# With user context:
# const newCheckout = flags.isEnabled('new-checkout', { userId: 123 });
#
# A/B testing variant:
# const variant = flags.getVariant('checkout-button');
# if (variant === 'red-large') {
#   showRedLargeButton();
# } else if (variant === 'blue-small') {
#   showBlueSmallButton();
# }

# Enable feature flag via config file
# echo \"new-checkout: true\" >> features.yml

# Disable feature flag (instant rollback)
# echo \"new-checkout: false\" >> features.yml

# Gradual rollout (5% canary)
# echo \"checkout-rollout-percent: 5\" >> features.yml

# Increase rollout to 50%
# echo \"checkout-rollout-percent: 50\" >> features.yml

# Full rollout to 100%
# echo \"checkout-rollout-percent: 100\" >> features.yml

# ============================================================================
