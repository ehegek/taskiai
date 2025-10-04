import Foundation
import SwiftData

@MainActor
final class TaskStore: ObservableObject {
    @Published var filterCategory: Category?

    func toggleComplete(_ task: Task, context: ModelContext) {
        task.isCompleted.toggle()
        try? context.save()
    }

    func addQuickTask(title: String, date: Date, context: ModelContext) {
        let t = Task(title: title, date: date)
        context.insert(t)
        try? context.save()
    }
}
