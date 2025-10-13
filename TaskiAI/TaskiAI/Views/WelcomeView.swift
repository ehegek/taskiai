import SwiftUI

struct WelcomeView: View {
    @EnvironmentObject var appState: AppState
    @State private var showSignIn = false
    @State private var showPrivacyPolicy = false
    @State private var showTermsOfService = false
    
    var body: some View {
        NavigationStack {
            GeometryReader { geo in
                ZStack {
                    // Black background
                    Color.black
                        .ignoresSafeArea()
                
                // Content
                VStack(spacing: 0) {
                    Spacer()
                        .frame(height: geo.safeAreaInsets.top + 20)
                    
                    // App logo/title
                    VStack(spacing: 20) {
                        Image("app_logo")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 120, height: 120)
                            .shadow(color: .white.opacity(0.4), radius: 20)
                        
                        Text("Welcome to")
                            .font(.system(size: 20, weight: .regular))
                            .foregroundStyle(.white.opacity(0.7))
                        
                        Text("TASKI AI")
                            .font(.system(size: 48, weight: .heavy, design: .rounded))
                            .foregroundStyle(.white)
                            .tracking(2)
                        
                        Text("Never Miss a Task")
                            .font(.system(size: 18, weight: .regular))
                            .foregroundStyle(.white.opacity(0.6))
                    }
                    .padding(.bottom, 50)
                    
                    // 3 Notification Cards
                    VStack(spacing: 12) {
                        notificationCard(
                            icon: "checkmark.circle.fill",
                            iconColor: .white,
                            backgroundColor: Color(white: 0.25),
                            title: "TaskiAI",
                            subtitle: "2 Hours until meeting with John",
                            detail: "Task Due Soon!",
                            time: "Due at 4:00pm"
                        )
                        
                        notificationCard(
                            icon: "checkmark.circle.fill",
                            iconColor: .white,
                            backgroundColor: Color.green,
                            title: "TASKI AI",
                            subtitle: "Reminder For Math Homework Due at 11:59 PM",
                            detail: nil,
                            time: "now"
                        )
                        
                        notificationCard(
                            icon: "envelope.fill",
                            iconColor: .red,
                            backgroundColor: Color.white,
                            title: "TASKI AI",
                            subtitle: "This is your reminder for your homework due at 11:59PM for Calc...",
                            detail: "Reminder For Homework Due at 11:59 Calc",
                            time: "now"
                        )
                    }
                    .padding(.horizontal, 20)
                    
                    Spacer()
                    
                    // Start Now button
                    Button {
                        withAnimation(.easeInOut) {
                            appState.hasSeenWelcome = true
                        }
                    } label: {
                        HStack {
                            Text("Get Started")
                                .font(.system(size: 18, weight: .bold))
                            Image(systemName: "arrow.right")
                                .font(.system(size: 16, weight: .bold))
                        }
                        .foregroundStyle(.black)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 18)
                        .background(Color.white)
                        .clipShape(RoundedRectangle(cornerRadius: 16))
                        .shadow(color: .white.opacity(0.3), radius: 15, y: 8)
                    }
                    .padding(.horizontal, 32)
                    
                    // Already have account text
                    Button {
                        showSignIn = true
                    } label: {
                        HStack(spacing: 4) {
                            Text("Already have an account?")
                                .foregroundStyle(.white.opacity(0.7))
                            Text("Sign In")
                                .foregroundStyle(.white)
                                .fontWeight(.semibold)
                        }
                        .font(.system(size: 14))
                    }
                    .padding(.top, 16)
                    
                    // Terms and Privacy text
                    HStack(spacing: 4) {
                        Text("By continuing, you agree to our")
                            .foregroundStyle(.white.opacity(0.5))
                            .font(.system(size: 11))
                        
                        Button {
                            showTermsOfService = true
                        } label: {
                            Text("Terms of Service")
                                .foregroundStyle(.white)
                                .fontWeight(.semibold)
                                .font(.system(size: 11))
                        }
                        
                        Text("and")
                            .foregroundStyle(.white.opacity(0.5))
                            .font(.system(size: 11))
                        
                        Button {
                            showPrivacyPolicy = true
                        } label: {
                            Text("Privacy Policy")
                                .foregroundStyle(.white)
                                .fontWeight(.semibold)
                                .font(.system(size: 11))
                        }
                    }
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 40)
                    .padding(.top, 24)
                    
                    Spacer()
                        .frame(height: geo.safeAreaInsets.bottom + 20)
                }
            }
            .navigationDestination(isPresented: $showSignIn) {
                AuthView()
            }
            .navigationDestination(isPresented: $showPrivacyPolicy) {
                PrivacyPolicyView()
            }
            .navigationDestination(isPresented: $showTermsOfService) {
                TermsOfServiceView()
            }
        }
        .edgesIgnoringSafeArea(.all)
        .statusBar(hidden: true)
        }
    }
    
    private func notificationCard(
        icon: String,
        iconColor: Color,
        backgroundColor: Color,
        title: String,
        subtitle: String,
        detail: String?,
        time: String
    ) -> some View {
        HStack(spacing: 12) {
            // Icon with app logo overlay
            ZStack {
                Circle()
                    .fill(backgroundColor)
                    .frame(width: 50, height: 50)
                
                Image("app_logo")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 32, height: 32)
            }
            
            // Content
            VStack(alignment: .leading, spacing: 4) {
                HStack {
                    Text(title)
                        .font(.system(size: 14, weight: .semibold))
                        .foregroundStyle(.white)
                    Spacer()
                    Text(time)
                        .font(.system(size: 12))
                        .foregroundStyle(.white.opacity(0.7))
                }
                
                if let detail = detail {
                    Text(detail)
                        .font(.system(size: 13, weight: .medium))
                        .foregroundStyle(.white)
                }
                
                Text(subtitle)
                    .font(.system(size: 12))
                    .foregroundStyle(.white.opacity(0.9))
                    .lineLimit(2)
            }
        }
        .padding(14)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color.black.opacity(0.75))
                .shadow(color: .black.opacity(0.3), radius: 8, y: 4)
        )
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(Color.white.opacity(0.3), lineWidth: 1.5)
        )
    }
}

#Preview {
    WelcomeView()
        .environmentObject(AppState())
}
