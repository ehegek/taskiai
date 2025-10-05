import SwiftUI
import SwiftData

@main
struct TaskiAIApp: App {
    @StateObject private var appState = AppState()
    var sharedModelContainer: ModelContainer = {
        do {
            return try ModelContainer(for: Task.self, Category.self)
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()

    var body: some Scene {
        WindowGroup {
            ContentRouterView()
                .environmentObject(appState)
        }
        .modelContainer(sharedModelContainer)
    }
}
