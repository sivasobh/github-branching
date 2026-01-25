# GitHub Actions Workflows for Git Flow & Version Tagging

This directory contains GitHub Actions workflows for automating:
- Semantic versioning and version tagging
- Branch management and enforcement
- Release automation
- Version incrementation logic

## Files in this Directory

### 1. `version-tagging.yml`
Automatically tags commits with semantic versions based on branch type and commit messages.

**Triggers:**
- Push to `main` (production release)
- Push to `develop` (development snapshot)
- Manual trigger

**Features:**
- Reads conventional commit messages
- Determines version increment (MAJOR, MINOR, PATCH)
- Creates annotated git tags
- Pushes tags to repository
- Creates GitHub releases

### 2. `branch-protection.yml`
Enforces branch protection rules and validates branching strategy.

**Triggers:**
- Pull request to `main` or `develop`
- Push to protected branches

**Features:**
- Validates branch naming conventions
- Enforces PR requirements
- Checks commit message format
- Prevents direct pushes
- Ensures release notes exist

### 3. `release-automation.yml`
Automates release creation from release branches.

**Triggers:**
- Push to `release/*` branches
- Manual trigger

**Features:**
- Validates version in release branch name
- Updates version in code files
- Generates changelog
- Creates GitHub release
- Merges to main and develop

### 4. `hotfix-automation.yml`
Automates hotfix creation and merging.

**Triggers:**
- Push to `hotfix/*` branches
- Manual trigger

**Features:**
- Creates patch version tags
- Updates version numbers
- Creates hotfix release notes
- Merges to main and develop
- Notifies team

## How to Use These Workflows

1. Copy all `.yml` files to `.github/workflows/` directory
2. Commit and push to your repository
3. GitHub Actions will automatically enable them

## Configuration

Most workflows can be customized by editing the:
- `env:` section for version file locations
- `permissions:` for security settings
- `on:` triggers for activation conditions

## Example Workflow Runs

See the documentation files for complete examples of:
- How to trigger version tagging
- How to format commit messages
- How to manage branches
- How to create releases

## Troubleshooting

If workflows don't run:
1. Check `.github/workflows/` directory exists
2. Verify files are `.yml` format
3. Check GitHub Actions is enabled in repository settings
4. Review Actions tab for error messages
