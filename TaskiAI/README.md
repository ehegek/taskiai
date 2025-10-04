# Taski AI (SwiftUI)

This is a SwiftUI iOS app scaffold implementing the flows from your mockups: Tasks, Action Reminders, Calendar, AI Chat, Settings, and a Home dashboard. It's designed to compile on Xcode 15+ (iOS 17) using SwiftData.

Important: You need a Mac with Xcode to build and run. This repo provides all Swift sources so you can open a new Xcode project and drop in the `TaskiAI` folder or use XcodeGen.

## Features in this scaffold
- Task model with categories, repeat rules, and reminder channels
- Task list with inline quick add, complete checkbox, open-task confirmation, detail and edit views
- Action Reminder list (only tasks with reminders)
- Calendar screens with month view and Day sections (To Do, Completed)
- AI Chat screen with text input, voice-to-text stub, and hooks to create tasks from intents
- Settings and Search screens
- Local notifications scheduler service (request/ schedule/ cancel)
- Speech recognition wrapper (permission + start/stop with transcribed text)

## Build/Run
1. On macOS, open Xcode 15+.
2. Create a new iOS App project named `TaskiAI` (SwiftUI, Swift, iOS 17). Close it.
3. Replace the generated project `TaskiAI` group's contents with this folder's `TaskiAI` sources, or simply add these files into the Xcode project.
4. Ensure the app target Info has these keys:
   - NSSpeechRecognitionUsageDescription
   - NSMicrophoneUsageDescription
   - NSUserNotificationUsageDescription (or equivalent)
5. Capabilities: Push Notifications (optional), Background Modes: Remote notifications (optional), and enable Notifications.
6. Run on a simulator or device.

## Next steps
- Hook an LLM for Taski Bot and intent parsing
- Polish the calendar UI per design
- Add persistence for images (Photos picker) and file attachments
- Implement referral, paywall flows as separate modules
