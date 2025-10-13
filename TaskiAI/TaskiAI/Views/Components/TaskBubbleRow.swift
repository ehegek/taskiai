import SwiftUI
import SwiftData

struct TaskBubbleRow: View {
    @Environment(\.modelContext) private var context
    var task: Task

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack(alignment: .center, spacing: 12) {
                Button { toggleDone() } label: { CheckCircle(checked: task.isCompleted) }
                    .buttonStyle(.plain)
                Text(task.title)
                    .fontWeight(.semibold)
                    .foregroundStyle(.primary)
                    .strikethrough(task.isCompleted)
                Spacer()
            }

            HStack(spacing: 8) {
                if let category = task.category {
                    Label(category.name, systemImage: category.icon ?? "folder.fill")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
                let t = task.reminderTime ?? task.date
                Text(timeString(t))
                    .font(.caption)
                    .padding(.horizontal, 10)
                    .padding(.vertical, 4)
                    .background(RoundedRectangle(cornerRadius: 8).fill(Color.black))
                    .foregroundStyle(.white)
            }
        }
        .padding(14)
        .background(RoundedRectangle(cornerRadius: 18).fill(Color(.systemBackground)))
        .shadow(color: .black.opacity(0.06), radius: 10, y: 4)
    }

    private func toggleDone() { task.isCompleted.toggle(); try? context.save() }
    private func timeString(_ d: Date) -> String { d.formatted(.dateTime.hour(.twoDigits(amPM: .abbreviated)).minute()) }
}
