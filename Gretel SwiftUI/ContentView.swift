//
//  ContentView.swift
//  Gretel SwiftUI
//
//  Created by Ben Reed on 15/09/2022.
//

import SwiftUI
import CoreData
import PermissionsSwiftUI
import CoreLocation

struct ContentView: View {
    
    @EnvironmentObject var locationRecorderService:LocationRecorderService
        
    var body: some View {
        
        NavigationView {
            
            VStack {
                
                if let activeTrack = locationRecorderService.currentActiveTrack {
                    TrackHUDView(track: activeTrack,
                                 recordingState: $locationRecorderService.currentRecordingState)
                }
                
                TrackListView()
            }

        }
        
    }

}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        PreviewFactory.ContentViewPreview()
    }
}

struct TrackHUDView: View {
    
    var track:Track
    @Binding var recordingState:RecordingState
    
    var body: some View {
        VStack {
           
            HStack {
                VStack {
                    DashboardLabelView(title: "Distance", value: track.formattedDistance(), alignment: .leading)
                    DashboardLabelView(title: "Duration", value: track.formattedDuration(), alignment: .leading)
                    DashboardLabelView(title: "Altitude", value: "27m", alignment: .leading)
                }
                RecordButtonView(buttonState: $recordingState)
            }
            
        }
        .padding()
        .frame(
            minWidth: 0,
            maxWidth: .infinity,
            minHeight: 0,
            maxHeight: 160.0,
            alignment: .center
        )
        .background(Color(UIColor.systemFill))
        .cornerRadius(17.0)
        .padding()
    }
}
