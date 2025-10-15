import Foundation
import UserNotifications

final class NotificationService: ObservableObject {
    static let shared = NotificationService()

    func requestAuthorization() async -> Bool {
        do {
            let granted = try await UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge])
            return granted
        } catch {
            return false
        }
    }

    /// Schedule both 10-minute warning and exact time notifications
    func scheduleReminder(for task: Task, channels: [ReminderChannel], userPhone: String?, userEmail: String?) async throws {
        guard let reminderTime = task.reminderTime else { return }
        
        // Cancel any existing notifications for this task
        cancelReminder(for: task.id)
        
        // Schedule app push notifications if selected
        if channels.contains(.appPush) {
            // 10 minutes before notification
            if let tenMinsBefore = Calendar.current.date(byAdding: .minute, value: -10, to: reminderTime),
               tenMinsBefore > Date() {
                try await scheduleAppNotification(
                    identifier: "\(task.id.uuidString)-10min",
                    title: "Upcoming Task",
                    body: "\(task.title) is due in 10 minutes",
                    date: tenMinsBefore
                )
            }
            
            // Exact time notification
            if reminderTime > Date() {
                try await scheduleAppNotification(
                    identifier: task.id.uuidString,
                    title: task.title,
                    body: "Task is due now!",
                    date: reminderTime
                )
            }
        }
        
        // Schedule Twilio-based reminders
        Task.detached {
            try? await self.scheduleTwilioReminders(
                for: task,
                channels: channels,
                userPhone: userPhone,
                userEmail: userEmail
            )
        }
    }
    
    private func scheduleAppNotification(identifier: String, title: String, body: String, date: Date) async throws {
        let content = UNMutableNotificationContent()
        content.title = title
        content.body = body
        content.sound = .default
        content.badge = 1
        
        let comps = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute], from: date)
        let trigger = UNCalendarNotificationTrigger(dateMatching: comps, repeats: false)
        let request = UNNotificationRequest(identifier: identifier, content: content, trigger: trigger)
        try await UNUserNotificationCenter.current().add(request)
    }
    
    private func scheduleTwilioReminders(for task: Task, channels: [ReminderChannel], userPhone: String?, userEmail: String?) async throws {
        guard let reminderTime = task.reminderTime else { return }
        
        // For demo purposes, we'll trigger immediately if time is past
        // In production, you'd use a backend scheduler (like Cloud Functions, AWS Lambda, etc.)
        let shouldTriggerNow = reminderTime <= Date()
        
        if channels.contains(.sms), let phone = userPhone, !phone.isEmpty {
            if shouldTriggerNow {
                try? await TwilioService.shared.sendSMSReminder(to: phone, taskTitle: task.title, taskTime: reminderTime)
            }
            // TODO: Schedule via backend for future times
        }
        
        if channels.contains(.email), let email = userEmail, !email.isEmpty {
            if shouldTriggerNow {
                try? await TwilioService.shared.sendEmailReminder(to: email, taskTitle: task.title, taskTime: reminderTime)
            }
            // TODO: Schedule via backend for future times
        }
        
        if channels.contains(.phoneCall), let phone = userPhone, !phone.isEmpty {
            if shouldTriggerNow {
                try? await TwilioService.shared.schedulePhoneCallReminder(to: phone, taskTitle: task.title, taskTime: reminderTime)
            }
            // TODO: Schedule via backend for future times
        }
    }

    func cancelReminder(for taskID: UUID) {
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [
            taskID.uuidString,
            "\(taskID.uuidString)-10min"
        ])
    }
}
