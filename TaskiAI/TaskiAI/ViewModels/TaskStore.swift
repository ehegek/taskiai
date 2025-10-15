import Foundation
import SwiftData

@MainActor
final class TaskStore: ObservableObject {
    @Published var filterCategory: Category?
    var appState: AppState?

    func toggleComplete(_ task: Task, context: ModelContext) {
        task.isCompleted.toggle()
        try? context.save()
    }

    func addQuickTask(title: String, date: Date, context: ModelContext) async {
        let t = Task(title: title, date: date)
        context.insert(t)
        try? context.save()
        
        // Update streak
        await appState?.recordTaskAdded(on: date)
        
        // Sync to Firestore if authenticated
        #if canImport(FirebaseFirestore)
        if let userId = appState?.currentUserId {
            let taskData = TaskData(
                id: t.id.uuidString,
                userId: userId,
                title: t.title,
                notes: t.notes,
                date: t.date,
                isCompleted: t.isCompleted,
                categoryName: t.category?.name,
                reminderEnabled: t.reminderEnabled,
                reminderChannels: t.reminderChannels.map { $0.rawValue },
                reminderTime: t.reminderTime,
                createdAt: Date(),
                updatedAt: Date()
            )
            try? await FirestoreService.shared.syncTask(userId: userId, task: taskData)
        }
        #endif
    }
    
    func scheduleReminders(for task: Task) async {
        guard task.reminderEnabled else { return }
        
        do {
            try await NotificationService.shared.scheduleReminder(
                for: task,
                channels: task.reminderChannels,
                userPhone: appState?.userPhone,
                userEmail: appState?.currentUserEmail
            )
        } catch {
            print("Failed to schedule reminders: \(error)")
        }
    }
}
