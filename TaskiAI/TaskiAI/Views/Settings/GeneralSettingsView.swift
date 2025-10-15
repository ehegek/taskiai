import SwiftUI

struct GeneralSettingsView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var notificationsEnabled = true
    @State private var soundEnabled = true
    @AppStorage("app.theme") private var selectedTheme = "System"
    
    var body: some View {
        ZStack {
            Color(.systemBackground).ignoresSafeArea()
            
            GeometryReader { geo in
                ScrollView {
                    VStack(spacing: 0) {
                        Spacer()
                            .frame(height: geo.safeAreaInsets.top)
                        
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
                        
                        VStack(spacing: 20) {
                            VStack(alignment: .leading, spacing: 8) {
                                Text("Appearance")
                                    .font(.system(size: 14, weight: .semibold))
                                    .textCase(.uppercase)
                                    .foregroundStyle(.secondary)
                                    .padding(.horizontal, 20)
                                
                                VStack(spacing: 0) {
                                    Picker("Theme", selection: $selectedTheme) {
                                        Text("System").tag("System")
                                        Text("Light").tag("Light")
                                        Text("Dark").tag("Dark")
                                    }
                                    .padding()
                                    .background(Color(.systemGray6))
                                }
                                .background(Color(.systemGray6))
                                .cornerRadius(12)
                            }
                            
                            VStack(alignment: .leading, spacing: 8) {
                                Text("Notifications")
                                    .font(.system(size: 14, weight: .semibold))
                                    .textCase(.uppercase)
                                    .foregroundStyle(.secondary)
                                    .padding(.horizontal, 20)
                                
                                VStack(spacing: 0) {
                                    Toggle("Enable Notifications", isOn: $notificationsEnabled)
                                        .padding()
                                        .background(Color(.systemGray6))
                                    
                                    Divider().padding(.leading, 20)
                                    
                                    Toggle("Sound", isOn: $soundEnabled)
                                        .padding()
                                        .background(Color(.systemGray6))
                                }
                                .background(Color(.systemGray6))
                                .cornerRadius(12)
                            }
                            
                            VStack(alignment: .leading, spacing: 8) {
                                Text("App")
                                    .font(.system(size: 14, weight: .semibold))
                                    .textCase(.uppercase)
                                    .foregroundStyle(.secondary)
                                    .padding(.horizontal, 20)
                                
                                VStack(spacing: 0) {
                                    HStack {
                                        Text("Version")
                                        Spacer()
                                        Text("1.0.0")
                                            .foregroundStyle(.secondary)
                                    }
                                    .padding()
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
