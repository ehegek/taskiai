import SwiftUI
import SwiftData

struct RemindersView: View {
    @Environment(\.modelContext) private var context
    @Environment(\.dismiss) private var dismiss
    @Query(filter: #Predicate<Task> { $0.reminderEnabled == true }, sort: \Task.reminderTime)
    private var tasksWithReminders: [Task]
    
    @State private var selectedTask: Task?
    
    var body: some View {
        GeometryReader { geo in
            ZStack {
                Color(.systemBackground).ignoresSafeArea()
                
                VStack(spacing: 0) {
                    // Header with proper spacing
                    HStack {
                            Button { dismiss() } label: {
                                Image(systemName: "chevron.left")
                                    .font(.system(size: 20, weight: .semibold))
                                    .foregroundStyle(.primary)
                            }
                            Spacer()
                            Text("Reminders")
                                .font(.system(size: 20, weight: .bold))
                            Spacer()
                            Color.clear.frame(width: 20)
                    }
                    .padding(.horizontal, 20)
                    .padding(.vertical, 12)
                    .padding(.top, geo.safeAreaInsets.top + 8)
                    .background(Color(.systemBackground))
                    
                    if tasksWithReminders.isEmpty {
                        // Empty state
                        VStack(spacing: 20) {
                            Spacer()
                            Image(systemName: "bell.slash")
                                .font(.system(size: 60))
                                .foregroundStyle(.secondary)
                            Text("No Reminders")
                                .font(.system(size: 24, weight: .bold))
                            Text("Add reminders to your tasks to see them here")
                                .font(.system(size: 16))
                                .foregroundStyle(.secondary)
                                .multilineTextAlignment(.center)
                                .padding(.horizontal, 40)
                            Spacer()
                        }
                    } else {
                        // List of tasks with reminders
                        ScrollView {
                            LazyVStack(spacing: 12) {
                                ForEach(tasksWithReminders) { task in
                                    reminderCard(task)
                                        .onTapGesture {
                                            selectedTask = task
                                        }
                                }
                            }
                            .padding(.horizontal, 20)
                            .padding(.vertical, 16)
                        }
                    }
                }
            }
        }
        .navigationBarHidden(true)
        .navigationDestination(item: $selectedTask) { task in
            TaskDetailView(task: task)
        }
    }
    
    private func reminderCard(_ task: Task) -> some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Image(systemName: "bell.fill")
                    .font(.system(size: 20))
                    .foregroundStyle(.orange)
                
                VStack(alignment: .leading, spacing: 4) {
                    Text(task.title)
                        .font(.system(size: 17, weight: .semibold))
                        .foregroundStyle(.primary)
                    
                    if let reminderTime = task.reminderTime {
                        Text(reminderTime.formatted(date: .abbreviated, time: .shortened))
                            .font(.system(size: 14))
                            .foregroundStyle(.secondary)
                    }
                }
                
                Spacer()
                
                if let channel = task.reminderChannels.first {
                    Text(channel.displayName)
                        .font(.caption)
                        .padding(.horizontal, 10)
                        .padding(.vertical, 6)
                        .background(
                            RoundedRectangle(cornerRadius: 8)
                                .fill(Color.blue.opacity(0.1))
                        )
                        .foregroundStyle(.blue)
                }
            }
            
            if let category = task.category {
                Label(category.name, systemImage: category.icon ?? "folder.fill")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
        }
        .padding(16)
        .background(
            RoundedRectangle(cornerRadius: 14)
                .fill(Color(.systemGray6))
        )
        .shadow(color: .black.opacity(0.05), radius: 4, y: 2)
    }
}
