import SwiftUI
import SwiftData

struct TaskRow: View {
    @Environment(\.modelContext) private var context
    var task: Task

    var body: some View {
        HStack(alignment: .center, spacing: 12) {
            Button { task.isCompleted.toggle(); try? context.save() } label: { CheckCircle(checked: task.isCompleted) }
                .buttonStyle(.plain)
            VStack(alignment: .leading) {
                Text(task.title).strikethrough(task.isCompleted)
                HStack(spacing: 8) {
                    if let category = task.category { Text(category.name).font(.caption).foregroundStyle(.secondary) }
                    Text(task.date, style: .time).font(.caption).foregroundStyle(.secondary)
                }
            }
            Spacer()
            if task.reminderEnabled { Image(systemName: "bell.fill").foregroundStyle(.orange) }
        }
    }
}
