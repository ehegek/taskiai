import SwiftUI
import SwiftData

struct SearchView: View {
    @State private var query = ""
    @Query private var tasks: [Task]
    @State private var showCreate = false

    init() {
        _tasks = Query(sort: \.date)
    }

    var results: [Task] {
        if query.isEmpty { return [Task]() }
        return tasks.filter { $0.title.localizedCaseInsensitiveContains(query) || ($0.notes ?? "").localizedCaseInsensitiveContains(query) }
    }

    var body: some View {
        GeometryReader { geo in
            ZStack(alignment: .bottomTrailing) {
                Color(.systemBackground).ignoresSafeArea(.all, edges: .all)
                
                VStack(spacing: 0) {
                    VStack(spacing: 16) {
                        Text("Search")
                            .font(.system(size: 28, weight: .bold))
                            .frame(maxWidth: .infinity, alignment: .leading)
                        
                        HStack(spacing: 12) {
                            Image(systemName: "magnifyingglass")
                                .font(.system(size: 18))
                                .foregroundStyle(.secondary)
                            
                            TextField("Search for tasks...", text: $query)
                                .font(.system(size: 17))
                            
                            if !query.isEmpty {
                                Button {
                                    query = ""
                                } label: {
                                    Image(systemName: "xmark.circle.fill")
                                        .font(.system(size: 18))
                                        .foregroundStyle(.secondary)
                                }
                            }
                        }
                        .padding(14)
                        .background(
                            RoundedRectangle(cornerRadius: 14)
                                .fill(Color(.systemGray6))
                        )
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, geo.safeAreaInsets.top + 12)
                    .padding(.bottom, 12)
                    
                    if query.isEmpty {
                        VStack(spacing: 12) {
                            Image(systemName: "magnifyingglass")
                                .font(.system(size: 60))
                                .foregroundStyle(.secondary)
                            Text("Search for tasks")
                                .font(.system(size: 20, weight: .medium))
                                .foregroundStyle(.secondary)
                            Text("Enter a task name or keyword")
                                .font(.system(size: 15))
                                .foregroundStyle(.secondary)
                        }
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                    } else if results.isEmpty {
                        VStack(spacing: 12) {
                            Image(systemName: "magnifyingglass")
                                .font(.system(size: 60))
                                .foregroundStyle(.secondary)
                            Text("No results found")
                                .font(.system(size: 20, weight: .medium))
                                .foregroundStyle(.secondary)
                            Text("Try a different search term")
                                .font(.system(size: 15))
                                .foregroundStyle(.secondary)
                        }
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                    } else {
                        ScrollView {
                            LazyVStack(spacing: 12) {
                                ForEach(results) { task in
                                    TaskRow(task: task)
                                }
                            }
                            .padding(.horizontal, 20)
                            .padding(.bottom, geo.safeAreaInsets.bottom + 80)
                        }
                    }
                }
                
                Button { showCreate = true } label: {
                    Image(systemName: "plus")
                        .font(.system(size: 24, weight: .semibold))
                        .foregroundStyle(.white)
                        .frame(width: 60, height: 60)
                        .background(
                            Circle()
                                .fill(Color.black)
                                .shadow(color: .black.opacity(0.3), radius: 12, y: 6)
                        )
                }
                .padding(.trailing, 20)
                .padding(.bottom, geo.safeAreaInsets.bottom + 20)
            }
            .navigationTitle("Search")
            .toolbar(.hidden, for: .navigationBar)
            .navigationDestination(isPresented: $showCreate) { NewTaskView(defaultDate: .now) }
        }
    }
}
