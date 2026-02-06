# GitHub Actions CI/CD Pipeline

This project uses GitHub Actions to automate code quality checks, testing, and deployment.

## Workflows

### 1. Build & Test (`build-and-test.yml`)

**Triggers:** 
- On every PR to `main` or `dev`
- On every push to `main` or `dev`

**What it does:**
- ✅ Builds the project with Xcode 16.2
- ✅ Runs unit tests on iPhone 16 simulator
- ✅ Runs UI tests
- ✅ Checks code metrics and project organization
- ✅ Validates Swift syntax
- ✅ Generates build reports

**Jobs:**
1. **build-and-test** (20-30 min)
   - Checks out code
   - Caches dependencies (Pods, Derived Data)
   - Builds project
   - Runs unit tests
   - Uploads test logs and artifacts

2. **code-quality** (5-10 min)
   - Calculates code statistics
   - Checks Swift syntax
   - Validates project organization
   - Generates build summary

3. **lint-check** (5-10 min)
   - Checks code style (trailing whitespace, formatting)
   - Looks for common pitfalls (force unwraps, print statements)
   - Validates documentation
   - Checks for TODO/FIXME comments

**Total Time:** ~30-50 minutes

### 2. PR Review (`pr-review.yml`)

**Triggers:** 
- When a PR is opened, synchronized, or reopened

**What it does:**
- ✅ Validates PR title follows conventional commits
- ✅ Validates PR description is present and detailed
- ✅ Checks Git commit history
- ✅ Generates PR validation summary

**PR Title Format:**
```
type(scope): description

Valid types:
- feat: A new feature
- fix: A bug fix
- docs: Documentation changes
- style: Code style changes (formatting, semicolons)
- refactor: Code refactoring
- test: Adding or updating tests
- chore: Build process, dependencies
- ci: CI/CD changes
```

**Examples:**
- ✅ `feat(feed): Add infinite scroll to discover feed`
- ✅ `fix(swipe): Resolve card centering issue`
- ✅ `docs: Update setup instructions for Xcode 16.2`

### 3. Release (`release.yml`)

**Triggers:** 
- On push to `main` branch
- On creation of version tags (v1.0.0, etc.)

**What it does:**
- ✅ Builds a release archive
- ✅ Creates GitHub releases with notes
- ✅ Uploads release artifacts
- ✅ Generates release documentation

## Environment

**Runner:** macOS 14 (GitHub-hosted)
- Pre-installed with Xcode 16.2
- Swift 5.9+
- CocoaPods support

**Simulators:** iPhone 16 with iOS 18

## How to Use

### For Contributors

1. **Create a feature branch:**
   ```bash
   git checkout -b feat/your-feature
   ```

2. **Make changes and commit with conventional commits:**
   ```bash
   git commit -m "feat(module): Description of changes"
   ```

3. **Push and create PR:**
   ```bash
   git push origin feat/your-feature
   ```

4. **Wait for CI checks to pass:**
   - Watch the GitHub Actions tab
   - All checks (Build & Test, PR Review) must pass ✅
   - Address any issues if checks fail

5. **Get code review and merge:**
   - Maintainer reviews your code
   - Merge to `dev` (or `main` for hotfixes)

### For Maintainers

1. **Monitor CI status:**
   - Check GitHub Actions for each PR
   - Review test results and code quality reports

2. **Merge approved PRs:**
   ```bash
   # From GitHub UI: Squash and merge to dev
   ```

3. **Release when ready:**
   ```bash
   git tag -a v1.0.0 -m "Release version 1.0.0"
   git push origin v1.0.0
   ```

## Status Badges

Add these badges to your README:

```markdown
![Tests](https://github.com/romanvorozhbyt/Pettio.IOS/actions/workflows/build-and-test.yml/badge.svg)
![PR Review](https://github.com/romanvorozhbyt/Pettio.IOS/actions/workflows/pr-review.yml/badge.svg)
```

## Accessing CI Logs

1. Go to **Actions** tab in GitHub
2. Select the workflow run you want to view
3. Click on a job (build-and-test, code-quality, etc.)
4. Expand steps to see logs

**Test Results:**
- Build logs: `~/Library/Developer/Xcode/DerivedData/*/Logs/Build`
- Test logs: `~/Library/Developer/Xcode/DerivedData/*/Logs/Test`
- Artifacts available for 30 days

## Configuration Files

- `.github/workflows/build-and-test.yml` - Main CI workflow
- `.github/workflows/pr-review.yml` - PR validation workflow
- `.github/workflows/release.yml` - Release workflow

## Troubleshooting

### Build Failed
1. Check the error message in GitHub Actions
2. Reproduce locally:
   ```bash
   cd Pettio.IOS
   xcodebuild -scheme Pettio.IOS clean build
   ```
3. Fix the issue and push again

### Tests Failing
1. Review test results in GitHub Actions
2. Run tests locally:
   ```bash
   xcodebuild -scheme Pettio.IOS test
   ```
3. Debug and fix

### PR Review Failed (Title/Description)
1. Update PR title to follow conventional commits
2. Add a detailed PR description
3. Push changes to your branch (PR will re-run automatically)

### Caching Issues
1. Clear cache in **Actions settings** → **Clear caches**
2. Re-run the workflow

## Performance

| Workflow | Duration | Cost |
|----------|----------|------|
| Full Build & Test | 30-50 min | ~5 credits |
| Code Quality | 5-10 min | ~1 credit |
| PR Review | 1-2 min | <1 credit |
| Release | 20-30 min | ~3 credits |

## Security

- No secrets are stored in workflows
- All dependencies are from official sources
- Code is validated before merge

## Future Enhancements

- [ ] CodeQL security scanning
- [ ] SonarQube integration for code analysis
- [ ] Automated changelog generation
- [ ] Slack notifications for build status
- [ ] Automatic TestFlight builds
- [ ] App Store Connect upload
- [ ] Performance regression testing
- [ ] Visual regression testing (screenshots)

## References

- [GitHub Actions Docs](https://docs.github.com/en/actions)
- [Swift GitHub Actions](https://github.com/maxim-lobanov/setup-xcode)
- [Conventional Commits](https://www.conventionalcommits.org/)
- [Xcode Build Operations](https://developer.apple.com/documentation/xcode/building-from-the-command-line-with-xcodebuild)

---

**Last Updated:** February 6, 2026
**Version:** 1.0.0
