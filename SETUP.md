# Pettio iOS - Setup & Installation Guide

## Overview

**Pettio** is a Tinder-like social app for pet owners to connect their dogs and cats. Create profiles for your pets, swipe through an endless feed, and find potential matches based on breed, location, and interests.

## System Requirements

- **macOS**: 14.5 or later
- **Xcode**: 16.2 or later
- **iOS Deployment Target**: iOS 16.0+
- **Swift**: 5.9 or later

## Prerequisites

Before getting started, ensure you have:

1. **Xcode 16.2** installed from the [App Store](https://apps.apple.com/us/app/xcode/id497799835)
2. **macOS 14.5** or later
3. **Git** installed (included with Xcode Command Line Tools)
4. An Apple Developer Account (optional, for device testing)

## Installation Steps

### 1. Clone the Repository

```bash
git clone https://github.com/romanvorozhbyt/Pettio.IOS.git
cd Pettio.IOS
```

### 2. Open the Project

```bash
cd Pettio.IOS
open Pettio.IOS.xcodeproj
```

Or open directly in Xcode:
- Launch Xcode
- File → Open
- Select `Pettio.IOS.xcodeproj`

### 3. Select Target and Simulator

1. In Xcode, select the **Pettio.IOS** target from the target dropdown
2. Choose a simulator:
   - **iPhone 16** (recommended)
   - **iPhone 15 Pro**
   - **iPhone 14**
   - Any iPhone with iOS 16.0 or later

### 4. Build and Run

```bash
# Using Xcode UI
Cmd + R  (Run)

# Or using command line
xcodebuild -scheme Pettio.IOS -destination 'generic/platform=iOS Simulator,name=iPhone 16' build
```

## Project Structure

```
Pettio.IOS/
├── Models/
│   ├── Pet.swift              # Pet profile model
│   ├── Match.swift            # Match tracking model
│   └── SwipeAction.swift      # Swipe interaction model
├── ViewModels/
│   ├── FeedViewModel.swift    # Feed state management
│   ├── MatchesViewModel.swift # Matches management
│   └── ProfileViewModel.swift # Profile management
├── Views/
│   ├── ContentView.swift      # Main tab navigation
│   ├── FeedView.swift         # Swipeable pet feed
│   ├── SwipeCardView.swift    # Individual pet card
│   ├── FilterView.swift       # Feed filters
│   ├── MatchesView.swift      # Matched pets list
│   ├── ProfileView.swift      # User's pet profile
│   └── SettingsView.swift     # App settings
├── Pettio_IOSApp.swift        # App entry point
└── Assets.xcassets/           # Images and colors
```

## Core Features

### 1. **Pet Profiles**
- Create and edit pet profiles with:
  - Name, breed, age, size, type (dog/cat)
  - Location and bio
  - Interests and purpose (playmate, breeding, adoption, friendship)
  - Multiple image URLs

### 2. **Endless Feed**
- Swipeable card-based feed
- Smooth gesture animations
- Stacked card preview effect
- Real-time filtering

### 3. **Swipe Interactions**
- **Right Swipe / Like Button**: Show interest in a pet
- **Left Swipe / Dislike Button**: Pass on a pet
- **Up Swipe / Super Like Button**: Express strong interest
- All interactions are tracked and create matches

### 4. **Feed Customization**
Filter pets by:
- Age range (0-15 years)
- Breed selection
- Pet size (Small, Medium, Large)
- Purpose (Playmate, Breeding, Adoption, Friendship)

### 5. **Matches System**
- View all matched pets
- See match type (Like or SuperLike)
- Browse matched pet details
- Message functionality placeholder

### 6. **Settings & Preferences**
- Toggle push notifications
- Privacy settings (private profile)
- Discovery preferences (distance, age, pet type)
- About and legal information

## Data Persistence

The app uses **SwiftData** for local data storage:
- All pet profiles are stored locally
- Matches and swipe history are persisted
- Data is automatically saved to device

**Note:** Data syncing to a backend server is not implemented in this version.

## Code Compatibility

### Swift Version
- **Minimum**: Swift 5.9
- **Recommended**: Swift 5.9+

### iOS Compatibility
- **Deployment Target**: iOS 16.0+
- Uses modern SwiftUI 4 features (iOS 16+)
- Uses `@Observable` macro (iOS 17+, with fallback for iOS 16)

### Framework Dependencies
- **SwiftUI**: Native UI framework
- **SwiftData**: Modern database persistence
- **Combine**: Reactive programming (implicit)

## Building from Command Line

### Build for Simulator
```bash
xcodebuild -scheme Pettio.IOS \
  -destination 'generic/platform=iOS Simulator,name=iPhone 16' \
  -configuration Debug \
  build
```

### Run Tests
```bash
xcodebuild -scheme Pettio.IOS \
  -destination 'generic/platform=iOS Simulator,name=iPhone 16' \
  test
```

### Archive for Distribution
```bash
xcodebuild -scheme Pettio.IOS \
  archivePath "$(pwd)/Pettio.xcarchive" \
  archive
```

## Troubleshooting

### Problem: "Cannot open file" errors
**Solution:**
1. Clean build folder: `Cmd + Shift + K`
2. Delete DerivedData: `rm -rf ~/Library/Developer/Xcode/DerivedData/Pettio*`
3. Rebuild project: `Cmd + B`

### Problem: SwiftData model conflicts
**Solution:**
1. Ensure all model files are in `Models/` folder
2. Verify models are registered in `Pettio_IOSApp.swift`
3. Clear app data in simulator: Device → Erase All Content and Settings

### Problem: Deployment target mismatch
**Solution:**
1. Select project in Xcode
2. Select target → Build Settings
3. Set "iOS Deployment Target" to 16.0 or later

### Problem: ViewBuilder errors
**Solution:**
- Update Xcode to 16.2 or later
- Clear derived data and rebuild
- Avoid imperative code in View bodies (use computed properties)

## Development Best Practices

### Code Organization
- **Models**: Data structures with `@Model` decorator
- **ViewModels**: State management with `@Observable`
- **Views**: UI components using SwiftUI

### Performance Optimization
- Use `LazyVStack` and `LazyVGrid` for large lists
- Implement card pagination in feed
- Cache pet images locally (future enhancement)

### Testing
- Unit tests in `Pettio.IOSTests/`
- UI tests in `Pettio.IOSUITests/`
- Run with: `Cmd + U`

## Git Workflow

### Branch Structure
- **main**: Production-ready code
- **dev**: Development branch with latest features

### Creating a PR
```bash
git checkout -b feature/your-feature-name
# Make changes
git add .
git commit -m "feat: Add your feature description"
git push origin feature/your-feature-name
```

Then create a pull request to `dev` branch.

## Next Steps & Future Enhancements

- [ ] Backend API integration (user authentication, messaging)
- [ ] Image upload and storage (CloudKit or Firebase)
- [ ] Real-time messaging system
- [ ] Push notifications
- [ ] Location services integration
- [ ] User authentication system
- [ ] Social features (follow, block, report)

## Support & Troubleshooting

For issues or questions:
1. Check existing GitHub issues
2. Review error messages carefully
3. Ensure all system requirements are met
4. Try clearing build artifacts and rebuilding

## License

Specify your license here (MIT, Apache, etc.)

## Author

Created by Katerina Kaverina & Roman Vorozhbyt
Created on 06 February 2026

---

**Happy coding! 🐾**
