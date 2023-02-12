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
    
    var locationRecorder:LocationRecorderService
    var locationService:LocationService
    var settingsService:SettingsService
    var unitFormatter:UnitFormatter
    
    init() {
        
        let userDefaults = UserDefaults.standard
        let settingsService = SettingsService(userDefaults: userDefaults)
        let unitFormatter = UnitFormatter(settingsService: settingsService)
        
        self.locationService = LocationService(locationManager: CLLocationManager())
        self.locationRecorder = LocationRecorderService(locationService: self.locationService,
                                                 settingsService: SettingsService(userDefaults: userDefaults),
                                                 trackHelper: TrackDataService(viewContext: PersistenceController.shared.container.viewContext), unitFormatter: unitFormatter)
        self.settingsService = settingsService
        self.unitFormatter = unitFormatter
        self.settingsService.configureSettings()
        
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
