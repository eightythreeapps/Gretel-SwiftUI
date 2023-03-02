//
//  PreviewFactory.swift
//  Gretel SwiftUI
//
//  Created by Ben Reed on 19/10/2022.
//

import SwiftUI
import CoreLocation
import MapKit
import CoreData

public class PreviewFactory {
    
    public static func ConfiguredLocationRecorder() -> LocationRecorderService  {
        
        let locationService = LocationService(locationManager: CLLocationManager())
        let settingsService = SettingsService(userDefaults: UserDefaults.standard)
     
        return LocationRecorderService(locationService:locationService,
                                settingsService: SettingsService(userDefaults: UserDefaults.standard),
                                trackHelper: TrackDataService.init(viewContext: PersistenceController.preview.container.viewContext))
    }
    
    public static func ConfiguredLocationService() -> LocationService {
        return LocationService(locationManager: CLLocationManager())
    }
    
    public static func ConfiguredViewModelFactory() -> ViewModelFactory {
        
        let config = ViewModelFactoryConfiguration(locationRecorderService: ConfiguredLocationRecorder(),
                                                   locationService: ConfiguredLocationService())
        ViewModelFactory.configure(config: config)
        
        return ViewModelFactory.shared
    }
    
    public static func makeTrackListPreview() -> some View {
        
        let fetchRequest: NSFetchRequest<Track> = Track.fetchRequest()
        let results = try! PersistenceController.preview.container.viewContext.fetch(fetchRequest)
        let track = results.first!
        
        return NavigationStack<NavigationPath, TrackListView> {
            TrackListView(path: .constant([track]))
                .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext) as! TrackListView
        }
    }
    
    public static func makeTrackRecorderHUDPreview() -> some View {
        
        return LocationHUDView()
            .environmentObject(ConfiguredLocationRecorder())
        
    }
    
    public static func makeTrackRecorderPreview() -> some View {
        
        let vm = ConfiguredViewModelFactory().makeTrackRecorderViewModel()
        return TrackRecorderView()
                    
    }
    
    public static func makeContentViewPreview() -> some View {
        return ContentView()
            .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
   
    }
  
    public static func makeSettingsView() -> some View {
        return SettingsView()
            .environmentObject(SettingsService(userDefaults: UserDefaults.standard))
    }
    
    public static func makeRecordedTrackDetailView() -> some View {
        
        let fetchRequest: NSFetchRequest<Track> = Track.fetchRequest()
        let results = try! PersistenceController.preview.container.viewContext.fetch(fetchRequest)
        
        return RecordedTrackDetailView(track: results.first!)
    }
    
    public static func makeRecorderMiniView() -> some View {
        
        let fetchRequest: NSFetchRequest<Track> = Track.fetchRequest()
        let results = try! PersistenceController.preview.container.viewContext.fetch(fetchRequest)
        let track = results.first!
        
        return RecorderMiniView()
        
    }
    
}
