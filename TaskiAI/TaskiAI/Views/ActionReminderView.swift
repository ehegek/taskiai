import SwiftUI
import SwiftData

struct ActionReminderView: View {
    @Environment(\.modelContext) private var context
    @Query(filter: #Predicate<Task> { $0.reminderEnabled == true }, sort: \.date) private var reminderTasks: [Task]
    var selectedDate: Date
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        GeometryReader { geo in
            ZStack {
                Color(.systemBackground).ignoresSafeArea(.all, edges: .all)
                
                VStack(spacing: 0) {
                    HStack(spacing: 8) {
                        Button { dismiss() } label: {
                            Image(systemName: "chevron.left")
                                .font(.system(size: 18, weight: .semibold))
                                .foregroundStyle(.primary)
                        }
                        Spacer()
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, geo.safeAreaInsets.top + 8)

                    HStack {
                        Text("Action Reminder")
                            .font(.system(size: 28, weight: .bold))
                        Spacer()
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
                        .padding(.bottom, geo.safeAreaInsets.bottom + 20)
                    }
                }
            }
            .navigationTitle("Action Reminder")
            .toolbar(.hidden, for: .navigationBar)
        }
    }
}

