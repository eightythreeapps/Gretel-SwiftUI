//
//  LocationProvider.swift
//  Gretel SwiftUI
//
//  Created by Ben Reed on 09/02/2023.
//

import Foundation
import CoreLocation
import MapKit
import _MapKit_SwiftUI

public protocol LocationProvider {
    
    var currentLocationTrackingState:LocationTrackingState { get set }
    var currentRecordingState:RecordingState { get set }
    var currentHeading:CLHeading { get set }
    var currentLocation:CLLocation { get set }
    var isTrackingUserLocation:MapUserTrackingMode { get set }
    var region:MKCoordinateRegion { get set }
    
    func startUpdatingUserHeading()
    func startUpdatingUserLocation()
    func stopUpdatingUserLocation()

}
