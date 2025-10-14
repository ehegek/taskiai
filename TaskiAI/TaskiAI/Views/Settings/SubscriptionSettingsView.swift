import SwiftUI

struct SubscriptionSettingsView: View {
    @EnvironmentObject var appState: AppState
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        ZStack {
            Color(.systemBackground).ignoresSafeArea()
            
            GeometryReader { geo in
                ScrollView {
                    VStack(spacing: 0) {
                        Spacer()
                            .frame(height: max(geo.safeAreaInsets.top + 1, 50))
                        
                        HStack {
                            Button { dismiss() } label: {
                                Image(systemName: "chevron.left")
                                    .font(.system(size: 20, weight: .semibold))
                                    .foregroundStyle(.primary)
                            }
                            Spacer()
                            Text("Subscriptions")
                                .font(.system(size: 20, weight: .bold))
                            Spacer()
                            Color.clear.frame(width: 20)
                        }
                        .padding(.horizontal, 20)
                        .padding(.vertical, 12)
                        
                        VStack(spacing: 20) {
                            VStack(alignment: .leading, spacing: 8) {
                                Text("Current Plan")
                                    .font(.system(size: 14, weight: .semibold))
                                    .textCase(.uppercase)
                                    .foregroundStyle(.secondary)
                                    .padding(.horizontal, 20)
                                
                                VStack(spacing: 0) {
                                    HStack {
                                        Text("Status")
                                        Spacer()
                                        Text(appState.hasActiveSubscription ? "Premium" : "Free")
                                            .foregroundStyle(appState.hasActiveSubscription ? .green : .secondary)
                                    }
                                    .padding()
                                    .background(Color(.systemGray6))
                                }
                                .background(Color(.systemGray6))
                                .cornerRadius(12)
                            }
                            
                            if !appState.hasActiveSubscription {
                                Button {
                                    // Navigate to paywall
                                } label: {
                                    Text("Upgrade to Premium")
                                        .frame(maxWidth: .infinity)
                                        .font(.system(size: 17, weight: .semibold))
                                        .padding()
                                        .background(Color.blue)
                                        .foregroundStyle(.white)
                                        .cornerRadius(12)
                                }
                                .padding(.horizontal, 20)
                            } else {
                                Button(role: .destructive) {
                                    appState.hasActiveSubscription = false
                                } label: {
                                    Text("Cancel Subscription")
                                        .frame(maxWidth: .infinity)
                                        .padding()
                                        .background(Color(.systemGray6))
                                        .foregroundStyle(.red)
                                        .cornerRadius(12)
                                }
                                .padding(.horizontal, 20)
                            }
                            
                            VStack(alignment: .leading, spacing: 8) {
                                Text("Benefits")
                                    .font(.system(size: 14, weight: .semibold))
                                    .textCase(.uppercase)
                                    .foregroundStyle(.secondary)
                                    .padding(.horizontal, 20)
                                
                                VStack(spacing: 0) {
                                    Label("Unlimited Tasks", systemImage: "checkmark.circle.fill")
                                        .foregroundStyle(.green)
                                        .padding()
                                        .frame(maxWidth: .infinity, alignment: .leading)
                                        .background(Color(.systemGray6))
                                    
                                    Divider().padding(.leading, 20)
                                    
                                    Label("AI Assistant", systemImage: "checkmark.circle.fill")
                                        .foregroundStyle(.green)
                                        .padding()
                                        .frame(maxWidth: .infinity, alignment: .leading)
                                        .background(Color(.systemGray6))
                                    
                                    Divider().padding(.leading, 20)
                                    
                                    Label("Voice Chat", systemImage: "checkmark.circle.fill")
                                        .foregroundStyle(.green)
                                        .padding()
                                        .frame(maxWidth: .infinity, alignment: .leading)
                                        .background(Color(.systemGray6))
                                    
                                    Divider().padding(.leading, 20)
                                    
                                    Label("Priority Support", systemImage: "checkmark.circle.fill")
                                        .foregroundStyle(.green)
                                        .padding()
                                        .frame(maxWidth: .infinity, alignment: .leading)
                                        .background(Color(.systemGray6))
                                }
                                .background(Color(.systemGray6))
                                .cornerRadius(12)
                            }
                        }
                        .padding(.horizontal, 20)
                        .padding(.top, 12)
                        
                        Spacer()
                            .frame(height: max(geo.safeAreaInsets.bottom + 20, 40))
                    }
                }
                .scrollIndicators(.hidden)
            }
        }
        .navigationBarHidden(true)
    }
}
