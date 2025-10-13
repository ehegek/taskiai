import SwiftUI
import SwiftData

struct RootView: View {
    var body: some View {
        NavigationStack {
            HomeView()
                .navigationBarHidden(true)
                .edgesIgnoringSafeArea(.all)
        }
        .edgesIgnoringSafeArea(.all)
    }
}

struct HomeView: View {
    @EnvironmentObject var appState: AppState
    @Environment(\.modelContext) private var context
    @Query(sort: \Task.date) private var tasks: [Task]
    @State private var showCreate = false

    var body: some View {
        ZStack(alignment: .bottomTrailing) {
            Rectangle()
                .fill(Color(.systemBackground))
                .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
                .edgesIgnoringSafeArea(.all)
            
            GeometryReader { geo in
                ScrollView {
                    VStack(alignment: .leading, spacing: 20) {
                        Spacer()
                            .frame(height: max(geo.safeAreaInsets.top + 10, 50))
                        header
                        streakPill
                        grid
                        Spacer()
                            .frame(height: max(geo.safeAreaInsets.bottom + 100, 120))
                    }
                    .padding(.horizontal, 16)
                }
                .scrollIndicators(.hidden)
                .edgesIgnoringSafeArea(.all)
                
                VStack {
                    Spacer()
                    HStack {
                        Spacer()
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
                        .padding(.bottom, max(geo.safeAreaInsets.bottom + 20, 30))
                    }
                }
            }
        }
        .navigationTitle("")
        .navigationBarHidden(true)
        .navigationDestination(isPresented: $showCreate) { NewTaskView(defaultDate: .now) }
        .ignoresSafeArea(.keyboard, edges: .bottom)
    }


    private var header: some View {
        HStack(alignment: .top) {
            VStack(alignment: .leading, spacing: 6) {
                Text(greeting())
                    .font(.system(size: 18, weight: .medium))
                    .foregroundStyle(.secondary)
                
                Text(appState.currentUserName ?? "There")
                    .font(.system(size: 32, weight: .bold))
                
                Text(Date.now.formatted(date: .abbreviated, time: .omitted))
                    .font(.system(size: 14))
                    .foregroundStyle(.secondary)
            }
            
            Spacer()
            
            HStack(spacing: 14) {
                NavigationLink(destination: CategoriesView()) {
                    Image(systemName: "folder.fill")
                        .font(.system(size: 18, weight: .medium))
                        .foregroundStyle(.primary)
                        .frame(width: 40, height: 40)
                        .background(Circle().fill(Color(.systemGray6)))
                }
                
                NavigationLink(destination: SearchView()) {
                    Image(systemName: "magnifyingglass")
                        .font(.system(size: 18, weight: .medium))
                        .foregroundStyle(.primary)
                        .frame(width: 40, height: 40)
                        .background(Circle().fill(Color(.systemGray6)))
                }
                
                NavigationLink(destination: SettingsView()) {
                    let initial = String((appState.currentUserName ?? "").prefix(1)).uppercased()
                    ZStack {
                        Circle().fill(Color.black)
                        Text(initial.isEmpty ? "U" : initial)
                            .font(.system(size: 16, weight: .semibold))
                            .foregroundStyle(.white)
                    }
                    .frame(width: 40, height: 40)
                }
            }
        }
    }

    private var streakPill: some View {
        HStack(spacing: 16) {
            VStack(alignment: .leading, spacing: 6) {
                HStack(spacing: 6) {
                    Image(systemName: "flame.fill")
                        .font(.system(size: 18))
                        .foregroundStyle(.orange)
                    Text("Streak")
                        .font(.system(size: 15, weight: .medium))
                        .foregroundStyle(.white)
                }
                Text("\(appState.streakDays) Days")
                    .font(.system(size: 24, weight: .bold))
                    .foregroundStyle(.white)
            }
            
            Spacer()
            
            VStack(spacing: 6) {
                Text("TASKI AI")
                    .font(.system(size: 12, weight: .bold))
                    .foregroundStyle(.white.opacity(0.9))
                Text("\(Int(completionPercent()))%")
                    .font(.system(size: 20, weight: .bold))
                    .foregroundStyle(.white)
                ProgressView(value: completionRatio())
                    .tint(.white)
                    .frame(width: 90)
            }
        }
        .padding(20)
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(
                    LinearGradient(
                        colors: [Color.black, Color(red: 0.2, green: 0.2, blue: 0.2)],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .shadow(color: .black.opacity(0.2), radius: 10, y: 4)
        )
    }

    private var grid: some View {
        LazyVGrid(
            columns: [GridItem(.flexible(), spacing: 16), GridItem(.flexible(), spacing: 16)],
            spacing: 16
        ) {
            NavigationLink { TaskListView(date: .now) } label: {
                card(title: "Tasks", subtitle: "Manage your tasks", icon: "checkmark.circle.fill", color: .blue)
            }
            NavigationLink { ChatView() } label: {
                card(title: "Taski Bot", subtitle: "AI Assistant", icon: "message.fill", color: .purple)
            }
            NavigationLink { RemindersView() } label: {
                card(title: "Reminders", subtitle: "Your active reminders", icon: "bell.fill", color: .orange)
            }
            NavigationLink { CalendarView() } label: {
                card(title: "Calendar", subtitle: "View schedule", icon: "calendar", color: .green)
            }
        }
    }

    private func card(title: String, subtitle: String, icon: String, color: Color) -> some View {
        VStack(alignment: .leading, spacing: 16) {
            Image(systemName: icon)
                .font(.system(size: 44, weight: .medium))
                .foregroundStyle(color)
            
            Spacer()
            
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.system(size: 19, weight: .bold))
                    .foregroundStyle(.primary)
                
                Text(subtitle)
                    .font(.system(size: 14))
                    .foregroundStyle(.secondary)
            }
        }
        .frame(height: 190)
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(20)
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(Color(.systemBackground))
                .shadow(color: Color.black.opacity(0.08), radius: 8, y: 4)
        )
        .overlay(
            RoundedRectangle(cornerRadius: 20)
                .stroke(Color(.systemGray5), lineWidth: 1)
        )
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
