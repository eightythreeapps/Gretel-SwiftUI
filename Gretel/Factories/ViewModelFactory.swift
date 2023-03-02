//
//  ViewModelFactory.swift
//  Gretel
//
//  Created by Ben Reed on 01/03/2023.
//

import Foundation
import CoreLocation

public struct ViewModelFactoryConfiguration {
    var locationRecorderService:LocationRecorderService
    var locationService:LocationService
}

public class ViewModelFactory {
    
    static let shared = ViewModelFactory()
    static var config:ViewModelFactoryConfiguration?
    
    private var locationRecorderService:LocationRecorderService
    private var locationService:LocationService
    
    class func configure(config:ViewModelFactoryConfiguration) {
        ViewModelFactory.config = config
    }
    
    private init() {
        guard let config = ViewModelFactory.config else {
            fatalError("Error - you must call setup before accessing ViewModelFactory.shared")
        }
        
        self.locationService = config.locationService
        self.locationRecorderService = config.locationRecorderService
    }
    
    public func makeTrackRecorderViewModel() -> TrackRecorderViewModel {
        
        let viewModel = TrackRecorderViewModel(mapRegion: LocationService.defaultRegion,
                                        isTrackingUserLocation: .follow,
                                        recordingState: .stopped,
                                        shouldShowError: false,
                                        isVisible: false,
                                        showsUserLocation: true,
                                        currentLocation: CLLocation(latitude: 0.0, longitude: 0.0),
                                        locationRecorder: locationRecorderService)
        
        return viewModel
        
    }
    
    public func makeRecorderMiniViewViewModel() -> RecorderMiniViewViewModel {
        let viewModel = RecorderMiniViewViewModel(shouldShowFullRecorderView: false, track: ActiveTrack(), recordingState: .stopped)
        
        return viewModel
    }
    
}
