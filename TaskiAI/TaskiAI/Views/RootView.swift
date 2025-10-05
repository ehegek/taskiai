import SwiftUI
import SwiftData

struct RootView: View {
    var body: some View {
        NavigationStack {
            HomeView()
        }
        .ignoresSafeArea(.all)
    }
}

struct HomeView: View {
    @EnvironmentObject var appState: AppState
    @Environment(\.modelContext) private var context
    @Query(sort: \Task.date) private var tasks: [Task]
    @State private var showCreate = false

    var body: some View {
        ZStack(alignment: .bottomTrailing) {
            ScrollView {
                VStack(alignment: .leading, spacing: 16) {
                    topBar
                    header
                    streakAndProgress
                    grid
                }
                .padding()
            }
            .background(Color.black.opacity(0.02).ignoresSafeArea(.all))

            Button { showCreate = true } label: {
                Image(systemName: "plus").font(.system(size: 28)).foregroundStyle(.white)
                    .padding(24)
                    .background(Circle().fill(Color.black))
            }
            .padding(24)
        }
        .navigationTitle("")
        .navigationDestination(isPresented: $showCreate) { NewTaskView(defaultDate: .now) }
    }

    private var topBar: some View {
        HStack {
            Text(Date.now, style: .time).font(.caption).foregroundStyle(.secondary)
            Spacer()
            HStack(spacing: 16) {
                NavigationLink(destination: SearchView()) { Image(systemName: "magnifyingglass") }
                NavigationLink(destination: SettingsView()) {
                    let initial = String((appState.currentUserName ?? "").prefix(1)).uppercased()
                    ZStack { Circle().fill(Color.black.opacity(0.9)); Text(initial.isEmpty ? "?" : initial).foregroundStyle(.white).bold() }.frame(width: 28, height: 28)
                }
            }
        }
    }

    private var header: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(greeting())
                .font(.title2).bold()
            Text(appState.currentUserName ?? "There").font(.largeTitle).bold()
            Text(Date.now.formatted(date: .complete, time: .omitted)).foregroundStyle(.secondary)
        }
    }

    private var streakAndProgress: some View {
        VStack(spacing: 12) {
            HStack {
                Image(systemName: "flame.fill").foregroundStyle(.orange)
                Text("Streak")
                Spacer()
                Text("\(appState.streakDays) Days")
            }
            .padding()
            .background(RoundedRectangle(cornerRadius: 16).fill(Color.black.opacity(0.9)))
            .foregroundStyle(.white)
            VStack(alignment: .leading) {
                HStack { Image(systemName: "checkmark.seal.fill"); Text("Completion") ; Spacer(); Text("\(completionPercent(), specifier: "%.0f")%") }
                ProgressView(value: completionRatio())
                    .tint(.black)
                    .background(RoundedRectangle(cornerRadius: 8).fill(Color.black.opacity(0.1)))
            }
            .padding()
            .background(RoundedRectangle(cornerRadius: 16).fill(Color.white))
            .shadow(color: .black.opacity(0.05), radius: 8, y: 4)
        }
    }

    private var grid: some View {
        LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 16) {
            NavigationLink { TaskListView(date: .now) } label: { card(title: "Task", subtitle: "Quick access to tasks") }
            NavigationLink { ChatView() } label: { card(title: "Taski Bot", subtitle: "What can I help with?") }
            NavigationLink { ActionReminderView(selectedDate: .now) } label: { card(title: "Action Reminder", subtitle: "Only tasks with reminders") }
            NavigationLink { CalendarView() } label: { card(title: "Calendar", subtitle: "Monthly overview") }
        }
    }

    private func card(title: String, subtitle: String) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title).bold()
            Text(subtitle).font(.footnote).foregroundStyle(.secondary)
            Spacer()
        }
        .frame(height: 140)
        .padding()
        .background {
            RoundedRectangle(cornerRadius: 16).fill(.ultraThickMaterial)
        }
    }

    private func completionRatio() -> Double {
        let total = tasks.count
        guard total > 0 else { return 0 }
        let done = tasks.filter { $0.isCompleted }.count
        return Double(done) / Double(total)
    }
    private func completionPercent() -> Double { completionRatio() * 100 }
    private func greeting() -> String {
        let h = Calendar.current.component(.hour, from: Date())
        switch h { case 5..<12: return "Good Morning,"; case 12..<17: return "Good Afternoon,"; default: return "Good Evening," }
    }
}
