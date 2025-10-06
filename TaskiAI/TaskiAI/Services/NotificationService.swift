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

    func scheduleReminder(for taskID: UUID, title: String, date: Date) async throws {
        let content = UNMutableNotificationContent()
        content.title = title
        content.body = "Reminder for your task"
        content.sound = .default
        let comps = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute], from: date)
        let trigger = UNCalendarNotificationTrigger(dateMatching: comps, repeats: false)
        let request = UNNotificationRequest(identifier: taskID.uuidString, content: content, trigger: trigger)
        try await UNUserNotificationCenter.current().add(request)
    }

    func cancelReminder(for taskID: UUID) {
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [taskID.uuidString])
    }
}
