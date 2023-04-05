//
//  RecorderControlsView.swift
//  Gretel
//
//  Created by Ben Reed on 16/02/2023.
//

import SwiftUI
import CoreLocation

struct RecorderControlsView: View {
    
    @Environment(\.activeUnitType) var activeUnitType
    @EnvironmentObject var locationRecorder:LocationRecorder
    @Binding var recordingState:RecordingState
    @State var showMoreDetail = false
    
    var elapsedTimeDisplay:String
    var totalRecordedPoints:Int
    var totalDistanceInMetres:Double
    var currentLocation:CLLocation
    
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
                RecordButtonView(size: .medium)
            }
            .padding()
        }
    }
}

struct RecorderControlsView_Previews: PreviewProvider {
    static var previews: some View {
        RecorderControlsView(recordingState: .constant(.stopped),
                             elapsedTimeDisplay: "00:00:00", totalRecordedPoints: 100,
                             totalDistanceInMetres: 123.4,
                             currentLocation: CLLocation(latitude: 0.0, longitude: 0.0))
    }
}
