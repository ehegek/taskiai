import SwiftUI

struct SettingsView: View {
    @EnvironmentObject var appState: AppState
    @Environment(\.dismiss) private var dismiss
    var body: some View {
        GeometryReader { geo in
            ZStack {
                Color(.systemBackground).ignoresSafeArea(.all, edges: .all)
                VStack(spacing: 0) {
                    Spacer()
                        .frame(height: 50)
                    // Header with proper spacing
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
                    .background(Color(.systemBackground))

                    List {
                    Section(header: Text("Account").font(.system(size: 14, weight: .semibold))) {
                        NavigationLink("Account") { AccountSettingsView() }
                        NavigationLink("General") { GeneralSettingsView() }
                        NavigationLink("Calendar") { CalendarSettingsView() }
                    }
                    
                    Section(header: Text("Preferences").font(.system(size: 14, weight: .semibold))) {
                        NavigationLink("Categories") { CategoriesView() }
                        NavigationLink("Subscriptions") { SubscriptionSettingsView() }
                    }
                    
                    Section(header: Text("Support").font(.system(size: 14, weight: .semibold))) {
                        Button(action: { rateApp() }) {
                            HStack {
                                Text("Rate 5 Stars")
                                Spacer()
                                Image(systemName: "star.fill")
                                    .foregroundStyle(.yellow)
                            }
                        }
                        Button(action: { shareApp() }) {
                            HStack {
                                Text("Share with a Friend")
                                Spacer()
                                Image(systemName: "square.and.arrow.up")
                            }
                        }
                        Button(action: { contactSupport() }) {
                            HStack {
                                Text("Contact Support")
                                Spacer()
                                Image(systemName: "envelope")
                            }
                        }
                    }
                    
                    Section(header: Text("Legal").font(.system(size: 14, weight: .semibold))) {
                        NavigationLink("Privacy Policy") { PlaceholderView(title: "Privacy Policy") }
                        NavigationLink("Terms of Use") { PlaceholderView(title: "Terms of Use") }
                    }
                    
                    Section(header: Text("Developer").font(.system(size: 14, weight: .semibold))) {
                        Button("Sign Out") {
                            appState.signOut()
                        }
                        .foregroundStyle(.red)
                        
                        Button("Reset Onboarding & Subscription") {
                            appState.resetAll()
                        }
                        .foregroundStyle(.orange)
                    }
                    }
                    .listStyle(.insetGrouped)
                    .scrollContentBackground(.hidden)
                }
            }
            .navigationTitle("Settings")
            .toolbar(.hidden, for: .navigationBar)
        }
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
        GeometryReader { geo in
            ZStack {
                Color(.systemBackground).ignoresSafeArea()
                
                VStack(spacing: 0) {
                    Spacer()
                        .frame(height: 50)
                    // Header with proper spacing
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
                    .background(Color(.systemBackground))
                    
                    Spacer()
                    
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
                    
                    Spacer()
                }
            }
        }
        .navigationBarHidden(true)
    }
}

