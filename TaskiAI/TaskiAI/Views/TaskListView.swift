import SwiftUI
import SwiftData

struct TaskListView: View {
    @Environment(\.modelContext) private var context
    @Environment(\.dismiss) private var dismiss
    @StateObject private var store = TaskStore()
    @State private var newTaskTitle = ""
    var date: Date

    @Query private var tasks: [Task]
    @State private var selectedTask: Task? = nil

    init(date: Date) {
        self.date = date
        let start = Calendar.current.startOfDay(for: date)
        let end = Calendar.current.date(byAdding: .day, value: 1, to: start)!
    _tasks = Query(filter: #Predicate<Task> { $0.date >= start && $0.date < end }, sort: \.date)
    }

    var body: some View {
        VStack(spacing: 0) {
            ScrollView {
                        LazyVStack(alignment: .leading, spacing: 12) {
                            ForEach(filteredTasks) { task in
                                TaskBubbleRow(task: task)
                                    .onTapGesture { selectedTask = task }
                            }
                        }
                        .padding(.horizontal, 20)
                        .padding(.top, 12)
                        .padding(.bottom, 80)
            }
            addBar
        }
        .safeAreaInset(edge: .top) {
            header
                .background(Color(.systemBackground))
        }
        .navigationBarHidden(true)
        .navigationDestination(item: $selectedTask) { task in
            TaskDetailView(task: task)
        }
        .onTapGesture {
            UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
        }
    }

    private var header: some View {
        VStack(spacing: 12) {
            HStack {
                Button { dismiss() } label: {
                    Image(systemName: "chevron.left")
                        .font(.system(size: 18, weight: .semibold))
                        .foregroundStyle(.primary)
                }
                Spacer()
                HStack(spacing: 16) {
                    CategoryPickerView(selection: $store.filterCategory)
                    Button { /* edit mode */ } label: {
                        Image(systemName: "pencil")
                            .font(.system(size: 16, weight: .medium))
                    }
                    NavigationLink { CalendarView() } label: {
                        Image(systemName: "calendar")
                            .font(.system(size: 16, weight: .medium))
                    }
                }
            }
            
            VStack(spacing: 4) {
                Text("Task")
                    .font(.system(size: 28, weight: .bold))
                Text(date.formatted(date: .abbreviated, time: .omitted))
                    .font(.system(size: 14))
                    .foregroundStyle(.secondary)
            }
        }
        .padding(.horizontal, 20)
        .padding(.top, 12)
        .padding(.bottom, 8)
    }

    private var addBar: some View {
        VStack(spacing: 10) {
            HStack(spacing: 10) {
                TextField("Add a new task...", text: $newTaskTitle)
                    .font(.system(size: 16))
                    .padding(.vertical, 12)
                    .padding(.horizontal, 16)
                    .background(
                        RoundedRectangle(cornerRadius: 14)
                            .fill(Color(.systemGray6))
                    )
                
                Button(action: addQuick) {
                    Text("Add")
                        .font(.system(size: 16, weight: .semibold))
                        .padding(.vertical, 12)
                        .padding(.horizontal, 20)
                        .background(
                            RoundedRectangle(cornerRadius: 14)
                                .fill(Color.black)
                        )
                        .foregroundStyle(.white)
                }
                .disabled(newTaskTitle.isEmpty)
                .opacity(newTaskTitle.isEmpty ? 0.5 : 1)
            }
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 14)
        .background(
            Rectangle()
                .fill(.ultraThinMaterial)
                .shadow(color: .black.opacity(0.05), radius: 8, y: -2)
        )
    }

    private func addQuick() {
        guard !newTaskTitle.isEmpty else { return }
        store.addQuickTask(title: newTaskTitle, date: date, context: context)
        newTaskTitle = ""
    }

    private var topActions: some ToolbarContent {
        ToolbarItemGroup(placement: .topBarLeading) {
            Button { } label: { Image(systemName: "chevron.left") }
        }
    }

    private var filteredTasks: [Task] {
        if let cat = store.filterCategory { return tasks.filter { $0.category?.id == cat.id } }
        return tasks
    }

    private func quickIcon(_ name: String) -> some View {
        Image(systemName: name)
            .font(.system(size: 16, weight: .bold))
            .frame(width: 34, height: 34)
            .background(Circle().fill(Color(.systemGray6)))
    }
}

