import SwiftUI
import SwiftData

struct ActionReminderView: View {
    @Environment(\.modelContext) private var context
    @Query(filter: #Predicate<Task> { $0.reminderEnabled == true }, sort: \Task.date) private var reminderTasks: [Task]
    var selectedDate: Date

    var body: some View {
        GeometryReader { geo in
            ZStack {
                Color(.systemBackground).ignoresSafeArea(.all, edges: .all)
                
                VStack(spacing: 0) {
                    Text("Action Reminder")
                        .font(.system(size: 28, weight: .bold))
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.horizontal, 20)
                        .padding(.top, geo.safeAreaInsets.top + 12)
                        .padding(.bottom, 16)
                    
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
