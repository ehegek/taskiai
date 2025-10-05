import SwiftUI

struct OnboardingView: View {
    @EnvironmentObject var appState: AppState
    @State private var selection = 0

    var body: some View {
        ZStack {
            LinearGradient(colors: [.blue.opacity(0.8), .purple.opacity(0.8)], startPoint: .top, endPoint: .bottom)
                .ignoresSafeArea()

            VStack {
                TabView(selection: $selection) {
                    page(title: "Welcome to TaskiAI",
                         subtitle: "Organize tasks, chat with AI, and stay on track.")
                    .tag(0)

                    page(title: "Plan and Track",
                         subtitle: "Calendar, reminders, and streaks keep you motivated.")
                    .tag(1)

                    page(title: "Voice and Chat",
                         subtitle: "Create tasks via voice and chat with Taski Bot.")
                    .tag(2)
                }
                .tabViewStyle(.page(indexDisplayMode: .always))
                .frame(maxWidth: .infinity, maxHeight: .infinity)

                Button(action: finish) {
                    Text(selection < 2 ? "Continue" : "Get Started")
                        .bold()
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 12))
                }
                .padding()
            }
        }
    }

    private func page(title: String, subtitle: String) -> some View {
        VStack(spacing: 16) {
            Spacer(minLength: 0)
            Image(systemName: "checkmark.circle.badge.clock")
                .font(.system(size: 72))
                .foregroundStyle(.white)
            Text(title)
                .font(.largeTitle).bold()
                .foregroundStyle(.white)
                .multilineTextAlignment(.center)
                .padding(.horizontal)
            Text(subtitle)
                .foregroundStyle(.white.opacity(0.9))
                .multilineTextAlignment(.center)
                .padding(.horizontal)
            Spacer(minLength: 0)
        }
    }

    private func finish() {
        if selection < 2 {
            withAnimation { selection += 1 }
        } else {
            appState.hasCompletedOnboarding = true
        }
    }
}
