import SwiftUI

struct ContentView: View {
    @EnvironmentObject var authManager: AuthManager
    
    var body: some View {
        VStack {
            if authManager.isLogin {
                    
                Button("Выйти") {
                    authManager.logout()
                }
                .padding()
            } else {
                LoginView()
                    .onAppear {
                        print("🖥️ Показан экран входа")
                    }
            }
        }
        .padding()
    }
}

#Preview {
    ContentView()
        .environmentObject(AuthManager())
}
