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

public class LocationService:NSObject, ObservableObject {
    
    private var locationManager:CLLocationManager
    private var settingsService:SettingsService
    
    var currentLocation:CLLocation?
    var currentCoordinate:CLLocationCoordinate2D?
    var currentHeading:CLHeading?
    var currentSpeed:Double = 0.0
    
    @Published var currentLatitudeDisplayValue = ""
    @Published var currentHeadingDisplayValue = ""
    @Published var currentSpeedDisplayValue = ""
    @Published var currentAltitudeDisplayValue = ""
    @Published var userLocationFound = false    
    
    @Published var error:Error?
    
    @Published var mapRegion = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 51.5, longitude: -0.12), span: MKCoordinateSpan(latitudeDelta: 0.2, longitudeDelta: 0.2))
    
    required public init(locationManager:CLLocationManager, settingsService:SettingsService) {
        self.locationManager = locationManager
        self.settingsService = settingsService
        
        super.init()
    }
    
    public func startTrackingLocation() {
        self.locationManager.startUpdatingLocation()
    }
    
    public func stopTrackingLocation() {
        self.locationManager.stopUpdatingLocation()
    }
    
}
