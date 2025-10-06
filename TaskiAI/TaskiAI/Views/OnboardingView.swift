import SwiftUI

struct OnboardingView: View {
    @EnvironmentObject var appState: AppState
    @State private var page = 0

    var body: some View {
        TabView(selection: $page) {
            welcome.tag(0)
            painPoint(icon: "person.crop.circle.badge.exclamationmark", title: "Disorganization is a silent killer", desc: "Missed tasks and forgotten deadlines compound over time.").tag(1)
            painPoint(icon: "brain.head.profile", title: "Without accountability, goals die", desc: "We break promises to ourselves without systems.").tag(2)
            painPoint(icon: "chart.line.downtrend.xyaxis", title: "Unfinished tasks kill potential", desc: "Lost opportunities compound.").tag(3)
            justification.tag(4)
            value(icon: "lock.fill", title: "Avoid setbacks", desc: "Overnight app protection keeps you on track.").tag(5)
            value(icon: "flag.checkered", title: "Conquer yourself", desc: "Focus and complete tasks with intention.").tag(6)
            value(icon: "brain.filled.head.profile", title: "Rewire your brain", desc: "Turn procrastination into action.").tag(7)
            socialProof.tag(8)
            referral.tag(9)
        }
        .tabViewStyle(.page(indexDisplayMode: .never))
        .ignoresSafeArea(.all, edges: .all)
    }

    // MARK: - Pages
    private var welcome: some View {
        GeometryReader { geo in
            ZStack {
                Color.black.ignoresSafeArea(.all, edges: .all)
                VStack(spacing: 20) {
                    Spacer(minLength: geo.safeAreaInsets.top + 20)
                    
                    Image("Orange_Minimalist_Travel_App_Business_Logo-removebg-preview 2")
                        .resizable().scaledToFit().frame(width: 100, height: 100)
                    
                    Text("Welcome To TASKI AI")
                        .font(.system(size: 32, weight: .bold))
                        .foregroundStyle(.white)
                        .multilineTextAlignment(.center)
                    
                    Text("Never Miss a Task")
                        .font(.system(size: 18))
                        .foregroundStyle(.white.opacity(0.9))
                    
                    HStack(spacing: 12) {
                        Image("Rectangle 89").resizable().scaledToFit().frame(height: 140)
                        Image("Rectangle 89").resizable().scaledToFit().frame(height: 140)
                        Image("Rectangle 89").resizable().scaledToFit().frame(height: 140)
                    }
                    .padding(.horizontal, 20)
                    .padding(.vertical, 10)
                    
                    Spacer(minLength: 20)
                    
                    VStack(spacing: 14) {
                        Button { next() } label: {
                            Text("Start Now")
                                .font(.system(size: 17, weight: .semibold))
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 16)
                                .background(Color.white)
                                .foregroundStyle(.black)
                                .cornerRadius(14)
                        }
                        
                        Button { appState.hasCompletedOnboarding = true; appState.isAuthenticated = false } label: {
                            Text("Already have an account? Sign In")
                                .font(.system(size: 15))
                        }
                        .foregroundStyle(.white.opacity(0.9))
                        
                        Button { } label: {
                            Text("Privacy Policy")
                                .font(.system(size: 13))
                        }
                        .foregroundStyle(.white.opacity(0.7))
                    }
                    .padding(.horizontal, 24)
                    .padding(.bottom, geo.safeAreaInsets.bottom + 20)
                }
            }
        }
    }

    private func painPoint(icon: String, title: String, desc: String) -> some View {
        GeometryReader { geo in
            ZStack {
                Color(red: 0.98, green: 0.25, blue: 0.24).ignoresSafeArea(.all, edges: .all)
                VStack(spacing: 20) {
                    Spacer(minLength: geo.safeAreaInsets.top + 40)
                    
                    Image("\(title)")
                        .resizable().scaledToFit()
                        .frame(height: 160)
                        .padding(.horizontal, 20)
                    
                    Text(title)
                        .font(.system(size: 28, weight: .bold))
                        .foregroundStyle(.white)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 24)
                    
                    Text(desc)
                        .font(.system(size: 17))
                        .foregroundStyle(.white.opacity(0.9))
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 24)
                    
                    Spacer(minLength: 40)
                    
                    Button { next() } label: {
                        Text("Continue")
                            .font(.system(size: 17, weight: .semibold))
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 16)
                            .background(Color.white)
                            .foregroundStyle(.black)
                            .cornerRadius(14)
                    }
                    .padding(.horizontal, 24)
                    .padding(.bottom, geo.safeAreaInsets.bottom + 20)
                }
            }
        }
    }

    private var justification: some View {
        GeometryReader { geo in
            ZStack {
                Color(red: 0.12, green: 0.44, blue: 0.84).ignoresSafeArea(.all, edges: .all)
                VStack(spacing: 20) {
                    Spacer(minLength: geo.safeAreaInsets.top + 40)
                    
                    Image("Path to Completion")
                        .resizable().scaledToFit()
                        .frame(height: 170)
                        .padding(.horizontal, 20)
                    
                    Text("Retrain your brain and focus on what matters.")
                        .font(.system(size: 20, weight: .medium))
                        .foregroundStyle(.white.opacity(0.95))
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 24)
                    
                    Text("Where we help >>>")
                        .font(.system(size: 18, weight: .semibold))
                        .foregroundStyle(.white)
                        .padding(.top, 10)
                    
                    Spacer()
                    
                    Button { next() } label: {
                        Text("Continue")
                            .font(.system(size: 17, weight: .semibold))
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 16)
                            .background(Color.white)
                            .foregroundStyle(.black)
                            .cornerRadius(14)
                    }
                    .padding(.horizontal, 24)
                    .padding(.bottom, geo.safeAreaInsets.bottom + 20)
                }
            }
        }
    }

    private func value(icon: String, title: String, desc: String) -> some View {
        GeometryReader { geo in
            ZStack {
                Color.black.ignoresSafeArea(.all, edges: .all)
                VStack(spacing: 20) {
                    Spacer(minLength: geo.safeAreaInsets.top + 40)
                    
                    Image(title)
                        .resizable().scaledToFit()
                        .frame(height: 160)
                        .padding(.horizontal, 20)
                    
                    Text(title)
                        .font(.system(size: 28, weight: .bold))
                        .foregroundStyle(.white)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 24)
                    
                    Text(desc)
                        .font(.system(size: 17))
                        .foregroundStyle(.white.opacity(0.9))
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 24)
                    
                    Spacer()
                    
                    Button { next() } label: {
                        Text("Continue")
                            .font(.system(size: 17, weight: .semibold))
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 16)
                            .background(Color.white)
                            .foregroundStyle(.black)
                            .cornerRadius(14)
                    }
                    .padding(.horizontal, 24)
                    .padding(.bottom, geo.safeAreaInsets.bottom + 20)
                }
            }
        }
    }

    private var socialProof: some View {
        GeometryReader { geo in
            ZStack {
                Color.black.ignoresSafeArea(.all, edges: .all)
                ScrollView {
                    VStack(spacing: 16) {
                        Spacer(minLength: geo.safeAreaInsets.top + 20)
                        
                        Text("What others have to say about us...")
                            .font(.system(size: 24, weight: .bold))
                            .foregroundStyle(.white)
                            .multilineTextAlignment(.center)
                            .padding(.horizontal, 24)
                            .padding(.top, 20)
                        
                        ForEach(0..<4) { idx in
                            HStack(alignment: .top, spacing: 12) {
                                Image(systemName: "person.circle.fill")
                                    .font(.system(size: 40))
                                    .foregroundStyle(.white)
                                
                                VStack(alignment: .leading, spacing: 6) {
                                    HStack(spacing: 4) {
                                        ForEach(0..<5) { _ in
                                            Image(systemName: "star.fill")
                                                .font(.system(size: 14))
                                                .foregroundStyle(.yellow)
                                        }
                                    }
                                    Text("Great app! Helped me get organized.")
                                        .font(.system(size: 15))
                                        .foregroundStyle(.white)
                                    Text("User \(idx + 1)")
                                        .font(.system(size: 13))
                                        .foregroundStyle(.white.opacity(0.7))
                                }
                                Spacer()
                            }
                            .padding(16)
                            .background(.ultraThinMaterial)
                            .cornerRadius(12)
                        }
                        
                        Spacer(minLength: 20)
                        
                        Button { next() } label: {
                            Text("Continue")
                                .font(.system(size: 17, weight: .semibold))
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 16)
                                .background(Color.white)
                                .foregroundStyle(.black)
                                .cornerRadius(14)
                        }
                        .padding(.bottom, geo.safeAreaInsets.bottom + 20)
                    }
                    .padding(.horizontal, 24)
                }
            }
        }
    }

    private var referral: some View {
        GeometryReader { geo in
            ZStack {
                LinearGradient(
                    colors: [Color(red: 0.1, green: 0.1, blue: 0.2), Color.black],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                .ignoresSafeArea(.all, edges: .all)
                
                VStack(spacing: 24) {
                    Spacer(minLength: geo.safeAreaInsets.top + 40)
                    
                    VStack(spacing: 12) {
                        Image(systemName: "gift.fill")
                            .font(.system(size: 60))
                            .foregroundStyle(.white)
                        
                        Text("Have a Referral Code?")
                            .font(.system(size: 28, weight: .bold))
                            .foregroundStyle(.white)
                            .multilineTextAlignment(.center)
                        
                        Text("Enter it below to unlock special benefits")
                            .font(.system(size: 16))
                            .foregroundStyle(.white.opacity(0.8))
                            .multilineTextAlignment(.center)
                    }
                    .padding(.horizontal, 24)
                    
                    VStack(spacing: 16) {
                        TextField("Referral code", text: Binding(
                            get: { appState.referralCode ?? "" },
                            set: { appState.referralCode = $0 }
                        ))
                        .font(.system(size: 17))
                        .padding(16)
                        .background(Color.white.opacity(0.15))
                        .foregroundStyle(.white)
                        .cornerRadius(12)
                        .textInputAutocapitalization(.none)
                        .autocorrectionDisabled()
                        
                        Text("Optional - You can skip this step")
                            .font(.system(size: 14))
                            .foregroundStyle(.white.opacity(0.6))
                    }
                    .padding(.horizontal, 24)
                    
                    Spacer()
                    
                    VStack(spacing: 12) {
                        Button {
                            appState.hasCompletedOnboarding = true
                            appState.isAuthenticated = false
                        } label: {
                            Text("Continue")
                                .font(.system(size: 17, weight: .semibold))
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 16)
                                .background(Color.white)
                                .foregroundStyle(.black)
                                .cornerRadius(14)
                        }
                        
                        Button {
                            appState.referralCode = nil
                            appState.hasCompletedOnboarding = true
                            appState.isAuthenticated = false
                        } label: {
                            Text("Skip")
                                .font(.system(size: 16, weight: .medium))
                                .foregroundStyle(.white.opacity(0.8))
                        }
                    }
                    .padding(.horizontal, 24)
                    .padding(.bottom, geo.safeAreaInsets.bottom + 20)
                }
            }
        }
    }

    // MARK: - Nav
    private func next() { withAnimation { page += 1 } }
}
