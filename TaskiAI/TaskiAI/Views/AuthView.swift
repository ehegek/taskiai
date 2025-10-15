import SwiftUI
import AuthenticationServices

struct AuthView: View {
    @EnvironmentObject var appState: AppState
    @State private var email = ""
    @State private var password = ""
    @State private var isSignUp = false
    @State private var error: String?
    @State private var isLoading = false

    var body: some View {
        GeometryReader { geo in
            ZStack {
                Color.black.ignoresSafeArea(.all, edges: .all)
                
                VStack(spacing: 28) {
                    Spacer(minLength: geo.safeAreaInsets.top + 40)
                    
                    VStack(spacing: 12) {
                        Text(isSignUp ? "Create Account" : "Sign In")
                            .font(.system(size: 34, weight: .bold))
                            .foregroundStyle(.white)
                        Text(isSignUp ? "Join TaskiAI to get started" : "Use your account to continue")
                            .font(.system(size: 15))
                            .foregroundStyle(.white.opacity(0.7))
                    }
                    .padding(.bottom, 20)
                    
                    VStack(spacing: 16) {
                        TextField("Email", text: $email)
                            .textContentType(.emailAddress)
                            .textInputAutocapitalization(.never)
                            .keyboardType(.emailAddress)
                            .font(.system(size: 17))
                            .padding(16)
                            .background(Color.white.opacity(0.1))
                            .cornerRadius(18)
                            .foregroundStyle(.white)
                        
                        SecureField("Password", text: $password)
                            .textContentType(isSignUp ? .newPassword : .password)
                            .font(.system(size: 17))
                            .padding(16)
                            .background(Color.white.opacity(0.1))
                            .cornerRadius(18)
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
                        Button(action: { _Concurrency.Task { await signInWithEmail() }}) {
                            HStack {
                                if isLoading {
                                    ProgressView()
                                        .tint(.black)
                                } else {
                                    Text(isSignUp ? "Sign Up" : "Sign In")
                                        .font(.system(size: 17, weight: .semibold))
                                }
                            }
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 16)
                            .background(Color.white)
                            .foregroundStyle(.black)
                            .cornerRadius(18)
                        }
                        .disabled(isLoading)
                        
                        // Sign in with Apple button
                        SignInWithAppleButton(
                            onRequest: { request in
                                request.requestedScopes = [.email, .fullName]
                            },
                            onCompletion: { result in
                                _Concurrency.Task {
                                    await handleAppleSignIn(result)
                                }
                            }
                        )
                        .signInWithAppleButtonStyle(.white)
                        .frame(height: 50)
                        .cornerRadius(18)
                        .padding(.horizontal, 24)
                        
                        // Toggle Sign In / Sign Up
                        Button {
                            withAnimation {
                                isSignUp.toggle()
                                error = nil
                            }
                        } label: {
                            HStack(spacing: 4) {
                                Text(isSignUp ? "Already have an account?" : "Don't have an account?")
                                    .foregroundStyle(.white.opacity(0.7))
                                Text(isSignUp ? "Sign In" : "Sign Up")
                                    .foregroundStyle(.white)
                                    .fontWeight(.semibold)
                            }
                            .font(.system(size: 14))
                        }
                        .padding(.top, 8)
                        
                        Button("Use admin (dev)") { adminBypass() }
                            .font(.system(size: 13))
                            .foregroundStyle(.white.opacity(0.5))
                    }
                    .padding(.horizontal, 24)
                    
                    Spacer()
                }
                .padding(.bottom, geo.safeAreaInsets.bottom + 20)
            }
        }
    }

    private func signInWithEmail() async {
        guard !email.isEmpty, !password.isEmpty else {
            error = "Please enter email and password"
            return
        }
        
        await MainActor.run { isLoading = true }
        
        do {
            #if canImport(FirebaseAuth)
            let user = try await (isSignUp
                ? FirebaseAuthService.shared.signUp(email: email, password: password)
                : FirebaseAuthService.shared.signIn(email: email, password: password))
            
            if isSignUp, let userId = user as? String ?? (user as AnyObject).value(forKey: "uid") as? String {
                try await FirestoreService.shared.createUser(
                    userId: userId,
                    email: email,
                    name: email.components(separatedBy: "@").first
                )
            }
            
            if let userId = user as? String ?? (user as AnyObject).value(forKey: "uid") as? String {
                try await appState.loadUserDataFromFirestore(userId: userId)
                
                await MainActor.run {
                    appState.currentUserId = userId
                    appState.currentUserEmail = email
                    appState.currentUserName = email.components(separatedBy: "@").first?.capitalized
                    appState.isAuthenticated = true
                    isLoading = false
                }
            }
            #else
            // Fallback when Firebase is not available - use mock auth
            await MainActor.run {
                appState.currentUserId = "local-\(UUID().uuidString)"
                appState.currentUserEmail = email
                appState.currentUserName = email.components(separatedBy: "@").first?.capitalized
                appState.isAuthenticated = true
                isLoading = false
            }
            #endif
        } catch {
            await MainActor.run {
                self.error = error.localizedDescription
                isLoading = false
            }
        }
    }
    
    private func handleAppleSignIn(_ result: Result<ASAuthorization, Error>) async {
        await MainActor.run { isLoading = true }
        
        switch result {
        case .success(let authorization):
            guard let credential = authorization.credential as? ASAuthorizationAppleIDCredential else {
                await MainActor.run {
                    error = "Invalid Apple credential"
                    isLoading = false
                }
                return
            }
            
            do {
                #if canImport(FirebaseAuth)
                let user = try await FirebaseAuthService.shared.signInWithApple(credential: credential)
                
                if let userId = user as? String ?? (user as AnyObject).value(forKey: "uid") as? String {
                    // Check if user exists in Firestore, if not create
                    if try await FirestoreService.shared.getUser(userId: userId) == nil {
                        let userEmail = (user as AnyObject).value(forKey: "email") as? String
                        try await FirestoreService.shared.createUser(
                            userId: userId,
                            email: userEmail,
                            name: credential.fullName?.givenName
                        )
                    }
                    
                    try await appState.loadUserDataFromFirestore(userId: userId)
                    
                    await MainActor.run {
                        appState.currentUserId = userId
                        appState.currentUserEmail = (user as AnyObject).value(forKey: "email") as? String
                        appState.currentUserName = credential.fullName?.givenName ?? "User"
                        appState.isAuthenticated = true
                        isLoading = false
                    }
                }
                #else
                // Fallback when Firebase is not available
                await MainActor.run {
                    appState.currentUserId = "apple-\(UUID().uuidString)"
                    appState.currentUserEmail = credential.email
                    appState.currentUserName = credential.fullName?.givenName ?? "User"
                    appState.isAuthenticated = true
                    isLoading = false
                }
                #endif
            } catch {
                await MainActor.run {
                    self.error = error.localizedDescription
                    isLoading = false
                }
            }
            
        case .failure(let error):
            await MainActor.run {
                self.error = error.localizedDescription
                isLoading = false
            }
        }
    }

    private func adminBypass() {
        withAnimation {
            appState.currentUserId = "admin-dev-id"
            appState.isAuthenticated = true
            appState.currentUserName = "Admin"
            appState.currentUserEmail = "admin@taskiai.dev"
            appState.hasActiveSubscription = true // bypass paywall in dev
        }
    }
}
