import SwiftUI
import UIKit

struct OnboardingView: View {
    @EnvironmentObject var appState: AppState
    @State private var page = 0

    var body: some View {
        TabView(selection: $page) {
            onboardingPage(imageName: "onboarding_welcome", isFirst: true).tag(0)
            onboardingPage(imageName: "onboarding_1").tag(1)
            onboardingPage(imageName: "onboarding_2").tag(2)
            onboardingPage(imageName: "onboarding_3").tag(3)
            onboardingPage(imageName: "onboarding_4").tag(4)
            onboardingPage(imageName: "onboarding_5").tag(5)
            onboardingPage(imageName: "onboarding_6").tag(6)
            onboardingPage(imageName: "onboarding_7").tag(7)
            onboardingPage(imageName: "onboarding_8").tag(8)
            referral.tag(9)
        }
        .tabViewStyle(.page(indexDisplayMode: .never))
        .ignoresSafeArea(.all, edges: .all)
        .statusBar(hidden: true)
    }

    // MARK: - Pages
    private func onboardingPage(imageName: String, isFirst: Bool = false) -> some View {
        ZStack {
            // Background image - full screen with proper scaling
            if let uiImage = UIImage(named: imageName) {
                GeometryReader { geo in
                    Image(uiImage: uiImage)
                        .resizable()
                        .scaledToFill()
                        .frame(width: geo.size.width, height: geo.size.height, alignment: .center)
                        .clipped()
                        .edgesIgnoringSafeArea(.all)
                }
            } else {
                Color.black.edgesIgnoringSafeArea(.all)
            }
            
            // Next button overlay at bottom
            VStack {
                Spacer()
                
                Button {
                    withAnimation {
                        page += 1
                    }
                } label: {
                    Text("Next")
                        .font(.system(size: 18, weight: .semibold))
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 16)
                        .background(
                            RoundedRectangle(cornerRadius: 18)
                                .fill(Color.white)
                        )
                        .foregroundStyle(.black)
                }
                .padding(.horizontal, 24)
                .padding(.bottom, 20)
            }
            .padding(.bottom, 20)
        }
        .edgesIgnoringSafeArea(.all)
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
