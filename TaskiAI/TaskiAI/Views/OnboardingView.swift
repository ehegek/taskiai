import SwiftUI
import UIKit

extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (255, 0, 0, 0)
        }
        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue: Double(b) / 255,
            opacity: Double(a) / 255
        )
    }
}

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
        // Welcome
        .init(
            title: "Welcome to Taski AI",
            subtitle: "Smart reminders that actually get done.",
            icon: "checkmark.seal.fill",
            topAccent: Color.black,
            bottomAccent: Color.black
        ),
        // Pain Point 1 - Red
        .init(
            title: "Overwhelmed by tasks?",
            subtitle: "Too many to-dos, not enough time to manage them all.",
            icon: "exclamationmark.triangle.fill",
            topAccent: Color(hex: "FF4545"),
            bottomAccent: Color(hex: "FF4545")
        ),
        // Pain Point 2 - Red
        .init(
            title: "Forget important things?",
            subtitle: "Critical tasks slip through the cracks every day.",
            icon: "brain.head.profile",
            topAccent: Color(hex: "FF4545"),
            bottomAccent: Color(hex: "FF4545")
        ),
        // Pain Point 3 - Red
        .init(
            title: "Lose motivation fast?",
            subtitle: "Start strong but can't keep the momentum going.",
            icon: "battery.0",
            topAccent: Color(hex: "FF4545"),
            bottomAccent: Color(hex: "FF4545")
        ),
        // Justification - Blue
        .init(
            title: "You need a system",
            subtitle: "Not another app—a partner that keeps you accountable.",
            icon: "shield.checkered",
            topAccent: Color(hex: "0E64AF"),
            bottomAccent: Color(hex: "0E64AF")
        ),
        // Value Add 1 - Green (solution to pain 1)
        .init(
            title: "Smart prioritization",
            subtitle: "We organize your tasks so you focus on what matters most.",
            icon: "list.bullet.clipboard.fill",
            topAccent: Color(hex: "34C759"),
            bottomAccent: Color(hex: "34C759")
        ),
        // Value Add 2 - Green (solution to pain 2)
        .init(
            title: "Never miss a deadline",
            subtitle: "Intelligent reminders that adapt to your schedule.",
            icon: "bell.badge.fill",
            topAccent: Color(hex: "34C759"),
            bottomAccent: Color(hex: "34C759")
        ),
        // Value Add 3 - Green (solution to pain 3)
        .init(
            title: "Build lasting habits",
            subtitle: "Track streaks and celebrate wins to stay motivated.",
            icon: "chart.line.uptrend.xyaxis",
            topAccent: Color(hex: "34C759"),
            bottomAccent: Color(hex: "34C759")
        ),
        // Social Proof
        .init(
            title: "Join 10,000+ users",
            subtitle: "People like you are crushing their goals with Taski AI.",
            icon: "person.3.fill",
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
