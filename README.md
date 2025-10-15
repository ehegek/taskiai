# TaskiAI - AI-Powered Task Manager

A full-featured iOS task management app with AI assistant, multi-channel reminders, and referral system.

## Features

### 🤖 AI Chat Assistant (GPT-4)
- Natural language task management
- Context-aware responses with full task list
- Automatically modify, create, or delete tasks via conversation
- Example: "What do I need to do this week?" or "Change the meeting to tomorrow"

### 📱 Multi-Channel Reminders
- **App Push Notifications**: 10 minutes before + exact time
- **SMS Reminders**: via Twilio
- **Email Reminders**: via SendGrid
- **Phone Call Reminders**: Automated calls with text-to-speech

### 🔥 Streak System
- Track daily task completion streaks
- Synced to Firebase Firestore
- Motivates consistent productivity

### 👥 Referral System
- Each user gets a unique referral code
- Track referrals and reward users
- Share code to invite friends

### 🔐 Authentication
- Email/Password sign-in (Firebase)
- Sign in with Apple
- Secure user data storage

### 🎨 Dark Mode
- Full dark theme support
- System/Light/Dark options
- Smooth theme transitions

### 📊 Task Management
- Create, edit, delete tasks
- Categories and tags
- Repeat rules (daily, weekly, monthly)
- Attach images
- Notes and descriptions

---

## Referral System - Implementation & Recommendations

### Current Implementation

The app includes a fully functional referral system:

1. **Automatic Code Generation**: Each user gets a unique 8-character code on signup
2. **Code Sharing**: Users can copy their code from Account Settings
3. **Code Redemption**: New users can apply a referral code
4. **Tracking**: Both referrer and referee are tracked in Firestore
5. **Statistics**: View referral count in Account Settings

### How It Works

```swift
// User A signs up → Gets code "ABC123XY"
// User A shares code with User B
// User B signs up and enters "ABC123XY"
// System:
//   - Links User B to User A (referredBy field)
//   - Increments User A's referralCount
//   - Both users can receive rewards
```

### Reward Strategies

Here are recommended strategies for your referral program:

#### 1. **Premium Features Unlock**
```
Referrer Reward: 1 month free premium for every 3 referrals
Referee Reward: 7 days free premium trial
```

Implementation:
```swift
// In FirestoreService.applyReferralCode()
if success {
    // Give referee 7 days premium
    try await updateUser(userId: userId, fields: [
        "premiumUntil": Date().addingTimeInterval(7 * 24 * 60 * 60)
    ])
    
    // Check if referrer reached milestone
    let newCount = currentCount + 1
    if newCount % 3 == 0 {
        // Give referrer 1 month premium
        try await updateUser(userId: referrerId, fields: [
            "premiumUntil": Date().addingTimeInterval(30 * 24 * 60 * 60)
        ])
    }
}
```

#### 2. **Task Boost System**
```
Referrer: +5 AI chat credits per referral
Referee: +10 AI chat credits on signup
```

Good for apps with usage limits.

#### 3. **Gamification Rewards**
```
Achievements/Badges:
- "Networker": 5 referrals
- "Influencer": 25 referrals  
- "Legend": 100 referrals

Each tier unlocks exclusive features:
- Custom app icons
- Special themes
- Priority support
```

#### 4. **Tiered System** (Recommended)
```
Tier 1 (1-4 referrals):
  - Referrer: 2 weeks premium per referral
  - Referee: 1 week premium

Tier 2 (5-9 referrals):
  - Referrer: 1 month premium per referral
  - Referee: 2 weeks premium
  - Bonus: Custom category icons unlocked

Tier 3 (10+ referrals):
  - Referrer: Lifetime premium
  - Referee: 1 month premium
  - Bonus: All features unlocked forever
```

#### 5. **Monetary Rewards** (If you have revenue)
```
Referrer: $5 credit per referral (redeemable on subscription)
Referee: $3 credit on first purchase
Minimum $25 to cash out (encourages 5+ referrals)
```

### Best Practices

1. **Make Sharing Easy**
   - Add "Share" button in Account Settings
   - Include referral code in app share text
   - Deep links to auto-apply code

2. **Clear Communication**
   - Show what users get for referring
   - Display progress toward next reward
   - Send notifications when reward is earned

3. **Prevent Abuse**
   - Limit one referral per email/device
   - Require referee to complete onboarding
   - Delay reward until referee is active for 7 days

4. **Track Performance**
   - Monitor referral conversion rate
   - A/B test different reward amounts
   - Send reminders to share code

### Implementation Example

```swift
// In AccountSettingsView, add share button:
Button {
    let text = """
    Join me on TaskiAI! Use my referral code \(appState.referralCode ?? "") 
    to get 1 week of premium free!
    
    Download: https://apps.apple.com/app/taskiai
    """
    
    let activityVC = UIActivityViewController(
        activityItems: [text],
        applicationActivities: nil
    )
    
    // Present share sheet
    if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
       let window = windowScene.windows.first,
       let rootVC = window.rootViewController {
        rootVC.present(activityVC, animated: true)
    }
} label: {
    Label("Share Referral Code", systemImage: "square.and.arrow.up")
}
```

### Analytics to Track

- Referral code usage rate (% of users who share)
- Conversion rate (% who use shared codes)
- Average referrals per user
- Time to first referral
- Lifetime value of referred users

### Push Notification Ideas

```
"🎉 You've earned a reward! [Name] joined using your code"
"💰 2 more referrals to unlock lifetime premium!"
"🚀 Share your code with friends and earn rewards"
```

---

## Tech Stack

- **Language**: Swift 5.9
- **UI Framework**: SwiftUI
- **Database**: SwiftData (local) + Firebase Firestore (cloud)
- **Authentication**: Firebase Auth
- **AI**: OpenAI GPT-4
- **Notifications**: UserNotifications + Twilio
- **Email**: SendGrid
- **Payments**: RevenueCat

---

## Setup

See [SETUP.md](SETUP.md) for detailed configuration instructions.

### Quick Start

1. Clone the repository
2. Open `TaskiAI.xcodeproj` in Xcode
3. Add Firebase dependencies via SPM
4. Add `GoogleService-Info.plist`
5. Configure API keys in `Info.plist`
6. Build and run

---

## Project Structure

```
TaskiAI/
├── TaskiAI/
│   ├── Models/
│   │   └── Task.swift              # Task & Category models
│   ├── ViewModels/
│   │   ├── AppState.swift          # Global app state
│   │   └── TaskStore.swift         # Task management
│   ├── Views/
│   │   ├── AuthView.swift          # Authentication
│   │   ├── ChatView.swift          # AI chat interface
│   │   ├── RootView.swift          # Main dashboard
│   │   ├── RemindersView.swift     # Reminders list
│   │   ├── SettingsView.swift      # Settings menu
│   │   └── Settings/               # Settings subpages
│   ├── Services/
│   │   ├── FirebaseAuthService.swift    # Firebase auth
│   │   ├── FirestoreService.swift       # Database operations
│   │   ├── TwilioService.swift          # SMS/Call/Email
│   │   ├── OpenAIService.swift          # GPT-4 integration
│   │   └── NotificationService.swift    # Push notifications
│   └── TaskiAIApp.swift            # App entry point
├── SETUP.md                        # Setup instructions
└── README.md                       # This file
```

---

## API Keys Required

- Firebase (Authentication + Firestore)
- OpenAI API Key
- Twilio Account SID + Auth Token
- SendGrid API Key
- RevenueCat (optional, for subscriptions)

---

## Features Roadmap

### Phase 1 ✅ (Current)
- [x] Task CRUD operations
- [x] Multi-channel reminders
- [x] AI chat assistant
- [x] Firebase authentication
- [x] Referral system
- [x] Dark mode
- [x] Streak tracking

### Phase 2 🚧 (Next)
- [ ] Task templates
- [ ] Collaboration (shared tasks)
- [ ] Calendar integration
- [ ] Widget support
- [ ] Apple Watch app
- [ ] Siri shortcuts

### Phase 3 🎯 (Future)
- [ ] Smart scheduling (AI suggests best times)
- [ ] Location-based reminders
- [ ] Task time tracking
- [ ] Productivity analytics
- [ ] Team workspaces
- [ ] API for third-party integrations

---

## Contributing

This is a commercial project. For inquiries, contact: support@taskiai.app

---

## License

Proprietary - All rights reserved

---

## Support

- Email: support@taskiai.app
- Twitter: @TaskiAI
- Website: https://taskiai.app

---

## Acknowledgments

- OpenAI for GPT-4 API
- Firebase for backend infrastructure
- Twilio for communication APIs
- SendGrid for email delivery
- RevenueCat for subscription management

---

**Built with ❤️ using SwiftUI**
