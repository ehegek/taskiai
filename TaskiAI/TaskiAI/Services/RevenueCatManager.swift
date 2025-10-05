import Foundation
import Combine

#if canImport(RevenueCat)
import RevenueCat

/// Thin wrapper around RevenueCat Purchases SDK.
final class RevenueCatManager: ObservableObject {
    static let shared = RevenueCatManager()

    @Published private(set) var customerInfo: CustomerInfo?
    @Published private(set) var currentOffering: Offering?
    @Published private(set) var isConfigured = false

    private var entitlementID: String = ""
    private var cancellables = Set<AnyCancellable>()

    private init() {}

    func configure(apiKey: String, entitlementID: String, appState: AppState) {
        guard !isConfigured else { return }
        self.entitlementID = entitlementID

        Purchases.logLevel = .info
        Purchases.configure(withAPIKey: apiKey)

        // Observe customer info changes
        Purchases.shared.customerInfo { [weak self] info, error in
            if let info { self?.handle(info: info, appState: appState) }
            if let error { print("[RevenueCat] customerInfo error:", error) }
        }
        Purchases.shared.getOfferings { [weak self] offerings, error in
            if let offerings {
                self?.currentOffering = offerings.current
            } else if let error { print("[RevenueCat] offerings error:", error) }
        }

        // Listen to future updates
        Purchases.shared.delegate = self
        isConfigured = true
    }

    private func handle(info: CustomerInfo, appState: AppState) {
        DispatchQueue.main.async {
            self.customerInfo = info
            let isActive = info.entitlements[ self.entitlementID ]?.isActive == true
            appState.hasActiveSubscription = isActive
        }
    }

    func refreshOfferings() {
        Purchases.shared.getOfferings { [weak self] offerings, _ in
            self?.currentOffering = offerings?.current
        }
    }

    @discardableResult
    func purchase(package: Package, appState: AppState) async throws -> CustomerInfo {
        let result = try await Purchases.shared.purchase(package: package)
        handle(info: result.customerInfo, appState: appState)
        return result.customerInfo
    }

    func restorePurchases(appState: AppState) async throws -> CustomerInfo {
        let info = try await Purchases.shared.restorePurchases()
        handle(info: info, appState: appState)
        return info
    }
}

extension RevenueCatManager: PurchasesDelegate {
    func purchases(_ purchases: Purchases, receivedUpdated customerInfo: CustomerInfo) {
        self.customerInfo = customerInfo
    }
}

#else

/// Fallback no-op manager used when RevenueCat module is unavailable (e.g., certain CI/test configs).
final class RevenueCatManager: ObservableObject {
    static let shared = RevenueCatManager()

    @Published private(set) var isConfigured = false

    private init() {}

    func configure(apiKey: String, entitlementID: String, appState: AppState) {
        isConfigured = true
        // Do nothing; leave subscription state unchanged.
    }

    func refreshOfferings() {}
}

#endif
