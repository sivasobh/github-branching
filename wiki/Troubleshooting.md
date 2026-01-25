# Troubleshooting - Common Git Issues & Solutions

Solutions to common Git and GitHub problems.

## Before You Panic

**Golden Rules:**
- ✅ Git rarely deletes data permanently
- ✅ Most mistakes can be undone
- ✅ `git reflog` can usually recover lost commits
- ✅ Ask for help if unsure

---

## Repository Access Issues

### "Repository not found"

**Error Message:**
```
fatal: repository not found
```

**Causes:**
1. Wrong repository URL
2. Repository is private and you're not authenticated
3. Repository was deleted
4. Network/firewall issue

**Solutions:**

```bash
# 1. Check remote URL
git remote -v

# 2. If wrong, update it
git remote set-url origin https://github.com/correct/repo.git

# 3. If private repo, authenticate:
# - Generate personal access token (GitHub Settings)
# - Use token as password when prompted

# 4. Test connection
git fetch origin
```

### "Permission denied (publickey)"

**Error Message:**
```
Permission denied (publickey).
fatal: Could not read from remote repository.
```

**Cause:** SSH key not set up or not added to GitHub

**Solutions:**

```bash
# 1. Check if SSH key exists
ls ~/.ssh/id_rsa

# 2. If not, generate
ssh-keygen -t rsa -b 4096 -f ~/.ssh/id_rsa

# 3. Add public key to GitHub:
# GitHub Settings → SSH Keys → New SSH Key
cat ~/.ssh/id_rsa.pub        # Copy this

# 4. Test connection
ssh -T git@github.com

# 5. Update remote to use SSH
git remote set-url origin git@github.com:user/repo.git
```

---

## Commit Issues

### "No changes added to commit"

**Error Message:**
```
nothing added to commit
```

**Cause:** Made changes but didn't stage them

**Solution:**

```bash
# Stage all changes
git add .

# Or stage specific file
git add filename.js

# Then commit
git commit -m "message"
```

### Committed to Wrong Branch

**Problem:** Realized commit is on wrong branch

**Solution:**

```bash
# Option 1: Move last commit (if not pushed)
git reset HEAD~1                # Undo commit, keep changes
git checkout correct-branch
git commit -m "message"

# Option 2: If already pushed, cherry-pick and revert
git checkout correct-branch
git cherry-pick wrong-branch
git checkout wrong-branch
git revert commit-hash
```

### Committed Sensitive Data

**Problem:** Accidentally committed password, API key, etc.

**Immediate Actions:**
```bash
# 1. Rotate the credential (change password, revoke API key)
# 2. Remove from history
git filter-branch --tree-filter 'rm -f sensitive-file' HEAD
git push origin --force
```

**Better Prevention:**
- Use `.gitignore` for secrets
- Never commit `.env` files
- Use GitHub Secrets for CI/CD

---

## Merge Conflicts

### Understanding Conflicts

**Error Message:**
```
CONFLICT (content merge): Merge conflict in file.js
Automatic merge failed; fix conflicts and then commit
```

**What's happening:** Git can't automatically merge because both branches changed the same lines.

### Resolving Conflicts

**Visual Conflict Markers:**
```javascript
<<<<<<< HEAD
  // Your changes from current branch
  const name = "Alice";
=======
  // Changes from incoming branch
  const name = "Bob";
>>>>>>> feature/branch-name
```

**Step-by-Step Resolution:**

```bash
# 1. Open the conflicted file
# (Look for <<<<<<, ======, >>>>>> markers)

# 2. Choose which version to keep:
# Option A: Keep your changes (HEAD)
# Option B: Keep their changes
# Option C: Keep both
# Option D: Write new code combining both

# 3. Remove markers completely
# Delete: <<<<<<< HEAD
# Delete: =======
# Delete: >>>>>>> feature/branch

# 4. Save the file

# 5. Stage and commit
git add .
git commit -m "fix: resolve merge conflict"
```

### Common Conflict Patterns

**Pattern 1: One side added, other side deleted**
```
<<<<<<< HEAD
  function foo() { }
=======
>>>>>>> feature/branch
```
Decision: Keep one side or merge logic

**Pattern 2: Both sides changed same code**
```
<<<<<<< HEAD
  const x = 10;
=======
  const x = 20;
>>>>>>> feature/branch
```
Decision: Choose 10, 20, or 15

**Pattern 3: Line breaks or whitespace**
```
<<<<<<< HEAD
const x = 10;
=======
const x = 10;

>>>>>>> feature/branch
```
Decision: Usually can choose either

### Abort Merge

If conflict is too complicated:

```bash
git merge --abort              # Cancel merge
git rebase --abort             # Cancel rebase
git cherry-pick --abort        # Cancel cherry-pick
```

---

## Branch Issues

### "fatal: pathspec 'branch-name' did not match any files"

**Cause:** Branch doesn't exist

**Solution:**

```bash
# List all branches
git branch -a

# Create branch if needed
git checkout -b branch-name
```

### Accidentally Deleted Branch

**Problem:** Deleted local branch but didn't mean to

**Solution:**

```bash
# View reflog
git reflog

# Find the commit hash where branch was
# Then recreate
git checkout -b branch-name commit-hash
```

### Can't Delete Branch

**Error:** `error: The branch is not fully merged`

**Cause:** Trying to delete unmerged branch

**Solution:**

```bash
# Force delete if sure
git branch -D branch-name

# Or merge first
git checkout main
git merge branch-name
git branch -d branch-name
```

---

## Push/Pull Issues

### "failed to push some refs"

**Error Message:**
```
error: failed to push some refs to 'origin'
hint: Updates were rejected because the remote contains work...
```

**Cause:** Remote has commits you don't have locally

**Solution:**

```bash
# Pull latest first
git pull origin main

# Then push
git push origin main
```

### "receive.denyCurrentBranch"

**Error:** Pushed to bare repository incorrectly

**Cause:** Repository doesn't accept pushes

**Solution:**
- Configure repository correctly
- Usually happens with local bare repos
- Use GitHub/GitLab instead

### Huge File in Git History

**Problem:** Accidentally committed large file (video, database, etc.)

**Impact:** Clones slow, lots of bandwidth

**Solution:**

```bash
# Remove from history
git filter-branch --tree-filter 'rm -f huge-file.zip' HEAD

# Add to .gitignore
echo "*.zip" >> .gitignore

# Force push
git push origin --force
```

---

## Rebase Issues

### "fatal: no changes - did you forget to use 'git add'?"

**During Interactive Rebase**

**Cause:** Made changes but didn't stage them

**Solution:**

```bash
git add .
git rebase --continue
```

### Rebase Seems Stuck

**Checking Status:**

```bash
# See what's happening
git status

# If stuck in rebase
git rebase --abort              # Cancel
# Or continue if ready
git rebase --continue
```

### Many Conflicts During Rebase

**Problem:** Rebasing causes lots of conflicts

**Alternative:**

```bash
# Abort rebase
git rebase --abort

# Merge instead (easier)
git merge feature/branch
```

---

## History Issues

### Lost Commits

**Problem:** Commits disappeared after reset

**Solution (Usually Works):**

```bash
# View recovery log
git reflog

# Find the lost commit
git reflog | grep "commit message"

# Restore
git checkout commit-hash
git branch recovered-branch
```

### Want to Undo Multiple Commits

**For Unpushed:**
```bash
git reset --soft HEAD~3         # Undo last 3, keep changes
git commit -m "new message"
```

**For Pushed (Safe Method):**
```bash
git revert HEAD~2..HEAD         # Creates undoing commits
git push origin main
```

---

## Authentication Issues

### "Access token has expired"

**Solution:**

```bash
# Generate new token at GitHub Settings
# Then re-enter credentials when prompted

# Or cache credentials
git config --global credential.helper cache
# (Token stored for 15 minutes)

# Or store permanently (less secure)
git config --global credential.helper store
# Token stored in .git-credentials
```

### Two-Factor Authentication Issues

**Solution:**
- Use personal access token instead of password
- Set up SSH keys (no password needed)
- GitHub CLI (`gh`) auth handles 2FA automatically

---

## Performance Issues

### Git Operations Very Slow

**Causes:**
1. Large repository
2. Too many commits
3. Network issues
4. Too many branches

**Solutions:**

```bash
# Shallow clone (faster for large repos)
git clone --depth 1 repo-url

# Check repository size
du -sh .git

# Optimize repository
git gc --aggressive
git prune

# Use sparse checkout for large monorepos
git sparse-checkout init --cone
```

### "your branch is ahead by X commits"

**Meaning:** You have commits not pushed

**Solution:**

```bash
# Push them
git push origin branch-name

# Or view what to push
git log origin/branch..branch
```

---

## Help & Recovery

### View Your Actions History

**See everything you've done:**

```bash
# Recent commands
git reflog

# Shows all branch movements
# Format: commit-hash ref-action
```

### Find a Lost Commit

**If you know part of the message:**

```bash
git log --grep="search term" --all

# Search in all commits ever
git log -S "code or text" --all
```

### Check What Branch Commit Is On

```bash
git branch -a --contains commit-hash
```

### Simulate Operations First

```bash
# Test merge without actually merging
git merge --no-commit --no-ff feature/branch
git merge --abort

# Test rebase with dry-run
git rebase --dry-run main
```

---

## When All Else Fails

### Nuclear Option: Reset Everything

**Warning: Dangerous! Only if very stuck**

```bash
# Discard all local changes
git reset --hard origin/main

# Remove untracked files
git clean -fd

# Get fresh copy
git pull origin main
```

### Ask For Help

**Provide Information:**
1. What are you trying to do?
2. What command did you run?
3. What error message?
4. Output of `git status`
5. Output of `git log --oneline -5`

**Good Help Resources:**
- This repo's [FAQ](./FAQ.md)
- `git help <command>`
- Team lead
- GitHub Community Discussions

---

## Prevention Tips

**Avoid Most Issues:**

```bash
# Always pull before working
git pull origin develop

# Create branches for any changes
git checkout -b feature/my-feature

# Commit often with clear messages
git commit -m "feat: ..."

# Push frequently
git push origin feature/my-feature

# Create PRs for code review
# (Don't merge directly to main)

# Use .gitignore for secrets
echo ".env" >> .gitignore
```

---

**Still Stuck?** Check [FAQ](./FAQ.md) | [Command Reference](./Command-Reference.md) | Ask your team
