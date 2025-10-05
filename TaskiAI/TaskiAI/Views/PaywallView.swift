import SwiftUI

struct PaywallView: View {
    @EnvironmentObject var appState: AppState
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

                VStack(alignment: .leading, spacing: 8) {
                    label("Unlimited tasks")
                    label("AI assistant")
                    label("Calendar & reminders")
                    label("Priority support")
                }
                .padding()
                .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 16))

                Button(action: purchase) {
                    HStack {
                        if isPurchasing { ProgressView().tint(.black) }
                        Text(isPurchasing ? "Purchasing…" : "Start 7‑day Free Trial")
                            .bold()
                    }
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.white, in: RoundedRectangle(cornerRadius: 12))
                    .foregroundStyle(.black)
                }
                .disabled(isPurchasing)

                if let error { Text(error).foregroundStyle(.red).font(.footnote) }

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

    private func purchase() {
        // Placeholder purchase flow; integrate StoreKit 2 in real app.
        isPurchasing = true
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            isPurchasing = false
            withAnimation { appState.hasActiveSubscription = true }
        }
    }
}
