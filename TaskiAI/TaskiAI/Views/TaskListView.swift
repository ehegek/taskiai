import SwiftUI
import SwiftData

struct TaskListView: View {
    @Environment(\.modelContext) private var context
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
        }
        .navigationTitle("Task")
        .toolbar { topActions }
        .alert("Open task?", isPresented: $showOpenConfirm) {
            Button("No", role: .cancel) {}
            Button("Yes") { selectedTask = pendingOpenTask }
        }
        .navigationDestination(item: $selectedTask) { task in
            TaskDetailView(task: task)
        }
    }

    private var header: some View {
        HStack {
            Image(systemName: "chevron.left")
            Spacer()
            Text(date.formatted(date: .complete, time: .omitted)).font(.subheadline)
            Spacer()
            HStack(spacing: 16) {
                CategoryPickerView(selection: $store.filterCategory)
                Image(systemName: "pencil")
                NavigationLink { CalendarView() } label: { Image(systemName: "calendar") }
            }
        }
        .padding(.horizontal)
    }

    private var addBar: some View {
        HStack {
            TextField("Add a new task...", text: $newTaskTitle)
                .textFieldStyle(.roundedBorder)
            Button("Add") {
                if !newTaskTitle.isEmpty {
                    store.addQuickTask(title: newTaskTitle, date: date, context: context)
                    newTaskTitle = ""
                }
            }
            .buttonStyle(.borderedProminent)
        }
        .padding()
        .background(
            Color.clear
                .background(.thinMaterial)
                .clipShape(RoundedRectangle(cornerRadius: 12))
        )
        .padding(.horizontal)
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
