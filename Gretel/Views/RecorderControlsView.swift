//
//  RecorderControlsView.swift
//  Gretel
//
//  Created by Ben Reed on 16/02/2023.
//

import SwiftUI
import CoreLocation

struct RecorderControlsView: View {
    
    @Binding var recordingState:RecordingState
    @Binding var totalRecordedPoints:Int
    @Binding var totalDistanceInMetres:Double
    @Binding var elapsedTimeDisplay:String
    
    var currentLocation:CLLocation
    
    @Environment(\.activeUnitType) var activeUnitType
    
    @EnvironmentObject var locationRecorder:LocationRecorderService
    
    
    var body: some View {
        VStack {
            HStack {
                Image(systemName: "clock")
                Text(elapsedTimeDisplay)
            }
            LocationHUDView(
                latitude: currentLocation.displayValue(for: .latitude),
                longitude: currentLocation.displayValue(for: .longitude),
                altitude: currentLocation.displayValue(for: .altidude)
            )
            .padding(EdgeInsets(top: 0.0, leading: 0.0, bottom: 0.0, trailing: 0.0))
            HStack {
                HUDLabelView(title: "Points", value: totalRecordedPoints.toString())
                RecordButtonView(recordingState: $recordingState)
                HUDLabelView(title: "Distance",
                             value: totalDistanceInMetres.formatDistance(unitType: activeUnitType, granularity: .large))
            }
            .padding()
        }
    }
}

struct RecorderControlsView_Previews: PreviewProvider {
    static var previews: some View {
        RecorderControlsView(recordingState: .constant(.stopped),
                             totalRecordedPoints: .constant(100),
                             totalDistanceInMetres: .constant(123.4),
                             elapsedTimeDisplay: .constant("00:00:00"),
                             currentLocation: CLLocation(latitude: 0.0, longitude: 0.0))
    }
}
