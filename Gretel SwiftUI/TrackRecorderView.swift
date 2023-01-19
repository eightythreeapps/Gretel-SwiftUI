//
//  TrackRecorderView.swift
//  Gretel SwiftUI
//
//  Created by Ben Reed on 19/01/2023.
//

import SwiftUI
import CoreLocation
import MapKit

struct TrackRecorderView: View {
    
    @EnvironmentObject var locationRecorder:LocationRecorder
    @EnvironmentObject var locationService:LocationService
    @Environment(\.horizontalSizeClass) var horizontalSizeClass
    @Environment(\.verticalSizeClass) var verticalSizeClass
    
    var body: some View {
        
        let layout = (horizontalSizeClass == .compact && verticalSizeClass == .regular) ?
        AnyLayout(VStackLayout()) :
        AnyLayout(HStackLayout())
        
        layout {
            
            Map(coordinateRegion: $locationService.region,
                showsUserLocation: true,
                userTrackingMode: $locationService.isTrackingUserLocation)
        
            VStack(alignment: .leading) {
                
                TrackRecorderHUDView(trackName: locationRecorder.currentActiveTrack?.displayName() ?? "No active track",
                                     latitude: locationService.currentLocation.displayValue(for: .latitude),
                                     longitude: locationService.currentLocation.displayValue(for: .longitude),
                                     altitude: locationService.currentLocation.displayValue(for: .altidude))
                
            }
            .padding(EdgeInsets(top: 0.0, leading: 0.0, bottom: 60.0, trailing: 0.0))
        
        }
        .edgesIgnoringSafeArea(.all)
        
        
        
    }
}

struct TrackRecorderView_Previews: PreviewProvider {
    static var previews: some View {
        PreviewFactory.makeTrackRecorderPreview()
    }
}
