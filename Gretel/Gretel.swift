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
    var settingsService:SettingsService = SettingsService(userDefaults: UserDefaults.standard)
    
    @StateObject var ioService = IOService()
    
    init() {
        
        let locationService = LocationService(locationManager: CLLocationManager())
        let locationRecorder = LocationRecorderService(locationService: locationService, settingsService: settingsService, trackHelper: TrackDataService(viewContext: persistenceController.container.viewContext))
        
        ViewModelFactory.configure(config: ViewModelFactoryConfiguration(locationRecorderService:locationRecorder,
                                                                                locationService: locationService))
        
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
                .environment(\.activeUnitType, .metric)
                .environmentObject(ioService)
        }
    }
    
}
