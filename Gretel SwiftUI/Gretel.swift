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
    
    let recordingService:RecordingService
    let locationService:LocationService
    
    init() {
        self.locationService = LocationService(locationManager: CLLocationManager(), settingsService: SettingsService())
        self.recordingService = RecordingService(trackHelper: TrackHelper(viewContext: persistenceController.container.viewContext))
    }

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(locationService)
                .environmentObject(recordingService)
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
