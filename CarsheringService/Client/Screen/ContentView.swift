import SwiftUI
import CoreData

final class AuthManager: ObservableObject {
    @Published var isLoggedIn: Bool = false
    
    func login(email: String, password: String) -> Bool {
        if email.lowercased() == "test@test.com" && password == "1234" {
            isLoggedIn = true
            return true
        } else {
            return false
        }
    }
}

struct PersistenceController {
    static let shared = PersistenceController()
    let container: NSPersistentContainer

    init() {
        container = NSPersistentContainer(name: "Model")
        container.loadPersistentStores { description, error in
            if let error = error {
                fatalError("Ошибка загрузки Core Data: \(error)")
            }
        }
    }
}

@main
struct CarsharingServiceApp: App {
    @AppStorage("didOnboard") var didOnboard: Bool = false

    let persistenceController = PersistenceController.shared
    @StateObject var authManager = AuthManager()

    // Вспомогательная переменная для выбора стартового экрана
    @ViewBuilder
    var startView: some View {
        if !didOnboard {
            OnBoardingView(hasCompletedBoarding: $didOnboard)
        } else {
            LoginView()
                .environmentObject(authManager)
        }
    }

    var body: some Scene {
        WindowGroup {
            NavigationStack {
                startView
            }
            .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
