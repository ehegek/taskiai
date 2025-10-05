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
                ForEach(ReminderChannel.allCases) { ch in
                    let on = task.reminderChannels.contains(ch)
                    Image(systemName: icon(for: ch))
                        .font(.system(size: 12, weight: .bold))
                        .foregroundStyle(on ? .primary : .secondary)
                        .padding(6)
                        .background(
                            Circle().fill(Color(.systemGray6).opacity(on ? 1 : 0.6))
                        )
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
    private func icon(for ch: ReminderChannel) -> String {
        switch ch { case .appPush: return "arrow.triangle.2.circlepath"; case .phoneCall: return "phone.fill"; case .sms: return "message.fill"; case .email: return "envelope.fill"; case .chat: return "bubble.left.and.bubble.right.fill" }
    }
    private func timeString(_ d: Date) -> String { d.formatted(.dateTime.hour(.twoDigits(amPM: .abbreviated)).minute()) }
}
