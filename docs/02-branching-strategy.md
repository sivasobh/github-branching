# 2. Branching Strategies

## What is a Branching Strategy?

A branching strategy is a set of rules and guidelines that explains how to organize work in branches. It helps teams:
- Work in parallel without conflicts
- Maintain code quality
- Control when features go to production
- Manage hotfixes and releases
- Keep history clean and readable

## Popular Branching Strategies

### Git Flow (Most Comprehensive)

Git Flow is designed for projects with planned releases. It uses multiple long-lived branches:

**Permanent Branches:**
- `main`: Production-ready code (stable releases)
- `develop`: Integration branch for features

**Supporting Branches:**
- `feature/*`: New features (from develop)
- `release/*`: Release preparation (from develop)
- `hotfix/*`: Critical production fixes (from main)

```
          feature branches
               ↓
    ┌──────────●──────────┐
    │          │          │
    ▼          ▼          ▼
   dev ← ← ← ← ← ← ← ← ← develop
             ↓
    release/1.0 branch
             ↓
         main ← ← ← ← ← ← v1.0
             ↑
          hotfix branch
```

**When to Use Git Flow:**
- Projects with planned release schedules
- Large teams with multiple features in progress
- Need for long-term support branches
- Complex release processes

---

### GitHub Flow (Simplest)

GitHub Flow is simpler and suitable for continuous deployment. It uses only two main branches:

**Branches:**
- `main`: Always production-ready (automatically deployed)
- Feature branches: Created from main

```
Feature branches:
     f1    f2    f3
     │     │     │
     ▼     ▼     ▼
     ●─────●─────● ← main (always deployable)
     │     │     │
     ▼     ▼     ▼
    merged to main
```

**Workflow:**
1. Create feature branch from `main`
2. Make changes and commit
3. Open Pull Request
4. Code review and discussion
5. Merge to `main`
6. Deploy immediately
7. Delete feature branch

**When to Use GitHub Flow:**
- Continuous deployment environments
- Web applications with frequent releases
- Small to medium teams
- Fast-moving projects
- Simple release process

---

### Trunk-Based Development

Developers make smaller, more frequent commits directly to the main line (trunk):

```
Individual commits to main:
    c1──c2──c3──c4──c5──c6──c7──c8 ← main
    │   │   │   │   │   │   │   │
    feature flags protect incomplete features
```

**Benefits:**
- Minimal merge conflicts
- Faster integration
- Continuous testing
- Better collaboration

**Challenges:**
- Requires discipline
- Feature flags are essential
- Need automated testing

---

### Release Flow

Variation combining elements of Git Flow and GitHub Flow:

```
Features:           Releases:
  ↓                   ↓
develop ────────────→ release/1.0 → main (v1.0)
  ↓                                   ↑
  └──────────────────────────────────┘
```

---

## Comparison Table

| Aspect | Git Flow | GitHub Flow | Trunk-Based |
|--------|----------|-------------|------------|
| **Main Branches** | 2 (main, develop) | 1 (main) | 1 (main) |
| **Release Cycles** | Planned | Continuous | Continuous |
| **Team Size** | Large | Small to Medium | Any |
| **Learning Curve** | Steep | Easy | Medium |
| **Merge Frequency** | Regular | Daily/Hourly | Hourly |
| **Feature Isolation** | High | Medium | Low |
| **Production Stability** | High | High | Requires discipline |

---

## Choosing Your Strategy

### Choose Git Flow if:
- ✓ You have scheduled releases
- ✓ You support multiple versions
- ✓ Your team is large
- ✓ You need clear separation of concerns

### Choose GitHub Flow if:
- ✓ You deploy continuously
- ✓ You have one production version
- ✓ Your team is small/medium
- ✓ You want simplicity

### Choose Trunk-Based if:
- ✓ You have very frequent releases
- ✓ You have strong automated testing
- ✓ Your team is highly coordinated
- ✓ You want minimal branching

---

## Branch Naming Conventions

Consistent naming helps identify branch purpose:

```
feature/user-authentication    → New feature
bugfix/login-redirect          → Bug fix
hotfix/critical-security       → Urgent fix
release/1.2.0                  → Release preparation
chore/update-dependencies      → Maintenance
docs/readme-update             → Documentation
refactor/reduce-complexity     → Code refactoring
perf/optimize-database-query   → Performance improvement
```

**Good Naming Rules:**
- Use lowercase letters
- Use hyphens to separate words (not underscores)
- Be descriptive but concise
- Use consistent prefixes
- Include issue number if applicable: `feature/PROJ-123-add-payment`

---

## Next Steps
→ Continue to [03-branching-workflow.md](03-branching-workflow.md) to see detailed workflows.
