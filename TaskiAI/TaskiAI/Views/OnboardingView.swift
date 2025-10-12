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
            .edgesIgnoringSafeArea(.all)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .edgesIgnoringSafeArea(.all)
        .statusBar(hidden: true)
    }

    // MARK: - Pages
    private func onboardingSlide(_ slide: Slide) -> some View {
        GeometryReader { geo in
            ZStack {
                Rectangle()
                    .fill(LinearGradient(colors: [slide.topAccent, slide.bottomAccent], startPoint: .top, endPoint: .bottom))
                    .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
                    .edgesIgnoringSafeArea(.all)

                VStack(spacing: 28) {
                    Spacer()
                        .frame(height: max(geo.safeAreaInsets.top + 60, 100))

                    ZStack {
                        Circle()
                            .fill(Color.white.opacity(0.08))
                            .frame(width: 200, height: 200)
                        Image(systemName: slide.icon)
                            .symbolRenderingMode(.palette)
                            .foregroundStyle(Color.white)
                            .font(.system(size: 100, weight: .bold))
                    }

                    Text(slide.title)
                        .font(.system(size: 32, weight: .bold))
                        .foregroundStyle(.white)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 32)
                        .fixedSize(horizontal: false, vertical: true)

                    Text(slide.subtitle)
                        .font(.system(size: 17, weight: .regular))
                        .foregroundStyle(.white.opacity(0.9))
                        .multilineTextAlignment(.center)
                        .lineSpacing(4)
                        .padding(.horizontal, 40)

                    Spacer()

                    Button {
                        withAnimation(.easeInOut) { page += 1 }
                    } label: {
                        Text("Next")
                            .font(.system(size: 18, weight: .semibold))
                            .foregroundStyle(.black)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 18)
                            .background(
                                RoundedRectangle(cornerRadius: 16, style: .continuous)
                                    .fill(Color.white)
                            )
                    }
                    .padding(.horizontal, 32)
                    
                    Spacer()
                        .frame(height: max(geo.safeAreaInsets.bottom + 24, 40))
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .edgesIgnoringSafeArea(.all)
        }
        .edgesIgnoringSafeArea(.all)
    }

    private var referral: some View {
        GeometryReader { geo in
            ZStack {
                Rectangle()
                    .fill(Color.black)
                    .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
                    .edgesIgnoringSafeArea(.all)

                VStack(spacing: 20) {
                    Spacer()
                        .frame(height: max(geo.safeAreaInsets.top + 20, 60))

                    HStack {
                        Button { withAnimation { page = max(0, page-1) } } label: {
                            Image(systemName: "chevron.left.circle.fill")
                                .font(.system(size: 22, weight: .semibold))
                                .foregroundStyle(.white.opacity(0.9))
                        }
                        Spacer()
                    }
                    .padding(.horizontal, 20)
                    
                    Spacer()

                    VStack(spacing: 32) {
                        // Icon
                        ZStack {
                            Circle()
                                .fill(Color.white.opacity(0.1))
                                .frame(width: 120, height: 120)
                            Image(systemName: "gift.fill")
                                .font(.system(size: 60))
                                .foregroundStyle(.white)
                        }
                        
                        VStack(alignment: .center, spacing: 8) {
                            Text("Enter referral code")
                                .font(.system(size: 32, weight: .bold))
                                .foregroundStyle(.white)
                                .multilineTextAlignment(.center)
                            
                            Text("Got a code from a friend? Enter it here to unlock exclusive benefits!")
                                .font(.system(size: 16))
                                .foregroundStyle(.white.opacity(0.8))
                                .multilineTextAlignment(.center)
                                .padding(.horizontal, 20)
                        }

                        TextField("Referral Code", text: Binding(
                            get: { appState.referralCode ?? "" },
                            set: { appState.referralCode = $0 }
                        ))
                        .textInputAutocapitalization(.none)
                        .autocorrectionDisabled()
                        .font(.system(size: 18))
                        .padding(.vertical, 18)
                        .padding(.horizontal, 20)
                        .background(RoundedRectangle(cornerRadius: 18).fill(Color.white.opacity(0.15)))
                        .foregroundStyle(.white)
                        .padding(.horizontal, 32)
                    }
                    
                    Spacer()

                    Button {
                        appState.hasCompletedOnboarding = true
                        appState.isAuthenticated = false
                    } label: {
                        Text("Next >")
                            .font(.system(size: 18, weight: .semibold))
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 18)
                            .background(RoundedRectangle(cornerRadius: 16).fill(.white))
                            .foregroundStyle(.black)
                    }
                    .padding(.horizontal, 32)

                    Button {
                        appState.referralCode = nil
                        appState.hasCompletedOnboarding = true
                        appState.isAuthenticated = false
                    } label: {
                        Text("Skip")
                            .font(.system(size: 16, weight: .medium))
                            .foregroundStyle(.white.opacity(0.8))
                    }
                    
                    Spacer()
                        .frame(height: max(geo.safeAreaInsets.bottom + 20, 40))
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .edgesIgnoringSafeArea(.all)
        }
        .edgesIgnoringSafeArea(.all)
    }

}
