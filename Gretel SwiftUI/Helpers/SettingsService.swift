//
//  SettingService.swift
//  Gretel SwiftUI
//
//  Created by Ben Reed on 19/10/2022.
//

import Foundation

enum UnitType:CaseIterable, Identifiable {
    
    //https://sarunw.com/posts/swift-enum-identifiable/
    var id: Self {
        return self
    }
    
    case metric
    case imperial
    
    func displayValue() -> String {
        switch self {
        case .metric:
            return "Metric"
        case .imperial:
            return "Imperial"
        }
    }
    
    func displayMessage() -> String {
        switch self {
        case .metric:
            return "Application will use Metric units: m, km & kph"
        case .imperial:
            return "Application will use Imperial units: ft, m & mph"
        }
    }
        
}

enum UnitGranularity {
    case small
    case large
    
    func suffix(type:UnitType) -> String {
        
        switch self {
        case .small:
            if type == .imperial {
                return "ft"
            }else{
                return "M"
            }
        case .large:
            if type == .imperial {
                return "m"
            }else{
                return "km"
            }
        }
        
    }
    
}


public class SettingsService:ObservableObject {
    
    @Published var unitType:UnitType = .metric
    
    private var userDefaults:UserDefaults
    
    required init(userDefaults:UserDefaults) {
        self.userDefaults = userDefaults
    }
    
    func getDeviceLocale() -> Locale {
        
        return Locale.current
        
    }
    
    func updateUnitType(unitType:UnitType) {
        self.unitType = unitType
    }
    
}
