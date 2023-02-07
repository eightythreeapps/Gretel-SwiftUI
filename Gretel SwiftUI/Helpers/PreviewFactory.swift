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
    
    public static func ConfiguredLocationRecorder() -> LocationRecorder  {
        
        let locationService = LocationService(locationManager: CLLocationManager())
        
        return LocationRecorder(locationService:locationService, settingsService: SettingsService(), trackHelper: TrackDataService.init(viewContext: PersistenceController.preview.container.viewContext))
    }
    
    public static func ConfiguredLocationService() -> LocationService {
        return LocationService(locationManager: CLLocationManager())
    }
    
    public static func makeTrackListPreview() -> some View {
        
        let fetchRequest: NSFetchRequest<Track> = Track.fetchRequest()
        let results = try! PersistenceController.preview.container.viewContext.fetch(fetchRequest)
        let track = results.first!
        
        return NavigationStack {
            TrackListView(path: .constant([track]))
                .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
        }
    }
    
    public static func makeTrackRecorderHUDPreview() -> some View {
        
        return LocationHUDView()
            .environmentObject(ConfiguredLocationRecorder())
        
    }
    
    public static func makeTrackRecorderPreview() -> some View {
        return TrackRecorderView(isVisible: .constant(false))
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
    
    public static func makeRecordedTrackDetailView() -> some View {
        
        let fetchRequest: NSFetchRequest<Track> = Track.fetchRequest()
        let results = try! PersistenceController.preview.container.viewContext.fetch(fetchRequest)
        
        return RecordedTrackDetailView(track: results.first!)
    }
    
    public static func makeRecorderMiniView() -> some View {
        
        let fetchRequest: NSFetchRequest<Track> = Track.fetchRequest()
        let results = try! PersistenceController.preview.container.viewContext.fetch(fetchRequest)
        let track = results.first!
        
        return RecorderMiniView(shouldShowFullRecorderView: .constant(false))
            .environmentObject(ConfiguredLocationRecorder())
        
    }
    
}
