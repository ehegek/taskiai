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
            Color(.systemBackground).ignoresSafeArea(.all)
            Form {
                Section { TextField("Enter task name", text: $title) }
                DatePicker("Date", selection: $date, displayedComponents: [.date, .hourAndMinute])
                Section("Category") { CategoryPickerView(selection: $category) }
            Toggle("Repeat", isOn: $repeatOn)
            if repeatOn {
                // Segmented control for frequency
                Picker("Frequency", selection: $repeatFreq) {
                    ForEach(RepeatFrequency.allCases) { Text($0.rawValue.capitalized).tag($0) }
                }
                .pickerStyle(.segmented)

                // "Repeat Every" pill row
                VStack(alignment: .leading, spacing: 6) {
                    Text("Repeat Every").font(.caption)
                    HStack {
                        Button(action: { repeatInterval = max(1, repeatInterval-1) }) { Image(systemName: "minus") }
                        Text("\(repeatInterval) \(repeatFreq == .weekly ? "wk" : repeatFreq == .monthly ? "mo" : repeatFreq == .yearly ? "yr" : "day")")
                            .fontWeight(.semibold)
                        Button(action: { repeatInterval = min(30, repeatInterval+1) }) { Image(systemName: "plus") }
                        Spacer()
                        Text("Day ◔").font(.caption).opacity(0.6) // visual tag placeholder
                    }
                    .padding(.horizontal, 12)
                    .padding(.vertical, 10)
                    .background(RoundedRectangle(cornerRadius: 10).fill(Color.black.opacity(0.9)))
                    .foregroundStyle(.white)
                }

                // "Repeat Ends" pill row
                VStack(alignment: .leading, spacing: 6) {
                    Text("Repeat Ends").font(.caption)
                    HStack {
                        DatePicker("", selection: Binding(get: { repeatEnd ?? date }, set: { repeatEnd = $0 }), displayedComponents: .date)
                            .labelsHidden()
                        Spacer()
                        Text(repeatEnd == nil ? "Never ◔" : "On")
                            .font(.caption)
                            .opacity(0.6)
                    }
                    .padding(.horizontal, 12)
                    .padding(.vertical, 10)
                    .background(RoundedRectangle(cornerRadius: 10).fill(Color.black.opacity(0.9)))
                    .foregroundStyle(.white)
                }
            }
            Toggle("Reminder", isOn: $reminderOn)
            if reminderOn {
                HStack(spacing: 16) {
                    iconToggle(.appPush, "arrow.triangle.2.circlepath")
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
            .scrollContentBackground(.hidden)
        }
        // Persistent bottom CTA matching the mock
        .safeAreaInset(edge: .bottom) {
            Button(action: create) {
                Text("Create Task").bold().frame(maxWidth: .infinity)
                    .padding(.vertical, 16)
                    .background(RoundedRectangle(cornerRadius: 18).fill(Color.black))
                    .foregroundStyle(.white)
            }
            .padding(.horizontal)
            .padding(.bottom, 8)
            .disabled(title.isEmpty)
            .opacity(title.isEmpty ? 0.5 : 1)
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
                .font(.system(size: 18, weight: .bold))
                .frame(width: 34, height: 34)
                .background(
                    Circle().fill(channels.contains(ch) ? Color.green.opacity(0.2) : Color.clear)
                )
                .foregroundStyle(channels.contains(ch) ? .green : .secondary)
        }
    }
    private func toggle(_ ch: ReminderChannel) { if channels.contains(ch) { channels.remove(ch) } else { channels.insert(ch) } }
}
