import SwiftUI

struct WelcomeView: View {
    @EnvironmentObject var appState: AppState
    
    var body: some View {
        GeometryReader { geo in
            ZStack {
                // Modern gradient background
                LinearGradient(
                    colors: [
                        Color(red: 0.1, green: 0.1, blue: 0.15),
                        Color.black
                    ],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                .ignoresSafeArea()
                
                // Content
                VStack(spacing: 0) {
                    Spacer()
                        .frame(height: geo.safeAreaInsets.top + 40)
                    
                    // App logo/title
                    VStack(spacing: 12) {
                        Image(systemName: "checkmark.seal.fill")
                            .font(.system(size: 70))
                            .foregroundStyle(
                                LinearGradient(
                                    colors: [.blue, .cyan],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                )
                            )
                            .shadow(color: .blue.opacity(0.5), radius: 20)
                        
                        Text("TASKI AI")
                            .font(.system(size: 42, weight: .black, design: .rounded))
                            .foregroundStyle(.white)
                            .tracking(3)
                        
                        Text("Never Miss a Task")
                            .font(.system(size: 16, weight: .medium))
                            .foregroundStyle(.white.opacity(0.7))
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
                        .foregroundStyle(.white)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 18)
                        .background(
                            LinearGradient(
                                colors: [.blue, .cyan],
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                        )
                        .clipShape(RoundedRectangle(cornerRadius: 16))
                        .shadow(color: .blue.opacity(0.5), radius: 15, y: 8)
                    }
                    .padding(.horizontal, 32)
                    
                    // Already have account text
                    Button {
                        // Sign in action (placeholder)
                    } label: {
                        HStack(spacing: 4) {
                            Text("Already have an account?")
                                .foregroundStyle(.white.opacity(0.7))
                            Text("Sign In")
                                .foregroundStyle(.blue)
                                .fontWeight(.semibold)
                        }
                        .font(.system(size: 14))
                    }
                    .padding(.top, 16)
                    
                    // Terms and Privacy text
                    (Text("By continuing, you agree to our ")
                        .foregroundStyle(.white.opacity(0.5))
                    +
                    Text("Terms of Service")
                        .foregroundStyle(.blue)
                        .fontWeight(.semibold)
                    +
                    Text(" and ")
                        .foregroundStyle(.white.opacity(0.5))
                    +
                    Text("Privacy Policy")
                        .foregroundStyle(.blue)
                        .fontWeight(.semibold))
                    .font(.system(size: 11))
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 40)
                    .padding(.top, 24)
                    
                    Spacer()
                        .frame(height: geo.safeAreaInsets.bottom + 30)
                }
            }
        }
        .edgesIgnoringSafeArea(.all)
        .statusBar(hidden: true)
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
            // Icon
            ZStack {
                Circle()
                    .fill(backgroundColor)
                    .frame(width: 40, height: 40)
                Image(systemName: icon)
                    .font(.system(size: 20))
                    .foregroundStyle(iconColor)
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
