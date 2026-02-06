# Swift Style Guide for Pettio

This document outlines the Swift coding style and best practices for the Pettio project.

## Formatting

### Indentation
- Use 4 spaces for indentation (not tabs)
- Consistent across all files

```swift
// ✅ Good
func updatePet(_ pet: Pet) {
    pet.name = "Max"
    pet.age += 1
}

// ❌ Bad
func updatePet(_ pet: Pet) {
  pet.name = "Max"
  pet.age += 1
}
```

### Line Length
- Maximum 120 characters per line
- Break long lines for readability

```swift
// ✅ Good
let match = Match(
    myPetId: myPetId,
    matchedPetId: pet.id,
    matchedPet: pet,
    matchType: .like
)

// ❌ Bad
let match = Match(myPetId: myPetId, matchedPetId: pet.id, matchedPet: pet, matchType: .like)
```

### Blank Lines
- One blank line between methods
- Two blank lines between classes/structs
- No trailing blank lines

```swift
// ✅ Good
class PetViewModel {
    var pets: [Pet] = []
    
    func loadPets() {
        // Implementation
    }
    
    func updatePet(_ pet: Pet) {
        // Implementation
    }
}


class MatchViewModel {
    // New class starts here
}
```

## Naming Conventions

### Variables & Properties
- Use camelCase
- Descriptive names
- Avoid abbreviations unless widely understood

```swift
// ✅ Good
var currentPetIndex: Int = 0
var isLoadingPets: Bool = false
let maxFetchRetries = 3

// ❌ Bad
var CPIdx: Int = 0
var loading: Bool = false
let max_fetch_retries = 3
```

### Functions & Methods
- Use camelCase
- Start with action verb for methods
- Avoid `get` prefix for getters

```swift
// ✅ Good
func fetchPets() { }
func updatePetProfile(_ pet: Pet) { }
var isActive: Bool { }

// ❌ Bad
func Fetch_Pets() { }
func getPetProfile() -> Pet? { }
func get_isActive() -> Bool { }
```

### Classes & Structs
- Use PascalCase
- Singular nouns preferred

```swift
// ✅ Good
class PetViewController { }
struct Pet { }
enum PetType { }

// ❌ Bad
class pet_view_controller { }
struct Pets { }
enum pet_type { }
```

### Constants
- Use camelCase (not SCREAMING_SNAKE_CASE)
- Define at module or class level

```swift
// ✅ Good
let maxAge = 15
let defaultLocation = "San Francisco"

// ❌ Bad
let MAX_AGE = 15
let DEFAULT_LOCATION = "San Francisco"
```

## Code Organization

### File Structure
```swift
//
//  FileName.swift
//  Pettio.IOS
//
//  Created by Name on Date.
//

import SwiftUI
import SwiftData

// MARK: - Main Class/Struct
class ViewController: UIViewController {
    // MARK: - Properties
    var property1: String
    
    // MARK: - Lifecycle
    override func viewDidLoad() { }
    
    // MARK: - Actions
    @IBAction func buttonTapped() { }
    
    // MARK: - Private Methods
    private func setupUI() { }
}
```

### Import Statements
- Group by framework
- Alphabetize within groups
- Remove unused imports

```swift
// ✅ Good
import SwiftUI
import SwiftData
import Combine

// ❌ Bad
import Combine
import SwiftData
import SwiftUI
import Foundation  // if not used
```

## SwiftUI Conventions

### View Body
- Keep body property simple
- Extract complex views into separate views
- Use `@ViewBuilder` for helper properties

```swift
// ✅ Good
struct ContentView: View {
    var body: some View {
        VStack {
            HeaderView()
            MainContent()
            FooterView()
        }
    }
}

struct HeaderView: View {
    var body: some View {
        Text("Header")
    }
}

// ❌ Bad (too complex in one view)
struct ContentView: View {
    var body: some View {
        VStack {
            Text("Header")
                .font(.title)
                .fontWeight(.bold)
            
            List {
                // 50 lines of code
            }
        }
    }
}
```

### Property Wrappers
- Use appropriate wrappers (@State, @Environment, @ObservedObject, etc.)
- Document why each wrapper is needed

```swift
// ✅ Good
@State private var isPresented = false
@Environment(\.modelContext) private var modelContext
@Observable final class ViewModel { }

// ❌ Bad
@State var isPresented = false  // Should be private
var isShowing = false  // Should use @State
```

### Modifiers Order
- Prefer: Frame → Padding → Background → Foreground → Font

```swift
// ✅ Good
Text("Hello")
    .font(.headline)
    .foregroundColor(.white)
    .padding()
    .background(Color.blue)
    .cornerRadius(8)

// ❌ Bad (inconsistent order)
Text("Hello")
    .cornerRadius(8)
    .padding()
    .font(.headline)
    .background(Color.blue)
    .foregroundColor(.white)
```

## Data Management

### Model Dependencies
- Avoid circular references
- Use weak references for delegates
- Prefer composition over inheritance

```swift
// ✅ Good
@Model
final class Pet {
    var id: String
    var name: String
    var breed: String
}

// ❌ Bad
@Model
final class Pet {
    var id: String
    var name: String
    var breed: String
    var owner: Owner?  // Can cause circular reference
}
```

### Optional Handling
- Prefer optional binding over force unwrapping
- Use guard statements for early exit

```swift
// ✅ Good
if let pet = currentPet {
    updatePetProfile(pet)
}

guard let data = data else { return }
processData(data)

// ❌ Bad
let pet = currentPet!  // Force unwrap
updatePetProfile(pet)

let data = data!
processData(data)
```

## Comments & Documentation

### File Headers
Every file should start with:
```swift
//
//  FileName.swift
//  Pettio.IOS
//
//  Created by Your Name on Date.
//
```

### Inline Comments
- Use for "why", not "what"
- Keep comments up-to-date

```swift
// ✅ Good
// Use weak reference to avoid retain cycle
weak var delegate: ViewControllerDelegate?

// ✅ Good
// Filter only active pets (performant for large datasets)
let activePets = pets.filter { $0.isActive }

// ❌ Bad
// Loop through pets
for pet in pets {
}

// ❌ Bad
// Add one to index
index += 1
```

### Documentation Comments
For public APIs:
```swift
/// Creates a new match between two pets.
/// - Parameters:
///   - myPetId: The ID of your pet
///   - matchedPetId: The ID of the matched pet
///   - matchType: Type of match (like or superLike)
/// - Returns: The newly created Match object
func createMatch(
    myPetId: String,
    matchedPetId: String,
    matchType: MatchType
) -> Match { }
```

## Accessibility

### VoiceOver Support
- Provide accessibility labels for interactive elements
- Use semantic structure

```swift
// ✅ Good
Button(action: { swipeRight() }) {
    Image(systemName: "heart.fill")
}
.accessibilityLabel("Like")
.accessibilityHint("Swipe right to like this pet")

// ❌ Bad
Button(action: { swipeRight() }) {
    Image(systemName: "heart.fill")
}
// No accessibility labels
```

## Performance

### Avoid Common Pitfalls
1. Don't use `!` (force unwrap) in production code
2. Avoid massive ViewControllers/Views
3. Use LazyVGrid/LazyVStack for long lists
4. Cache expensive computations
5. Profile with Xcode Instruments

## Testing

### Test File Naming
- `ClassNameTests.swift` for unit tests
- `ClassNameUITests.swift` for UI tests

### Test Structure
```swift
class PetViewModelTests: XCTestCase {
    var viewModel: PetViewModel!
    
    override func setUp() {
        super.setUp()
        viewModel = PetViewModel()
    }
    
    override func tearDown() {
        viewModel = nil
        super.tearDown()
    }
    
    func testFetchPets() {
        // Arrange
        // Act
        // Assert
    }
}
```

## Checklist

Before committing code:

- [ ] Code follows naming conventions
- [ ] No force unwraps (!) except in tests
- [ ] No trailing whitespace
- [ ] Lines are < 120 characters
- [ ] Comments explain "why" not "what"
- [ ] No unused imports
- [ ] Properties organized with MARK comments
- [ ] Tests are included and passing
- [ ] No print() statements (except debugging)
- [ ] Documentation is updated

## Tools

### Recommended Tools for macOS
- **SwiftLint** - Automatically enforces many of these rules
  ```bash
  brew install swiftlint
  swiftlint
  ```
- **Xcode**: Use built-in formatter: `Editor → Structure → Re-Indent`

---

**Version:** 1.0.0
**Last Updated:** February 6, 2026
