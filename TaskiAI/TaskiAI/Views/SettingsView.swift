import SwiftUI

struct SettingsView: View {
    @EnvironmentObject var appState: AppState
    @Environment(\.dismiss) private var dismiss
    var body: some View {
        GeometryReader { geo in
            ZStack {
                Color(.systemBackground).ignoresSafeArea(.all, edges: .all)
                VStack(spacing: 0) {
                    // Back + Title
                    HStack(spacing: 8) {
                        Button { dismiss() } label: {
                            HStack(spacing: 6) {
                                Image(systemName: "chevron.left")
                                    .font(.system(size: 18, weight: .semibold))
                                Text("Back")
                                    .font(.system(size: 14, weight: .medium))
                            }
                            .foregroundStyle(.primary)
                        }
                        Spacer()
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, geo.safeAreaInsets.top + 8)

                    Text("Settings")
                        .font(.system(size: 28, weight: .bold))
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.horizontal, 20)
                        .padding(.bottom, 8)

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
            }
            .navigationTitle("Settings")
            .toolbar(.hidden, for: .navigationBar)
        }
    }
}

