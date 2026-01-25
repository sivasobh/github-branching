# Quick Start Guide (5 Minutes)

Get up and running with Git and branching in 5 minutes!

## What You Need

- Git installed ([git-scm.com](https://git-scm.com))
- A GitHub account
- A project repository

## Step 1: Clone the Repository (1 min)

```bash
git clone https://github.com/your-username/your-repo.git
cd your-repo
```

## Step 2: Configure Git (1 min)

```bash
git config user.name "Your Name"
git config user.email "your.email@example.com"

# Make it global (for all repos)
git config --global user.name "Your Name"
git config --global user.email "your.email@example.com"
```

## Step 3: Create a Feature Branch (1 min)

```bash
# Start from develop
git checkout develop
git pull origin develop

# Create new feature branch
git checkout -b feature/my-awesome-feature

# Push to remote
git push -u origin feature/my-awesome-feature
```

## Step 4: Make Changes & Commit (1 min)

```bash
# Make your changes
# Edit files...

# Stage changes
git add .

# Commit with a message
git commit -m "feat(auth): add password reset functionality"

# Push to remote
git push origin feature/my-awesome-feature
```

## Step 5: Create Pull Request (1 min)

1. Go to GitHub repository
2. Click "Pull Requests" tab
3. Click "New Pull Request"
4. Select your branch
5. Add description
6. Click "Create Pull Request"
7. Wait for approval
8. Click "Merge Pull Request"

## Basic Commands

```bash
# View branches
git branch -a

# Switch branch
git checkout branch-name

# Create & switch
git checkout -b branch-name

# View changes
git status

# View commits
git log --oneline

# Push changes
git push origin branch-name

# Pull changes
git pull origin branch-name
```

## Key Concepts

| Term | Meaning |
|------|---------|
| **Repository** | Your entire project (code + history) |
| **Branch** | Independent line of development |
| **Commit** | Snapshot of changes with message |
| **Pull Request** | Proposed changes for review |
| **Merge** | Combining branches together |

## Next Steps

- Read [Git Flow vs GitHub Flow](./Git-Flow-vs-GitHub-Flow.md) to understand strategies
- Check [Commit Message Guide](./Commit-Message-Guide.md) for better commits
- Review [Code Review Guidelines](./Code-Review-Guidelines.md) for PR process

## Common Tasks

**I want to update my feature branch with latest develop:**
```bash
git fetch origin
git merge origin/develop
# Resolve any conflicts, then push
git push origin feature/my-feature
```

**I made a mistake in my last commit:**
```bash
# Change the commit message
git commit --amend -m "new message"

# OR undo last commit (keep changes)
git reset --soft HEAD~1
```

**I want to see what changed:**
```bash
# View differences
git diff

# View commit history
git log --oneline -10

# View specific file history
git log --oneline -- filename.js
```

## Help!

- **Have questions?** → [FAQ](./FAQ.md)
- **Something broken?** → [Common Issues](./Common-Issues.md)
- **Need a command?** → [Command Reference](./Command-Reference.md)

---

**Congratulations! You now know the basics of Git and GitHub workflow!** 🎉

For more information, explore the [wiki index](./README.md).
