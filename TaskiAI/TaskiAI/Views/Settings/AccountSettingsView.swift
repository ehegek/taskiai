import SwiftUI

struct AccountSettingsView: View {
    @EnvironmentObject var appState: AppState
    @Environment(\.dismiss) private var dismiss
    @State private var userName: String = ""
    @State private var email: String = ""
    
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
                            Text("Account")
                                .font(.system(size: 20, weight: .bold))
                            Spacer()
                            Color.clear.frame(width: 20)
                        }
                        .padding(.horizontal, 20)
                        .padding(.vertical, 12)
                        
                        VStack(spacing: 20) {
                            VStack(alignment: .leading, spacing: 8) {
                                Text("Profile")
                                    .font(.system(size: 14, weight: .semibold))
                                    .textCase(.uppercase)
                                    .foregroundStyle(.secondary)
                                    .padding(.horizontal, 20)
                                
                                VStack(spacing: 0) {
                                    VStack(alignment: .leading, spacing: 4) {
                                        Text("Name")
                                            .font(.caption)
                                            .foregroundStyle(.secondary)
                                        TextField("Name", text: Binding(
                                            get: { appState.currentUserName ?? "" },
                                            set: { appState.currentUserName = $0 }
                                        ))
                                    }
                                    .padding()
                                    .background(Color(.systemGray6))
                                    
                                    Divider().padding(.leading, 20)
                                    
                                    VStack(alignment: .leading, spacing: 4) {
                                        Text("Email")
                                            .font(.caption)
                                            .foregroundStyle(.secondary)
                                        TextField("Email", text: $email)
                                            .keyboardType(.emailAddress)
                                            .autocapitalization(.none)
                                    }
                                    .padding()
                                    .background(Color(.systemGray6))
                                }
                                .background(Color(.systemGray6))
                                .cornerRadius(12)
                            }
                            
                            VStack(alignment: .leading, spacing: 8) {
                                Text("Stats")
                                    .font(.system(size: 14, weight: .semibold))
                                    .textCase(.uppercase)
                                    .foregroundStyle(.secondary)
                                    .padding(.horizontal, 20)
                                
                                VStack(spacing: 0) {
                                    HStack {
                                        Text("Streak")
                                        Spacer()
                                        Text("\(appState.streakDays) days")
                                            .foregroundStyle(.secondary)
                                    }
                                    .padding()
                                    .background(Color(.systemGray6))
                                    
                                    Divider().padding(.leading, 20)
                                    
                                    HStack {
                                        Text("Referral Code")
                                        Spacer()
                                        Text(appState.referralCode ?? "None")
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
