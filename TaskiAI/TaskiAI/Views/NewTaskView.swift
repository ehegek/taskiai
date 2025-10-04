import SwiftUI
import SwiftData

struct NewTaskView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var context
    @State private var title = ""
    @State private var date = Date()
    @State private var category: Category?
    @State private var repeatOn = false
    @State private var reminderOn = false
    @State private var notes = ""
    let defaultDate: Date

    var body: some View {
        Form {
            Section { TextField("Enter task name", text: $title) }
            DatePicker("Date", selection: $date, displayedComponents: [.date, .hourAndMinute])
            Toggle("Repeat", isOn: $repeatOn)
            Toggle("Reminder", isOn: $reminderOn)
            Section("Details (optional)") { TextField("Notes", text: $notes, axis: .vertical) }
        }
        .navigationTitle("New Task")
        .toolbar {
            ToolbarItem(placement: .topBarLeading) { Button { dismiss() } label: { Image(systemName: "xmark") } }
            ToolbarItem(placement: .topBarTrailing) { Button { create() } label: { Image(systemName: "checkmark.circle") } }
        }
        .onAppear { date = defaultDate }
    }

    private func create() {
        guard !title.isEmpty else { return }
        let task = Task(title: title, notes: notes, date: date, category: category, reminderEnabled: reminderOn)
        context.insert(task)
        try? context.save()
        dismiss()
    }
}
