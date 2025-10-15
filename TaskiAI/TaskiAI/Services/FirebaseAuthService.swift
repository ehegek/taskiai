import Foundation
// TODO: Add Firebase SDK via SPM, then uncomment these imports
// import FirebaseAuth
// import FirebaseCore
import AuthenticationServices

#if canImport(FirebaseAuth)
import FirebaseAuth
#endif

#if canImport(FirebaseAuth)
final class FirebaseAuthService: ObservableObject {
    static let shared = FirebaseAuthService()
    
    @Published var currentUser: User?
    @Published var isAuthenticated = false
    
    private init() {
        // Listen to auth state changes
        Auth.auth().addStateDidChangeListener { [weak self] _, user in
            self?.currentUser = user
            self?.isAuthenticated = user != nil
        }
    }
    
    // MARK: - Email/Password Authentication
    
    func signUp(email: String, password: String) async throws -> User {
        let result = try await Auth.auth().createUser(withEmail: email, password: password)
        return result.user
    }
    
    func signIn(email: String, password: String) async throws -> User {
        let result = try await Auth.auth().signIn(withEmail: email, password: password)
        return result.user
    }
    
    // MARK: - Apple Sign In
    
    func signInWithApple(credential: ASAuthorizationAppleIDCredential) async throws -> User {
        guard let token = credential.identityToken,
              let tokenString = String(data: token, encoding: .utf8) else {
            throw NSError(domain: "FirebaseAuth", code: -1, userInfo: [NSLocalizedDescriptionKey: "Unable to fetch identity token"])
        }
        
        let oAuthCredential = OAuthProvider.credential(
            withProviderID: "apple.com",
            idToken: tokenString,
            rawNonce: nil
        )
        
        let result = try await Auth.auth().signIn(with: oAuthCredential)
        return result.user
    }
    
    // MARK: - Password Reset
    
    func resetPassword(email: String) async throws {
        try await Auth.auth().sendPasswordReset(withEmail: email)
    }
    
    // MARK: - Sign Out
    
    func signOut() throws {
        try Auth.auth().signOut()
    }
    
    // MARK: - User Info
    
    var currentUserId: String? {
        return currentUser?.uid
    }
    
    var currentUserEmail: String? {
        return currentUser?.email
    }
}
#else
// Stub implementation when Firebase is not available
final class FirebaseAuthService: ObservableObject {
    static let shared = FirebaseAuthService()
    @Published var currentUser: Any?
    @Published var isAuthenticated = false
    private init() {}
    func signUp(email: String, password: String) async throws -> Any { throw NSError(domain: "Firebase", code: -1) }
    func signIn(email: String, password: String) async throws -> Any { throw NSError(domain: "Firebase", code: -1) }
    func signInWithApple(credential: ASAuthorizationAppleIDCredential) async throws -> Any { throw NSError(domain: "Firebase", code: -1) }
    func resetPassword(email: String) async throws {}
    func signOut() throws {}
    var currentUserId: String? { return nil }
    var currentUserEmail: String? { return nil }
}
#endif
