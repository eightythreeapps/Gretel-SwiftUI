//
//  Gretel_SwiftUIApp.swift
//  Gretel SwiftUI
//
//  Created by Ben Reed on 15/09/2022.
//

import SwiftUI

@main
struct Gretel_SwiftUIApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
