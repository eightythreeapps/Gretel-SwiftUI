//
//  CLLocation+Utils.swift
//  Gretel SwiftUI
//
//  Created by Ben Reed on 19/01/2023.
//

import Foundation
import CoreLocation
import MapKit

extension CLLocation {
    
    public enum LocationProperty {
        case latitude
        case longitude
        case speed
        case altidude
    }
    
    public func mapRegion() -> MKCoordinateRegion {
        
        return MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: self.coordinate.latitude, longitude: self.coordinate.longitude),
                                  span: MKCoordinateSpan(latitudeDelta: 0.5, longitudeDelta: 0.5))
        
    }
    
    public func displayValue(for property:LocationProperty) -> String {
        
        switch property {
            
        case .latitude:
            return "\(self.coordinate.latitude)"
        case .longitude:
            return "\(self.coordinate.longitude)"
        case .speed:
            return "\(self.speed)"
        case .altidude:
            return "\(self.altitude)"
        }
        
    }
    
}
