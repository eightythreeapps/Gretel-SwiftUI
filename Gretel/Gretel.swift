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
    
    @StateObject var locationRecorder = LocationRecorderService(locationService: LocationService(locationManager: CLLocationManager()),
                                                                settingsService: SettingsService(userDefaults: UserDefaults.standard),
                                                                trackHelper: TrackDataService(viewContext: PersistenceController.shared.container.viewContext))
    
    @StateObject var locationProvider = LocationService(locationManager: CLLocationManager())
    
    
    var body: some Scene {
        WindowGroup {
            ContentView(locationRecorder: locationRecorder, locationService: locationProvider)
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
                .environment(\.activeUnitType, .metric)
                .environmentObject(locationRecorder)
        }
    }
    
}
