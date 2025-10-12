import SwiftUI

struct WelcomeView: View {
    @EnvironmentObject var appState: AppState
    
    var body: some View {
        GeometryReader { geo in
            ZStack {
                // Background image covering entire screen
                Image("welcome_tab")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
                    .clipped()
                    .edgesIgnoringSafeArea(.all)
                
                // Overlay content (notifications + button + text)
                VStack(spacing: 16) {
                    Spacer()
                        .frame(height: max(geo.safeAreaInsets.top + 200, 240))
                    
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
                        Text("Start Now")
                            .font(.system(size: 25, weight: .light))
                            .foregroundStyle(.black)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 20)
                            .background(
                                RoundedRectangle(cornerRadius: 20)
                                    .fill(Color.white)
                                    .shadow(color: .black.opacity(0.25), radius: 4, y: 4)
                            )
                    }
                    .padding(.horizontal, 60)
                    
                    // Already have account text
                    Button {
                        // Sign in action (placeholder)
                    } label: {
                        Text("Already have an account? Sign In")
                            .font(.system(size: 11, weight: .regular))
                            .foregroundStyle(.white)
                            .shadow(color: .black.opacity(0.25), radius: 4, y: 4)
                    }
                    .padding(.top, 8)
                    
                    // Terms and Privacy text
                    Text("By continuing, you agree to out Terms of Use and\nHave read and agreed to our Privacy Policy")
                        .font(.system(size: 11, weight: .light))
                        .foregroundStyle(.white)
                        .multilineTextAlignment(.center)
                        .lineSpacing(2)
                        .shadow(color: .black.opacity(0.25), radius: 4, y: 4)
                        .padding(.top, 12)
                    
                    Spacer()
                        .frame(height: max(geo.safeAreaInsets.bottom + 20, 40))
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
        .padding(12)
        .background(
            RoundedRectangle(cornerRadius: 14)
                .fill(Color.black.opacity(0.6))
                .blur(radius: 20)
        )
        .overlay(
            RoundedRectangle(cornerRadius: 14)
                .stroke(Color.white.opacity(0.2), lineWidth: 1)
        )
    }
}

#Preview {
    WelcomeView()
        .environmentObject(AppState())
}
