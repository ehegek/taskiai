import SwiftUI
import SwiftData
import FirebaseCore

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

    init() {
        // Configure Firebase
        FirebaseApp.configure()
    }

    var body: some Scene {
        WindowGroup {
            ContentRouterView()
                .environmentObject(appState)
                .onAppear {
                    configureRevenueCat()
                    requestNotificationPermissions()
                    loadUserReferralData()
                }
        }
        .modelContainer(sharedModelContainer)
    }
}

private extension TaskiAIApp {
    func configureRevenueCat() {
        guard let apiKey = Bundle.main.object(forInfoDictionaryKey: "REVENUECAT_API_KEY") as? String,
              let entitlement = Bundle.main.object(forInfoDictionaryKey: "REVENUECAT_ENTITLEMENT_ID") as? String,
              !apiKey.isEmpty, !entitlement.isEmpty,
              !apiKey.contains("__SET") else {
            print("[RevenueCat] Missing API key or entitlement in Info.plist")
            return
        }
        RevenueCatManager.shared.configure(apiKey: apiKey, entitlementID: entitlement, appState: appState)
        RevenueCatManager.shared.refreshOfferings()
    }
    
    func requestNotificationPermissions() {
        Task {
            _ = await NotificationService.shared.requestAuthorization()
        }
    }
    
    func loadUserReferralData() {
        Task {
            await appState.loadReferralStats()
        }
    }
}
