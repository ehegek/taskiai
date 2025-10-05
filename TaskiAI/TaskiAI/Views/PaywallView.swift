import SwiftUI
import RevenueCat

struct PaywallView: View {
    @EnvironmentObject var appState: AppState
    @ObservedObject private var rc = RevenueCatManager.shared
    @State private var isPurchasing = false
    @State private var error: String?

    var body: some View {
        ZStack {
            LinearGradient(colors: [.purple, .pink], startPoint: .topLeading, endPoint: .bottomTrailing)
                .ignoresSafeArea()
            VStack(spacing: 20) {
                Text("Go Pro")
                    .font(.largeTitle).bold()
                    .foregroundStyle(.white)
                Text("Unlock unlimited tasks, AI chat, and reminders.")
                    .foregroundStyle(.white.opacity(0.9))

                offeringCard

                Button(action: purchase) {
                    HStack {
                        if isPurchasing { ProgressView().tint(.black) }
                        Text(isPurchasing ? "Purchasing…" : primaryCTA)
                            .bold()
                    }
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.white, in: RoundedRectangle(cornerRadius: 12))
                    .foregroundStyle(.black)
                }
                .disabled(isPurchasing)

                if let error { Text(error).foregroundStyle(.red).font(.footnote) }

                Button("Restore Purchases") { Task { await restore() } }
                    .foregroundStyle(.white.opacity(0.9))

                Button("Maybe later (dev)") {
                    withAnimation { appState.hasActiveSubscription = true }
                }
                .foregroundStyle(.white.opacity(0.9))

                Spacer()
                Text("Terms • Privacy • Restore Purchases")
                    .font(.footnote)
                    .foregroundStyle(.white.opacity(0.8))
                    .padding(.bottom)
            }
            .padding()
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
        VStack(alignment: .leading, spacing: 8) {
            if let pkg = primaryPackage {
                label("Includes: \(pkg.storeProduct.localizedTitle)")
                if !pkg.storeProduct.localizedDescription.isEmpty {
                    Text(pkg.storeProduct.localizedDescription)
                        .foregroundStyle(.white.opacity(0.9))
                }
            } else {
                label("Unlimited tasks")
                label("AI assistant")
                label("Calendar & reminders")
                label("Priority support")
            }
        }
        .padding()
        .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 16))
    }
}
