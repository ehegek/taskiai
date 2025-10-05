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
                VStack(alignment: .leading, spacing: 20) {
                    topBar
                    header
                    streakPill
                    grid
                }
                .padding()
            }
            .background(Color(.systemBackground).ignoresSafeArea(.all))

            Button { showCreate = true } label: {
                Image(systemName: "plus").font(.system(size: 28)).foregroundStyle(.white)
                    .padding(24)
                    .background(Circle().fill(Color.black))
                    .shadow(color: .black.opacity(0.2), radius: 10, y: 6)
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
        VStack(alignment: .leading, spacing: 6) {
            HStack(alignment: .center) {
                VStack(alignment: .leading, spacing: 2) {
                    Text(greeting()).font(.title3).bold()
                    Text(appState.currentUserName ?? "There").font(.title).bold()
                    Text(Date.now.formatted(date: .complete, time: .omitted)).foregroundStyle(.secondary).font(.footnote)
                }
                Spacer()
                HStack(spacing: 12) {
                    NavigationLink(destination: SearchView()) {
                        Image(systemName: "magnifyingglass").padding(10).background(Circle().fill(Color(.systemGray6)))
                    }
                    NavigationLink(destination: SettingsView()) {
                        let initial = String((appState.currentUserName ?? "").prefix(1)).uppercased()
                        ZStack { Circle().fill(Color.black); Text(initial.isEmpty ? "D" : initial).foregroundStyle(.white).bold() }.frame(width: 28, height: 28)
                    }
                }
            }
        }
    }

    private var streakPill: some View {
        HStack(spacing: 12) {
            VStack(alignment: .leading, spacing: 2) {
                HStack { Image(systemName: "flame.fill").foregroundStyle(.orange); Text("Streak").foregroundStyle(.white) }
                Text("\(appState.streakDays) Days").foregroundStyle(.white).font(.headline).bold()
            }
            Spacer()
            VStack(spacing: 4) {
                Text("TASKI AI").foregroundStyle(.white).font(.footnote).bold()
                ProgressView(value: completionRatio())
                    .tint(.white)
                    .frame(width: 80)
            }
        }
        .padding()
        .background(RoundedRectangle(cornerRadius: 16).fill(Color.black))
    }

    private var grid: some View {
        LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 16) {
            NavigationLink { TaskListView(date: .now) } label: { card(title: "Task", subtitle: "") }
            NavigationLink { ChatView() } label: { card(title: "Taski Bot", subtitle: "What can I help with?") }
            NavigationLink { ActionReminderView(selectedDate: .now) } label: { card(title: "Action Reminder", subtitle: "") }
            NavigationLink { CalendarView() } label: { card(title: "Calendar", subtitle: "") }
        }
    }

    private func card(title: String, subtitle: String) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title).bold()
            Text(subtitle).font(.footnote).foregroundStyle(.secondary)
            Spacer()
        }
        .frame(height: 160)
        .padding()
        .background(RoundedRectangle(cornerRadius: 16).fill(Color(.systemGray6)))
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
