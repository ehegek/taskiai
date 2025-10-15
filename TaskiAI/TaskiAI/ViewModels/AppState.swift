import Foundation
import Combine

/// Global application state for high-level routing and flags.
final class AppState: ObservableObject {
    @Published var hasSeenWelcome: Bool {
        didSet { UserDefaults.standard.set(hasSeenWelcome, forKey: Keys.welcome) }
    }
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
    @Published var currentUserEmail: String? {
        didSet { UserDefaults.standard.set(currentUserEmail, forKey: Keys.userEmail) }
    }
    @Published var currentUserId: String? {
        didSet { UserDefaults.standard.set(currentUserId, forKey: Keys.userId) }
    }
    @Published var userPhone: String? {
        didSet { UserDefaults.standard.set(userPhone, forKey: Keys.userPhone) }
    }
    @Published var streakDays: Int {
        didSet { 
            UserDefaults.standard.set(streakDays, forKey: Keys.streakDays)
            // Sync to Firestore
            Task { try? await syncStreakToFirestore() }
        }
    }
    @Published var lastTaskAddedDay: Date? {
        didSet { 
            UserDefaults.standard.set(lastTaskAddedDay?.timeIntervalSince1970, forKey: Keys.lastTaskDay)
            // Sync to Firestore
            Task { try? await syncStreakToFirestore() }
        }
    }
    @Published var referralCode: String? {
        didSet { UserDefaults.standard.set(referralCode, forKey: Keys.referral) }
    }
    @Published var referralCount: Int = 0
    @Published var selectedTheme: String {
        didSet { 
            UserDefaults.standard.set(selectedTheme, forKey: Keys.theme)
            applyTheme()
        }
    }

    struct Keys {
        static let welcome = "app.welcome.seen"
        static let onboarding = "app.onboarding.done"
        static let authenticated = "app.auth.authenticated"
        static let subscription = "app.sub.active"
        static let userName = "app.user.name"
        static let userEmail = "app.user.email"
        static let userId = "app.user.id"
        static let userPhone = "app.user.phone"
        static let streakDays = "app.streak.days"
        static let lastTaskDay = "app.streak.lastDay"
        static let referral = "app.referral.code"
        static let theme = "app.theme"
    }

    init() {
        let d = UserDefaults.standard
        self.hasSeenWelcome = d.bool(forKey: Keys.welcome)
        self.hasCompletedOnboarding = d.bool(forKey: Keys.onboarding)
        self.isAuthenticated = d.bool(forKey: Keys.authenticated)
        self.hasActiveSubscription = d.bool(forKey: Keys.subscription)
        self.currentUserName = d.string(forKey: Keys.userName)
        self.currentUserEmail = d.string(forKey: Keys.userEmail)
        self.currentUserId = d.string(forKey: Keys.userId)
        self.userPhone = d.string(forKey: Keys.userPhone)
        self.streakDays = d.object(forKey: Keys.streakDays) as? Int ?? 0
        if let t = d.object(forKey: Keys.lastTaskDay) as? Double { self.lastTaskAddedDay = Date(timeIntervalSince1970: t) } else { self.lastTaskAddedDay = nil }
        self.referralCode = d.string(forKey: Keys.referral)
        self.selectedTheme = d.string(forKey: Keys.theme) ?? "System"
        
        applyTheme()
        
        // Load user data from Firestore if authenticated
        if isAuthenticated, let userId = currentUserId {
            Task {
                try? await loadUserDataFromFirestore(userId: userId)
            }
        }
    }

    func signOut() {
        do {
            try FirebaseAuthService.shared.signOut()
            isAuthenticated = false
            hasActiveSubscription = false
            currentUserName = nil
            currentUserEmail = nil
            currentUserId = nil
            userPhone = nil
        } catch {
            print("Sign out error: \(error)")
        }
    }

    func resetAll() {
        hasSeenWelcome = false
        hasCompletedOnboarding = false
        signOut()
        streakDays = 0
        lastTaskAddedDay = nil
        referralCode = nil
        referralCount = 0
    }

    func recordTaskAdded(on date: Date = Date()) async {
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
    
    // MARK: - Theme Management
    
    func applyTheme() {
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene else { return }
        
        switch selectedTheme {
        case "Light":
            windowScene.windows.forEach { $0.overrideUserInterfaceStyle = .light }
        case "Dark":
            windowScene.windows.forEach { $0.overrideUserInterfaceStyle = .dark }
        default:
            windowScene.windows.forEach { $0.overrideUserInterfaceStyle = .unspecified }
        }
    }
    
    // MARK: - Firebase Sync
    
    func loadUserDataFromFirestore(userId: String) async throws {
        guard let userData = try await FirestoreService.shared.getUser(userId: userId) else { return }
        
        await MainActor.run {
            self.currentUserName = userData.name
            self.currentUserEmail = userData.email
            self.referralCode = userData.referralCode
            self.referralCount = userData.referralCount
            self.streakDays = userData.streakDays
            self.lastTaskAddedDay = userData.lastTaskDate
            self.hasActiveSubscription = userData.hasActiveSubscription
        }
    }
    
    private func syncStreakToFirestore() async throws {
        guard let userId = currentUserId else { return }
        
        if let lastDate = lastTaskAddedDay {
            try await FirestoreService.shared.updateStreak(
                userId: userId,
                streakDays: streakDays,
                lastTaskDate: lastDate
            )
        }
    }
    
    func applyReferralCode(_ code: String) async -> Bool {
        guard let userId = currentUserId else { return false }
        
        do {
            let success = try await FirestoreService.shared.applyReferralCode(code, toUser: userId)
            if success {
                await MainActor.run {
                    // Optionally reward the user
                }
            }
            return success
        } catch {
            return false
        }
    }
    
    func loadReferralStats() async {
        guard let userId = currentUserId else { return }
        
        do {
            let stats = try await FirestoreService.shared.getReferralStats(userId: userId)
            await MainActor.run {
                self.referralCode = stats.code
                self.referralCount = stats.count
            }
        } catch {
            print("Failed to load referral stats: \(error)")
        }
    }
}
