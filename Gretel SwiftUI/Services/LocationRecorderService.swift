//
//  LocationService.swift
//  Gretel SwiftUI
//
//  Created by Ben Reed on 16/09/2022.
//

import Foundation
import Combine
import CoreLocation
import MapKit

public final class LocationRecorderService:NSObject, ObservableObject {
    
    public enum LocationTrackingState {
        case tracking
        case stopped
        case error
        
        public var stringValue: String {
            switch self {
                
            case .tracking:
                return "Tracking"
            case .stopped:
                return "Stopped"
            case .error:
                return "Error"
            }
        }
        
    }

    private var locationManager:CLLocationManager
    private var settingsService:SettingsService
    private var cancellables = Set<AnyCancellable>()
    
    private static let DefaultLatitude = 0.1276
    private static let DefaultLongitude = 51.5072
    private static let DefaultCoordinateSpanDelta = 0.1
    
    @Published var currentLocationTrackingState:LocationTrackingState = .stopped
    
    @Published var currentLocation:Location = Location(location: CLLocation(coordinate: CLLocationCoordinate2D(latitude: LocationRecorderService.DefaultLatitude, longitude: LocationRecorderService.DefaultLongitude),
                                                                            altitude: 0,
                                                                            horizontalAccuracy: 0,
                                                                            verticalAccuracy: 0,
                                                                            course: 0.0,
                                                                            courseAccuracy: 0,
                                                                            speed: 0,
                                                                            speedAccuracy: 0, timestamp: Date()))
    
    @Published var region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: LocationRecorderService.DefaultLatitude, longitude: LocationRecorderService.DefaultLongitude),
                                               span: MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1))
    
    required public init(locationManager:CLLocationManager, settingsService:SettingsService) {
        self.locationManager = locationManager
        self.settingsService = settingsService
        super.init()
    }
 
    public func updateRecordingState() {
        switch self.currentLocationTrackingState {
            
        case .tracking:
            self.stopUpdatingUserLocation()
        case .stopped:
            self.startUpdatingUserLocation()
        case .error:
            print("Error")
        }
    }
    
    public func stopUpdatingUserLocation() {
        self.currentLocationTrackingState = .stopped
        self.cancellables.removeAll()
    }
    
    public func startUpdatingUserLocation() {
        
        self.currentLocationTrackingState = .tracking
        
        let config = LocationPublisherConfig(activityType: .other,
                                             desiredAccuracy: kCLLocationAccuracyBest,
                                             headingFilter: 100.0)
        
        locationManager.publishLocation(configuration: config).sink(
            receiveCompletion: { completion in
                print(completion)
            },
            receiveValue: { location in
                self.currentLocation = Location(location: location)
                self.region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude),
                                                 span: MKCoordinateSpan(latitudeDelta: LocationRecorderService.DefaultCoordinateSpanDelta, longitudeDelta: LocationRecorderService.DefaultCoordinateSpanDelta))
            }
        )
        .store(in: &cancellables)
        
    }
        
}
