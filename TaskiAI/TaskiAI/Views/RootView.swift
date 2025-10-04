import SwiftUI
import SwiftData

struct RootView: View {
    var body: some View {
        NavigationStack {
            HomeView()
        }
    }
}

struct HomeView: View {
    @Environment(\.modelContext) private var context
    @Query(sort: \Task.date) private var tasks: [Task]
    @State private var showCreate = false

    var body: some View {
        ZStack(alignment: .bottomTrailing) {
            ScrollView {
                VStack(alignment: .leading, spacing: 16) {
                    header
                    streak
                    grid
                }
                .padding()
            }
            Button { showCreate = true } label: {
                Image(systemName: "plus.circle.fill").font(.system(size: 56))
            }
            .padding(24)
        }
        .navigationTitle("")
        .toolbar { ToolbarItem(placement: .topBarTrailing) { Image(systemName: "person.crop.circle") } }
        .navigationDestination(isPresented: $showCreate) { NewTaskView(defaultDate: .now) }
    }

    private var header: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text("Good Afternoon,")
                .font(.title2).bold()
            Text("Dakota Johnson").font(.largeTitle).bold()
            Text(Date.now.formatted(date: .complete, time: .omitted)).foregroundStyle(.secondary)
        }
    }

    private var streak: some View {
        HStack {
            Image(systemName: "flame.fill").foregroundStyle(.orange)
            Text("Streak")
            Spacer()
            Text("7 Days")
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color.black.opacity(0.9))
        )
        .foregroundStyle(.white)
    }

    private var grid: some View {
        LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 16) {
            NavigationLink { TaskListView(date: .now) } label: { card(title: "Task") }
            NavigationLink { ChatView() } label: { card(title: "Taski Bot") }
            NavigationLink { ActionReminderView(selectedDate: .now) } label: { card(title: "Action Reminder") }
            NavigationLink { CalendarView() } label: { card(title: "Calendar") }
        }
    }

    private func card(title: String) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title).bold()
            Spacer()
        }
        .frame(height: 140)
        .padding()
        .background {
            RoundedRectangle(cornerRadius: 16).fill(.ultraThickMaterial)
        }
    }
}
