//
//  CarsheringServiceCleanApp.swift
//  CarsheringServiceClean
//
//  Created by Roman on 03.11.2025.
//

import SwiftUI
import CoreData

@main
struct CarsheringServiceCleanApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
