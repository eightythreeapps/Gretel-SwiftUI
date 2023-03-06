//
//  LocationService.swift
//  Gretel SwiftUI
//
//  Created by Ben Reed on 19/01/2023.
//

import Foundation
import Combine
import CoreLocation
import MapKit
import _MapKit_SwiftUI

public class LocationService:ObservableObject {
    
    @Published public var currentLocationTrackingState:LocationTrackingState = .notTracking
    @Published public var currentRecordingState:RecordingState = .stopped
    @Published public var currentHeading:CLHeading = CLHeading()
    @Published public var currentLocation:CLLocation = CLLocation(latitude: LocationService.DefaultLatitude, longitude: LocationService.DefaultLongitude)
    @Published public var isTrackingUserLocation:MapUserTrackingMode = .follow
    @Published public var region:MKCoordinateRegion
    
    public static let defaultRegion = MKCoordinateRegion(center:CLLocationCoordinate2D(latitude: LocationService.DefaultLatitude, longitude: LocationService.DefaultLongitude),
                                                         span: MKCoordinateSpan(latitudeDelta: LocationService.DefaultCoordinateSpanDelta,
                                                                                longitudeDelta: LocationService.DefaultCoordinateSpanDelta))
    
    private static let DefaultLatitude = 50.337570
    private static let DefaultLongitude = -4.793910
    private static let DefaultCoordinateSpanDelta = 0.1
    
    private var locationManager:CLLocationManager
    private var cancellables = Set<AnyCancellable>()
    
    required init(locationManager:CLLocationManager) {
        self.locationManager = locationManager
        self.region = LocationService.defaultRegion
    }
    
    public func startUpdatingUserHeading() {
        
        locationManager.publishHeading().sink { completion in
            print(completion)
        } receiveValue: { heading in
            self.currentHeading = heading
        }.store(in: &cancellables)

    }
    
    public func startUpdatingUserLocation() {
        
        self.currentLocationTrackingState = .tracking
        
        //TODO: Update this to work from Settings class. Give user control.
        let config = LocationPublisherConfig(activityType: .other,
                                             desiredAccuracy: kCLLocationAccuracyBest,
                                             headingFilter: 100.0)
        
        locationManager.publishLocation(configuration: config).sink(
            receiveCompletion: { completion in
                print(completion)
            },
            receiveValue: { location in
                self.currentLocation = location
                self.region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude),
                                                 span: MKCoordinateSpan(latitudeDelta: LocationService.DefaultCoordinateSpanDelta, longitudeDelta: LocationService.DefaultCoordinateSpanDelta))
            }
        )
        .store(in: &cancellables)
        
    }
    
    public func stopUpdatingUserLocation() {
        self.currentLocationTrackingState = .notTracking
        self.cancellables.removeAll()
    }
    
}
