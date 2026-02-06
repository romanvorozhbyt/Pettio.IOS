# System Requirements & Compatibility

## Minimum Requirements

### Operating System
- **macOS**: 14.5 or later
- **iOS Deployment Target**: iOS 16.0 or later

### Development Tools
- **Xcode**: 16.2 or later
- **Swift**: 5.9 or later
- **Git**: 2.30 or later (included with Xcode)

### Hardware
- **Mac Model**: Any Mac with Apple Silicon (M1+) or Intel processor compatible with macOS 14.5
- **RAM**: 8GB minimum (16GB recommended)
- **Storage**: 10GB free space minimum for Xcode and build artifacts

## Recommended Setup

### Operating System
- **macOS**: 14.5 - 15.x (latest stable)
- **iOS Deployment Target**: iOS 16.0 - 18.x

### Development Tools
- **Xcode**: 16.2 (latest stable version)
- **Swift**: 5.9+ (included with Xcode)
- **Git**: 2.40+

### Hardware
- **Mac Model**: Apple Silicon Mac (M1, M2, M3, M4)
- **RAM**: 16GB or more
- **Storage**: 50GB free space
- **Display**: 13" or larger for development comfort

### Simulator Devices
- **iPhone 15 or 16** (recommended)
- **iOS Version**: 18.x (or iOS 17.x, 16.x)

## Framework Dependencies

### Core Frameworks (iOS 16.0+)
- **SwiftUI** - UI Framework
- **SwiftData** - Data Persistence
- **Combine** - Reactive Programming (implicit)
- **Foundation** - Base APIs

### Optional Frameworks (for future features)
- **CloudKit** - Cloud sync (not yet integrated)
- **UserNotifications** - Push notifications (not yet implemented)
- **CoreLocation** - Location services (not yet integrated)
- **Vision** - Image processing (for future image features)

## Swift Language Version

```
SWIFT_VERSION = 5.9
```

## Xcode Project Settings

### Build Settings
- **Minimum Deployment Target**: iOS 16.0
- **Swift Compiler Version**: Swift 5.9 or later
- **Build System**: New Build System (Xcode 14+)
- **Linking**: Other Linker Flags: None required

### Code Signing
- **Signing Certificate**: Any Apple Development certificate
- **Team ID**: Required for device testing
- **Provisioning Profile**: Automatic for simulator testing

## Compatibility Matrix

| Component | Minimum | Recommended | Notes |
|-----------|---------|-------------|--------|
| macOS | 14.5 | 14.5+ | M1+ recommended |
| Xcode | 16.2 | 16.2+ | No iOS 14/15 support |
| Swift | 5.9 | 5.9+ | Requires @Observable macro |
| iOS | 16.0 | 17.0+ | SwiftUI 4 features |
| iPhone | iPhone SE 2 | iPhone 15/16 | Testing device recommendation |

## Known Compatibility Issues

### macOS 14.4 and earlier
- ❌ **Not supported** - Xcode 16.2 requires macOS 14.5+

### Xcode 16.1 and earlier
- ❌ **Not supported** - Some APIs require 16.2
- ⚠️ May have compatibility issues with SwiftUI 4

### iOS 15.x and earlier
- ❌ **Not supported** - Minimum target is iOS 16.0
- SwiftUI changes breaking changes in iOS 16

### Swift 5.8 and earlier
- ❌ **Not supported** - @Observable macro requires Swift 5.9

## Environment Variables

None currently required for development.

## Network Requirements

- **Internet connection**: Required for:
  - Fetching dependencies
  - Running on simulator
  - GitHub integration
  - App Store distribution

## Disk Space Requirements

| Component | Size |
|-----------|------|
| macOS 14.5+ | 15-20GB |
| Xcode 16.2 | 10-15GB |
| iOS 16-18 Simulators | 5-20GB (varies) |
| Project + Dependencies | 500MB |
| **Total** | **~30-50GB** |

## Installation Verification

After installation, verify your setup:

```bash
# Check macOS version
system_profiler SPSoftwareDataType | grep "System Version"

# Check Xcode installation
xcode-select -p
# Should output: /Applications/Xcode.app/Contents/Developer

# Check Swift version
swift --version
# Should output: swift-driver version 1.x.x (or higher)
# Apple Swift version 5.9 (or higher)

# Check Xcode version
xcodebuild -version
# Should output: Xcode 16.2 (or higher)

# Test project
cd Pettio.IOS
xcodebuild -version
xcodebuild -scheme Pettio.IOS clean
```

## Troubleshooting Installation

### Issue: "xcode-select: error: unable to get active developer directory"
```bash
sudo xcode-select -r
sudo xcode-select --switch /Applications/Xcode.app/Contents/Developer
```

### Issue: "Swift version mismatch"
- Update to Xcode 16.2+
- Clear derived data: `rm -rf ~/Library/Developer/Xcode/DerivedData/*`

### Issue: "Cannot find simulator"
- Xcode → Preferences → Components
- Download iOS 16+ simulator

### Issue: "macOS version too old"
- Update to macOS 14.5 or later
- Check System Preferences → General → Software Update

## CI/CD Compatibility

### GitHub Actions
- Recommended runner: `macos-13` or `macos-14`
- Swift 5.9+ available
- Xcode 16.2+ available

### Local CI/CD
```bash
# Example GitHub Actions workflow
xcodebuild -scheme Pettio.IOS \
  -destination 'generic/platform=iOS Simulator,name=iPhone 16' \
  -configuration Debug \
  clean build test
```

## Performance Benchmarks

Expected build times (clean build on M1 Mac):
- **Debug Build**: 30-60 seconds
- **Release Build**: 60-120 seconds
- **Unit Tests**: 15-30 seconds
- **UI Tests**: 2-3 minutes

## Support

For compatibility issues:
1. Verify all system requirements are met
2. Update to latest Xcode/macOS versions
3. Clear build artifacts: `Cmd + Shift + K`
4. Delete derived data: `rm -rf ~/Library/Developer/Xcode/DerivedData/Pettio*`
5. Check GitHub Issues for similar problems

---

**Last Updated**: February 6, 2026
**Version**: 1.0.0
