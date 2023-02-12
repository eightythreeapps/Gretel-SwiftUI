//
//  SettingsProvider.swift
//  Gretel SwiftUI
//
//  Created by Ben Reed on 09/02/2023.
//

import Foundation

public protocol SettingsProvider {
    var unitType:UnitType { get set }
    
    func configureSettings()
    func getDeviceLocale() -> Locale
    func updateUnitType(unitType:UnitType)
}
