//
//  LocationTrackingState.swift
//  Gretel SwiftUI
//
//  Created by Ben Reed on 25/10/2022.
//

import Foundation

public enum LocationTrackingState {
    
    case tracking
    case notTracking
    case error
    
    public var stringValue: String {
        switch self {
            
        case .tracking:
            return "Tracking"
        case .notTracking:
            return "Stopped"
        case .error:
            return "Error"
        }
    }
    
}
