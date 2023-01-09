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
    @Environment(\.horizontalSizeClass) var sizeClass
    
    var body: some View {
        
        if sizeClass == .compact {
            
            VStack {
                Map(coordinateRegion: $locationRecorder.region, showsUserLocation: true)
                Spacer()
                TripDashboardControlsCompactView()
            }.edgesIgnoringSafeArea(.all)
            
            
        } else {
            
            HStack {
                Map(coordinateRegion: $locationRecorder.region, showsUserLocation: true)
                HStack {
                    
                    TripDashboardControlsView()
                        
                }
               
            }.edgesIgnoringSafeArea(.all)
            
        }
        
    }
}

struct TripDashboardView_Previews: PreviewProvider {
    static var previews: some View {
        PreviewFactory.TripDashboardPreview()
    }
}

struct TripDashboardControlsCompactView: View {
    
    @EnvironmentObject var locationRecorder:LocationRecorderService
    
    var body: some View {
        
        VStack{
            LocationDataView()
            HStack {
                VStack {
                    DashboardLabelView(title: "Elapsed time",
                                       value: locationRecorder.currentLocation.displayValue(for: .altidude),
                                       alignment: .leading)
                    DashboardLabelView(title: "Distance",
                                       value: locationRecorder.currentLocation.displayValue(for: .speed),
                                       alignment: .leading)
                }
                Spacer()
                Button {
                    locationRecorder.updateRecordingState()
                } label: {
                    RecordButtonView(buttonState: $locationRecorder.currentRecordingState)
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
}

struct TripDashboardControlsView: View {
    
    @EnvironmentObject var locationRecorder:LocationRecorderService
    
    var body: some View {
        
        Text("Hai")
    }
}

struct LocationDataView: View {
    
    @EnvironmentObject var locationRecorder:LocationRecorderService
    
    var body: some View {
        HStack {
            Text(locationRecorder.currentLocationTrackingState == .tracking ? "Tracking location" : "Location unavailable")
            Spacer()
            Text("Signal")
        }.padding(EdgeInsets(top: 0.0, leading: 8.0, bottom: 0.0, trailing: 8.0))
    }
}
