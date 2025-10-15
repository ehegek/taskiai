# TaskiAI Setup Guide

This guide will help you configure all the necessary services for TaskiAI to work at full capacity.

## Table of Contents
1. [Firebase Setup](#firebase-setup)
2. [Twilio Setup](#twilio-setup)
3. [SendGrid Setup](#sendgrid-setup)
4. [OpenAI Setup](#openai-setup)
5. [Configuration](#configuration)

---

## Firebase Setup

### 1. Create Firebase Project
1. Go to [Firebase Console](https://console.firebase.google.com/)
2. Click "Add project"
3. Name it "TaskiAI" and follow the setup wizard

### 2. Enable Authentication
1. In Firebase Console, go to **Authentication** → **Sign-in method**
2. Enable **Email/Password** provider
3. Enable **Apple** provider:
   - You'll need an Apple Developer account
   - Configure Service ID, Team ID, Key ID, and Private Key
   - [Apple Sign-In Documentation](https://firebase.google.com/docs/auth/ios/apple)

### 3. Setup Firestore Database
1. Go to **Firestore Database** → **Create database**
2. Start in **production mode** (we'll add security rules later)
3. Choose a location close to your users

### 4. Security Rules
Add these Firestore security rules:
```
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    match /users/{userId} {
      allow read, write: if request.auth != null && request.auth.uid == userId;
      
      match /tasks/{taskId} {
        allow read, write: if request.auth != null && request.auth.uid == userId;
      }
    }
  }
}
```

### 5. Download GoogleService-Info.plist
1. In Firebase Console, go to **Project Settings** → **Your apps**
2. Add an iOS app (bundle ID: `com.taskiai.app`)
3. Download `GoogleService-Info.plist`
4. Add it to your Xcode project at `TaskiAI/TaskiAI/GoogleService-Info.plist`

---

## Twilio Setup

### 1. Create Twilio Account
1. Sign up at [Twilio](https://www.twilio.com/try-twilio)
2. Verify your email and phone number

### 2. Get Phone Number
1. Go to **Phone Numbers** → **Buy a number**
2. Choose a number with SMS, Voice, and MMS capabilities
3. Note down this number

### 3. Get API Credentials
1. Go to **Dashboard** → **Account Info**
2. Copy your **Account SID** and **Auth Token**

### 4. (Optional) Configure TwiML Bin for Phone Calls
1. Go to **Developer Tools** → **TwiML Bins**
2. Create a new TwiML Bin for call handling
3. Or use inline TwiML (already configured in code)

---

## SendGrid Setup

### 1. Create SendGrid Account
1. Sign up at [SendGrid](https://sendgrid.com/)
2. Complete the verification process

### 2. Get API Key
1. Go to **Settings** → **API Keys**
2. Click **Create API Key**
3. Name it "TaskiAI"
4. Choose **Full Access** or **Restricted Access** with Mail Send permissions
5. Copy the API key (you'll only see it once!)

### 3. Configure Sender Identity
1. Go to **Settings** → **Sender Authentication**
2. Verify either a **Single Sender** or a **Domain**
3. Use `noreply@taskiai.app` or your verified email

---

## OpenAI Setup

### 1. Create OpenAI Account
1. Sign up at [OpenAI](https://platform.openai.com/)
2. Add payment method (required for API access)

### 2. Get API Key
1. Go to [API Keys](https://platform.openai.com/api-keys)
2. Click **Create new secret key**
3. Name it "TaskiAI"
4. Copy the API key

### 3. Choose Model
- The app is configured to use `gpt-4-turbo-preview`
- You can change to `gpt-4`, `gpt-4o`, or `gpt-3.5-turbo` in `OpenAIService.swift`
- Note: GPT-4 models are more expensive but provide better task management

---

## Configuration

### Update Info.plist
Open `TaskiAI/TaskiAI/Info.plist` and replace the placeholder values:

```xml
<key>OPENAI_API_KEY</key>
<string>sk-your-actual-openai-key-here</string>

<key>TWILIO_ACCOUNT_SID</key>
<string>ACxxxxxxxxxxxxxxxxxxxxxxxxxxxx</string>

<key>TWILIO_AUTH_TOKEN</key>
<string>your-twilio-auth-token-here</string>

<key>TWILIO_PHONE_NUMBER</key>
<string>+1234567890</string>

<key>SENDGRID_API_KEY</key>
<string>SG.xxxxxxxxxxxxxxxxxxxxxxxxxx</string>

<key>TWILIO_EMAIL</key>
<string>noreply@taskiai.app</string>
```

### Configure Apple Sign-In
1. In Xcode, select the project
2. Go to **Signing & Capabilities**
3. Add **Sign in with Apple** capability
4. Make sure your Bundle ID matches Firebase configuration

### Add Required Packages
Add these Swift Package dependencies in Xcode:

1. **Firebase SDK**
   - URL: `https://github.com/firebase/firebase-ios-sdk.git`
   - Products: `FirebaseAuth`, `FirebaseFirestore`

2. Already included in project:
   - SwiftData (built-in)
   - AuthenticationServices (built-in)

### Info.plist Permissions
Make sure these are present (already added):
```xml
<key>NSUserTrackingUsageDescription</key>
<string>We use tracking to provide personalized task recommendations</string>

<key>NSContactsUsageDescription</key>
<string>We need access to contacts to share tasks</string>
```

---

## Testing

### Test Each Feature

1. **Firebase Auth**
   - Sign up with email/password
   - Sign in with Apple ID

2. **Firestore**
   - Create a task
   - Check Firebase Console to see it synced

3. **Push Notifications**
   - Create a task with reminder
   - Enable app notifications in Settings
   - Wait for notification (or change time to test)

4. **SMS/Email (Twilio/SendGrid)**
   - Add phone number in Account Settings
   - Create task with SMS or Email reminder
   - Check if SMS/Email arrives

5. **Phone Call (Twilio)**
   - Create task with Phone Call reminder
   - You should receive a call with TTS message

6. **AI Chat (OpenAI)**
   - Open Chat view
   - Ask: "What do I need to do this week?"
   - Ask: "Change the meeting task to tomorrow"

7. **Referral System**
   - Go to Account Settings
   - Copy your referral code
   - Share with another user
   - Check referral count increases

8. **Streak Feature**
   - Create a task today
   - Check streak in Account Settings
   - Create another task tomorrow
   - Streak should increment

9. **Dark Mode**
   - Go to Settings → General
   - Toggle theme between System/Light/Dark
   - UI should change accordingly

---

## Cost Estimates

### Monthly Costs (approximate)
- **Firebase**: Free tier covers most small apps
- **Twilio SMS**: $0.0075 per SMS
- **Twilio Voice**: $0.013 per minute
- **SendGrid**: Free tier (100 emails/day)
- **OpenAI GPT-4**: ~$0.03 per 1K tokens (~$0.10 per conversation)

**Total**: Minimal for testing, scales with usage

---

## Production Deployment

### Backend Scheduler (Important!)
For production, you should implement a backend scheduler for Twilio reminders:

1. **Firebase Cloud Functions** (Recommended)
   - Schedule SMS/Email/Calls at specific times
   - Example function:
   ```javascript
   exports.sendScheduledReminders = functions.pubsub
     .schedule('every 1 minutes')
     .onRun(async (context) => {
       // Query tasks with reminders due now
       // Send via Twilio
     });
   ```

2. **Alternative**: AWS Lambda, Heroku Scheduler, or Cron job

### Security
1. Never commit API keys to Git
2. Use environment variables or secure storage
3. Enable Firestore security rules
4. Implement rate limiting for API calls

---

## Troubleshooting

### Firebase Auth Issues
- Make sure `GoogleService-Info.plist` is in the project
- Check Bundle ID matches Firebase project
- For Apple Sign-In, verify capabilities are enabled

### Twilio Not Working
- Check credentials are correct
- Verify phone number has capabilities enabled
- For phone calls, check Twilio logs in Console

### OpenAI Errors
- Verify API key is valid
- Check you have credits available
- Ensure model name is correct

### Notifications Not Showing
- Check app has notification permissions
- Verify reminderTime is in the future
- Check device Do Not Disturb settings

---

## Support

For issues:
1. Check Xcode console for error messages
2. Review Firebase/Twilio/OpenAI dashboards for logs
3. Enable debug logging in services

---

## Next Steps

After setup:
1. Test all features thoroughly
2. Customize UI/UX as needed
3. Add more AI prompts in `OpenAIService.swift`
4. Implement backend scheduler for production
5. Submit to App Store

**Good luck! 🚀**
