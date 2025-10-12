import SwiftUI
import SwiftData

struct ActionReminderView: View {
    @Environment(\.modelContext) private var context
    @Query(filter: #Predicate<Task> { $0.reminderEnabled == true }, sort: \.date) private var reminderTasks: [Task]
    var selectedDate: Date
    @Environment(\.dismiss) private var dismiss
    @State private var newTitle: String = ""
    @State private var reminderDate: Date = Date()
    @State private var selectedChannel: ReminderChannel = .appPush

    var body: some View {
        ZStack {
            Rectangle()
                .fill(Color(.systemBackground))
                .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
                .edgesIgnoringSafeArea(.all)
            
            GeometryReader { geo in
                VStack(spacing: 0) {
                    Spacer()
                        .frame(height: max(geo.safeAreaInsets.top + 10, 50))
                    HStack(spacing: 8) {
                        Button { dismiss() } label: {
                            Image(systemName: "chevron.left")
                                .font(.system(size: 18, weight: .semibold))
                                .foregroundStyle(.primary)
                        }
                        Spacer()
                    }
                    .padding(.horizontal, 20)

                    HStack {
                        Text("Action Reminder")
                            .font(.system(size: 28, weight: .bold))
                        Spacer()
                    }
                    .padding(.horizontal, 20)
                    .padding(.bottom, 12)

                    // Composer
                    VStack(alignment: .leading, spacing: 12) {
                        TextField("Reminder title...", text: $newTitle)
                            .textInputAutocapitalization(.sentences)
                            .padding(.vertical, 12)
                            .padding(.horizontal, 14)
                            .background(RoundedRectangle(cornerRadius: 14).fill(Color(.systemGray6)))

                        HStack(spacing: 12) {
                            DatePicker("When", selection: $reminderDate, displayedComponents: [.date, .hourAndMinute])
                                .labelsHidden()
                            Picker("Channel", selection: $selectedChannel) {
                                ForEach(ReminderChannel.allCases) { ch in
                                    Text(ch.displayName).tag(ch)
                                }
                            }
                            .pickerStyle(.menu)
                        }

                        Button {
                            guard !newTitle.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else { return }
                            let task = Task(title: newTitle.trimmingCharacters(in: .whitespacesAndNewlines),
                                            date: reminderDate,
                                            reminderEnabled: true,
                                            reminderChannels: [selectedChannel],
                                            reminderTime: reminderDate)
                            context.insert(task)
                            try? context.save()
                            newTitle = ""
                            reminderDate = selectedDate
                            selectedChannel = .appPush
                        } label: {
                            Text("Add Reminder")
                                .font(.system(size: 16, weight: .semibold))
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 12)
                                .background(RoundedRectangle(cornerRadius: 14).fill(Color.black))
                                .foregroundStyle(.white)
                        }
                    }
                    .padding(.horizontal, 20)
                    .padding(.bottom, 12)

                    ScrollView {
                        LazyVStack(alignment: .leading, spacing: 12) {
                            ForEach(reminderTasks) { task in
                                TaskBubbleRow(task: task)
                            }
                        }
                        .padding(.horizontal, 20)
                        .padding(.bottom, 20)
                    }
                    Spacer()
                        .frame(height: max(geo.safeAreaInsets.bottom + 10, 20))
                }
            }
        }
        .navigationTitle("Action Reminder")
        .navigationBarHidden(true)
        .ignoresSafeArea(.keyboard, edges: .bottom)
        .onAppear {
            if newTitle.isEmpty { reminderDate = selectedDate }
        }
    }
}

