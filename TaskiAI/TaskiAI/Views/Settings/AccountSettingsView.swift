import SwiftUI

struct AccountSettingsView: View {
    @EnvironmentObject var appState: AppState
    @Environment(\.dismiss) private var dismiss
    @State private var userName: String = ""
    @State private var email: String = ""
    
    var body: some View {
        GeometryReader { geo in
            ZStack {
                Color(.systemBackground).ignoresSafeArea()
                
                VStack(spacing: 0) {
                    Spacer()
                        .frame(height: geo.safeAreaInsets.top + 70)
                    
                    Form {
                        Section("Profile") {
                            TextField("Name", text: Binding(
                                get: { appState.currentUserName ?? "" },
                                set: { appState.currentUserName = $0 }
                            ))
                            TextField("Email", text: $email)
                                .keyboardType(.emailAddress)
                                .autocapitalization(.none)
                        }
                        
                        Section("Stats") {
                            HStack {
                                Text("Streak")
                                Spacer()
                                Text("\(appState.streakDays) days")
                                    .foregroundStyle(.secondary)
                            }
                            HStack {
                                Text("Referral Code")
                                Spacer()
                                Text(appState.referralCode ?? "None")
                                    .foregroundStyle(.secondary)
                            }
                        }
                    }
                }
                
                // Floating header
                VStack {
                    HStack {
                        Button { dismiss() } label: {
                            Image(systemName: "chevron.left")
                                .font(.system(size: 20, weight: .semibold))
                                .foregroundStyle(.primary)
                        }
                        Spacer()
                        Text("Account")
                            .font(.system(size: 20, weight: .bold))
                        Spacer()
                        Color.clear.frame(width: 20)
                    }
                    .padding(.horizontal, 20)
                    .padding(.vertical, 12)
                    .padding(.top, geo.safeAreaInsets.top + 10)
                    .background(Color(.systemBackground))
                    Spacer()
                }
            }
        }
        .navigationBarHidden(true)
    }
}
