# FAQ - Frequently Asked Questions

Common questions about Git, GitHub, and our branching strategy.

## Getting Started

**Q: I've never used Git before. Where should I start?**
A: Start here:
1. Read [Quick Start](./Quick-Start.md) (5 minutes)
2. Read [Git Fundamentals](../docs/01-git-fundamentals.md)
3. Try the commands in [examples/branch-commands.sh](../examples/branch-commands.sh)
4. Follow [Hands-On Example](../docs/10-hands-on-example.md)

**Q: What's the difference between Git and GitHub?**
A: 
- **Git**: Version control software (runs on your computer)
- **GitHub**: Service hosting Git repositories (online platform)
- Analogy: Git is like a camera, GitHub is like a photo sharing site

**Q: How do I clone this repository?**
A: 
```bash
git clone https://github.com/sivasobh/github-branching.git
cd github-branching
```

**Q: Should I use SSH or HTTPS for cloning?**
A: 
- **HTTPS**: Works everywhere, needs personal access token
- **SSH**: Requires key setup, more secure long-term
- Recommendation: SSH if you'll be using Git frequently

---

## Branching & Workflows

**Q: Which branching strategy should we use?**
A: Depends on your team:
- **Git Flow**: Large teams, multiple versions in production
- **GitHub Flow**: Small teams, single version, continuous deployment
- **Trunk-Based**: Frequent deployments, heavy use of feature flags
- See: [Choosing-Your-Strategy.md](./Choosing-Your-Strategy.md)

**Q: How do I create a feature branch?**
A: 
```bash
git checkout develop
git pull origin develop
git checkout -b feature/my-feature-name
```

**Q: What should I name my branch?**
A: Follow the pattern:
- `feature/user-authentication` ✅ Descriptive, lowercase
- `feature/login` ✅ Simple and clear
- `feature/MyFeature` ❌ Avoid mixed case
- `random123` ❌ Avoid unclear names

See: [Branch Naming Guide](./Branch-Naming.md)

**Q: When should I create a new branch?**
A: Create a branch when:
- Starting any new feature
- Fixing a reported bug
- Experimenting with new ideas
- Making any code changes (except hotfixes)

Don't create branches for: Documentation fixes, README updates (usually)

**Q: Can I push directly to main?**
A: No, branch protection prevents it. This protects production code.
You must:
1. Create a feature branch
2. Make your changes
3. Create a pull request
4. Get approval
5. Merge via PR

**Q: What's the difference between merge and rebase?**
A: 
- **Merge**: Creates merge commit, preserves history
- **Rebase**: Replays commits, linear history
- Default: Use merge (safer)
- See: [Merge vs Rebase](../docs/04-merging-rebase.md)

---

## Pull Requests

**Q: How do I create a pull request?**
A: 
```bash
# 1. Push your branch
git push origin feature/my-feature

# 2. Go to GitHub and click "Compare & pull request"
# 3. Add description
# 4. Click "Create pull request"
```

**Q: What should my PR description include?**
A: Include:
- ✅ What changes you made
- ✅ Why you made them
- ✅ How to test the changes
- ✅ Related issues (#123)
- ✅ Screenshots (if UI changes)

Example:
```
## What
Added user authentication form

## Why
Users need to login to access dashboard

## How to test
1. Click login button
2. Enter test@example.com / password123
3. Should see dashboard

## Related
Fixes #45
```

**Q: Why is my PR blocked?**
A: Common reasons:
1. Branch protection rules not met (needs approvals, status checks)
2. Commit messages don't follow conventional format
3. CI/CD checks failed (tests, linting)
4. Conflicts with main branch

Check GitHub PR status for details.

**Q: How do I resolve a merge conflict?**
A: 
1. Pull latest main: `git pull origin main`
2. Open conflicted file
3. Find `<<<<<<< HEAD` and `>>>>>>>` markers
4. Choose your code or their code
5. Remove markers
6. Commit: `git add . && git commit -m "fix: resolve conflict"`
7. Push: `git push origin feature/my-feature`

See: [Conflict Resolution Guide](./Conflict-Resolution.md)

---

## Commits

**Q: How often should I commit?**
A: 
- **Frequency**: Multiple times per work session (not just at end)
- **Trigger**: After completing a logical unit of work
- **Bad**: One huge commit with everything
- **Good**: Several smaller, focused commits

**Q: What makes a good commit message?**
A: Follow conventional commits:
```
type(scope): short description

Optional longer explanation
- Point 1
- Point 2

Fixes #123
```

Types: `feat`, `fix`, `docs`, `style`, `refactor`, `test`, `chore`

Examples:
- ✅ `feat(auth): add password reset flow`
- ✅ `fix(api): handle null response gracefully`
- ❌ `updated stuff`
- ❌ `asdf`

See: [Commit Guide](../docs/05-commits.md)

**Q: Can I fix my last commit?**
A: Yes, before pushing:
```bash
# Fix the commit
git commit --amend

# Or add forgotten file
git add forgotten-file.js
git commit --amend
```

**Q: Can I change history on main?**
A: No, branch protection prevents force-pushing to main.
If you need to revert:
```bash
git revert commit-hash
```
This creates NEW commit that undoes changes (safe).

---

## Merging & Releases

**Q: What's the difference between main and develop?**
A: 
| Aspect | main | develop |
|--------|------|---------|
| **Purpose** | Production code | Integration branch |
| **Stability** | Must be stable | Can be in progress |
| **Protection** | High (requires PR) | Medium (requires PR) |
| **Releases** | Every commit tagged | No tags |
| **Deployment** | Auto to production | No auto deployment |

**Q: How do I release code?**
A: 
1. Create release branch: `git checkout -b release/v1.2.0`
2. Update version numbers
3. Create pull request to main
4. Get approval
5. Merge to main (auto-tags: v1.2.0)
6. Merge back to develop
7. Done! GitHub Actions handles deployment

See: [Release Process](../docs/08-release-branch.md)

**Q: What's a hotfix?**
A: Emergency fix for production issue:
1. Create from main: `git checkout -b hotfix/v1.2.1`
2. Fix the bug
3. Test thoroughly
4. Merge to main (creates v1.2.1 tag)
5. Merge to develop
6. Done!

See: [Hotfix Guide](../docs/09-hotfix-branch.md)

**Q: When do I delete a branch?**
A: After merging to main or develop:
```bash
# Delete locally
git branch -d feature/my-feature

# Delete on GitHub
git push origin --delete feature/my-feature
```

---

## Advanced Topics

**Q: What is cherry-picking?**
A: Applying specific commits from one branch to another:
```bash
git cherry-pick commit-hash
```

When to use:
- ✅ Backporting fixes to older versions
- ✅ Applying select commits from develop to hotfix
- ❌ Don't use for large-scale merges (merge instead)

See: [Cherry Picking Guide](../docs/13-cherry-picking-feature-flipping.md)

**Q: What are feature flags?**
A: Code toggles controlling feature visibility without redeploying:
```javascript
if (config.features.newDashboard) {
  renderNewDashboard();
} else {
  renderOldDashboard();
}
```

Benefits:
- ✅ Instant on/off without redeploying
- ✅ Gradual rollout (5% → 25% → 100%)
- ✅ Instant rollback if issues
- ✅ A/B testing

See: [Feature Flags Guide](../docs/13-cherry-picking-feature-flipping.md)

**Q: What are GitHub Actions?**
A: Automated workflows triggered by Git events:
- Run tests on every PR
- Auto-tag releases based on commit messages
- Validate branch naming
- Send notifications
- Deploy to production

This project includes 4 example workflows. See: [GitHub Actions Guide](../docs/12-github-actions-automation.md)

---

## Troubleshooting

**Q: I accidentally committed to main. What do I do?**
A: Don't panic. Options:
1. If not pushed yet: `git reset HEAD~1` (undo commit, keep changes)
2. If pushed: Create PR to undo: `git revert commit-hash`
3. Contact team lead if urgent

**Q: I'm on the wrong branch. How do I move my commits?**
A: 
```bash
# Save your commits
git log --oneline -5

# Move to correct branch
git checkout correct-branch

# Apply commits there
git cherry-pick old-branch

# Go back and undo
git checkout wrong-branch
git reset hard-reset-point
```

**Q: Git says "fatal: not a git repository"**
A: You're not in a Git repository. Solutions:
```bash
# Clone the repo
git clone <repo-url>

# Or initialize current folder
git init
```

**Q: I have uncommitted changes and want to switch branches**
A: Temporarily save them:
```bash
git stash
git checkout another-branch
# Later, restore:
git stash pop
```

**Q: How do I see the status of my repository?**
A: 
```bash
git status
```

Shows:
- Current branch
- Changes to commit
- Untracked files
- Ahead/behind remote

---

## Commands

**Q: What's the most important Git command?**
A: 
```bash
git help <command>
```

Look up any command's full documentation.

**Q: Where can I find all commands?**
A: 
- [Command Reference](./Command-Reference.md)
- [Examples](../examples/branch-commands.sh)
- [QUICK-REFERENCE.md](../QUICK-REFERENCE.md)

---

## Still Have Questions?

1. Check the [Glossary](./Glossary.md) for term definitions
2. Read the [Documentation](../docs/) for detailed guides
3. Check [examples/branch-commands.sh](../examples/branch-commands.sh) for commands
4. Search GitHub issues in the repository
5. Ask your team lead

---

**Last Updated**: 2024
**Main Resources**: [Home](./Home.md) | [Quick Start](./Quick-Start.md) | [Glossary](./Glossary.md)
