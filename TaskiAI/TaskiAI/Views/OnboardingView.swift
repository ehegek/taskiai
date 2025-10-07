import SwiftUI
import UIKit

struct OnboardingView: View {
    @EnvironmentObject var appState: AppState
    @State private var page = 0

    private struct Slide: Identifiable {
        let id = UUID()
        let title: String
        let subtitle: String
        let icon: String
        let topAccent: Color
        let bottomAccent: Color
    }

    private var slides: [Slide] = [
        .init(
            title: "Welcome to Taski AI",
            subtitle: "Smart reminders that actually get done.",
            icon: "checkmark.seal.fill",
            topAccent: Color.black,
            bottomAccent: Color.black
        ),
        .init(
            title: "Avoid setbacks",
            subtitle: "Protect progress with guardrails and timely nudges.",
            icon: "lock.fill",
            topAccent: Color(red: 0.10, green: 0.10, blue: 0.10),
            bottomAccent: Color(red: 0.00, green: 0.00, blue: 0.00)
        ),
        .init(
            title: "Conquer yourself",
            subtitle: "Build discipline, focus, and momentum every day.",
            icon: "flag.checkered",
            topAccent: Color(red: 0.10, green: 0.10, blue: 0.10),
            bottomAccent: Color.black
        ),
        .init(
            title: "Rewire your brain",
            subtitle: "Small wins release dopamine and fuel motivation.",
            icon: "brain.head.profile",
            topAccent: Color(red: 0.10, green: 0.10, blue: 0.10),
            bottomAccent: Color.black
        ),
        .init(
            title: "Stay on track",
            subtitle: "Gentle, context-aware reminders keep you moving.",
            icon: "bell.badge.fill",
            topAccent: Color(red: 0.10, green: 0.10, blue: 0.10),
            bottomAccent: Color.black
        ),
        .init(
            title: "Plan once",
            subtitle: "We handle the follow-ups and accountability.",
            icon: "calendar.badge.clock",
            topAccent: Color(red: 0.10, green: 0.10, blue: 0.10),
            bottomAccent: Color.black
        ),
        .init(
            title: "Focus mode",
            subtitle: "One clear next step—no overwhelm.",
            icon: "target",
            topAccent: Color(red: 0.10, green: 0.10, blue: 0.10),
            bottomAccent: Color.black
        ),
        .init(
            title: "Progress you can feel",
            subtitle: "See streaks, trends, and completions grow.",
            icon: "chart.line.uptrend.xyaxis",
            topAccent: Color(red: 0.10, green: 0.10, blue: 0.10),
            bottomAccent: Color.black
        )
    ]

    var body: some View {
        ZStack {
            TabView(selection: $page) {
                ForEach(0..<slides.count, id: \.self) { idx in
                    onboardingSlide(slides[idx])
                        .tag(idx)
                }
                referral.tag(slides.count)
            }
            .tabViewStyle(.page(indexDisplayMode: .never))
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
        .ignoresSafeArea(.all)
        .statusBar(hidden: true)
    }

    // MARK: - Pages
    private func onboardingSlide(_ slide: Slide) -> some View {
        GeometryReader { geo in
            ZStack {
                LinearGradient(colors: [slide.topAccent, slide.bottomAccent], startPoint: .top, endPoint: .bottom)
                    .frame(width: geo.size.width, height: geo.size.height)
                    .ignoresSafeArea(.all)

                VStack(spacing: 20) {
                    Spacer(minLength: geo.safeAreaInsets.top + 24)

                    ZStack {
                        Circle()
                            .fill(Color.white.opacity(0.08))
                            .frame(width: min(220, geo.size.width * 0.45), height: min(220, geo.size.width * 0.45))
                        Image(systemName: slide.icon)
                            .symbolRenderingMode(.palette)
                            .foregroundStyle(Color.white)
                            .font(.system(size: min(110, geo.size.width * 0.22), weight: .bold))
                    }
                    .padding(.top, 10)

                    Text(slide.title)
                        .font(.system(size: min(36, geo.size.width * 0.09), weight: .heavy))
                        .foregroundStyle(.white)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 24)

                    Text(slide.subtitle)
                        .font(.system(size: min(17, geo.size.width * 0.045), weight: .medium))
                        .foregroundStyle(.white.opacity(0.9))
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 28)

                    Spacer()

                    Button {
                        withAnimation(.easeInOut) { page += 1 }
                    } label: {
                        Text("Next")
                            .font(.system(size: 18, weight: .semibold))
                            .foregroundStyle(.black)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 16)
                            .background(
                                RoundedRectangle(cornerRadius: 18, style: .continuous)
                                    .fill(Color.white)
                            )
                    }
                    .padding(.horizontal, 24)
                    .padding(.bottom, geo.safeAreaInsets.bottom + 12)
                }
            }
            .frame(width: geo.size.width, height: geo.size.height)
            .ignoresSafeArea(.all)
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

}
