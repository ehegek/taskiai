import SwiftUI

struct SettingsView: View {
    var body: some View {
        List {
            Section { NavigationLink("Account") { Text("Account") }
                     NavigationLink("General") { Text("General") }
                     NavigationLink("Calendar") { Text("Calendar") } }
            Section { NavigationLink("Categories") { Text("Categories") }
                     NavigationLink("Subscriptions") { Text("Subscriptions") } }
            Section { Button("Rate 5 Stars") {} ; Button("Share with a Friend") {} ; Button("Contact Support") {} }
            Section { NavigationLink("Privacy Policy") { Text("Privacy Policy") }
                     NavigationLink("Terms of Use") { Text("Terms of Use") } }
        }
        .navigationTitle("Settings")
    }
}
