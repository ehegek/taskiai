import SwiftUI
import SwiftData

struct SearchView: View {
    @State private var query = ""
    @Query private var tasks: [Task]
    @State private var showCreate = false

    init() {
        _tasks = Query(sort: \Task.date)
    }

    var results: [Task] {
        if query.isEmpty { return [Task]() }
        return tasks.filter { $0.title.localizedCaseInsensitiveContains(query) || ($0.notes ?? "").localizedCaseInsensitiveContains(query) }
    }

    var body: some View {
        ZStack(alignment: .bottomTrailing) {
            VStack {
                TextField("Search for Task", text: $query)
                    .textFieldStyle(.roundedBorder)
                List(results) { TaskRow(task: $0) }
                Spacer()
            }
            Button { showCreate = true } label: {
                Image(systemName: "plus.circle.fill").font(.system(size: 56))
            }
            .padding(24)
        }
        .padding()
        .navigationTitle("Search")
        .navigationDestination(isPresented: $showCreate) { NewTaskView(defaultDate: .now) }
    }
}
