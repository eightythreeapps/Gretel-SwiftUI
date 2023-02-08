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
    var settingsService:SettingsService
    
    init() {
        
        let userDefaults = UserDefaults.standard
        
        self.locationService = LocationService(locationManager: CLLocationManager())
        self.locationRecorder = LocationRecorder(locationService: self.locationService,
                                                 settingsService: SettingsService(userDefaults: userDefaults),
                                                 trackHelper: TrackDataService(viewContext: PersistenceController.shared.container.viewContext))
        
        self.settingsService = SettingsService(userDefaults: userDefaults)
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(locationRecorder)
                .environmentObject(locationService)
                .environmentObject(settingsService)
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
    
}
