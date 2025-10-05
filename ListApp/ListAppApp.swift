//
//  ListAppApp.swift
//  ListApp
//
//  Created by Musthafa Labeeb K A on 04/10/25.
//

import SwiftUI
import CoreData

@main
struct ListAppApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
