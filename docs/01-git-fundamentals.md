# 1. Git Fundamentals

## What is Git?

Git is a distributed version control system that tracks changes to files over time. It allows multiple developers to collaborate on projects while maintaining a complete history of all changes.

## Core Concepts

### Repository (Repo)
A repository is a project folder that contains all your files and the complete history of changes. It can exist locally on your machine or remotely on GitHub.

```
Types of Repositories:
- Local Repository: On your computer
- Remote Repository: On GitHub (origin)
- Bare Repository: Used for shared access (typically on server)
```

### Commits
A commit is a snapshot of your project at a specific point in time. Each commit contains:
- **Hash**: Unique identifier (SHA-1)
- **Author**: Who made the change
- **Date**: When it was committed
- **Message**: Description of changes
- **Changes**: File additions, deletions, modifications

```
Example Commit:
commit 3f4d2e8c9b1a5f6e7d8c9b0a1f2e3d4c
Author: John Doe <john@example.com>
Date:   Mon Jan 25 10:30:45 2026 +0000

    Add user authentication module
```

### Working Directory, Staging Area, and Repository

```
┌─────────────────────┐
│ Working Directory   │  ← Your local files
│   (modified)        │
└──────────┬──────────┘
           │ git add
           ▼
┌─────────────────────┐
│  Staging Area       │  ← Files ready to commit
│   (Index)           │
└──────────┬──────────┘
           │ git commit
           ▼
┌─────────────────────┐
│  Repository         │  ← Permanent history
│   (HEAD)            │
└─────────────────────┘
```

### Branches
A branch is an independent line of development. By default, your repository has a `main` (or `master`) branch.

```
Main Branch:        Feature Branch:
    ●                    ●
    ├─ ●                 ├─ ●
    │  ├─ ●              │  ├─ ●
    │  │  └─ ●           │  │  └─ ●
    └──┴─────────●       └──┴─────────●
    
    Linear History      Parallel Development
```

## Essential Git Commands

### Setting Up Git
```bash
# Configure your identity
git config --global user.name "Your Name"
git config --global user.email "your@email.com"

# Verify configuration
git config --global --list
```

### Creating and Cloning Repositories
```bash
# Create a new local repository
git init

# Clone an existing repository
git clone <repository-url>
git clone <repository-url> <directory-name>
```

### Checking Status
```bash
# View current status
git status

# View brief status
git status -s

# View differences in modified files
git diff

# View differences in staged files
git diff --staged
```

### Staging and Committing
```bash
# Add specific file
git add <filename>

# Add all changes
git add .

# Stage specific changes (interactive)
git add -p

# Commit changes
git commit -m "Descriptive message"

# Commit with detailed message
git commit -m "Title" -m "Detailed description"

# Add and commit together
git commit -am "message"
```

### Viewing History
```bash
# View commit history
git log

# View compact history
git log --oneline

# View history with graph
git log --oneline --graph --all

# View history for specific file
git log <filename>

# View specific commit details
git show <commit-hash>
```

### Undoing Changes
```bash
# Discard changes in working directory
git checkout <filename>

# Unstage a file
git reset <filename>

# Undo last commit (keep changes)
git reset --soft HEAD~1

# Undo last commit (lose changes)
git reset --hard HEAD~1

# Create a new commit that undoes changes
git revert <commit-hash>
```

## Key Terminology

| Term | Meaning |
|------|---------|
| **HEAD** | Pointer to current branch's latest commit |
| **Origin** | Default remote repository name |
| **Upstream** | Original repository you forked from |
| **Fetch** | Download changes from remote without merging |
| **Pull** | Fetch + Merge in one command |
| **Push** | Upload local commits to remote |
| **Detached HEAD** | Being on a commit that's not a branch tip |

## Git States Summary

```
MODIFIED      → STAGED       → COMMITTED
(changed)       (ready)       (saved)
  ↓              ↓              ↓
git add →    git commit →   git push
```

## Next Steps
→ Continue to [02-branching-strategy.md](02-branching-strategy.md) to learn about different branching strategies.
