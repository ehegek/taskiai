import SwiftUI
import SwiftData

struct SearchView: View {
    @State private var query = ""
    @Query private var tasks: [Task]

    init() {
        _tasks = Query(sort: \Task.date)
    }

    var results: [Task] { if query.isEmpty { return [] } ; return tasks.filter { $0.title.localizedCaseInsensitiveContains(query) || ($0.notes ?? "").localizedCaseInsensitiveContains(query) } }

    var body: some View {
        VStack {
            TextField("Search For Task", text: $query)
                .textFieldStyle(.roundedBorder)
            List(results) { TaskRow(task: $0) }
            Spacer()
        }
        .padding()
        .navigationTitle("Search")
    }
}
