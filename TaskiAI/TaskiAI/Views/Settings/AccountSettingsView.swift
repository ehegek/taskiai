import SwiftUI

struct AccountSettingsView: View {
    @EnvironmentObject var appState: AppState
    @Environment(\.dismiss) private var dismiss
    @State private var userName: String = ""
    @State private var email: String = ""
    @State private var phoneNumber: String = ""
    @State private var referralCodeInput: String = ""
    @State private var showReferralSuccess = false
    @State private var showReferralError = false
    
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
                                        TextField("Email", text: Binding(
                                            get: { appState.currentUserEmail ?? "" },
                                            set: { appState.currentUserEmail = $0 }
                                        ))
                                        .keyboardType(.emailAddress)
                                        .autocapitalization(.none)
                                        .disabled(true)
                                    }
                                    .padding()
                                    .background(Color(.systemGray6))
                                    
                                    Divider().padding(.leading, 20)
                                    
                                    VStack(alignment: .leading, spacing: 4) {
                                        Text("Phone Number")
                                            .font(.caption)
                                            .foregroundStyle(.secondary)
                                        TextField("Phone Number", text: Binding(
                                            get: { appState.userPhone ?? "" },
                                            set: { appState.userPhone = $0 }
                                        ))
                                        .keyboardType(.phonePad)
                                    }
                                    .padding()
                                    .background(Color(.systemGray6))
                                }
                                .background(Color(.systemGray6))
                                .cornerRadius(12)
                            }
                            
                            VStack(alignment: .leading, spacing: 8) {
                                Text("Referral System")
                                    .font(.system(size: 14, weight: .semibold))
                                    .textCase(.uppercase)
                                    .foregroundStyle(.secondary)
                                    .padding(.horizontal, 20)
                                
                                VStack(spacing: 0) {
                                    HStack {
                                        VStack(alignment: .leading, spacing: 4) {
                                            Text("Your Referral Code")
                                                .font(.caption)
                                                .foregroundStyle(.secondary)
                                            Text(appState.referralCode ?? "Loading...")
                                                .font(.system(size: 18, weight: .bold, design: .monospaced))
                                        }
                                        Spacer()
                                        Button {
                                            if let code = appState.referralCode {
                                                UIPasteboard.general.string = code
                                            }
                                        } label: {
                                            Image(systemName: "doc.on.doc")
                                                .foregroundStyle(.blue)
                                        }
                                    }
                                    .padding()
                                    .background(Color(.systemGray6))
                                    
                                    Divider().padding(.leading, 20)
                                    
                                    HStack {
                                        Text("Referrals Made")
                                        Spacer()
                                        Text("\(appState.referralCount)")
                                            .font(.system(size: 17, weight: .semibold))
                                            .foregroundStyle(.green)
                                    }
                                    .padding()
                                    .background(Color(.systemGray6))
                                    
                                    Divider().padding(.leading, 20)
                                    
                                    VStack(alignment: .leading, spacing: 8) {
                                        Text("Have a referral code?")
                                            .font(.caption)
                                            .foregroundStyle(.secondary)
                                        HStack {
                                            TextField("Enter code", text: $referralCodeInput)
                                                .textInputAutocapitalization(.characters)
                                            Button("Apply") {
                                                _Concurrency.Task {
                                                    let success = await appState.applyReferralCode(referralCodeInput)
                                                    if success {
                                                        showReferralSuccess = true
                                                        referralCodeInput = ""
                                                    } else {
                                                        showReferralError = true
                                                    }
                                                }
                                            }
                                            .disabled(referralCodeInput.isEmpty)
                                        }
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
                                        HStack(spacing: 8) {
                                            Text("🔥")
                                                .font(.system(size: 24))
                                            Text("Streak")
                                        }
                                        Spacer()
                                        Text("\(appState.streakDays) days")
                                            .font(.system(size: 17, weight: .semibold))
                                            .foregroundStyle(.orange)
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
