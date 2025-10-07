import SwiftUI

struct OnboardingView: View {
    @EnvironmentObject var appState: AppState
    @State private var page = 0

    var body: some View {
        TabView(selection: $page) {
            welcome.tag(0)
            painPoint(
                icon: "person.crop.circle.badge.exclamationmark",
                title: "Disorganization is a silent killer",
                desc: "Every missed task, forgotten call, or untracked goal chips away at your future. Without structure, small slips turn into big failures."
            ).tag(1)
            painPoint(
                icon: "brain.head.profile",
                title: "Without accountability, goals die",
                desc: "Your brain craves shortcuts. When no one's watching, you let yourself off the hook. Dreams fade when discipline isn't enforced."
            ).tag(2)
            painPoint(
                icon: "chart.line.downtrend.xyaxis",
                title: "Unfinished tasks kill potential",
                desc: "Success isn't lost overnight—it's lost one unchecked box at a time. Each missed step compounds into regret."
            ).tag(3)
            justification.tag(4)
            value(
                icon: "lock.fill",
                title: "Avoid setbacks",
                desc: "Stay protected from slippage with smart guardrails."
            ).tag(5)
            value(
                icon: "flag.checkered",
                title: "Conquer yourself",
                desc: "Strengthen discipline, focus, and completion every day."
            ).tag(6)
            value(
                icon: "brain.filled.head.profile",
                title: "Rewire your brain",
                desc: "Turn small wins into lasting motivation, turning intention into action."
            ).tag(7)
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
                    Spacer(minLength: geo.safeAreaInsets.top + 8)

                    Text("Welcome To")
                        .font(.system(size: 18, weight: .semibold))
                        .foregroundStyle(.white.opacity(0.9))

                    Text("TASKI  AI")
                        .font(.system(size: 52, weight: .heavy))
                        .tracking(1.2)
                        .foregroundStyle(.white)

                    ZStack {
                        Circle().stroke(lineWidth: 8).foregroundStyle(.white).frame(width: 112, height: 112)
                        Image(systemName: "checkmark")
                            .font(.system(size: 54, weight: .bold))
                            .foregroundStyle(.white)
                    }
                    .padding(.top, 4)

                    HStack(spacing: 12) {
                        Image("Rectangle 89").resizable().scaledToFit().frame(height: 160)
                        Image("Rectangle 89").resizable().scaledToFit().frame(height: 160)
                        Image("Rectangle 89").resizable().scaledToFit().frame(height: 160)
                    }
                    .padding(.horizontal, 20)
                    .padding(.vertical, 6)

                    Text("Never Miss a Task")
                        .font(.system(size: 15, weight: .medium))
                        .foregroundStyle(.white.opacity(0.9))
                        .padding(.top, 6)

                    Spacer(minLength: 0)

                    VStack(spacing: 12) {
                        Button { next() } label: {
                            Text("Start Now")
                                .font(.system(size: 20, weight: .semibold))
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 18)
                                .background(
                                    RoundedRectangle(cornerRadius: 18)
                                        .fill(Color.white)
                                        .shadow(color: .white.opacity(0.15), radius: 14, y: 4)
                                )
                                .foregroundStyle(.black)
                        }

                        Button { appState.hasCompletedOnboarding = true; appState.isAuthenticated = false } label: {
                            Text("Already have an account? Sign In")
                                .font(.system(size: 15))
                                .foregroundStyle(.white.opacity(0.9))
                        }

                        Text("By continuing, you agree to our Terms of Use and Privacy Policy")
                            .font(.system(size: 11))
                            .multilineTextAlignment(.center)
                            .foregroundStyle(.white.opacity(0.6))
                    }
                    .padding(.horizontal, 24)
                    .padding(.bottom, geo.safeAreaInsets.bottom + 18)
                }
            }
        }
    }

    private func painPoint(icon: String, title: String, desc: String) -> some View {
        GeometryReader { geo in
            ZStack {
                Color(red: 0.98, green: 0.25, blue: 0.24).ignoresSafeArea(.all, edges: .all)
                VStack(spacing: 18) {
                    Spacer(minLength: geo.safeAreaInsets.top + 18)

                    HStack(spacing: 8) {
                        Image(systemName: "checkmark.circle")
                            .font(.system(size: 18, weight: .bold))
                            .foregroundStyle(.white)
                        Text("TASKI AI")
                            .font(.system(size: 16, weight: .semibold))
                            .foregroundStyle(.white)
                        Spacer()
                    }
                    .padding(.horizontal, 24)

                    Spacer(minLength: 8)

                    Group {
                        if UIImage(named: title) != nil {
                            Image(title).resizable().scaledToFit()
                        } else {
                            Image(systemName: icon).resizable().scaledToFit().padding(40)
                        }
                    }
                    .frame(height: 200)
                    .foregroundStyle(.white)
                    .padding(.horizontal, 20)

                    Text(title)
                        .font(.system(size: 22, weight: .bold))
                        .foregroundStyle(.white)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 28)

                    Text(desc)
                        .font(.system(size: 15))
                        .foregroundStyle(.white.opacity(0.9))
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 28)

                    Spacer()

                    HStack(spacing: 6) { Circle().fill(Color.white).frame(width: 6, height: 6); Circle().fill(Color.white.opacity(0.6)).frame(width: 6, height: 6); Circle().fill(Color.white.opacity(0.6)).frame(width: 6, height: 6) }
                        .opacity(0) // placeholder for page dots alignment

                    Button { next() } label: {
                        Text("Next >")
                            .font(.system(size: 18, weight: .semibold))
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 16)
                            .background(RoundedRectangle(cornerRadius: 18).fill(.white))
                            .foregroundStyle(.black)
                    }
                    .padding(.horizontal, 24)
                    .padding(.bottom, geo.safeAreaInsets.bottom + 18)
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
                    
                    Text("Path to Completion")
                        .font(.system(size: 22, weight: .bold))
                        .foregroundStyle(.white)
                        .padding(.top, 4)

                    Text("Your brain can be retrained, habits rebuilt, and focus sharpened. Writing down tasks and checking them off creates small wins that release dopamine, fueling motivation and momentum.")
                        .font(.system(size: 15))
                        .foregroundStyle(.white.opacity(0.95))
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 24)
                    
                    Text("where we help >>>")
                        .font(.system(size: 14, weight: .semibold))
                        .foregroundStyle(.white)
                        .padding(.top, 8)
                    
                    Spacer()
                    
                    Button { next() } label: {
                        Text("Next >")
                            .font(.system(size: 18, weight: .semibold))
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 16)
                            .background(Color.white)
                            .foregroundStyle(.black)
                            .cornerRadius(18)
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
                    
                    Group {
                        if UIImage(named: title) != nil {
                            Image(title).resizable().scaledToFit()
                        } else {
                            Image(systemName: icon).resizable().scaledToFit().padding(40)
                        }
                    }
                    .frame(height: 160)
                    .foregroundStyle(.white)
                    .padding(.horizontal, 20)
                    
                    Text(title)
                        .font(.system(size: 28, weight: .bold))
                        .foregroundStyle(.white)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 24)
                    
                    Text(desc)
                        .font(.system(size: 16))
                        .foregroundStyle(.white.opacity(0.9))
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 24)
                    
                    Spacer()
                    
                    Button { next() } label: {
                        Text("Next >")
                            .font(.system(size: 18, weight: .semibold))
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 16)
                            .background(Color.white)
                            .foregroundStyle(.black)
                            .cornerRadius(18)
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
                                                .font(.system(size: 12))
                                                .foregroundStyle(.yellow)
                                        }
                                    }
                                    Text("Taski AI keeps me consistent and on track. My completion rate is up.")
                                        .font(.system(size: 14))
                                        .foregroundStyle(.white)
                                    Text(["Emma Johnson","Alex Carter","Mia Davis","Jack Costel"][idx % 4])
                                        .font(.system(size: 12))
                                        .foregroundStyle(.white.opacity(0.7))
                                }
                                Spacer()
                            }
                            .padding(16)
                            .background(
                                RoundedRectangle(cornerRadius: 16)
                                    .strokeBorder(Color.white.opacity(0.15))
                                    .background(RoundedRectangle(cornerRadius: 16).fill(Color.white.opacity(0.04)))
                            )
                        }
                        
                        Spacer(minLength: 20)
                        
                        Button { next() } label: {
                            Text("Next >")
                                .font(.system(size: 18, weight: .semibold))
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 16)
                                .background(Color.white)
                                .foregroundStyle(.black)
                                .cornerRadius(18)
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
                Color.black.ignoresSafeArea(.all, edges: .all)

                VStack(spacing: 18) {
                    Spacer(minLength: geo.safeAreaInsets.top + 18)

                    HStack {
                        Button { withAnimation { page = max(0, page-1) } } label: {
                            Image(systemName: "chevron.left.circle.fill")
                                .font(.system(size: 22, weight: .semibold))
                                .foregroundStyle(.white.opacity(0.9))
                        }
                        Spacer()
                    }
                    .padding(.horizontal, 20)

                    VStack(alignment: .leading, spacing: 6) {
                        Text("Enter referral code\n(optional)")
                            .font(.system(size: 28, weight: .bold))
                            .foregroundStyle(.white)

                        Text("You can skip this step")
                            .font(.system(size: 15))
                            .foregroundStyle(.white.opacity(0.7))
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal, 24)

                    HStack {
                        TextField("Referral Code", text: Binding(
                            get: { appState.referralCode ?? "" },
                            set: { appState.referralCode = $0 }
                        ))
                        .textInputAutocapitalization(.none)
                        .autocorrectionDisabled()
                        .font(.system(size: 16))
                        .padding(.vertical, 14)
                        .padding(.horizontal, 16)
                        .background(RoundedRectangle(cornerRadius: 18).fill(Color.white.opacity(0.15)))
                        .foregroundStyle(.white)
                    }
                    .padding(.horizontal, 24)

                    Spacer()

                    Button {
                        appState.hasCompletedOnboarding = true
                        appState.isAuthenticated = false
                    } label: {
                        Text("Next >")
                            .font(.system(size: 18, weight: .semibold))
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 16)
                            .background(RoundedRectangle(cornerRadius: 18).fill(.white))
                            .foregroundStyle(.black)
                    }
                    .padding(.horizontal, 24)

                    Button {
                        appState.referralCode = nil
                        appState.hasCompletedOnboarding = true
                        appState.isAuthenticated = false
                    } label: {
                        Text("Skip")
                            .font(.system(size: 16, weight: .medium))
                            .foregroundStyle(.white.opacity(0.8))
                    }
                    .padding(.bottom, geo.safeAreaInsets.bottom + 16)
                }
            }
        }
    }

    // MARK: - Nav
    private func next() { withAnimation { page += 1 } }
}

