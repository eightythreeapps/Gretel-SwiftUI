//
//  TripDashboardView.swift
//  Gretel SwiftUI
//
//  Created by Ben Reed on 13/10/2022.
//

import SwiftUI
import MapKit

struct TripDashboardView: View {
    
    @EnvironmentObject var locationRecorder:LocationRecorderService
    
    var body: some View {
        
        ZStack {
            
            VStack {
                Map(coordinateRegion: $locationRecorder.region)
                Spacer()
                
                HStack {
                    VStack {
                        Text(locationRecorder.currentLocationTrackingState == .tracking ? "Tracking" : "Stopped")
                        DashboardLabelView(title: "Altitude",
                                           value: locationRecorder.currentLocation.displayValue(for: .altidude),
                                           alignment: .leading)
                        DashboardLabelView(title: "Speed",
                                           value: locationRecorder.currentLocation.displayValue(for: .speed),
                                           alignment: .leading)
                    }
                    Spacer()
                    Button {
                        locationRecorder.updateRecordingState()
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
