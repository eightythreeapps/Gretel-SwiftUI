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
    
    @Environment(\.horizontalSizeClass) var horizontalSizeClass
    @Environment(\.verticalSizeClass) var verticalSizeClass
    @Environment(\.activeUnitType) var activeUnitType
    
    @EnvironmentObject var locationRecorder:LocationRecorder
    
    @Binding var isVisible:Bool
    @Binding var isTrackingUserLocation:MapUserTrackingMode
    
    @State var mapRegion:MKCoordinateRegion
    
    var showsUserLocation:Bool
    var currentLocation:CLLocation
    var buttonBackground:Color = .gray.opacity(0.4)
    
    var body: some View {
        
        let layout = (horizontalSizeClass == .compact && verticalSizeClass == .regular) ?
        AnyLayout(VStackLayout()) :
        AnyLayout(HStackLayout())
        
            layout {
                ZStack {
                    
                    Map(coordinateRegion: $mapRegion,
                        showsUserLocation: showsUserLocation,
                        userTrackingMode: $isTrackingUserLocation)

                    VStack {
                        HStack{
                            Spacer()
                            Button {
                                isVisible = false
                            } label: {
                                Image(systemName: "xmark")
                            }
                            .padding(EdgeInsets(top: 8.0, leading: 8.0, bottom: 8.0, trailing: 8.0))
                            .foregroundColor(.white)
                            .fontWeight(.bold)
                            .background(.gray.opacity(0.4))
                            .cornerRadius(20.0)
                            .padding()
                        }
                        Spacer()
                    }
                }
                VStack {
                    
                    if self.locationRecorder.state == .error {
                        HStack {
                            Text("Error")
                                .font(.callout)
                                .bold()
                                .padding(EdgeInsets(top: 4.0,
                                                    leading: 0.0,
                                                    bottom: 4.0,
                                                    trailing: 0.0))
                                .frame(maxWidth: .infinity)
                                .foregroundColor(.white)
                                .background(.red)
                        }
                    }
                    
                    RecorderControlsView(recordingState: $locationRecorder.state,
                                         elapsedTimeDisplay: locationRecorder.elapsedTimeDisplay,
                                         totalRecordedPoints: 0,
                                         totalDistanceInMetres: 0,
                                         currentLocation: currentLocation)
                }

            }.onAppear {
                locationRecorder.prepareToRecord()
            }.onDisappear {
                locationRecorder.cleanUp()
            }
    }
}

struct TrackRecorderView_Previews: PreviewProvider {
    static var previews: some View {
        PreviewFactory.makeTrackRecorderPreview()
    }
}
