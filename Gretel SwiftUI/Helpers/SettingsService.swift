//
//  SettingService.swift
//  Gretel SwiftUI
//
//  Created by Ben Reed on 19/10/2022.
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

public enum UnitGranularity {
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
    
    private static let UnitTypeKey = "space.sometinylittle.Gretel.UnitType"
    private static let FirstLaunchKey = "space.sometinylittle.Gretel.FirstLaunch"
    
    private let defaultUnitType:UnitType = .metric
    private var userDefaults:UserDefaults

    
    required init(userDefaults:UserDefaults) {
        self.userDefaults = userDefaults
    }
    
    func configureSettings() {
        
        if self.userDefaults.string(forKey: SettingsService.FirstLaunchKey) != nil {
            
            if let type = self.userDefaults.string(forKey: SettingsService.UnitTypeKey) {
                self.unitType = UnitType(rawValue: type) ?? self.defaultUnitType
            }
            
        }else{
            self.userDefaults.set(self.defaultUnitType.rawValue, forKey: SettingsService.UnitTypeKey)
            self.unitType = self.defaultUnitType
            self.userDefaults.set("HasLaunched", forKey: SettingsService.FirstLaunchKey)
        }
        
    }
    
    func getDeviceLocale() -> Locale {
        
        return Locale.current
        
    }
    
    func updateUnitType(unitType:UnitType) {
        self.unitType = unitType
        
        self.userDefaults.set(unitType.rawValue, forKey: SettingsService.UnitTypeKey)
        
    }
    
}
