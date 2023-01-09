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
    
    public static func ConfiguredLocationService() -> LocationRecorderService  {
        return LocationRecorderService(locationManager: CLLocationManager(), settingsService: SettingsService(), trackHelper: TrackHelper.init(viewContext: PersistenceController.preview.container.viewContext))
    }
    
    public static func TripDashboardPreview() -> some View {
        return TripDashboardView()
            .environmentObject(ConfiguredLocationService())
            .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
    
    public static func TrackListPreview() -> some View {
        return TrackListView()
            .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
    
    public static func DashboardLabelPreview() -> some View {
        return DashboardLabelView(title: "Title", value: "Value", alignment: .leading)
    }
    
    public static func RecordButtonPreview() -> some View {
        return RecordButtonView(buttonState: .constant(.stopped))
    }
    
    public static func ContentViewPreview() -> some View {
        return ContentView()
            .environmentObject(ConfiguredLocationService())
            .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
