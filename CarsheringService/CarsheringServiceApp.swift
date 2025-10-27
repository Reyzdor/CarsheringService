import SwiftUI

@main
struct CarsharingServiceApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            MainView()
                .environment(\.managedObjectContext, persistenceController.context)
                .ignoresSafeArea()
        }
    }
}
