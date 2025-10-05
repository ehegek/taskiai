import Foundation
import Combine

/// Global application state for high-level routing and flags.
final class AppState: ObservableObject {
    @Published var hasCompletedOnboarding: Bool {
        didSet { UserDefaults.standard.set(hasCompletedOnboarding, forKey: Keys.onboarding) }
    }
    @Published var isAuthenticated: Bool {
        didSet { UserDefaults.standard.set(isAuthenticated, forKey: Keys.authenticated) }
    }
    @Published var hasActiveSubscription: Bool {
        didSet { UserDefaults.standard.set(hasActiveSubscription, forKey: Keys.subscription) }
    }
    @Published var currentUserName: String? {
        didSet { UserDefaults.standard.set(currentUserName, forKey: Keys.userName) }
    }

    struct Keys {
        static let onboarding = "app.onboarding.done"
        static let authenticated = "app.auth.authenticated"
        static let subscription = "app.sub.active"
        static let userName = "app.user.name"
    }

    // Simple admin credentials for development/testing.
    static let adminEmail = "admin@taskiai.dev"
    static let adminPassword = "letmein123"

    init() {
        let d = UserDefaults.standard
        self.hasCompletedOnboarding = d.bool(forKey: Keys.onboarding)
        self.isAuthenticated = d.bool(forKey: Keys.authenticated)
        self.hasActiveSubscription = d.bool(forKey: Keys.subscription)
        self.currentUserName = d.string(forKey: Keys.userName)
    }

    func signOut() {
        isAuthenticated = false
        hasActiveSubscription = false
        currentUserName = nil
    }

    func resetAll() {
        hasCompletedOnboarding = false
        signOut()
    }
}
