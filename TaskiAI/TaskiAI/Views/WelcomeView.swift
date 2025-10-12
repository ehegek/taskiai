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
                
                // Overlay content (button + text)
                VStack(spacing: 16) {
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
}

#Preview {
    WelcomeView()
        .environmentObject(AppState())
}
