import SwiftUI
import SwiftData

struct TaskRow: View {
    @Environment(\.modelContext) private var context
    var task: Task

    var body: some View {
        HStack(alignment: .center, spacing: 12) {
            Button { task.isCompleted.toggle(); try? context.save() } label: { CheckCircle(checked: task.isCompleted) }
                .buttonStyle(.plain)
            VStack(alignment: .leading, spacing: 4) {
                Text(task.title)
                    .strikethrough(task.isCompleted)
                    .font(.system(size: 16, weight: .medium))
                HStack(spacing: 8) {
                    if let category = task.category {
                        Label(category.name, systemImage: category.icon ?? "folder.fill")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    }
                    Text(task.date, style: .time)
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
            }
            Spacer()
        }
    }
}
