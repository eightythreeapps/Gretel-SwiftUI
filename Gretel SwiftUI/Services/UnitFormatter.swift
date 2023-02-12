//
//  UnitFormatter.swift
//  Gretel SwiftUI
//
//  Created by Ben Reed on 08/02/2023.
//

import Foundation

public class UnitFormatter {
    
    private var settingsService:SettingsService
    
    required init(settingsService:SettingsService) {
        self.settingsService = settingsService
    }
    
    public func formatDistance(distanceInMetres:Double, granularity:UnitGranularity) -> String {
        
        var calculatedDistance:Double = 0
        
        switch self.settingsService.unitType {
            
        case .imperial:
            
            switch granularity {
            case .small:
                calculatedDistance = calculateDistanceInFeet(distanceInMeters: distanceInMetres)
            case .large:
                calculatedDistance = calculateDistanceInMiles(distanceInMeters: distanceInMetres)
            }
            
        case .metric:
            
            switch granularity {
            case .large:
                calculatedDistance = calculateDistanceInKilometers(distanceInMeters: distanceInMetres)
            case .small:
                calculatedDistance = distanceInMetres
            }
            
        }
        
        return "\(calculatedDistance.rounded(toPlaces: 2))\(granularity.suffix(type: self.settingsService.unitType))"
        
    }
    
}

private extension UnitFormatter {
    
    func calculateDistanceInKilometers(distanceInMeters:Double) -> Double {
        return distanceInMeters / 1000
    }
    
    func calculateDistanceInMiles(distanceInMeters:Double) -> Double {
        return distanceInMeters * 0.000621
    }
    
    func calculateDistanceInFeet(distanceInMeters:Double) -> Double {
        return distanceInMeters * 3.28084
    }
    
}
