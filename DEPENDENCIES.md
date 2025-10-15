# Dependencies Guide

## Swift Package Manager (SPM)

Add these packages in Xcode:

### 1. Firebase SDK
```
URL: https://github.com/firebase/firebase-ios-sdk.git
Version: 10.19.0 or later
```

**Required Products:**
- `FirebaseAuth` - For authentication
- `FirebaseFirestore` - For cloud database
- `FirebaseCore` - Core Firebase functionality

**How to Add:**
1. In Xcode, go to File → Add Package Dependencies
2. Paste the GitHub URL
3. Select "Up to Next Major Version" with 10.19.0
4. Select the three products listed above
5. Click "Add Package"

---

## CocoaPods (Alternative)

If you prefer CocoaPods, create a `Podfile`:

```ruby
platform :ios, '17.0'
use_frameworks!

target 'TaskiAI' do
  # Firebase
  pod 'Firebase/Auth'
  pod 'Firebase/Firestore'
  pod 'Firebase/Core'
end

post_install do |installer|
  installer.pods_project.targets.each do |target|
    target.build_configurations.each do |config|
      config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '17.0'
    end
  end
end
```

Then run:
```bash
pod install
```

---

## Built-in Frameworks (No installation needed)

These are included with iOS SDK:

- **SwiftUI** - UI framework
- **SwiftData** - Local data persistence
- **UserNotifications** - Push notifications
- **AuthenticationServices** - Sign in with Apple
- **Foundation** - Core utilities
- **Combine** - Reactive programming

---

## Third-Party Services (API-based)

These don't require package installation, only API keys:

### OpenAI
- **Service**: GPT-4 API
- **Implementation**: `OpenAIService.swift`
- **No package needed** - Uses URLSession

### Twilio
- **Service**: SMS, Voice, Email
- **Implementation**: `TwilioService.swift`
- **No package needed** - Uses URLSession + REST API

### SendGrid
- **Service**: Email delivery
- **Implementation**: `TwilioService.swift`
- **No package needed** - Uses URLSession + REST API

### RevenueCat
- **Service**: Subscription management
- **Implementation**: `RevenueCatManager.swift`
- **Package URL**: `https://github.com/RevenueCat/purchases-ios.git`
- **Note**: Currently referenced but optional for MVP

---

## Version Requirements

| Package/Framework | Minimum Version | Notes |
|------------------|----------------|-------|
| iOS | 17.0 | Required for SwiftData |
| Xcode | 15.0 | For iOS 17 support |
| Swift | 5.9 | For latest syntax |
| Firebase | 10.19.0 | For auth & firestore |

---

## Build Settings

### Minimum Deployment Target
```
iOS 17.0
```

### Swift Version
```
Swift 5.9
```

### Bundle Identifier
```
com.taskiai.app
```

---

## Signing & Capabilities

Enable these in Xcode:

1. **Push Notifications**
   - Xcode → Target → Signing & Capabilities
   - Click + → Push Notifications

2. **Sign in with Apple**
   - Click + → Sign in with Apple

3. **Background Modes** (if needed for notifications)
   - Click + → Background Modes
   - Enable "Remote notifications"

---

## Firebase Configuration File

Required file: `GoogleService-Info.plist`

**Location**: `TaskiAI/TaskiAI/GoogleService-Info.plist`

**How to get it:**
1. Go to Firebase Console
2. Project Settings → Your Apps
3. Download the plist file
4. Drag to Xcode project

**Important**: Add to `.gitignore` to keep credentials private

---

## API Keys Security

### Development
Store keys in `Info.plist` with placeholders:
```xml
<key>OPENAI_API_KEY</key>
<string>__SET_OPENAI_API_KEY__</string>
```

Replace placeholders with real values (don't commit real keys!)

### Production
Use one of these methods:

1. **Xcode Configuration Files**
   - Create `Config.xcconfig`
   - Add keys there
   - Reference in build settings

2. **Environment Variables**
   - Use `xcconfig` with `$(OPENAI_API_KEY)`
   - Set in CI/CD pipeline

3. **Backend Proxy** (Most Secure)
   - Call your own server
   - Server makes API calls with keys
   - App never sees the keys

---

## Installation Steps

### Full Setup

1. **Install Xcode 15+**
   ```bash
   # Check version
   xcodebuild -version
   ```

2. **Clone Repository**
   ```bash
   git clone https://github.com/yourusername/taskiai.git
   cd taskiai
   ```

3. **Add Firebase Package**
   - Open project in Xcode
   - File → Add Package Dependencies
   - Add Firebase SDK

4. **Add GoogleService-Info.plist**
   - Download from Firebase Console
   - Add to project

5. **Configure API Keys**
   - Open `Info.plist`
   - Replace all `__SET_*__` placeholders

6. **Build Project**
   ```bash
   xcodebuild -project TaskiAI.xcodeproj -scheme TaskiAI -configuration Debug
   ```

7. **Run on Simulator**
   - Select iPhone 15 Pro simulator
   - Press Cmd+R

---

## Troubleshooting

### Firebase Package Issues
```
Error: Module 'Firebase' not found
```
**Solution**: Clean build folder (Cmd+Shift+K), then rebuild

### GoogleService-Info.plist Missing
```
Error: Could not load GoogleService-Info.plist
```
**Solution**: Ensure file is in project and added to target

### API Key Errors
```
Error: Invalid API key
```
**Solution**: Check Info.plist has correct keys without `__SET_` prefix

### Sign in with Apple
```
Error: Apple sign in failed
```
**Solution**: 
1. Check capability is enabled
2. Verify bundle ID matches Firebase
3. Test on real device (doesn't work in some simulators)

---

## Package Updates

To update packages:

1. In Xcode, go to File → Packages → Update to Latest Package Versions
2. Or update specific package: Right-click package → Update Package

Check for updates regularly for security patches.

---

## Dependency Graph

```
TaskiAI
├── SwiftUI (Built-in)
├── SwiftData (Built-in)
├── Firebase
│   ├── FirebaseAuth
│   ├── FirebaseFirestore
│   └── FirebaseCore
├── AuthenticationServices (Built-in)
├── UserNotifications (Built-in)
└── External APIs (via URLSession)
    ├── OpenAI (GPT-4)
    ├── Twilio (SMS/Voice)
    └── SendGrid (Email)
```

---

## Package Licenses

- **Firebase SDK**: Apache 2.0
- **SwiftUI**: Apple SDK License
- **SwiftData**: Apple SDK License

Always check third-party licenses before using in production.

---

## Support

For package-related issues:
- Firebase: https://firebase.google.com/support
- Apple Frameworks: https://developer.apple.com/support

---

**Last Updated**: October 2024
