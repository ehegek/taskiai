import SwiftUI
import SwiftData
import RevenueCat

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
                .onAppear {
                    configureRevenueCat()
                }
        }
        .modelContainer(sharedModelContainer)
    }
}

private extension TaskiAIApp {
    func configureRevenueCat() {
        guard let apiKey = Bundle.main.object(forInfoDictionaryKey: "REVENUECAT_API_KEY") as? String,
              let entitlement = Bundle.main.object(forInfoDictionaryKey: "REVENUECAT_ENTITLEMENT_ID") as? String,
              !apiKey.isEmpty, !entitlement.isEmpty else {
            print("[RevenueCat] Missing API key or entitlement in Info.plist")
            return
        }
        RevenueCatManager.shared.configure(apiKey: apiKey, entitlementID: entitlement, appState: appState)
        RevenueCatManager.shared.refreshOfferings()
    }
}
