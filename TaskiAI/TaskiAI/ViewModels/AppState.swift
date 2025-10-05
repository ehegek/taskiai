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
    @Published var streakDays: Int {
        didSet { UserDefaults.standard.set(streakDays, forKey: Keys.streakDays) }
    }
    @Published var lastTaskAddedDay: Date? {
        didSet { UserDefaults.standard.set(lastTaskAddedDay?.timeIntervalSince1970, forKey: Keys.lastTaskDay) }
    }
    @Published var referralCode: String? {
        didSet { UserDefaults.standard.set(referralCode, forKey: Keys.referral) }
    }

    struct Keys {
        static let onboarding = "app.onboarding.done"
        static let authenticated = "app.auth.authenticated"
        static let subscription = "app.sub.active"
        static let userName = "app.user.name"
        static let streakDays = "app.streak.days"
        static let lastTaskDay = "app.streak.lastDay"
        static let referral = "app.referral.code"
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
        self.streakDays = d.object(forKey: Keys.streakDays) as? Int ?? 0
        if let t = d.object(forKey: Keys.lastTaskDay) as? Double { self.lastTaskAddedDay = Date(timeIntervalSince1970: t) } else { self.lastTaskAddedDay = nil }
        self.referralCode = d.string(forKey: Keys.referral)
    }

    func signOut() {
        isAuthenticated = false
        hasActiveSubscription = false
        currentUserName = nil
    }

    func resetAll() {
        hasCompletedOnboarding = false
        signOut()
        streakDays = 0
        lastTaskAddedDay = nil
        referralCode = nil
    }

    func recordTaskAdded(on date: Date = Date()) {
        let cal = Calendar.current
        let today = cal.startOfDay(for: date)
        guard let last = lastTaskAddedDay.map({ cal.startOfDay(for: $0) }) else {
            // First ever task
            streakDays = 1
            lastTaskAddedDay = today
            return
        }
        if last == today {
            // Already counted today
            return
        }
        if let nextAfterLast = cal.date(byAdding: .day, value: 1, to: last), cal.isDate(today, inSameDayAs: nextAfterLast) {
            streakDays += 1
        } else {
            streakDays = 1
        }
        lastTaskAddedDay = today
    }
}
