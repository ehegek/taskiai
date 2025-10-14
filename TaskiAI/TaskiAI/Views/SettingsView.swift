import SwiftUI

struct SettingsView: View {
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
                        
                        header
                        
                        VStack(spacing: 20) {
                            Section {
                                VStack(spacing: 0) {
                                    NavigationLink("Account") { AccountSettingsView() }
                                        .padding()
                                        .background(Color(.systemGray6))
                                    Divider().padding(.leading, 20)
                                    NavigationLink("General") { GeneralSettingsView() }
                                        .padding()
                                        .background(Color(.systemGray6))
                                    Divider().padding(.leading, 20)
                                    NavigationLink("Calendar") { CalendarSettingsView() }
                                        .padding()
                                        .background(Color(.systemGray6))
                                }
                                .background(Color(.systemGray6))
                                .cornerRadius(12)
                            } header: {
                                Text("Account")
                                    .font(.system(size: 14, weight: .semibold))
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                    .padding(.horizontal, 20)
                                    .padding(.bottom, 6)
                                    .textCase(.uppercase)
                                    .foregroundStyle(.secondary)
                            }
                            
                            Section {
                                VStack(spacing: 0) {
                                    NavigationLink("Categories") { CategoriesView() }
                                        .padding()
                                        .background(Color(.systemGray6))
                                    Divider().padding(.leading, 20)
                                    NavigationLink("Subscriptions") { SubscriptionSettingsView() }
                                        .padding()
                                        .background(Color(.systemGray6))
                                }
                                .background(Color(.systemGray6))
                                .cornerRadius(12)
                            } header: {
                                Text("Preferences")
                                    .font(.system(size: 14, weight: .semibold))
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                    .padding(.horizontal, 20)
                                    .padding(.bottom, 6)
                                    .textCase(.uppercase)
                                    .foregroundStyle(.secondary)
                            }
                            
                            Section {
                                VStack(spacing: 0) {
                                    Button(action: { rateApp() }) {
                                        HStack {
                                            Text("Rate 5 Stars")
                                            Spacer()
                                            Image(systemName: "star.fill")
                                                .foregroundStyle(.yellow)
                                        }
                                        .padding()
                                        .background(Color(.systemGray6))
                                    }
                                    Divider().padding(.leading, 20)
                                    Button(action: { shareApp() }) {
                                        HStack {
                                            Text("Share with a Friend")
                                            Spacer()
                                            Image(systemName: "square.and.arrow.up")
                                        }
                                        .padding()
                                        .background(Color(.systemGray6))
                                    }
                                    Divider().padding(.leading, 20)
                                    Button(action: { contactSupport() }) {
                                        HStack {
                                            Text("Contact Support")
                                            Spacer()
                                            Image(systemName: "envelope")
                                        }
                                        .padding()
                                        .background(Color(.systemGray6))
                                    }
                                }
                                .background(Color(.systemGray6))
                                .cornerRadius(12)
                            } header: {
                                Text("Support")
                                    .font(.system(size: 14, weight: .semibold))
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                    .padding(.horizontal, 20)
                                    .padding(.bottom, 6)
                                    .textCase(.uppercase)
                                    .foregroundStyle(.secondary)
                            }
                            
                            Section {
                                VStack(spacing: 0) {
                                    NavigationLink("Privacy Policy") { PlaceholderView(title: "Privacy Policy") }
                                        .padding()
                                        .background(Color(.systemGray6))
                                    Divider().padding(.leading, 20)
                                    NavigationLink("Terms of Use") { PlaceholderView(title: "Terms of Use") }
                                        .padding()
                                        .background(Color(.systemGray6))
                                }
                                .background(Color(.systemGray6))
                                .cornerRadius(12)
                            } header: {
                                Text("Legal")
                                    .font(.system(size: 14, weight: .semibold))
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                    .padding(.horizontal, 20)
                                    .padding(.bottom, 6)
                                    .textCase(.uppercase)
                                    .foregroundStyle(.secondary)
                            }
                            
                            Section {
                                VStack(spacing: 0) {
                                    Button("Sign Out") { appState.signOut() }
                                        .foregroundStyle(.red)
                                        .frame(maxWidth: .infinity, alignment: .leading)
                                        .padding()
                                        .background(Color(.systemGray6))
                                    Divider().padding(.leading, 20)
                                    Button("Reset Onboarding & Subscription") { appState.resetAll() }
                                        .foregroundStyle(.orange)
                                        .frame(maxWidth: .infinity, alignment: .leading)
                                        .padding()
                                        .background(Color(.systemGray6))
                                }
                                .background(Color(.systemGray6))
                                .cornerRadius(12)
                            } header: {
                                Text("Developer")
                                    .font(.system(size: 14, weight: .semibold))
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                    .padding(.horizontal, 20)
                                    .padding(.bottom, 6)
                                    .textCase(.uppercase)
                                    .foregroundStyle(.secondary)
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
        .navigationTitle("Settings")
        .toolbar(.hidden, for: .navigationBar)
        .navigationBarHidden(true)
    }
    
    private var header: some View {
        HStack {
            Button { dismiss() } label: {
                Image(systemName: "chevron.left")
                    .font(.system(size: 20, weight: .semibold))
                    .foregroundStyle(.primary)
            }
            Spacer()
            Text("Settings")
                .font(.system(size: 20, weight: .bold))
            Spacer()
            Color.clear.frame(width: 20)
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 12)
    }
    
    private func rateApp() {
        if let url = URL(string: "https://apps.apple.com/app/id123456789") {
            UIApplication.shared.open(url)
        }
    }
    
    private func shareApp() {
        let text = "Check out Taski AI - The smartest task manager!"
        let url = URL(string: "https://apps.apple.com/app/id123456789")!
        let activityVC = UIActivityViewController(activityItems: [text, url], applicationActivities: nil)
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
           let window = windowScene.windows.first,
           let rootVC = window.rootViewController {
            rootVC.present(activityVC, animated: true)
        }
    }
    
    private func contactSupport() {
        if let url = URL(string: "mailto:support@taskiai.app") {
            UIApplication.shared.open(url)
        }
    }
}

struct PlaceholderView: View {
    let title: String
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
                            Text(title)
                                .font(.system(size: 20, weight: .bold))
                            Spacer()
                            Color.clear.frame(width: 20)
                        }
                        .padding(.horizontal, 20)
                        .padding(.vertical, 12)
                        
                        VStack(spacing: 16) {
                            Image(systemName: "doc.text")
                                .font(.system(size: 60))
                                .foregroundStyle(.secondary)
                            Text("Coming Soon")
                                .font(.system(size: 24, weight: .bold))
                            Text("This page is under construction")
                                .font(.system(size: 16))
                                .foregroundStyle(.secondary)
                        }
                        .padding(.top, 100)
                        
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

