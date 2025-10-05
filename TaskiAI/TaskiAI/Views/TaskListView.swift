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
    @State private var pendingOpenTask: Task? = nil
    @State private var showOpenConfirm = false

    init(date: Date) {
        self.date = date
        let start = Calendar.current.startOfDay(for: date)
        let end = Calendar.current.date(byAdding: .day, value: 1, to: start)!
    _tasks = Query(filter: #Predicate<Task> { $0.date >= start && $0.date < end }, sort: \Task.date)
    }

    var body: some View {
        ZStack {
            Color(.systemBackground).ignoresSafeArea(.all)
            VStack(spacing: 0) {
                header
                addBar
                List {
                    ForEach(filteredTasks) { task in
                        TaskRow(task: task)
                            .swipeActions(edge: .trailing) {
                                Button(role: .destructive) { context.delete(task); try? context.save() } label: { Label("Delete", systemImage: "trash") }
                            }
                            .onTapGesture {
                                pendingOpenTask = task
                                showOpenConfirm = true
                            }
                    }
                }
                .listStyle(.plain)
                .scrollContentBackground(.hidden)
            }
        }
        .toolbar(.hidden, for: .navigationBar)
        .alert("Open task?", isPresented: $showOpenConfirm) {
            Button("No", role: .cancel) {}
            Button("Yes") { selectedTask = pendingOpenTask }
        }
        .navigationDestination(item: $selectedTask) { task in
            TaskDetailView(task: task)
        }
    }

    private var header: some View {
        VStack(spacing: 8) {
            HStack {
                Button { dismiss() } label: { Image(systemName: "chevron.left") }
                Spacer()
                HStack(spacing: 16) {
                    CategoryPickerView(selection: $store.filterCategory)
                    Button { /* edit mode */ } label: { Image(systemName: "pencil") }
                    NavigationLink { CalendarView() } label: { Image(systemName: "calendar") }
                }
            }
            .font(.body)
            Text("Task").font(.title).bold()
            Text(date.formatted(date: .complete, time: .omitted))
                .font(.footnote).foregroundStyle(.secondary)
        }
        .padding(.horizontal)
        .padding(.top, 8)
    }

    private var addBar: some View {
        HStack(spacing: 8) {
            TextField("Add a new task...", text: $newTaskTitle)
                .padding(.vertical, 10)
                .padding(.horizontal, 12)
                .background(RoundedRectangle(cornerRadius: 12).fill(Color(.systemFill)))
            Button(action: addQuick) {
                Text("Add").bold()
                    .padding(.vertical, 10)
                    .padding(.horizontal, 16)
                    .background(RoundedRectangle(cornerRadius: 12).fill(Color.black))
                    .foregroundStyle(.white)
            }
            .disabled(newTaskTitle.isEmpty)
            .opacity(newTaskTitle.isEmpty ? 0.5 : 1)
        }
        .padding(.horizontal)
        .padding(.vertical, 12)
        .background(RoundedRectangle(cornerRadius: 16).fill(.ultraThinMaterial))
        .padding(.horizontal)
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
}
