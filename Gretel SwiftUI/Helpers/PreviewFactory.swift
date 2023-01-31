//
//  PreviewFactory.swift
//  Gretel SwiftUI
//
//  Created by Ben Reed on 19/10/2022.
//

import SwiftUI
import CoreLocation
import MapKit


public class PreviewFactory {
    
    public static func ConfiguredLocationRecorder() -> LocationRecorder  {
        
        let locationService = LocationService(locationManager: CLLocationManager())
        
        return LocationRecorder(locationService:locationService, settingsService: SettingsService(), trackHelper: TrackDataService.init(viewContext: PersistenceController.preview.container.viewContext))
    }
    
    public static func ConfiguredLocationService() -> LocationService {
        return LocationService(locationManager: CLLocationManager())
    }
    
    public static func makeTrackListPreview() -> some View {
        return TrackListView()
            .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
    
    public static func makeTrackRecorderHUDPreview() -> some View {
        
        return LocationHUDView()
            .environmentObject(ConfiguredLocationRecorder())
        
    }
    
    public static func makeTrackRecorderPreview() -> some View {
        return TrackRecorderView()
            .environmentObject(ConfiguredLocationRecorder())
            .environmentObject(ConfiguredLocationService())
    }
    
    public static func makeContentViewPreview() -> some View {
        return ContentView()
            .environmentObject(ConfiguredLocationRecorder())
            .environmentObject(ConfiguredLocationService())
            .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
   
    }
  
    public static func makeSettingsView() -> some View {
        return SettingsView()
    }
    
}
