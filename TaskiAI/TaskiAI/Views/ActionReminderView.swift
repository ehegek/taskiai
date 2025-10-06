import SwiftUI
import SwiftData

struct ActionReminderView: View {
    @Environment(\.modelContext) private var context
    @Query(filter: #Predicate<Task> { $0.reminderEnabled == true }, sort: \Task.date) private var reminderTasks: [Task]
    var selectedDate: Date

    var body: some View {
        ZStack {
            Color(.systemBackground).ignoresSafeArea(.all)
            ScrollView {
                LazyVStack(alignment: .leading, spacing: 12) {
                    ForEach(reminderTasks) { task in
                        TaskBubbleRow(task: task)
                    }
                }
                .padding(.horizontal)
                .padding(.top, 12)
            }
        }
        .navigationTitle("Action Reminder")
        .toolbar(.hidden, for: .navigationBar)
    }
}
