//
//  Double+displayUnits.swift
//  Gretel
//
//  Created by Ben Reed on 16/02/2023.
//

import Foundation

extension Double:DisplayFormatting {
    
    private func asMetresToKilometers() -> Double {
        return self / 1000
    }
    
    private func asMetreToMiles() -> Double {
        return self * 0.000621
    }
    
    private func asMetresToFeet() -> Double {
        return self * 3.28084
    }
    
    public func formatDistance(unitType:UnitType, granularity:UnitGranularity) -> String {
        
        var calculatedDistance:Double = 0
        
        switch unitType {
            
        case .imperial:
            
            switch granularity {
            case .small:
                calculatedDistance = asMetresToFeet()
            case .large:
                calculatedDistance = asMetreToMiles()
            }
            
        case .metric:
            
            switch granularity {
            case .large:
                calculatedDistance = asMetresToKilometers()
            case .small:
                calculatedDistance = self
            }
            
        }
        
        return "\(calculatedDistance.rounded(toPlaces: 2))\(granularity.suffix(type: unitType))"
        
    }
    
}
