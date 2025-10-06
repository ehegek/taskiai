import SwiftUI

#if canImport(RevenueCat)
import RevenueCat

struct PaywallView: View {
    @EnvironmentObject var appState: AppState
    @ObservedObject private var rc = RevenueCatManager.shared
    @State private var isPurchasing = false
    @State private var error: String?

    var body: some View {
        GeometryReader { geo in
            ZStack {
                LinearGradient(
                    colors: [Color.purple, Color.pink, Color.orange],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                .ignoresSafeArea(.all, edges: .all)
                
                ScrollView {
                    VStack(spacing: 24) {
                        Spacer(minLength: geo.safeAreaInsets.top + 30)
                        
                        VStack(spacing: 12) {
                            Image(systemName: "crown.fill")
                                .font(.system(size: 60))
                                .foregroundStyle(.yellow)
                            
                            Text("Go Pro")
                                .font(.system(size: 40, weight: .bold))
                                .foregroundStyle(.white)
                            
                            Text("Unlock unlimited tasks, AI chat, and reminders.")
                                .font(.system(size: 17))
                                .foregroundStyle(.white.opacity(0.95))
                                .multilineTextAlignment(.center)
                                .padding(.horizontal, 24)
                        }
                        .padding(.bottom, 10)
                        
                        offeringCard
                        
                        VStack(spacing: 14) {
                            Button(action: purchase) {
                                HStack(spacing: 8) {
                                    if isPurchasing { ProgressView().tint(.black) }
                                    Text(isPurchasing ? "Purchasing…" : primaryCTA)
                                        .font(.system(size: 17, weight: .semibold))
                                }
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 16)
                                .background(Color.white)
                                .foregroundStyle(.black)
                                .cornerRadius(14)
                            }
                            .disabled(isPurchasing)
                            
                            if let error {
                                Text(error)
                                    .font(.system(size: 14))
                                    .foregroundStyle(.red)
                                    .padding(.horizontal, 24)
                            }
                            
                            Button("Restore Purchases") { Task { await restore() } }
                                .font(.system(size: 15))
                                .foregroundStyle(.white.opacity(0.9))
                            
                            Button("Maybe later (dev)") {
                                withAnimation { appState.hasActiveSubscription = true }
                            }
                            .font(.system(size: 15))
                            .foregroundStyle(.white.opacity(0.9))
                        }
                        .padding(.horizontal, 24)
                        
                        Spacer(minLength: 20)
                        
                        Text("Terms • Privacy • Restore Purchases")
                            .font(.system(size: 13))
                            .foregroundStyle(.white.opacity(0.8))
                            .padding(.bottom, geo.safeAreaInsets.bottom + 20)
                    }
                }
            }
        }
    }

    private func label(_ text: String) -> some View {
        HStack { Image(systemName: "checkmark.circle.fill").foregroundStyle(.green); Text(text).bold() }
            .foregroundStyle(.white)
    }

    private var primaryPackage: Package? { rc.currentOffering?.availablePackages.first }
    private var primaryCTA: String {
        if let pkg = primaryPackage {
            return "Continue: \(pkg.storeProduct.localizedPriceString)"
        }
        return "Continue"
    }

    @MainActor
    private func purchase() {
        guard let pkg = primaryPackage else { error = "No products available"; return }
        isPurchasing = true
        Task {
            do {
                _ = try await rc.purchase(package: pkg, appState: appState)
                error = nil
            } catch {
                self.error = error.localizedDescription
            }
            isPurchasing = false
        }
    }

    @MainActor
    private func restore() async {
        do {
            _ = try await rc.restorePurchases(appState: appState)
            error = nil
        } catch {
            self.error = error.localizedDescription
        }
    }

    private var offeringCard: some View {
        VStack(alignment: .leading, spacing: 12) {
            if let pkg = primaryPackage {
                label("Includes: \(pkg.storeProduct.localizedTitle)")
                if !pkg.storeProduct.localizedDescription.isEmpty {
                    Text(pkg.storeProduct.localizedDescription)
                        .font(.system(size: 15))
                        .foregroundStyle(.white.opacity(0.9))
                }
            } else {
                label("Unlimited tasks")
                label("AI assistant")
                label("Calendar & reminders")
                label("Priority support")
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(20)
        .background(.ultraThinMaterial)
        .cornerRadius(16)
        .padding(.horizontal, 24)
    }
}
#else

struct PaywallView: View {
    @EnvironmentObject var appState: AppState
    var body: some View {
        GeometryReader { geo in
            ZStack {
                LinearGradient(
                    colors: [.purple, .pink, .orange],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                .ignoresSafeArea(.all, edges: .all)
                
                VStack(spacing: 24) {
                    Spacer(minLength: geo.safeAreaInsets.top + 40)
                    
                    Image(systemName: "crown.fill")
                        .font(.system(size: 60))
                        .foregroundStyle(.yellow)
                    
                    Text("Go Pro")
                        .font(.system(size: 40, weight: .bold))
                        .foregroundStyle(.white)
                    
                    Text("RevenueCat SDK not available in this build.")
                        .font(.system(size: 17))
                        .foregroundStyle(.white.opacity(0.9))
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 24)
                    
                    Spacer()
                    
                    Button("Continue (dev)") {
                        appState.hasActiveSubscription = true
                    }
                    .font(.system(size: 17, weight: .semibold))
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 16)
                    .background(Color.white)
                    .foregroundStyle(.black)
                    .cornerRadius(14)
                    .padding(.horizontal, 24)
                    .padding(.bottom, geo.safeAreaInsets.bottom + 20)
                }
            }
        }
    }
}

#endif
