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
    
    @State var showMoreDetail = false
    
    var currentLocation:CLLocation
    
    @Environment(\.activeUnitType) var activeUnitType
    
    @EnvironmentObject var locationRecorder:LocationRecorderService
    
    
    var body: some View {
        VStack {
            HStack {
                Spacer()
                HUDLabelView(imageName: "clock", value: elapsedTimeDisplay)
                Spacer()
                HUDLabelView(imageName: "signpost.right.and.left", value: totalDistanceInMetres.formatDistance(unitType: activeUnitType, granularity: .large))
                Spacer()
                HUDLabelView(imageName: "mappin.and.ellipse", value: totalRecordedPoints.toString())
                Spacer()
            }
            if self.showMoreDetail {
                HStack {
                    HUDLabelView(imageName: "location", value: currentLocation.displayValue(for: .latitude))
                    HUDLabelView(imageName: "Lon", value: currentLocation.displayValue(for: .longitude))
                    HUDLabelView(imageName: "Altitude", value: currentLocation.displayValue(for: .altidude))
                    HUDLabelView(imageName: "Speed", value: "0.0")
                }
            }
            HStack {
                RecordButtonView(recordingState: $recordingState)
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
