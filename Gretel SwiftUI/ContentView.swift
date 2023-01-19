//
//  ContentView.swift
//  Gretel SwiftUI
//
//  Created by Ben Reed on 15/09/2022.
//

import SwiftUI
import CoreData
import CoreLocation
import MapKit

struct ContentView: View {
    
    @EnvironmentObject var locationRecorder:LocationRecorder
    @EnvironmentObject var locationService:LocationService
    
    @State var isShowingTrackList = false
    
    var body: some View {
        
        ZStack {
            
            Map(coordinateRegion: $locationService.region,
                showsUserLocation: true,
                userTrackingMode: $locationService.isTrackingUserLocation)
            
            VStack(alignment: .leading) {
                Button {
                    isShowingTrackList = true
                } label: {
                    Image(systemName: "list.bullet.circle.fill")
                        .resizable()
                        .frame(width: 45.0, height: 45.0)
                }

                TrackRecorderHUDView(trackName: locationRecorder.currentActiveTrack?.displayName() ?? "No active track",
                                     latitude: locationService.currentLocation.displayValue(for: .latitude),
                                     longitude: locationService.currentLocation.displayValue(for: .longitude),
                                     altitude: locationService.currentLocation.displayValue(for: .altidude))
                
            }
        
        }
        .edgesIgnoringSafeArea(.all)
        .sheet(isPresented: $isShowingTrackList) {
            TrackListView()
        }
        
    }

}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        PreviewFactory.makeContentViewPreview()
    }
}
