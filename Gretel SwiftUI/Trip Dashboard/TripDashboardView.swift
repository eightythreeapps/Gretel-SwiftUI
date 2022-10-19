//
//  TripDashboardView.swift
//  Gretel SwiftUI
//
//  Created by Ben Reed on 13/10/2022.
//

import SwiftUI
import MapKit

struct TripDashboardView: View {
    
    @EnvironmentObject var recordingService:RecordingService
    @EnvironmentObject var locationService:LocationService
    
    var body: some View {
        
        ZStack {
            
            VStack {
                Map(coordinateRegion: $locationService.mapRegion)
                Spacer()
                
                HStack {
                    VStack {
                        DashboardLabelView(title: "Altitude", value: locationService.currentAltitudeDisplayValue, alignment: .leading)
                        DashboardLabelView(title: "Speed", value: locationService.currentSpeedDisplayValue, alignment: .leading)
                    }
                    Spacer()
                    Button {
                        if recordingService.isUpdatingLocation {
                            recordingService.stopRecordingLocation()
                        }else{
                            recordingService.startRecordingLocation()
                        }
                    } label: {
                        RecordButtonView()
                    }
                    Spacer()
                    VStack {
                        DashboardLabelView(title: "Points", value: "3,000", alignment: .trailing)
                        DashboardLabelView(title: "Distance", value: "100km", alignment: .trailing)
                    }
                }
                .padding()
                .frame(
                    maxWidth: .infinity,
                    maxHeight: 120.0,
                    alignment: .bottom
                )
            }
        }
        .edgesIgnoringSafeArea(.all)
    }
}

struct TripDashboardView_Previews: PreviewProvider {
    static var previews: some View {
        PreviewFactory.TripDashboardPreview()
    }
}
