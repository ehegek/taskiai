import SwiftUI
import SwiftData

struct TaskDetailView: View, Identifiable {
    var id: UUID { task.id }
    @Environment(\.modelContext) private var context
    @Bindable var task: Task

    @State private var repeatOn: Bool = false
    @State private var reminderOn: Bool = false

    init(task: Task) { self.task = task; _repeatOn = State(initialValue: task.repeatRule.frequency != .none); _reminderOn = State(initialValue: task.reminderEnabled) }

    var body: some View {
        GeometryReader { geo in
            Form {
                Section { TextField("Title", text: $task.title) }
                DatePicker("Date", selection: $task.date, displayedComponents: [.date, .hourAndMinute])
                Toggle("Repeat", isOn: Binding(get: { repeatOn }, set: { repeatOn = $0; task.repeatRule.frequency = $0 ? .daily : .none }))
                Toggle("Reminder", isOn: Binding(get: { reminderOn }, set: { reminderOn = $0; task.reminderEnabled = $0 }))
                if reminderOn {
                    Picker("Channels", selection: Binding(get: { task.reminderChannels.first ?? .appPush }, set: { task.reminderChannels = [$0]; try? context.save() })) {
                        ForEach(ReminderChannel.allCases) { ch in Text(String(describing: ch.rawValue)).tag(ch) }
                    }
                }
                Section("Details (optional)") {
                    TextField("Notes", text: Binding(get: { task.notes ?? "" }, set: { task.notes = $0 }), axis: .vertical)
                }
            }
            .navigationTitle("Details")
            .onDisappear { try? context.save() }
        }
    }
}
