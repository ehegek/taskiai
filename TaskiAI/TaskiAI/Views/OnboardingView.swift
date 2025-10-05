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
        .tabViewStyle(.page(indexDisplayMode: .always))
        .ignoresSafeArea(edges: .all)
    }

    // MARK: - Pages
    private var welcome: some View {
        ZStack {
            Color.black.ignoresSafeArea()
            VStack(spacing: 24) {
                Spacer()
                Image(systemName: "checkmark.seal.fill").font(.system(size: 72)).foregroundStyle(.white)
                Text("Welcome To TASKI AI").font(.largeTitle).bold().foregroundStyle(.white)
                Text("Never Miss a Task").foregroundStyle(.white.opacity(0.9))
                Rectangle().fill(.white.opacity(0.15)).frame(height: 180).overlay(Text("[Mockups]").foregroundStyle(.white.opacity(0.8)))
                Spacer()
                VStack(spacing: 12) {
                    Button { next() } label: { Text("Start Now").bold().frame(maxWidth: .infinity).padding().background(Color.white, in: RoundedRectangle(cornerRadius: 12)).foregroundStyle(.black) }
                    Button { appState.hasCompletedOnboarding = true } label: { Text("Already have an account? Sign In") }
                        .foregroundStyle(.white.opacity(0.9))
                    Button { /* open privacy */ } label: { Text("Privacy Policy") }.foregroundStyle(.white.opacity(0.7)).font(.footnote)
                }.padding(.horizontal)
            }.padding()
        }
    }

    private func painPoint(icon: String, title: String, desc: String) -> some View {
        ZStack {
            Color.red.ignoresSafeArea()
            VStack(spacing: 16) {
                Spacer()
                Image(systemName: icon).font(.system(size: 72)).foregroundStyle(.white)
                Text(title).font(.title).bold().foregroundStyle(.white).multilineTextAlignment(.center).padding(.horizontal)
                Text(desc).foregroundStyle(.white.opacity(0.9)).multilineTextAlignment(.center).padding(.horizontal)
                Spacer()
                Button { next() } label: { Text("Continue").bold().frame(maxWidth: .infinity).padding().background(Color.white, in: RoundedRectangle(cornerRadius: 12)).foregroundStyle(.black) }
                .padding(.horizontal)
                .padding(.bottom)
            }
        }
    }

    private var justification: some View {
        ZStack {
            Color.blue.ignoresSafeArea()
            VStack(spacing: 16) {
                Spacer()
                Text("Path to Completion").font(.largeTitle).bold().foregroundStyle(.white)
                Text("Retrain your brain and focus on what matters.").foregroundStyle(.white.opacity(0.9)).multilineTextAlignment(.center).padding(.horizontal)
                Text("Where we help >>>").foregroundStyle(.white).padding(.top)
                Spacer()
                Button { next() } label: { Text("Continue").bold().frame(maxWidth: .infinity).padding().background(Color.white, in: RoundedRectangle(cornerRadius: 12)).foregroundStyle(.black) }
                .padding(.horizontal)
                .padding(.bottom)
            }
        }
    }

    private func value(icon: String, title: String, desc: String) -> some View {
        ZStack { Color.black.ignoresSafeArea()
            VStack(spacing: 16) {
                Spacer()
                Image(systemName: icon).font(.system(size: 64)).foregroundStyle(.green)
                Text(title).font(.title).bold().foregroundStyle(.white)
                Text(desc).foregroundStyle(.white.opacity(0.9)).multilineTextAlignment(.center).padding(.horizontal)
                Spacer()
                Button { next() } label: { Text("Continue").bold().frame(maxWidth: .infinity).padding().background(Color.white, in: RoundedRectangle(cornerRadius: 12)).foregroundStyle(.black) }
                .padding(.horizontal)
                .padding(.bottom)
            }
        }
    }

    private var socialProof: some View {
        ZStack { Color.black.ignoresSafeArea()
            VStack(spacing: 16) {
                Text("What others have to say about us...").font(.title2).bold().foregroundStyle(.white)
                ForEach(0..<4) { idx in
                    HStack { Image(systemName: "person.circle.fill").font(.largeTitle).foregroundStyle(.white); VStack(alignment: .leading) { HStack { ForEach(0..<5) { _ in Image(systemName: "star.fill").foregroundStyle(.yellow) } }; Text("Great app! Helped me get organized.").foregroundStyle(.white) ; Text("User \(idx + 1)").foregroundStyle(.white.opacity(0.8)).font(.footnote) } ; Spacer() }
                    .padding()
                    .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 12))
                }
                Spacer()
                Button { next() } label: { Text("Continue").bold().frame(maxWidth: .infinity).padding().background(Color.white, in: RoundedRectangle(cornerRadius: 12)).foregroundStyle(.black) }
                .padding(.horizontal)
                .padding(.bottom)
            }.padding()
        }
    }

    private var referral: some View {
        ZStack { Color.black.ignoresSafeArea()
            VStack(spacing: 16) {
                Text("Enter referral code (optional)").font(.title3).bold().foregroundStyle(.white)
                Text("You can skip this step").foregroundStyle(.white.opacity(0.8))
                TextField("Referral code", text: Binding(get: { appState.referralCode ?? "" }, set: { appState.referralCode = $0 }))
                    .padding()
                    .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 12))
                    .foregroundStyle(.white)
                    .textInputAutocapitalization(.none)
                Rectangle().fill(.white.opacity(0.15)).frame(height: 180).overlay(Text("[Paywall Placeholder]").foregroundStyle(.white.opacity(0.8)))
                Spacer()
                Button { appState.hasCompletedOnboarding = true } label: { Text("Finish").bold().frame(maxWidth: .infinity).padding().background(Color.white, in: RoundedRectangle(cornerRadius: 12)).foregroundStyle(.black) }
                .padding(.horizontal)
                .padding(.bottom)
            }.padding()
        }
    }

    // MARK: - Nav
    private func next() { withAnimation { page += 1 } }
}
