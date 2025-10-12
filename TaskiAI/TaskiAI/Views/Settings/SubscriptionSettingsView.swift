import SwiftUI

struct SubscriptionSettingsView: View {
    @EnvironmentObject var appState: AppState
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        GeometryReader { geo in
            ZStack {
                Color(.systemBackground).ignoresSafeArea()
                
                VStack(spacing: 0) {
                    // Header
                    HStack {
                        Button { dismiss() } label: {
                            Image(systemName: "chevron.left")
                                .font(.system(size: 18, weight: .semibold))
                                .foregroundStyle(.primary)
                        }
                        Spacer()
                        Text("Subscriptions")
                            .font(.system(size: 20, weight: .bold))
                        Spacer()
                        Color.clear.frame(width: 20)
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, max(geo.safeAreaInsets.top + 10, 50))
                    .padding(.bottom, 16)
                    
                    Form {
                        Section("Current Plan") {
                            HStack {
                                Text("Status")
                                Spacer()
                                Text(appState.hasActiveSubscription ? "Premium" : "Free")
                                    .foregroundStyle(appState.hasActiveSubscription ? .green : .secondary)
                            }
                        }
                        
                        if !appState.hasActiveSubscription {
                            Section {
                                Button {
                                    // Navigate to paywall
                                } label: {
                                    Text("Upgrade to Premium")
                                        .frame(maxWidth: .infinity)
                                        .font(.system(size: 17, weight: .semibold))
                                }
                            }
                        } else {
                            Section {
                                Button(role: .destructive) {
                                    appState.hasActiveSubscription = false
                                } label: {
                                    Text("Cancel Subscription")
                                }
                            }
                        }
                        
                        Section("Benefits") {
                            Label("Unlimited Tasks", systemImage: "checkmark.circle.fill")
                                .foregroundStyle(.green)
                            Label("AI Assistant", systemImage: "checkmark.circle.fill")
                                .foregroundStyle(.green)
                            Label("Voice Chat", systemImage: "checkmark.circle.fill")
                                .foregroundStyle(.green)
                            Label("Priority Support", systemImage: "checkmark.circle.fill")
                                .foregroundStyle(.green)
                        }
                    }
                }
            }
        }
        .navigationBarHidden(true)
    }
}
