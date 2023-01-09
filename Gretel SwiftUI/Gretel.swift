//
//  Gretel_SwiftUIApp.swift
//  Gretel SwiftUI
//
//  Created by Ben Reed on 15/09/2022.
//

import SwiftUI
import CoreLocation

@main
struct Gretel: App {
    
    let persistenceController = PersistenceController.shared
    let locationRecorder:LocationRecorderService
    
    init() {
        self.locationRecorder = LocationRecorderService(locationManager: CLLocationManager(),
                                                        settingsService: SettingsService(),
                                                        trackHelper: TrackHelper(viewContext: persistenceController.container.viewContext))
    }

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(locationRecorder)
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
