import SwiftUI

struct ContentView: View {
    @EnvironmentObject var authManager: AuthManager
    @State private var hasCompletedOnboarding = false
    
    var body: some View {
        ZStack {
            if !hasCompletedOnboarding {
                OnBoarding(hasCompetedBoarding: $hasCompletedOnboarding)
            } else if authManager.isLogin {
                Button("Выйти") {
                    authManager.logout()
                }
                .padding()
            } else {
                LoginView()
            }
        }
    }
}

#Preview {
    ContentView()
        .environmentObject(AuthManager())
}
