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
        let _ = SettingsService(userDefaults: UserDefaults.standard)
     
        return LocationRecorder(locationService:locationService,
                                settingsService: SettingsService(userDefaults: UserDefaults.standard))
    }
    
    public static func ConfiguredLocationService() -> LocationService {
        return LocationService(locationManager: CLLocationManager())
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
        
        let location = CLLocation(latitude: 0.0, longitude: 0.0)
        let region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 0.0, longitude: 0.0),span: MKCoordinateSpan(latitudeDelta: 10, longitudeDelta: 10))
        
        return TrackRecorderView(recordingState: .constant(.recording),
                                 isVisible: .constant(true),
                                 isTrackingUserLocation: .constant(.follow),
                                 mapRegion: region, showsUserLocation: true, currentLocation: location)
        .environmentObject(ConfiguredLocationRecorder())
            
    }
    
    public static func makeContentViewPreview() -> some View {
        return ContentView(locationRecorder: ConfiguredLocationRecorder(), locationService: ConfiguredLocationService())
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
        
        return RecorderMiniView(locationRecorder: ConfiguredLocationRecorder(),
                                shouldShowFullRecorderView: .constant(false),
                                recordingState: .constant(.recording))
        
    }
    
}
