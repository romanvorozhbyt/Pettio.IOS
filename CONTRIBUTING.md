# CONTRIBUTING.md

Welcome to Pettio! We're excited to have you contribute to our pet-matching social app.

## Table of Contents

- [Code of Conduct](#code-of-conduct)
- [Getting Started](#getting-started)
- [Development Workflow](#development-workflow)
- [Commit Guidelines](#commit-guidelines)
- [Pull Request Process](#pull-request-process)
- [Code Quality](#code-quality)
- [Testing](#testing)

## Code of Conduct

Please treat all contributors with respect and courtesy. We follow the [Contributor Covenant](https://www.contributor-covenant.org/version/2/0/code_of_conduct/) code of conduct.

## Getting Started

### Prerequisites

- macOS 14.5 or later
- Xcode 16.2
- Git 2.30+

### Setup Development Environment

```bash
# Clone the repository
git clone https://github.com/romanvorozhbyt/Pettio.IOS.git
cd Pettio.IOS/Pettio.IOS

# Install git hooks for pre-commit checks
bash .githooks/install-hooks.sh

# Open in Xcode
open Pettio.IOS.xcodeproj
```

### Install Git Hooks

```bash
# This runs pre-commit checks locally before you commit
bash .githooks/install-hooks.sh
```

## Development Workflow

### 1. Create a Feature Branch

```bash
git checkout -b feature/your-feature-name
```

**Branch naming convention:**
- `feature/add-messaging` - New feature
- `fix/crash-on-swipe` - Bug fix
- `docs/update-readme` - Documentation
- `refactor/simplify-feed-logic` - Code refactoring

### 2. Make Changes

- Follow the [Swift Style Guide](/.github/SWIFT_STYLE_GUIDE.md)
- Write clear, descriptive code
- Add comments for complex logic
- Update documentation as needed

### 3. Run Local Checks

Before committing:

```bash
# Build the project
cd Pettio.IOS
xcodebuild -scheme Pettio.IOS clean build

# Run tests
xcodebuild -scheme Pettio.IOS test

# Format code (if using SwiftLint)
swiftlint --fix
```

### 4. Commit Changes

```bash
git add .
git commit -m "feat(scope): Description of changes"
```

Follow [Conventional Commits](https://www.conventionalcommits.org/):

```
type(scope): subject

body

footer
```

**Types:**
- `feat` - A new feature
- `fix` - A bug fix
- `docs` - Documentation changes
- `style` - Code style (formatting, semicolons)
- `refactor` - Code refactoring
- `perf` - Performance improvements
- `test` - Adding/updating tests
- `chore` - Build, dependencies, config
- `ci` - CI/CD changes

**Examples:**
```
feat(feed): Add endless scroll pagination

Implement infinite scroll for the pet discovery feed.
Users can now swipe through more pets without manual refresh.

Fixes #123
```

```
fix(swipe): Resolve card animation glitch on iPhone SE

The card was not centering properly on smaller screens.
Added layout constraints to fix positioning.
```

### 5. Push and Create PR

```bash
git push origin feature/your-feature-name
```

Then create a PR on GitHub:
1. Visit https://github.com/romanvorozhbyt/Pettio.IOS/pulls
2. Click "New Pull Request"
3. Select base: `dev`, compare: `feature/your-feature-name`
4. Fill in PR title and description

## Commit Guidelines

### Good Commit Messages

✅ **Good:**
```
feat(profile): Add profile image upload

Users can now upload custom images for their pet profiles.
Images are stored locally and displayed on the profile card.

Fixes #234
```

❌ **Bad:**
```
Update profile
Fixed stuff
WIP
```

### Commit Message Format

```
type(scope): subject (50 characters max)

More detailed explanation if needed. Keep lines at 72 characters.
Explain what and why, not how.

- Bullet points are okay too
- Use for multiple changes

Fixes #issue-number
Closes #issue-number
Relates to #issue-number

Co-authored-by: Name <email@example.com>
```

## Pull Request Process

### PR Title Format

```
type(scope): subject
```

**Example:**
```
feat(matches): Add messaging placeholder UI
```

### PR Checklist

Before submitting:

- [ ] Code follows style guide (`.github/SWIFT_STYLE_GUIDE.md`)
- [ ] Changes include updated documentation
- [ ] New features include tests
- [ ] Pull request description is detailed
- [ ] No hardcoded values or debug code
- [ ] All CI checks pass ✅

### PR Description Template

```markdown
## Description
Brief description of changes

## Type of Change
- [ ] Bug fix
- [ ] New feature
- [ ] Documentation update
- [ ] Breaking change

## Related Issues
Fixes #123
Relates to #456

## Testing
How was this tested?

## Screenshots (if applicable)
Before/after screenshots for UI changes

## Checklist
- [ ] Tests pass locally
- [ ] Code follows style guide
- [ ] Documentation updated
- [ ] No new warnings
```

### What to Expect

1. **GitHub Actions** runs automatically:
   - Build & Test (30-50 min)
   - PR Review (1-2 min)
   - Code Quality (5-10 min)

2. **Code Review** by maintainers:
   - Feedback on code quality
   - Suggestions for improvement
   - Approval when ready

3. **Merge**:
   - Squash commits to `dev` branch
   - Delete feature branch
   - Close related issues

## Code Quality

### Follow the Style Guide

Read [.github/SWIFT_STYLE_GUIDE.md](.github/SWIFT_STYLE_GUIDE.md) for:
- Naming conventions
- File organization
- SwiftUI conventions
- Best practices

### Key Points

- Use 4 spaces for indentation
- Maximum 120 characters per line
- camelCase for variables/methods
- PascalCase for classes/structs
- Add file headers to new files
- Use MARK comments for organization

### Example File Structure

```swift
//
//  PetView.swift
//  Pettio.IOS
//
//  Created by Your Name on 06.02.2026.
//

import SwiftUI
import SwiftData

struct PetView: View {
    // MARK: - Properties
    let pet: Pet
    @State private var isEditing = false
    
    // MARK: - Body
    var body: some View {
        VStack {
            // UI code
        }
    }
    
    // MARK: - Private Methods
    private func updatePet() {
        // Implementation
    }
}

#Preview {
    PetView(pet: Pet(...))
}
```

## Testing

### Unit Tests

```swift
class PetViewModelTests: XCTestCase {
    var viewModel: PetViewModel!
    
    override func setUp() {
        super.setUp()
        viewModel = PetViewModel()
    }
    
    func testFetchPets() {
        // Arrange
        let expectedCount = 5
        
        // Act
        viewModel.fetchPets()
        
        // Assert
        XCTAssertEqual(viewModel.pets.count, expectedCount)
    }
}
```

### Run Tests Locally

```bash
xcodebuild -scheme Pettio.IOS test
```

### UI Tests

Place UI tests in `Pettio.IOSUITests/`:

```swift
class SwipeCardUITests: XCTestCase {
    func testSwipeRight() {
        // Test swipe interaction
    }
}
```

## Documentation

### Inline Comments

```swift
// ✅ Explain WHY, not what
// Filter only active pets (improves performance for large datasets)
let activePets = pets.filter { $0.isActive }

// ❌ Don't describe obvious code
pets.filter { $0.isActive }  // Filter pets that are active
```

### Documentation Comments

```swift
/// Creates a new match between two pets.
/// - Parameters:
///   - myPetId: Your pet's ID
///   - matchedPetId: The matched pet's ID
/// - Returns: The created Match object
func createMatch(myPetId: String, matchedPetId: String) -> Match {
}
```

### Update README/SETUP

If your change affects:
- Installation process → Update `SETUP.md`
- Project structure → Update `README.md`
- Requirements → Update `REQUIREMENTS.md`

## Common Tasks

### Running Tests

```bash
# All tests
xcodebuild test

# Specific test class
xcodebuild test -only-testing Pettio_IOSTests/PetViewModelTests

# With coverage
xcodebuild test -enableCodeCoverage YES
```

### Building for Simulator

```bash
xcodebuild build \
  -scheme Pettio.IOS \
  -destination 'generic/platform=iOS Simulator,name=iPhone 16'
```

### Debugging Build Failures

```bash
# Clean build
xcodebuild clean

# Remove cache
rm -rf ~/Library/Developer/Xcode/DerivedData/Pettio*

# Rebuild
xcodebuild build
```

## Getting Help

- Check existing [Issues](https://github.com/romanvorozhbyt/Pettio.IOS/issues)
- Read the [Documentation](.github/CI_CD_GUIDE.md)
- Ask in Pull Request comments
- Join our community discussions

## Becoming a Maintainer

Interested in joining the team? Reach out after several successful contributions!

---

Thank you for contributing to Pettio! 🐾❤️

