//
//  TrackRecorderView.swift
//  Gretel SwiftUI
//
//  Created by Ben Reed on 19/01/2023.
//

import SwiftUI
import CoreLocation
import MapKit

public class TrackRecorderViewModel:ObservableObject {
    
    @Published var mapRegion:MKCoordinateRegion = LocationService.defaultRegion
    @Published var isTrackingUserLocation:MapUserTrackingMode = .none
    @Published var track:ActiveTrack = ActiveTrack()
    @Published var recordingState:RecordingState = .stopped
    
    @Published var shouldShowError:Bool = false
    @Published var isVisible:Bool = false
    
    var showsUserLocation:Bool
    var currentLocation:CLLocation
    
    private var locationRecorder:LocationRecorderService
    
    init(mapRegion: MKCoordinateRegion, isTrackingUserLocation: MapUserTrackingMode, recordingState: RecordingState, shouldShowError: Bool, isVisible: Bool, showsUserLocation: Bool, currentLocation: CLLocation, locationRecorder: LocationRecorderService) {
        self.mapRegion = mapRegion
        self.isTrackingUserLocation = isTrackingUserLocation
        self.recordingState = recordingState
        self.shouldShowError = shouldShowError
        self.isVisible = isVisible
        self.showsUserLocation = showsUserLocation
        self.currentLocation = currentLocation
        self.locationRecorder = locationRecorder
    }
    
    public func elapsedTimeDisplay() -> String {
        return locationRecorder.elapsedTimeDisplay
    }
    
}

struct TrackRecorderView: View {
    
    @Environment(\.horizontalSizeClass) var horizontalSizeClass
    @Environment(\.verticalSizeClass) var verticalSizeClass
    @Environment(\.activeUnitType) var activeUnitType
    
    @StateObject var viewModel = ViewModelFactory.shared.makeTrackRecorderViewModel()
    
    private var buttonBackground:Color = .gray.opacity(0.4)
    
    var body: some View {
        
        let layout = (horizontalSizeClass == .compact && verticalSizeClass == .regular) ?
        AnyLayout(VStackLayout()) :
        AnyLayout(HStackLayout())
        
            layout {
                ZStack {
                    
                    Map(coordinateRegion: $viewModel.mapRegion,
                        showsUserLocation: viewModel.showsUserLocation,
                        userTrackingMode: $viewModel.isTrackingUserLocation)

                    VStack {
                        HStack{
                            Spacer()
                            Button {
                                viewModel.isVisible = false
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
                    
                    if viewModel.recordingState == .error {
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
                    
                    RecorderControlsView(recordingState: $viewModel.recordingState,
                                         totalRecordedPoints: viewModel.track.totalPointsCount,
                                         totalDistanceInMetres: viewModel.track.totalDistanceMetres,
                                         elapsedTimeDisplay: viewModel.elapsedTimeDisplay(),
                                         currentLocation: viewModel.currentLocation)
                }

            }
        
    }
}

struct TrackRecorderView_Previews: PreviewProvider {
    static var previews: some View {
        PreviewFactory.makeTrackRecorderPreview()
    }
}
