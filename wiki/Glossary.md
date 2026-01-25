# Glossary - Git & GitHub Terms

A comprehensive glossary of Git and GitHub terminology.

## A

**Amend**
- Modify the last commit without creating a new one
- Command: `git commit --amend`
- Use case: Fixing typos or adding forgotten files

**Atomic Commit**
- A commit that makes one logical change
- Rule: One feature = one commit (or related commits)
- Benefit: Easier to review and revert if needed

**Annotated Tag**
- A tag with metadata (author, date, message)
- More complete than lightweight tags
- Used for official releases

## B

**Base Branch**
- The branch you're merging into
- Example: Merging feature/ INTO develop (develop is base)
- Also called: target branch

**Blame**
- Git tool showing who changed each line
- Command: `git blame filename`
- Use: Tracking when/why changes were made

**Branch**
- An independent line of development
- Points to a specific commit
- Used to work on features separately

**Branch Protection**
- Rules preventing direct commits to important branches
- Example: main branch requires PR review
- Enforcement: Can't merge without approval

## C

**Checkout**
- Switch to a different branch
- Command: `git checkout branch-name`
- Or create new: `git checkout -b new-branch`

**Cherry Pick**
- Apply specific commits from one branch to another
- Command: `git cherry-pick commit-hash`
- Use case: Backporting fixes to stable versions

**Clone**
- Copy an entire repository to your computer
- Command: `git clone <url>`
- Creates: Local copy of all branches and history

**Commit**
- Save changes with a message
- Creates: New point in history
- Contains: Code changes + timestamp + author + message

**Conventional Commits**
- Standardized commit message format
- Format: `type(scope): description`
- Example: `feat(auth): add login form`

**Conflict**
- When Git can't automatically merge changes
- Happens: When both branches changed same lines
- Resolution: Manual editing required

## D

**Develop Branch**
- Integration branch for features
- Staging area before production
- Name: Usually called `develop`

**Diff**
- Show differences between versions
- Command: `git diff`
- Shows: Added/removed lines and changes

## E

**End of Life (EOL)**
- Support date when a version stops getting updates
- Important: Plan migration before EOL
- Example: v1.0 EOL = January 2027

## F

**Fast-Forward**
- Merge without creating merge commit
- Happens: When target branch is behind
- Result: Linear history

**Feature Branch**
- Branch for developing a single feature
- Naming: `feature/feature-name`
- Lifecycle: Created and deleted with feature

**Feature Flag**
- Code toggle controlling feature visibility
- Without: Redeploying to turn features on/off
- Benefit: Instant activation/deactivation

**Fetch**
- Get updates from remote (no merge)
- Command: `git fetch origin`
- Safe: Doesn't change your code

## G

**Git**
- Distributed version control system
- Tracks: Code changes over time
- Enables: Collaboration and history management

**GitHub**
- Web platform for hosting Git repositories
- Adds: Pull requests, issues, actions
- Cloud: Hosted centrally (but Git is distributed)

**Git Flow**
- Branching strategy with main/develop/feature/release/hotfix
- Complexity: High
- Best for: Large teams with multiple versions

## H

**HEAD**
- Pointer to current commit
- Usually: Points to current branch
- Can be: Detached (pointing to specific commit)

**Hotfix**
- Emergency fix for production issues
- Created from: main branch
- Released as: Patch version (1.0.0 → 1.0.1)

## I

**Issue**
- GitHub feature for tracking problems/features
- Format: GitHub Issue #123
- Linked: To pull requests and commits

## L

**Lightweight Tag**
- Simple tag (just a name pointing to commit)
- vs: Annotated tag (has metadata)
- Use: When metadata not important

**Log**
- Show commit history
- Command: `git log`
- Format: Show commits chronologically

## M

**Main Branch**
- Production-ready code
- Protection: Usually has strict rules
- Releases: All releases tagged here

**Merge**
- Combine two branches
- Creates: Merge commit (unless fast-forward)
- vs: Rebase (creates different history)

**Merge Commit**
- Special commit with two parents
- Created: When merging branches
- Shows: Parallel development in history

**Merge Conflict**
- When Git can't automatically merge
- Resolution: Manual editing of conflicted files
- Prevention: Good branching strategy

## P

**Patch**
- Bug fix release (1.0.0 → 1.0.1)
- Version component: X.Y.Z (Z is patch)
- Contains: Only bug fixes, no new features

**Pull**
- Fetch + merge from remote
- Command: `git pull origin branch`
- Shorthand: `git fetch` then `git merge`

**Pull Request (PR)**
- Proposed code changes for review
- Workflow: Create → Review → Approve → Merge
- Benefits: Code review, discussion, CI/CD checks

## Q

**Rebase**
- Replay commits on new base
- vs: Merge (different history result)
- Result: Linear history

**Release**
- Tagged version ready for deployment
- Format: Semantic versioning (1.2.3)
- Contains: All changes since previous release

**Release Branch**
- Preparation branch for release
- Name: `release/v1.0.0`
- Lifetime: Days (then merged to main)

**Remote**
- Copy of repo on server (GitHub)
- Default: Called `origin`
- Fetch from/push to: Synchronize changes

## S

**Semantic Versioning**
- Version format: MAJOR.MINOR.PATCH
- Example: 1.2.3
- Breaking=MAJOR, Features=MINOR, Fixes=PATCH

**Squash**
- Combine multiple commits into one
- Command: `git merge --squash`
- Use: Cleaning up messy branch history

**Stage/Staging**
- Mark changes for commit
- Command: `git add`
- Separates: Changes you want vs don't want to commit

**Stash**
- Temporarily save changes
- Command: `git stash`
- Use: Switch branches without committing

## T

**Tag**
- Named label for a commit
- Usually: For releases (v1.0.0, v1.1.0)
- Types: Annotated (recommended) or lightweight

**Trunk-Based Development**
- All work on main branch
- Uses: Feature flags for control
- Releases: Frequent, small deployments

## U

**Upstream**
- Original repository you cloned from
- When: You forked a repo
- Command: `git remote add upstream <url>`

## V

**Version**
- Specific release snapshot
- Format: Semantic versioning (X.Y.Z)
- Tags: v1.0.0, v1.1.0, v2.0.0

## W

**Worktree**
- Working directory with repository
- Git stores: .git directory with repo data
- Files: Actual project files you edit

## Z

(No Z terms yet!)

---

## Quick Reference

**Common Version Patterns:**
- `v1.0.0` - First release
- `v1.0.1` - Bug fix release
- `v1.1.0` - New features release
- `v2.0.0` - Breaking changes release

**Common Branch Names:**
- `main` or `master` - Production
- `develop` - Integration
- `feature/...` - New features
- `hotfix/...` - Emergency fixes
- `release/...` - Release preparation

**Common Commands:**
- `git clone` - Copy repo
- `git checkout` - Switch branch
- `git commit` - Save changes
- `git push` - Send to remote
- `git pull` - Get from remote
- `git merge` - Combine branches

---

**Need more clarification on a term?** Check the [FAQ](./FAQ.md) or [Command Reference](./Command-Reference.md).
