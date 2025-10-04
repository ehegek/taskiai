import SwiftUI
import SwiftData

struct ActionReminderView: View {
    @Environment(\.modelContext) private var context
    @Query(filter: #Predicate<Task> { $0.reminderEnabled == true }, sort: \Task.date) private var reminderTasks: [Task]
    var selectedDate: Date

    var body: some View {
        List {
            ForEach(reminderTasks) { task in
                TaskRow(task: task)
            }
        }
        .navigationTitle("Action Reminder")
    }
}
