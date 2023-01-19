//
//  TrackRecorderHUDView.swift
//  Gretel SwiftUI
//
//  Created by Ben Reed on 19/01/2023.
//

import SwiftUI

struct TrackRecorderHUDView: View {
    
    var trackName:String = "No Name"
    var latitude:String = "0.0"
    var longitude:String = "0.0"
    var altitude:String = "0.0"
    
    @EnvironmentObject var locationRecorder:LocationRecorder
    
    var body: some View {
        
        VStack {
            
            if let trackName = trackName {
                Text(trackName)
                    .padding()
            }
            
            HStack {
                HUDLabelView(title: "Latitude", value: latitude)
                HUDLabelView(title: "Longitude", value: longitude)
                HUDLabelView(title: "Altitude", value: altitude)
            }
            
            Button {
                locationRecorder.updateRecordingState()
            } label: {
                
                switch locationRecorder.currentRecordingState {
                case .stopped:
                    Text("Start new track")
                case .paused:
                    Text("Resume track")
                case .recording:
                    Text("Pause track")
                case .disabled:
                    Text("Recording disabled")
                }
            }
            .padding()
        }
    }
}


struct TrackRecorderHUDView_Previews: PreviewProvider {
    static var previews: some View {
        PreviewFactory.makeTrackRecorderHUDPreview()
    }
}

struct HUDLabelView: View {
    
    var title:String
    var value:String
    
    var body: some View {
        VStack {
            Text(title)
            Text(value)
        }
    }
}
