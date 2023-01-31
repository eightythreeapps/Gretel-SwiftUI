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
                ZStack {
                    Map(coordinateRegion: $locationService.region,
                        showsUserLocation: true,
                        userTrackingMode: $locationService.isTrackingUserLocation)

                    VStack {
                        LocationHUDView(
                            latitude: locationService.currentLocation.displayValue(for: .latitude),
                            longitude: locationService.currentLocation.displayValue(for: .longitude),
                            altitude: locationService.currentLocation.displayValue(for: .altidude))
                        Spacer()
                    }
                }
                VStack {
                    RecorderControlsView()
                }
            }
        
    }
}

struct TrackRecorderView_Previews: PreviewProvider {
    static var previews: some View {
        PreviewFactory.makeTrackRecorderPreview()
    }
}

struct RecordButtonView: View {
    
    @EnvironmentObject var locationRecorder:LocationRecorder
    @Binding var recordingState:RecordingState
    
    var body: some View {
        Button {
            locationRecorder.updateRecordingState()
        } label: {
            iconForState(recordingState: recordingState)
        }
    }
    
    func iconForState(recordingState:RecordingState) -> some View {
        switch recordingState {
            
        case .recording:
            return Image(systemName: "pause.circle.fill")
                .resizable()
                .frame(width: 60.0, height: 60.0)
                .foregroundColor(.blue)
        case .disabled:
            return Image(systemName: "record.circle")
                .resizable()
                .frame(width: 60.0, height: 60.0)
                .foregroundColor(.gray)
        case .paused, .stopped:
            return Image(systemName: "record.circle")
                .resizable()
                .frame(width: 60.0, height: 60.0)
                .foregroundColor(.red)
        
        }
    }
    
}

struct RecorderControlsView: View {
    
    @EnvironmentObject var locationRecorder:LocationRecorder
    
    var body: some View {
        VStack {
            HStack {
                Image(systemName: "clock")
                Text("--:--:--")
            }
            HStack {
                HUDLabelView(title: "Points", value: "--")
                RecordButtonView(recordingState: $locationRecorder.currentRecordingState)
                HUDLabelView(title: "Distance", value: "--")
            }
            .padding()
        }
    }
}
