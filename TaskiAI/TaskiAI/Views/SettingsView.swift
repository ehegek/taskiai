import SwiftUI

struct SettingsView: View {
    @EnvironmentObject var appState: AppState
    var body: some View {
        ZStack {
            Color(.systemBackground).ignoresSafeArea(.all)
            List {
                Section { NavigationLink("Account") { Text("Account") }
                         NavigationLink("General") { Text("General") }
                         NavigationLink("Calendar") { Text("Calendar") } }
                Section { NavigationLink("Categories") { Text("Categories") }
                         NavigationLink("Subscriptions") { Text("Subscriptions") } }
                Section { Button("Rate 5 Stars") {} ; Button("Share with a Friend") {} ; Button("Contact Support") {} }
                Section { NavigationLink("Privacy Policy") { Text("Privacy Policy") }
                         NavigationLink("Terms of Use") { Text("Terms of Use") } }
                Section("Developer") {
                    Button("Sign Out") { appState.signOut() }
                    Button("Reset Onboarding & Subscription") { appState.resetAll() }
                }
            }
            .listStyle(.insetGrouped)
            .scrollContentBackground(.hidden)
        }
        .navigationTitle("Settings")
    }
}
