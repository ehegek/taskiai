import SwiftUI

struct AuthView: View {
    @EnvironmentObject var appState: AppState
    @State private var email = ""
    @State private var password = ""
    @State private var error: String?

    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea(.all)
            VStack(spacing: 24) {
                VStack(spacing: 8) {
                    Text("Sign In").font(.largeTitle).bold().foregroundStyle(.white)
                    Text("Use your account to continue").foregroundStyle(.white.opacity(0.8))
                }

                VStack(spacing: 12) {
                    TextField("Email", text: $email)
                        .textContentType(.emailAddress)
                        .textInputAutocapitalization(.never)
                        .keyboardType(.emailAddress)
                        .padding()
                        .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 12))
                        .foregroundStyle(.white)
                    SecureField("Password", text: $password)
                        .textContentType(.password)
                        .padding()
                        .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 12))
                        .foregroundStyle(.white)
                }
                .padding(.horizontal)

                if let error { Text(error).foregroundStyle(.red).font(.footnote) }

                Button(action: signIn) {
                    Text("Continue").bold().frame(maxWidth: .infinity).padding()
                        .background(Color.white, in: RoundedRectangle(cornerRadius: 12))
                        .foregroundStyle(.black)
                }
                .padding(.horizontal)

                Button("Use admin (dev)") { adminBypass() }
                    .foregroundStyle(.white.opacity(0.9))

                Spacer()
            }
            .padding(.top, 80)
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
