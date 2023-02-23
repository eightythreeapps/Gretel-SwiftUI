//
//  UnitType.swift
//  Gretel SwiftUI
//
//  Created by Ben Reed on 09/02/2023.
//

import Foundation

public enum UnitType:String, CaseIterable, Identifiable {
    
    //https://sarunw.com/posts/swift-enum-identifiable/
    public var id: Self {
        return self
    }
    
    case metric = "Metric"
    case imperial = "Imperial"
        
    public func displayValue() -> String {
        switch self {
        case .metric:
            return "Metric"
        case .imperial:
            return "Imperial"
        }
    }
    
    public func displayMessage() -> String {
        switch self {
        case .metric:
            return "Application will use Metric units: m, km & kph"
        case .imperial:
            return "Application will use Imperial units: ft, m & mph"
        }
    }
        
}
