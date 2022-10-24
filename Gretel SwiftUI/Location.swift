//
//  Location.swift
//  Gretel SwiftUI
//
//  Created by Ben Reed on 20/10/2022.
//

import Foundation
import CoreLocation
import MapKit
import SwiftUI

public class Location {
    
    public enum LocationProperty {
        case latitude
        case longitude
        case speed
        case altidude
    }
    
    private var location:CLLocation
    
    required init(location:CLLocation) {
        self.location = location
    }
    
    public func mapRegion() -> MKCoordinateRegion {
        
        return MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude),
                                  span: MKCoordinateSpan(latitudeDelta: 0.5, longitudeDelta: 0.5))
        
    }
    
    public func displayValue(for property:LocationProperty) -> String {
        
        switch property {
            
        case .latitude:
            return "\(location.coordinate.latitude)"
        case .longitude:
            return "\(location.coordinate.longitude)"
        case .speed:
            return "\(location.speed)"
        case .altidude:
            return "\(location.altitude)"
        }
        
    }
    
}
