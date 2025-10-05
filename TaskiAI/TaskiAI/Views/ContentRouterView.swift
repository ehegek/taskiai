import SwiftUI

struct ContentRouterView: View {
    @EnvironmentObject var appState: AppState

    var body: some View {
        Group {
            if !appState.hasCompletedOnboarding {
                OnboardingView()
            } else if !appState.isAuthenticated {
                AuthView()
            } else if !appState.hasActiveSubscription {
                PaywallView()
            } else {
                RootView()
            }
        }
        .animation(.easeInOut, value: appState.hasCompletedOnboarding)
        .animation(.easeInOut, value: appState.isAuthenticated)
        .animation(.easeInOut, value: appState.hasActiveSubscription)
    }
}
