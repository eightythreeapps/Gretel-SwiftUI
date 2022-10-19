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
    
    public static func ConfiguredRecordingService() -> RecordingService {
        return RecordingService(trackHelper: TrackHelper(viewContext: PersistenceController.shared.container.viewContext)
        )
    }
    
    public static func ConfiguredLocationService() -> LocationService {
        return LocationService(locationManager: CLLocationManager(), settingsService: SettingsService())
    }
    
    public static func TripDashboardPreview() -> some View {
        return TripDashboardView()
            .environmentObject(ConfiguredLocationService())
            .environmentObject(ConfiguredRecordingService())
    }
    
    public static func DashboardLabelPreview() -> some View {
        return DashboardLabelView(title: "Title", value: "Value", alignment: .leading)
    }
    
    public static func RecordButtonPreview() -> some View {
        return RecordButtonView()
    }
    
    public static func ContentViewPreview() -> some View {
        return ContentView()
            .environmentObject(ConfiguredLocationService())
            .environmentObject(ConfiguredRecordingService())
            .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
