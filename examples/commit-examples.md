# Real-World Commit Message Examples

## Good Commit Messages

### Feature Commits

```
feat(auth): implement user authentication system

Add support for user login and logout functionality.
Users can now authenticate using email and password.
Passwords are hashed with bcrypt for security.

Implements GitHub issue #234
```

```
feat(dashboard): add user dashboard with statistics

Dashboard displays:
- Total tasks and completion percentage
- Tasks due today
- Quick task creation widget
- Recently completed tasks

Uses existing API endpoints for data.
Dashboard is responsive on mobile devices.
```

### Bug Fix Commits

```
fix(api): resolve timeout issue in user endpoint

The user profile endpoint was timing out when processing
large numbers of tasks. Implemented caching layer to
reduce database queries by 60%.

Fixes #456
```

```
fix(ui): correct button alignment on mobile

Buttons were misaligned on screens smaller than 480px.
Updated media query to properly center buttons.
Tested on iPhone 12, iPad, and Android devices.
```

### Documentation Commits

```
docs(readme): update installation instructions

Added section for Docker installation.
Updated dependencies list to reflect v2.0.
Added troubleshooting section for common issues.
```

```
docs(api): document authentication endpoints

Added detailed documentation for:
- POST /api/auth/login
- POST /api/auth/logout
- POST /api/auth/refresh-token

Includes request/response examples and error codes.
```

### Performance Commits

```
perf(database): optimize user query with indexing

Added compound index on (user_id, created_at) fields.
Query execution time reduced from 850ms to 45ms.
Improves dashboard load time by 40%.
```

```
perf(images): implement lazy loading for galleries

Images now load only when visible in viewport.
Reduced initial page load from 3.2s to 1.1s.
Mobile users will see 60% improvement in load time.
```

### Refactoring Commits

```
refactor(auth): extract password validation logic

Created reusable PasswordValidator class.
Reduces code duplication across auth module.
Makes validation logic easier to test and maintain.
```

```
refactor(core): simplify state management

Migrated from Redux to React Context API.
Reduced bundle size by 35KB.
Improved code readability and maintainability.
```

### Style Commits

```
style(ui): format button styles for consistency

Applied design system spacing and colors to all buttons.
Removed inline styles in favor of CSS classes.
No functional changes - styles only.
```

```
style(code): format code with Prettier

Ran Prettier with project configuration.
No logic changes - formatting only.
Improves code consistency across team.
```

### Test Commits

```
test(auth): add comprehensive login tests

Add unit tests for:
- Valid email and password
- Invalid email format
- Empty password field
- Case-insensitive email matching

Code coverage increased from 72% to 89%.
```

```
test(api): add integration tests for user endpoints

Tests cover:
- Create user with valid data
- Validation errors for invalid email
- Duplicate email prevention
- Authentication required for protected endpoints

Tests pass on PostgreSQL and MySQL.
```

### Chore Commits

```
chore(deps): upgrade dependencies to latest versions

Updated:
- react: 17.0.2 → 18.2.0
- lodash: 4.17.21 → 4.18.0
- jest: 27.5.1 → 29.0.0

All tests passing. No breaking changes detected.
```

```
chore(ci): add GitHub Actions workflow for testing

Automated tests run on:
- Push to develop/main
- All pull requests
- Scheduled daily at 2am UTC

Tests run on Node 16, 18, and 20.
```

### Multiple Line Commit Example

```
feat(payments): integrate Stripe payment processing

Adds complete payment flow:
- Product catalog with pricing
- Shopping cart functionality
- Stripe payment integration
- Order history and receipts
- Email confirmation for orders

Key features:
- Supports credit cards and Apple Pay
- PCI DSS compliant
- Handles payment failures gracefully
- Automatic retry for failed transactions

Technical details:
- Uses Stripe SDK v3
- Implements webhook handlers for payment events
- Stores payment metadata securely
- Logs all transactions for auditing

Closes #567
Related to #568, #569
```

---

## Bad Commit Messages (Examples to Avoid)

### ❌ Too Vague

```
git commit -m "update things"
git commit -m "fixed bugs"
git commit -m "changes"
git commit -m "it works now"
git commit -m "WIP"
```

Why these are bad:
- Doesn't describe what was changed
- No context for future developers
- Hard to find with git log --grep
- Difficult to bisect when finding bugs

### ❌ No Context

```
git commit -m "asdf"
git commit -m "temp fix"
git commit -m "todo: check this later"
git commit -m "temp commit"
```

Why these are bad:
- No information whatsoever
- Unprofessional
- Indicates rushed/careless work
- Makes code review difficult

### ❌ Too Long Subject Line

```
git commit -m "Add the new authentication system with support for OAuth, JWT, two-factor authentication, and session management with cookie handling and token refresh endpoints"
```

Why this is bad:
- Subject line should be 50 characters max
- Hard to read in log output
- Makes git history difficult to navigate
- Use body for detailed explanation

### ❌ Mixing Unrelated Changes

```
git commit -m "fix(api): resolve timeout + update styles + add comments + fix typo"
```

Why this is bad:
- Multiple unrelated changes in one commit
- Hard to revert individual changes
- Makes code review complex
- Breaks the atomicity principle

### ❌ Using Imperative Mood Incorrectly

```
git commit -m "fixed the login bug"
git commit -m "adding new features"
git commit -m "created user database"
```

Better versions:
```
git commit -m "fix: login issue with session validation"
git commit -m "feat: add new payment processing"
git commit -m "feat(db): create user model"
```

### ❌ Forgetting Context

```
git commit -m "update database schema"
```

Better version:
```
git commit -m "feat(db): add user_roles table for permission management

Create new user_roles table to support role-based access control.
Includes foreign key to users table.
Includes migration script for existing databases."
```

---

## Commit Message Format Template

Use this template for your commit messages:

```
<type>(<scope>): <subject>

<body>

<footer>
```

### Type
- `feat`: New feature
- `fix`: Bug fix
- `docs`: Documentation
- `style`: Code style (formatting, not logic)
- `refactor`: Code refactoring
- `perf`: Performance improvement
- `test`: Testing
- `chore`: Build, dependencies, etc.
- `ci`: CI/CD configuration

### Scope (optional)
Component or module affected:
- `auth`, `api`, `db`, `ui`, `payment`, etc.

### Subject
- Imperative mood ("add", "fix", "implement")
- No period at end
- 50 characters or less
- Lowercase

### Body (optional)
- Explain **what** and **why**, not **how**
- 72 characters per line
- Separate from subject with blank line
- Can have multiple paragraphs

### Footer (optional)
- Reference issues: `Fixes #123`, `Closes #456`
- Breaking changes: `BREAKING CHANGE: description`
- Related: `Related to #789`

---

## Commit Message Examples by Project Type

### Web Application

```
feat(auth): implement password reset functionality

Users can now reset their password via email link.
Email includes secure token valid for 24 hours.
Password updated through secure form on reset page.

Uses bcrypt for password hashing.
Emails sent through SendGrid.

Closes #234
```

### REST API

```
feat(api): add pagination to user list endpoint

GET /api/users now supports:
- page: page number (default: 1)
- limit: items per page (default: 20, max: 100)
- sort: sort field (default: created_at)
- order: asc or desc (default: desc)

Response includes:
- data: array of users
- total: total user count
- pages: total number of pages

Fixes #345
```

### Mobile App

```
feat(ui): add dark mode support

Dark mode available in settings.
Respects system dark mode preference.
Consistent dark theme across all screens.
Uses colors from design system.

Fixes #456
```

### Library/Package

```
feat: add TypeScript type definitions

All exports now have proper TypeScript types.
Includes JSDoc comments for autocomplete.
Compatible with TypeScript 4.2+.

BREAKING CHANGE: Requires TypeScript 4.0 or higher
```

---

## Tips for Writing Better Commits

1. **Commit Frequently**
   - Multiple small commits > One giant commit
   - Easier to review, bisect, and understand

2. **Write Meaningful Messages**
   - Explain the "why", not the "what"
   - Code shows what changed, message explains why

3. **Keep Commits Focused**
   - One logical change per commit
   - Easy to revert if needed
   - Easier to test and review

4. **Use Conventions**
   - Consistent format helps team understand
   - Makes automation easier
   - Helps with changelog generation

5. **Reference Issues**
   - Link commits to issues
   - Creates connection between code and requirements
   - Helps with traceability

6. **Review Before Committing**
   - Run `git diff` before commit
   - Catch unintended changes
   - Verify commit message accuracy

---

## Auto-Generated Changelog from Commits

When commits follow conventions, tools can auto-generate changelogs:

```
# CHANGELOG.md generated from commits

## Features
- Add user authentication system
- Add dark mode support
- Add pagination to API endpoints

## Bug Fixes
- Fix login timeout issue
- Fix database connection leak
- Fix button alignment on mobile

## Performance
- Optimize user query with indexing (850ms → 45ms)
- Implement lazy loading for images (3.2s → 1.1s)

## Documentation
- Update API documentation
- Add installation guide
- Add troubleshooting section
```

This automatic changelog is generated by tools reading commit messages with proper format!

---

## Reference

For more info on commit conventions, see:
- Conventional Commits: https://www.conventionalcommits.org/
- Angular Commit Convention: https://github.com/angular/angular/blob/master/CONTRIBUTING.md
- Document: [05-commits.md](../docs/05-commits.md)
