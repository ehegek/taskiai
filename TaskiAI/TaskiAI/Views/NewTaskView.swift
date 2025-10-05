import SwiftUI
import SwiftData

struct NewTaskView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var context
    @EnvironmentObject var appState: AppState
    @State private var title = ""
    @State private var date = Date()
    @State private var category: Category?
    @State private var repeatOn = false
    @State private var reminderOn = false
    @State private var repeatFreq: RepeatFrequency = .none
    @State private var repeatInterval: Int = 1
    @State private var repeatEnd: Date? = nil
    @State private var channels: Set<ReminderChannel> = []
    @State private var reminderTime: Date = Date()
    @State private var notes = ""
    let defaultDate: Date

    var body: some View {
        ZStack {
            Color.black.opacity(0.02).ignoresSafeArea(.all)
            Form {
                Section { TextField("Enter task name", text: $title) }
                DatePicker("Date", selection: $date, displayedComponents: [.date, .hourAndMinute])
                Section("Category") { CategoryPickerView(selection: $category) }
            Toggle("Repeat", isOn: $repeatOn)
            if repeatOn {
                Picker("Frequency", selection: $repeatFreq) { ForEach(RepeatFrequency.allCases) { Text($0.rawValue.capitalized).tag($0) } }
                Stepper(value: $repeatInterval, in: 1...30) { Text("Repeat Every \(repeatInterval)") }
                DatePicker(
                    "Repeat Ends",
                    selection: Binding(
                        get: { repeatEnd ?? date },
                        set: { repeatEnd = $0 }
                    ),
                    displayedComponents: .date
                )
            }
            Toggle("Reminder", isOn: $reminderOn)
            if reminderOn {
                HStack(spacing: 16) {
                    iconToggle(.appPush, "bell.fill")
                    iconToggle(.phoneCall, "phone.fill")
                    iconToggle(.sms, "message.fill")
                    iconToggle(.email, "envelope.fill")
                    iconToggle(.chat, "bubble.left.and.bubble.right.fill")
                }
                DatePicker("Time", selection: $reminderTime, displayedComponents: .hourAndMinute)
            }
                Section("Details (optional)") { TextField("Notes", text: $notes, axis: .vertical) }
            }
            .navigationTitle("New Task")
            .toolbar {
                ToolbarItem(placement: .topBarLeading) { Button { dismiss() } label: { Image(systemName: "xmark") } }
                ToolbarItem(placement: .topBarTrailing) { Button { create() } label: { Image(systemName: "checkmark.circle") } }
            }
            .onAppear { date = defaultDate }
        }
    }

    private func create() {
        guard !title.isEmpty else { return }
        let rule = RepeatRule(frequency: repeatOn ? repeatFreq : .none, interval: repeatInterval, endDate: repeatEnd)
        let task = Task(title: title, notes: notes, date: date, isCompleted: false, category: category, reminderEnabled: reminderOn, reminderChannels: Array(channels), reminderTime: reminderOn ? reminderTime : nil, repeatRule: rule)
        context.insert(task)
        try? context.save()
        appState.recordTaskAdded(on: Date())
        dismiss()
    }

    private func iconToggle(_ ch: ReminderChannel, _ sf: String) -> some View {
        Button(action: { toggle(ch) }) {
            Image(systemName: sf)
                .foregroundStyle(channels.contains(ch) ? .green : .secondary)
        }
    }
    private func toggle(_ ch: ReminderChannel) { if channels.contains(ch) { channels.remove(ch) } else { channels.insert(ch) } }
}
