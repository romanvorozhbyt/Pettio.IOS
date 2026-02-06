# Pettio iOS

A Tinder-like social app for pet owners to connect their dogs and cats. Create profiles for your pets, swipe through an endless feed, and find potential matches based on breed, location, and interests.

![iOS](https://img.shields.io/badge/iOS-16.0+-blue.svg)
![Xcode](https://img.shields.io/badge/Xcode-16.2+-orange.svg)
![Swift](https://img.shields.io/badge/Swift-5.9+-red.svg)
![License](https://img.shields.io/badge/License-MIT-green.svg)

## ✨ Features

### Core Functionality
- 🐾 **Pet Profiles**: Create and customize profiles for your dogs and cats
- 🔄 **Endless Feed**: Swipeable card-based discovery feed
- 💬 **Swipe Interactions**: Like (right), Dislike (left), or Super Like (up)
- 🔍 **Smart Filtering**: Filter by breed, age, size, and purpose
- ⚙️ **Settings & Preferences**: Customize discovery and notification preferences

### Native Mobile Design
- 📱 **Native iOS**: Built with SwiftUI for iOS 16.0+
- 👆 **Touch-Friendly UI**: Smooth gestures and proper touch targets
- ✨ **Smooth Animations**: Fluid swipe interactions with stacked cards
- 📐 **Adaptive Layouts**: Works seamlessly on all iPhone screen sizes

## 🚀 Quick Start

### Requirements
- macOS 14.5 or later
- Xcode 16.2 or later
- iOS deployment target: 16.0+

### Installation

1. **Clone the repository**
   ```bash
   git clone https://github.com/romanvorozhbyt/Pettio.IOS.git
   cd Pettio.IOS/Pettio.IOS
   ```

2. **Open in Xcode**
   ```bash
   open Pettio.IOS.xcodeproj
   ```

3. **Select a simulator and run**
   - Press `Cmd + R` or click the Run button
   - Wait for the build to complete

For detailed setup instructions, see [SETUP.md](SETUP.md)

## 📐 Project Architecture

```
Pettio.IOS/
├── Models/                 # Data models with SwiftData
│   ├── Pet.swift
│   ├── Match.swift
│   └── SwipeAction.swift
├── ViewModels/            # State management (@Observable)
│   ├── FeedViewModel.swift
│   ├── MatchesViewModel.swift
│   └── ProfileViewModel.swift
├── Views/                 # SwiftUI components
│   ├── ContentView.swift           # Main TabView
│   ├── FeedView.swift              # Swipe feed
│   ├── SwipeCardView.swift         # Individual card
│   ├── FilterView.swift            # Feed filters
│   ├── MatchesView.swift           # Matched pets
│   ├── ProfileView.swift           # Pet profile
│   └── SettingsView.swift          # App settings
└── Assets/                # Images and colors
```

## 🎮 How to Use

### 1. Create Your Pet Profile
- Tap the **Profile** tab
- Click **Create Profile**
- Fill in your pet's details (name, breed, age, location, bio)
- Save your profile

### 2. Discover Matches
- Go to the **Discover** tab
- Swipe right (`❤️`) to like a pet
- Swipe left (`✗`) to pass
- Swipe up (`⭐`) for a super like
- Use the filter button to customize your search

### 3. Manage Matches
- Check the **Matches** tab to see all your matches
- Tap a match to view their full profile
- Send a message (messaging feature coming soon!)

### 4. Customize Settings
- Go to **Settings** to configure:
  - Notification preferences
  - Privacy settings
  - Discovery preferences (distance, age range, pet type)

## 🏗️ Architecture

### Models (Data Layer)
- **Pet**: Complete pet profile with attributes (breed, age, size, location, interests, purpose)
- **Match**: Represents a match between two pets with match type
- **SwipeAction**: Tracks all swipe interactions (Like, Dislike, SuperLike)

### ViewModels (Business Logic)
- **FeedViewModel**: Manages card stack, filtering, and swipe logic
- **MatchesViewModel**: Manages matches list and filtering
- **ProfileViewModel**: Manages user's pet profile state

### Views (UI Layer)
- **SwipeCardView**: Animated card with gesture recognition
- **FeedView**: Card stack with gesture handlers
- **MatchesView**: List of matches with detail navigation
- **FilterView**: Interactive filter controls
- **ProfileView**: Pet profile display and editing
- **SettingsView**: App configuration options

## 💾 Data Storage

- Uses **SwiftData** for local persistence
- All data stored on device
- No backend sync in this version

## 🔧 Development

### Building from Command Line
```bash
xcodebuild -scheme Pettio.IOS \
  -destination 'generic/platform=iOS Simulator,name=iPhone 16' \
  build
```

### Running Tests
```bash
xcodebuild -scheme Pettio.IOS test
```

### Code Quality
- Follows SwiftUI best practices
- Organized with MVVM architecture
- Proper separation of concerns

## 📱 Supported Devices

- iPhone 15, 15 Plus, 15 Pro, 15 Pro Max
- iPhone 14, 14 Plus, 14 Pro, 14 Pro Max
- iPhone 13, 13 mini, 13 Pro, 13 Pro Max
- iPhone SE (3rd generation)
- Any iPhone running iOS 16.0 or later

## 🐛 Known Issues & Limitations

- Messaging system is not yet implemented
- Backend API integration is not included
- Image upload functionality is placeholder
- Push notifications are not configured
- Location services are not integrated

## 🔮 Future Enhancements

- [ ] Backend API integration (Node.js/Django)
- [ ] Cloud image storage (CloudKit/Firebase)
- [ ] Real-time messaging
- [ ] Push notifications
- [ ] GPS-based location matching
- [ ] User authentication system
- [ ] Social features (follow, block, report)
- [ ] Dark mode support
- [ ] Android version

## 🤝 Contributing

We welcome contributions! Please:

1. Create a feature branch: `git checkout -b feature/your-feature`
2. Make your changes
3. Commit: `git commit -m "feat: Your feature description"`
4. Push: `git push origin feature/your-feature`
5. Open a Pull Request to the `dev` branch

## 📄 License

MIT License - see LICENSE file for details

## 👥 Authors

- **Katerina Kaverina** - Initial implementation
- **Roman Vorozhbyt** - Architecture & design

## 📧 Contact & Support

For issues, questions, or suggestions:
- Open a GitHub Issue
- Check existing discussions
- See [SETUP.md](SETUP.md) for troubleshooting

## 📚 Resources

- [SwiftUI Documentation](https://developer.apple.com/xcode/swiftui/)
- [SwiftData Documentation](https://developer.apple.com/documentation/swiftdata)
- [iOS Human Interface Guidelines](https://developer.apple.com/design/human-interface-guidelines/ios)

---

**Status**: Beta v1.0 | **Last Updated**: February 6, 2026 | **Maintained**: ✅ Active

**Happy swiping! 🐾❤️**
