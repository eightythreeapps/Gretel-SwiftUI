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
    
    @Binding var mapRegion:MKCoordinateRegion
    @Binding var isTrackingUserLocation:MapUserTrackingMode
    @Binding var track:ActiveTrack
    @Binding var recordingState:RecordingState
    
    @EnvironmentObject var locationRecorder:LocationRecorderService
    
    var showsUserLocation:Bool
    var currentLocation:CLLocation
    var buttonBackground:Color = .gray.opacity(0.4)
    
    @State var shouldShowError:Bool = false
    
    @Binding var isVisible:Bool
    
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
                    
                    if self.recordingState == .error {
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
                    
                    RecorderControlsView(recordingState: $recordingState, totalRecordedPoints: $track.totalPointsCount,
                                         totalDistanceInMetres: $track.totalDistanceMetres,
                                         elapsedTimeDisplay: $locationRecorder.elapsedTimeDisplay,
                                         currentLocation: currentLocation)
                }

            }
    }
}

struct TrackRecorderView_Previews: PreviewProvider {
    static var previews: some View {
        PreviewFactory.makeTrackRecorderPreview()
    }
}
