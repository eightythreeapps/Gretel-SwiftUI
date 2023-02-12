//
//  SettingService.swift
//  Gretel SwiftUI
//
//  Created by Ben Reed on 19/10/2022.
//

import Foundation

public class SettingsService:ObservableObject {
    
    @Published public var unitType:UnitType = .metric
    
    private static let UnitTypeKey = "space.sometinylittle.Gretel.UnitType"
    private static let FirstLaunchKey = "space.sometinylittle.Gretel.FirstLaunch"
    
    private let defaultUnitType:UnitType = .metric
    private var userDefaults:UserDefaults

    
    required init(userDefaults:UserDefaults) {
        self.userDefaults = userDefaults
    }
    
    public func configureSettings() {
        
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
    
    public func getDeviceLocale() -> Locale {
        
        return Locale.current
        
    }
    
    public func updateUnitType(unitType:UnitType) {
        self.unitType = unitType
        
        self.userDefaults.set(unitType.rawValue, forKey: SettingsService.UnitTypeKey)
        
    }
    
}
