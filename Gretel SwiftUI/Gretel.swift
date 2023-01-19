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
    
    var locationRecorder:LocationRecorder
    var locationService:LocationService
    
    init() {
        
        self.locationService = LocationService(locationManager: CLLocationManager())
        self.locationRecorder = LocationRecorder(locationService: self.locationService,
                                                 settingsService: SettingsService(),
                                                 trackHelper: TrackHelper(viewContext: PersistenceController.shared.container.viewContext))
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(locationRecorder)
                .environmentObject(locationService)
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
    
}
