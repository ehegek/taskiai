import SwiftUI

struct SettingsView: View {
    @EnvironmentObject var appState: AppState
    var body: some View {
        GeometryReader { geo in
            ZStack {
                Color(.systemBackground).ignoresSafeArea(.all, edges: .all)
                List {
                    Section(header: Text("Account").font(.system(size: 14, weight: .semibold))) {
                        NavigationLink("Account") { Text("Account") }
                        NavigationLink("General") { Text("General") }
                        NavigationLink("Calendar") { Text("Calendar") }
                    }
                    
                    Section(header: Text("Preferences").font(.system(size: 14, weight: .semibold))) {
                        NavigationLink("Categories") { Text("Categories") }
                        NavigationLink("Subscriptions") { Text("Subscriptions") }
                    }
                    
                    Section(header: Text("Support").font(.system(size: 14, weight: .semibold))) {
                        Button(action: {}) {
                            HStack {
                                Text("Rate 5 Stars")
                                Spacer()
                                Image(systemName: "star.fill")
                                    .foregroundStyle(.yellow)
                            }
                        }
                        Button(action: {}) {
                            HStack {
                                Text("Share with a Friend")
                                Spacer()
                                Image(systemName: "square.and.arrow.up")
                            }
                        }
                        Button(action: {}) {
                            HStack {
                                Text("Contact Support")
                                Spacer()
                                Image(systemName: "envelope")
                            }
                        }
                    }
                    
                    Section(header: Text("Legal").font(.system(size: 14, weight: .semibold))) {
                        NavigationLink("Privacy Policy") { Text("Privacy Policy") }
                        NavigationLink("Terms of Use") { Text("Terms of Use") }
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
            .navigationTitle("Settings")
        }
    }
}
