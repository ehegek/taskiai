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
    @State private var reminderTime: Date = Date()
    @State private var notes = ""
    let defaultDate: Date

    var body: some View {
        GeometryReader { geo in
            ZStack {
                Color(.systemBackground).ignoresSafeArea(.all, edges: .all)
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
                DatePicker("Time", selection: $reminderTime, displayedComponents: .hourAndMinute)
                Text("Tap the pencil icon after creation to choose reminder channels")
                    .font(.caption)
                    .foregroundStyle(.secondary)
                    .padding(.horizontal, 12)
            }
                Section("Details (optional)") { TextField("Notes", text: $notes, axis: .vertical) }
                }
                .navigationTitle("New Task")
                .toolbar {
                    ToolbarItemGroup(placement: .topBarLeading) {
                        Button { dismiss() } label: {
                            Image(systemName: "xmark")
                                .font(.system(size: 16, weight: .semibold))
                        }
                    }
                    ToolbarItemGroup(placement: .topBarTrailing) {
                        Button { _Concurrency.Task { await create() } } label: {
                            Image(systemName: "checkmark.circle.fill")
                                .font(.system(size: 20, weight: .semibold))
                        }
                    }
                }
                .onAppear { date = defaultDate }
                .scrollContentBackground(.hidden)
                .scrollDismissesKeyboard(.interactively)
            }
            // Persistent bottom CTA
            .safeAreaInset(edge: .bottom) {
                Button { _Concurrency.Task { await create() } } label: {
                    Text("Create Task")
                        .font(.system(size: 17, weight: .semibold))
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 16)
                        .background(
                            RoundedRectangle(cornerRadius: 14)
                                .fill(Color.black)
                        )
                        .foregroundStyle(.white)
                }
                .padding(.horizontal, 20)
                .padding(.bottom, geo.safeAreaInsets.bottom + 8)
                .disabled(title.isEmpty)
                .opacity(title.isEmpty ? 0.5 : 1)
            }
        }
    }

    private func create() async {
        guard !title.isEmpty else { return }
        let rule = RepeatRule(frequency: repeatOn ? repeatFreq : .none, interval: repeatInterval, endDate: repeatEnd)
        // Default to appPush if reminder is enabled
        let defaultChannels = reminderOn ? [ReminderChannel.appPush] : []
        let task = Task(title: title, notes: notes, date: date, isCompleted: false, category: category, reminderEnabled: reminderOn, reminderChannels: defaultChannels, reminderTime: reminderOn ? reminderTime : nil, repeatRule: rule)
        context.insert(task)
        try? context.save()
        await appState.recordTaskAdded(on: Date())
        dismiss()
    }
}
