import SwiftUI
import CoreData

@main
struct CarsharingServiceApp: App {
    @AppStorage("didOnboard") var didOnboard: Bool = false

    let persistenceController = PersistenceController.shared
    @StateObject var authManager = AuthManager() // используем существующий AuthManager

    var body: some Scene {
        WindowGroup {
            NavigationStack {
                if !didOnboard {
                    OnBoardingView(hasCompletedBoarding: $didOnboard)
                } else {
                    LoginView()
                        .environmentObject(authManager)
                }
            }
            .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
