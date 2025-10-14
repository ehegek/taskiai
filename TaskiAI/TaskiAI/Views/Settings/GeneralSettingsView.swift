import SwiftUI

struct GeneralSettingsView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var notificationsEnabled = true
    @State private var soundEnabled = true
    @AppStorage("app.theme") private var selectedTheme = "System"
    
    var body: some View {
        GeometryReader { geo in
            ZStack {
                Color(.systemBackground)
                
                VStack(spacing: 0) {
                    Spacer()
                        .frame(height: 60)
                    
                    Form {
                        Section("Appearance") {
                            Picker("Theme", selection: $selectedTheme) {
                                Text("System").tag("System")
                                Text("Light").tag("Light")
                                Text("Dark").tag("Dark")
                            }
                        }
                        
                        Section("Notifications") {
                            Toggle("Enable Notifications", isOn: $notificationsEnabled)
                            Toggle("Sound", isOn: $soundEnabled)
                        }
                        
                        Section("App") {
                            HStack {
                                Text("Version")
                                Spacer()
                                Text("1.0.0")
                                    .foregroundStyle(.secondary)
                            }
                        }
                    }
                }
                
                // Header at top
                VStack(spacing: 0) {
                    HStack {
                        Button { dismiss() } label: {
                            Image(systemName: "chevron.left")
                                .font(.system(size: 20, weight: .semibold))
                                .foregroundStyle(.primary)
                        }
                        Spacer()
                        Text("General")
                            .font(.system(size: 20, weight: .bold))
                        Spacer()
                        Color.clear.frame(width: 20)
                    }
                    .padding(.horizontal, 20)
                    .padding(.vertical, 12)
                    .padding(.top, geo.safeAreaInsets.top)
                    .background(Color(.systemBackground))
                    Spacer()
                }
            }
            .ignoresSafeArea()
        }
        .navigationBarHidden(true)
    }
}
