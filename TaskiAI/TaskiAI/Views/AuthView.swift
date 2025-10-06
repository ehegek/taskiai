import SwiftUI

struct AuthView: View {
    @EnvironmentObject var appState: AppState
    @State private var email = ""
    @State private var password = ""
    @State private var error: String?

    var body: some View {
        GeometryReader { geo in
            ZStack {
                LinearGradient(
                    colors: [Color(red: 0.05, green: 0.05, blue: 0.15), Color.black],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                .ignoresSafeArea(.all, edges: .all)
                
                VStack(spacing: 28) {
                    Spacer(minLength: geo.safeAreaInsets.top + 40)
                    
                    VStack(spacing: 12) {
                        Image(systemName: "person.circle.fill")
                            .font(.system(size: 70))
                            .foregroundStyle(.white)
                        
                        Text("Sign In")
                            .font(.system(size: 34, weight: .bold))
                            .foregroundStyle(.white)
                        
                        Text("Use your account to continue")
                            .font(.system(size: 16))
                            .foregroundStyle(.white.opacity(0.8))
                    }
                    .padding(.bottom, 20)
                    
                    VStack(spacing: 16) {
                        TextField("Email", text: $email)
                            .textContentType(.emailAddress)
                            .textInputAutocapitalization(.never)
                            .keyboardType(.emailAddress)
                            .font(.system(size: 17))
                            .padding(16)
                            .background(.ultraThinMaterial)
                            .cornerRadius(12)
                            .foregroundStyle(.white)
                        
                        SecureField("Password", text: $password)
                            .textContentType(.password)
                            .font(.system(size: 17))
                            .padding(16)
                            .background(.ultraThinMaterial)
                            .cornerRadius(12)
                            .foregroundStyle(.white)
                    }
                    .padding(.horizontal, 24)
                    
                    if let error {
                        Text(error)
                            .font(.system(size: 14))
                            .foregroundStyle(.red)
                            .padding(.horizontal, 24)
                    }
                    
                    VStack(spacing: 12) {
                        Button(action: signIn) {
                            Text("Continue")
                                .font(.system(size: 17, weight: .semibold))
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 16)
                                .background(Color.white)
                                .foregroundStyle(.black)
                                .cornerRadius(14)
                        }
                        
                        Button("Use admin (dev)") { adminBypass() }
                            .font(.system(size: 15))
                            .foregroundStyle(.white.opacity(0.8))
                    }
                    .padding(.horizontal, 24)
                    
                    Spacer()
                }
                .padding(.bottom, geo.safeAreaInsets.bottom + 20)
            }
        }
    }

    private func signIn() {
        // Stub: accept any non-empty credentials; real app would call backend/Sign in with Apple.
        guard !email.isEmpty, !password.isEmpty else {
            error = "Please enter email and password"
            return
        }
        withAnimation {
            appState.isAuthenticated = true
            appState.currentUserName = email.components(separatedBy: "@").first?.capitalized
        }
    }

    private func adminBypass() {
        withAnimation {
            appState.isAuthenticated = true
            appState.currentUserName = "Admin"
            appState.hasActiveSubscription = true // bypass paywall in dev
        }
    }
}
